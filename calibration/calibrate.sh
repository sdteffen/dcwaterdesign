# calibration script for intermittent water supply
# uses genetic algorithms

# (c) 2000 DORSCH Consult

# requires the following software:

# GNU bash      It's a bash script
# GNU bc        command line calculator
# GNU cp        to copy files
# GNU rm        to delete old results
# mysql         other ANSI compliant SQL databases might work,
#               but are not tested
# epanetmysql   or something else that allows to import
#               epanet results to SQL db
# genetic       the program that provides the GA functionality 
#		(over XML interface)

#clean up
rm result.txt
rm population.xml

#determine the number of runs
factor=0
step=1
max_factor=10

#population settings
typeset -i num_population
num_population=50

# create initial population
echo "<calibration>" > calibration.xml
echo "  <limits>" >> calibration.xml

#limit settings
min_leakage_pipe_diameter_factor=0.8
max_leakage_pipe_diameter_factor=1.5
min_roughness=1.0
max_roughness=15.0
min_house_connection_diameter_factor=0.9
max_house_connection_diameter_factor=1.5
min_house_connection_tank_size_factor=0.8
max_house_connection_tank_size_factor=1.2

#house connection diameter thresholds
min_diameter_threshold=0.6
max_diameter_threshold=11.0

#pump power
max_power=170
min_power=20

echo '    <allele min="'$min_leakage_pipe_diameter_factor'" max="'$max_leakage_pipe_diameter_factor'">leakage_pipe_diameter_factor</allele>' >> calibration.xml
echo '   <allele min="'$min_roughness'" max="'$max_roughness'">roughness</allele>' >> calibration.xml
echo '   <allele min="'$min_house_connection_diameter_factor'" max="'$max_house_connection_diameter_factor'">house_connection_diameter_factor</allele>' >> calibration.xml
echo '   <allele min="'$min_house_connection_tank_size_factor'" max="'$max_house_connection_tank_size_factor'">house_connection_tank_size_factor</allele>' >> calibration.xml
echo '   <allele min="'$min_power'" max="'$max_power'">pump_power</allele>' >> calibration.xml
echo '   <allele min="'$min_diameter_threshold'" max="'$max_diameter_threshold'" >one_inch_threshold</allele>' >> calibration.xml
echo '   <allele min="'$min_diameter_threshold'" max="'$max_diameter_threshold'" >one_half_inch_threshold</allele>' >> calibration.xml
echo '   <allele min="'$min_diameter_threshold'" max="'$max_diameter_threshold'" >two_inch_threshold</allele>' >> calibration.xml
echo "  </limits>" >> calibration.xml

#create initial random population

echo "generating initial random population"

echo "  <population>" >> calibration.xml
typeset -i i
i=1
while [ $i -lt $num_population ]
do
    random_fitness=$(sh random.sh 0.0 100.0)
    echo '    <gene fitness="'$random_fitness'">' >> calibration.xml 

    leakage_pipe_diameter_factor=$(sh random.sh $min_leakage_pipe_diameter_factor $max_leakage_pipe_diameter_factor)
    echo '      <allele value="'$leakage_pipe_diameter_factor'">leakage_pipe_diameter_factor</allele>' >> calibration.xml   
    
    roughness=$(sh random.sh $min_roughness $max_roughness)
    echo '      <allele value="'$roughness'">roughness</allele>' >> calibration.xml   
    
    house_connection_diameter_factor=$(sh random.sh $min_house_connection_diameter_factor $max_house_connection_diameter_factor)
    echo '      <allele value="'$house_connection_diameter_factor'">house_connection_diameter_factor</allele>' >> calibration.xml   
    
    house_connection_tank_size_factor=$(sh random.sh $min_house_connection_tank_size_factor $max_house_connection_tank_size_factor)
    echo '      <allele value="'$house_connection_tank_size_factor'">house_connection_tank_size_factor</allele>' >> calibration.xml   
    
    pump_power=$(sh random.sh $min_power $max_power)
    echo '      <allele value="'$pump_power'">pump_power</allele>' >> calibration.xml

    one_inch_threshold=$(sh random.sh $min_diameter_threshold $max_diameter_threshold/2)
    echo '      <allele value="'$one_inch_threshold'">one_inch_threshold</allele>' >> calibration.xml

    one_half_inch_threshold=$(sh random.sh $one_inch_threshold $max_diameter_threshold)
    echo '      <allele value="'$one_half_inch_threshold'">one_half_inch_threshold</allele>' >> calibration.xml

    two_inch_threshold=$(sh random.sh $one_half_inch_threshold $max_diameter_threshold)
    echo '      <allele value="'$two_inch_threshold'">two_inch_threshold</allele>' >> calibration.xml

    echo "    </gene>" >> calibration.xml
