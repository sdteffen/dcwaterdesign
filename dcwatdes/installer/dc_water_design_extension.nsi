Name "DC Water Design Extension 2.02"
LicenseText "Please read and agree to this license before continuing."
LicenseData dcwatdes\license-dcwaterdesignextension.txt
ComponentText "This will install the DC Water Design Extension V 2.02 for ArcView on your system. Select which options you want set up."
DirText "Select a directory to install the Extension in. (The ArcView Extension directory.)"
UninstallText "This will uninstall the DC Water Design Extension V 2.02. Hit Next to uninstall, or Cancel to cancel."
UninstallExeName uninstall-dcwatdes.exe
OutFile dcwatdes-2.02-setup.exe
Icon dc.ico
EnabledBitmap bitmap1.bmp
DisabledBitmap bitmap2.bmp
InstType Typical

InstallDir "c:\esri\av_gis30\arcview\ext32"
InstallDirRegKey HKEY_LOCAL_MACHINE "Software\DCWaterDesignExtension" "instpath"
SetOverwrite on

Section "DC Water Design Extension V 2.02"
SetOutPath $INSTDIR\dcwatdes
File dcwatdes\epanet_options.dbf
File dcwatdes\epanet_report.dbf
File dcwatdes\epanet_times.dbf
File dcwatdes\epanet2mysql.exe
SetOutPath $INSTDIR
File d:\esri\av_gis30\arcview\ext32\dcwatdes2.avx

WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName" "DC Water Design Extension V 2.02 (remove only)"
WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString" '"$INSTDIR\uninstall-dcwatdes.EXE"'
WriteRegStr HKEY_LOCAL_MACHINE "Software\DCWaterDesignExtension" "instpath" $INSTDIR

Section "Xml Parser Extension V 1.00"
SectionIn 1
SetOutPath $INSTDIR
File c:\esri\av_gis30\arcview\ext32\XmlParser1_00.avx

Section "XSLT Processor"
SectionIn 1
SetOutPath $INSTDIR\dcwatdes\xslt
File dcwatdes\xslt\*.*

Section "sed"
SectionIn 1
SetOutPath $INSTDIR\dcwatdes\cygwin
File dcwatdes\cygwin\*.*

Section "Start Menu Entries"
SectionIn 1
SetOutPath "$SMPROGRAMS\DC Water Design Extension"
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Manual.lnk" "$INSTDIR\dcwatdes\dcwatdes_manual.pdf" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\License.lnk" "$INSTDIR\dcwatdes\license-dcwaterdesignextension.txt" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\Uninstall DC Water Design.lnk" "$INSTDIR\uninstall-dcwatdes.exe" "" "" 0

Section Uninstall
Delete $INSTDIR\dcwatdes\cygwin\*.*
RMDir $INSTDIR\dcwatdes\cygwin
Delete $INSTDIR\dcwatdes\xslt\*.*
RMDir $INSTDIR\dcwatdes\xslt
Delete $INSTDIR\dcwatdes\*.*
RMDir $INSTDIR\dcwatdes
Delete $INSTDIR\dcwatdes2.avx
Delete $INSTDIR\XmlParser1_00.avx
Delete "$SMPROGRAMS\DC Water Design Extension\*.*"
RMDir "$SMPROGRAMS\DC Water Design Extension"

DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString"
DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName"
DeleteRegKey HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension"

