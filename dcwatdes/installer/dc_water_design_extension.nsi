; DC Water Design Extension
; Installer Source Code for NSIS 2.0

; (c) 2000 - 2004 DORSCH Consult

!define DC_PRODUCT "DC Water Design Extension"
!define DC_VERSION "2.10+cvs-2"
!define DC_PACKAGING "1"

!include "MUI.nsh"

Name "${DC_PRODUCT} ${DC_VERSION}"
OutFile "dcwaterdesign-setup-${DC_VERSION}-${DC_PACKAGING}.exe"

InstallDir "c:\esri\av_gis30\arcview"

InstallDirRegKey HKCU "Software\{MUI_PRODUCT}" ""

  !define MUI_LICENSEPAGE
  !define MUI_COMPONENTSPAGE
  !define MUI_COMPONENTSPAGE_CHECKBITMAP "${NSISDIR}\Contrib\Graphics\Checks\colorful.bmp"
  !define MUI_ICON "dc.ico"
  !define MUI_UNICON "dc.ico"
  !define MUI_DIRECTORYPAGE
  !define MUI_HEADERIMAGE_BITMAP "installer-header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "installer-header.bmp"
  
  !define MUI_ABORTWARNING
  
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  
  !insertmacro MUI_PAGE_LICENSE "dcwatdes\license-dcwaterdesignextension.txt"

  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES 
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

  LangString DESC_SecWatDes ${LANG_ENGLISH} "Install the DC Water Design Extension."

;Icon dc.ico
;EnabledBitmap dcbitmap1.bmp
;DisabledBitmap dcbitmap2.bmp

Section "DC Water Design" SecWatDes
SetOutPath "$INSTDIR\ext32\dcwatdes"

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

SetOutPath "$INSTDIR\ext32"
File "c:\esri\av_gis30\arcview\ext32\dcwatdes2.avx"

; XML Parser
File "c:\esri\av_gis30\arcview\ext32\XmlParser1_00.avx"

SetOutPath "$INSTDIR\ext32\dcwatdes\xslt"
File "dcwatdes\xslt\*.*"

SetShellVarContext all
SetOutPath "$SMPROGRAMS\DC Water Design Extension"
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Manual (PDF).lnk" "$INSTDIR\help\dcwatdes_manual.pdf" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Manual (CHM).lnk" "$INSTDIR\help\dcwatdes_manual.chm" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\DC Water Design Data Model.lnk" "$INSTDIR\dcwatdes\av_epanet_data_model.pdf" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\License.lnk" "$INSTDIR\dcwatdes\license-dcwaterdesignextension.txt" "" "" 0
CreateShortCut "$SMPROGRAMS\DC Water Design Extension\Uninstall DC Water Design.lnk" "$INSTDIR\uninstall-dcwatdes.exe" "" "" 0
File "DC Water Design Extension Homepage.url"
File "Report a Bug.url"

WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName" "DC Water Design Extension V 2.10 (remove only)"
WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString" '"$INSTDIR\uninstall-dcwatdes.EXE"'
WriteRegStr HKEY_LOCAL_MACHINE "Software\DCWaterDesignExtension" "instpath" $INSTDIR

WriteUninstaller "$INSTDIR\uninstall-dcwatdes${DC_VERSION}-${DC_PACKAGING}.exe"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWatDes} $(DESC_SecWatDes)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section Uninstall
SetShellVarContext all
Delete $INSTDIR\ext32\dcwatdes\cygwin\*.*
RMDir $INSTDIR\ext32\dcwatdes\cygwin
Delete $INSTDIR\ext32\dcwatdes\xslt\*.*
RMDir $INSTDIR\ext32\dcwatdes\xslt
Delete $INSTDIR\ext32\dcwatdes\*.*
RMDir $INSTDIR\ext32\dcwatdes
Delete $INSTDIR\ext32\dcwatdes2.avx
Delete $INSTDIR\ext32\XmlParser1_00.avx
Delete "$INSTDIR\help\dcwaterdesign.chm"
Delete "$INSTDIR\help\dcwaterdesign.pdf"
Delete "$SMPROGRAMS\DC Water Design Extension\*.*"
RMDir "$SMPROGRAMS\DC Water Design Extension"

DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "UninstallString"
DeleteRegValue HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension" "DisplayName"
DeleteRegKey HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\DCWaterDesignExtension"
SectionEnd

Function .onInit
  ReadRegStr $1 HKEY_LOCAL_MACHINE "Software\ESRI\ArcView GIS Version 3.0\CurrentVersion" "Path"
  IfErrors arcview_not_found arcview_found
  arcview_not_found:
  MessageBox MB_OK|MB_ICONSTOP "No ArcView 3.* installation was found. Aborting."
  Abort "No ArcView 3.* installation was found."
  arcview_found:
  GetFullPathName $INSTDIR "$1\.."
FunctionEnd