i=$i+1
done 

echo "  </population>" >> calibration.xml
echo "</calibration>" >> calibration.xml

echo "... done"

while [ "$factor" != "$max_factor" ]
do
    
    i=1
    while [ $i -lt $num_population ]
    do

	#set up roughness
	roughness=$(./genetic.exe $i roughness)
	mysql -u root -e "update leakage_pipes set roughness=$roughness;" av
	mysql -u root -e "update pipes set roughness=$roughness;" av
	mysql -u root -e "update house_connections set roughness=$roughness;" av

	# set up new  pipe diameters 
        factor=$(./genetic.exe $i leakage_pipe_diameter_factor)
	
	mysql -u root -e "update leakage_pipes set diameter=(base_diameter*$factor);" av 
	
	mysql -u root -e "update house_connections set diameter=18;" av
	threshold=$(./genetic.exe $i one_inch_threshold)
	mysql -u root -e "update house_connections set diameter=15 where tank_volume > $threshold;" av
	threshold=$(./genetic.exe $i one_half_inch_threshold)
	mysql -u root -e "update house_connections set diameter=38 where tank_volume > $threshold;" av
	threshold=$(./genetic.exe $i two_inch_threshold)
	mysql -u root -e "update house_connections set diameter=50 where tank_volume > $threshold;" av

	factor=$(./genetic.exe $i house_connection_diameter_factor)
	mysql -u root -e "update house_connections set diameter=(diameter*$factor);" av

	factor=$(./genetic.exe $i house_connection_tank_size_factor)
	mysql -u root -e "update tanks set diameter=(base_diameter*$factor);" av

	# create new input file
	power=$(./genetic.exe $i pump_power)
        sed "s|POWER .*$|POWER $power|" hydraulic_model.inp > calibrate.inp
	mysql -u root -s -e "select id, elevation, initlevel, minlevel, maxlevel, diameter, minvol from tanks;" av >> calibrate.inp
	echo "[PIPES]" >> calibrate.inp
	mysql -u root -s -e "select id, node1, node2, length, diameter, roughness, minorloss, status from leakage_pipes;" av >> calibrate.inp
	mysql -u root -s -e "select * from pipes;" av >> calibrate.inp
	mysql -u root -s -e "select id, node1, node2, length, diameter, roughness, minorloss, status from house_connections;" av >> calibrate.inp
        cat controls.inp >> calibrate.inp

	# run epanet analysis

	./epanet.exe calibrate.inp report.txt out.bin 
	./epanet2mysql.exe out.bin nodes.txt links.txt

	# load results to db

	mysql -u root -s -e "delete from dc_nodes; load data infile 'e:\\\\development\\\\epanetmysql\\\\nodes.txt' into table dc_nodes fields terminated by ',' (dc_id, demand, head, pressure, time);" av 
	mysql -u root -s -e "delete from dc_links; load data infile 'e:\\\\development\\\\epanetmysql\\\\links.txt' into table dc_links fields terminated by ',' (dc_id, flow, velocity, headloss, time);" av 

	# calculate errors

	square_error_pressure=$(mysql -s -e "select sqrt((sum(pow(dc_nodes.pressure - log_pressure.pressure, 2)))/1548) from log_pressure, dc_nodes  where log_pressure.dc_id=dc_nodes.dc_id and log_pressure.time=dc_nodes.time;"  av )
	square_error_flow=$( mysql -s -e "select sqrt((sum(pow(dc_links.flow - log_flow.flow, 2)))/116) from log_flow, dc_links  where log_flow.dc_id=dc_links.dc_id and log_flow.time=dc_links.time;"  av )
	fill_error=$( mysql -u root -s -e  "select sum(pressure)/3.78 from dc_nodes where time=696 and dc_id like 'HT%%';" av)
	# calculate fitness
	fitness=$(echo "a=$fill_error;b=$square_error_pressure;c=$square_error_flow;100-a-33/(b/20+1)-33/(c/2+1)" | bc)
	leakage_volume=$(mysql -u root -s -e "select sum(pressure) from dc_nodes where time=696 and dc_id like 'LT%%';" av)
	
	./genetic.exe $i set $fitness

	echo $square_error_pressure $square_error_flow $fill_error $leakage_volume $fitness
        echo $square_error_pressure $square_error_flow $fill_error $leakage_volume $fitness >> result.txt
	i=$i+1
    done
    cat calibration.xml >> population.xml
    #create next generation
    echo "generating next generation"
	./genetic reproduce
    echo "... done"
done













