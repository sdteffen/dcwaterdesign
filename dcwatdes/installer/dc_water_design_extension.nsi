; DC Water Design Extension
; Installer Source Code for NSIS 2.0

; (c) 2000 - 2004 DORSCH Consult

Name "DC Water Design Extension 2.10"
LicenseText "Please read and agree to this license before continuing."
LicenseData dcwatdes\license-dcwaterdesignextension.txt
ComponentText "This will install the DC Water Design Extension V 2.10 for ArcView on your system. Select which options you want set up."
DirText "Select a directory to install the Extension in. (The ArcView Extension directory.)"
UninstallText "This will uninstall the DC Water Design Extension V 2.10. Hit Next to uninstall, or Cancel to cancel."
OutFile dcwatdes-2.10-setup.exe
Icon dc.ico
;EnabledBitmap dcbitmap1.bmp
;DisabledBitmap dcbitmap2.bmp
InstType Typical

InstallDir "c:\esri\av_gis30\arcview\ext32"
InstallDirRegKey HKEY_LOCAL_MACHINE "Software\DCWaterDesignExtension" "instpath"
SetOverwrite on

Section "DC Water Design Extension V 2.10"
SectionIn 1
SetOutPath $INSTDIR\dcwatdes
WriteUninstaller uninstall-dcwatdes.exe
File dcwatdes\epanet_options.dbf
File dcwatdes\epanet_report.dbf
File dcwatdes\epanet_times.dbf
File dcwatdes\epanet2mysql.exe 
File dcwatdes\license-dcwaterdesignextension.txt
File dcwatdes\av_epanet_data_model.pdf
File dcwatdes\xml2net.xsl
File dcwatdes\systemcall.dll
File ..\inp2shp\inp2shp.exe
File dcwatdes\epanet2.dll

SetOutPath "$INSTDIR\help"
File "..\doc\en\dcwaterdesign.pdf"
File "..\doc\en\dcwaterdesign.chm"

SetOutPath $INSTDIR
File c:\esri\av_gis30\arcview\ext32\dcwatdes2.avx

WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName" "DC Water Design Extension V 2.10 (remove only)"
WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString" '"$INSTDIR\uninstall-dcwatdes.EXE"'
WriteRegStr HKEY_LOCAL_MACHINE "Software\DCWaterDesignExtension" "instpath" $INSTDIR
SectionEnd

Section "Xml Parser Extension V 1.00"
SectionIn 1
SetOutPath $INSTDIR
File c:\esri\av_gis30\arcview\ext32\XmlParser1_00.avx
SectionEnd

Section "XSLT Processor"
SectionIn 1
SetOutPath $INSTDIR\dcwatdes\xslt
File dcwatdes\xslt\*.*
SectionEnd

Section "Start Menu Entries"
SectionIn 1
SetShellVarContext all
SetOutPath "$SMPROGRAMS\DC Water Design Extension"
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Manual (PDF).lnk" "$INSTDIR\help\dcwatdes_manual.pdf" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Manual (CHM).lnk" "$INSTDIR\help\dcwatdes_manual.chm" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Data Model.lnk" "$INSTDIR\dcwatdes\av_epanet_data_model.pdf" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\License.lnk" "$INSTDIR\dcwatdes\license-dcwaterdesignextension.txt" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\Uninstall DC Water Design.lnk" "$INSTDIR\uninstall-dcwatdes.exe" "" "" 0
File "DC Water Design Extension Homepage.url"
File "Report a Bug.url"
SectionEnd

Section Uninstall
SetShellVarContext all
Delete $INSTDIR\dcwatdes\cygwin\*.*
RMDir $INSTDIR\dcwatdes\cygwin
Delete $INSTDIR\dcwatdes\xslt\*.*
RMDir $INSTDIR\dcwatdes\xslt
Delete $INSTDIR\dcwatdes\*.*
RMDir $INSTDIR\dcwatdes
Delete $INSTDIR\dcwatdes2.avx
Delete $INSTDIR\XmlParser1_00.avx
Delete "$INSTDIR\help\dcwaterdesign.chm"
Delete "$INSTDIR\help\dcwaterdesign.pdf"
Delete "$SMPROGRAMS\DC Water Design Extension\*.*"
RMDir "$SMPROGRAMS\DC Water Design Extension"

DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString"
DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName"
DeleteRegKey HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension"
SectionEnd
