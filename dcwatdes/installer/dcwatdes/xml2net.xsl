<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns="http://www.w3.org/1999/xhtml"> 

<!-- DC Water Design Extension Version 2.03 Stylesheet -->
<!-- (c) 2000, 2001 DORSCH Consult -->
<!-- converts data from XML to an Epanet input file -->
<!-- requires an XLST processor -->

<xsl:template match="/network">
[TITLE]
<xsl:value-of select="title/text()"/>
[JUNCTIONS]
<xsl:for-each select="junctions/junction">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@elevation"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@demand"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@pattern"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[RESERVOIRS]
<xsl:for-each select="reservoirs/reservoir">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@head"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@pattern"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[TANKS]
<xsl:for-each select="tanks/tank">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@elevation"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@initiallevel"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@minimumlevel"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@maximumlevel"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@diameter"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@minimumvolume"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@volumecurve"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[Pipes]
<xsl:for-each select="pipes/pipe">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node1"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node2"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@length"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@diameter"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@roughness"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@minorloss"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@status"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[PUMPS]
<xsl:for-each select="pumps/pump">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node1"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node2"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@properties"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[Valves]
<xsl:for-each select="valves/valve">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node1"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@node2"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@diameter"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@type"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@setting"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@minorloss"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[EMITTERS]
<xsl:for-each select="emitters/emitter">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@flowcoefficient"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[CURVES]
<xsl:for-each select="curves/curve">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@dc_x"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@dc_y"/><xsl:text>
</xsl:text>
		</xsl:for-each>
[PATTERNS]
<xsl:for-each select="patterns/pattern">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>  
			<xsl:value-of select="@multiplier"/><xsl:text>
</xsl:text>
		</xsl:for-each>
  
[ENERGY]
<xsl:for-each select="energy/energ">
			<xsl:value-of select="@value"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@parameter"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[STATUS]
<xsl:for-each select="status/statu">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@setting"/><xsl:text>
</xsl:text>
		</xsl:for-each>


[CONTROLS]
<xsl:for-each select="controls/control">
			<xsl:value-of select="text"/><xsl:text></xsl:text>
			<xsl:value-of select="@whattodoif"/><xsl:text>
</xsl:text>
		
		</xsl:for-each>


[RULES]
<xsl:for-each select="rules/rule">
			<xsl:value-of select="text"/><xsl:text></xsl:text>  
			<xsl:value-of select="@number"/><xsl:text></xsl:text>  
			<xsl:value-of select="@law"/><xsl:text>
</xsl:text>
		</xsl:for-each>
  

[DEMANDS]
<xsl:for-each select="demands/demand">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@base_demand"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@demand_pattern"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@demand_category"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[QUALITY]
<xsl:for-each select="quality/qualit">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@initialquality"/><xsl:text>
</xsl:text>
		</xsl:for-each>


[REACTIONS]
<xsl:for-each select="reactions/reaction">
			<xsl:value-of select="text()"/><xsl:text></xsl:text>
			<xsl:value-of select="@result"/><xsl:text>
</xsl:text>
		</xsl:for-each>


[SOURCES]
<xsl:for-each select="sources/source">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@type"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@strength"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@pattern"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[MIXING]
<xsl:for-each select="mixing/mixin">
			<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@model"/><xsl:text>   </xsl:text>
			<xsl:value-of select="@fraction"/><xsl:text>
</xsl:text>
		</xsl:for-each>

[OPTIONS]

UNITS   <xsl:value-of select="options/units/text()"/>
HEADLOSS   <xsl:value-of select="options/headloss/text()"/>
<!-- Note HYDRAULICS removed due to Epanet GUI loading problems -->
QUALITY   <xsl:value-of select="options/quality/text()"/>
VISCOSITY   <xsl:value-of select="options/viscosity/text()"/>
DIFFUSITY   <xsl:value-of select="options/diffusivity/text()"/>
SPECIFIC GRAVITY   <xsl:value-of select="options/specificgravity/text()"/>
TRIALS   <xsl:value-of select="options/trials/text()"/>
ACCURACY   <xsl:value-of select="options/accuracy/text()"/>
UNBALANCED   <xsl:value-of select="options/unbalanced/text()"/>
PATTERN   <xsl:value-of select="options/pattern/text()"/>
DEMAND MULTIPLIER <xsl:value-of select="options/demandmultiplier/text()"/>
EMITTER EXPONENT <xsl:value-of select="options/emitterexponent/text()"/>
TOLERANCE   <xsl:value-of select="options/tolerance/text()"/>
<!-- Note MAP removed due to Epanet GUI loading problems -->


[TIMES]
DURATION <xsl:value-of select="times/duration/text()"/>
HYDRAULIC TIMESTEP <xsl:value-of select="times/hydraulictimestep/text()"/>
QUALITY TIMESTEP <xsl:value-of select="times/qualitytimestep/text()"/>
RULE TIMESTEP <xsl:value-of select="times/ruletimestep/text()"/>
PATTERN TIMESTEP <xsl:value-of select="times/patterntimestep/text()"/>
PATTERN START <xsl:value-of select="times/patternstart/text()"/>
REPORT TIMESTEP <xsl:value-of select="times/reporttimestep/text()"/>
REPORT START <xsl:value-of select="times/reportstart/text()"/>
START CLOCKTIME <xsl:value-of select="times/startclocktime/text()"/>
STATISTIC <xsl:value-of select="times/statistic/text()"/>

[REPORT]
PAGESIZE <xsl:value-of select="report/pagesize/text()"/>
<!-- FILE removed because of errors -->
STATUS <xsl:value-of select="report/status/text()"/>
SUMMARY <xsl:value-of select="report/summary/text()"/>
MESSAGES <xsl:value-of select="report/messages/text()"/>
ENERGY <xsl:value-of select="report/energy/text()"/>
NODES <xsl:value-of select="report/nodes/text()"/>
LINKS <xsl:value-of select="report/links/text()"/>

[COORDINATES]
<xsl:for-each select="coordinates/node">
	<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
	<xsl:value-of select="@x"/><xsl:text>   </xsl:text>
	<xsl:value-of select="@y"/><xsl:text>
</xsl:text>
</xsl:for-each>

[VERTICES]
<xsl:for-each select="vertices/link">
	<xsl:value-of select="text()"/><xsl:text>   </xsl:text>
	<xsl:value-of select="@x"/><xsl:text>   </xsl:text>
	<xsl:value-of select="@y"/><xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:apply-templates select="backdrop"/>
[END]
</xsl:template> 

<xsl:template match="backdrop">
[BACKDROP]
DIMENSIONS <xsl:value-of select="dimensions/text()"/>
UNITS <xsl:value-of select="units/text()"/>
FILE <xsl:value-of select="file/text()"/>
OFFSET 0.00 0.00
</xsl:template>

</xsl:stylesheet>
