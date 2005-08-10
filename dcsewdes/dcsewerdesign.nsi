; DC Sewer Design Extension Installer
; NSIS 2.0 Script
; (c) 2004, 2005 DORSCH Consult

; copy this file to the freshly extracted SewDes zip distribution folder and 
; compile

!define MUI_PRODUCT "DC Sewer Design Extension"
!define MUI_VERSION "2.0.8"
!define MUI_PACKAGING "1"

!include "MUI.nsh"

;--------------------------------
;Configuration

  ;General
  Name "${MUI_PRODUCT} ${MUI_VERSION}"
  OutFile "dcsewerdesign-setup-${MUI_VERSION}-${MUI_PACKAGING}.exe"

  ;Folder selection page
  InstallDir "c:\esri\av_gis30\arcview"
  
  ;Remember install folder
  InstallDirRegKey HKCU "Software\${MUI_PRODUCT}" ""

;--------------------------------
;Modern UI Configuration

  !define MUI_LICENSEPAGE
  !define MUI_COMPONENTSPAGE
  !define MUI_DIRECTORYPAGE
  
  !define MUI_ABORTWARNING
  
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  
  !insertmacro MUI_PAGE_LICENSE "COPYING"

  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES 
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
  
;--------------------------------
;Language Strings

  ;Description
  LangString DESC_SecSewDes ${LANG_ENGLISH} "Install the DC Sewer Design Extension."

;--------------------------------
;Installer Sections

Section "Sewer Design" SecSewDes
 SetOutPath "$INSTDIR\ext32"
 File "c:\esri\av_gis30\arcview\ext32\dcsewdes.avx"  
 
 SetOutPath "$INSTDIR\help"
 File "doc\en\dcsewerdesign.chm"
 File "doc\en\dcsewerdesign.pdf"
 
 ; Store install folder
 WriteRegStr HKCU "Software\${MUI_PRODUCT}" "" $INSTDIR
  
 ; Create uninstaller
 WriteUninstaller "$INSTDIR\uninstall-dcsewerdesign-${MUI_VERSION}-${MUI_PACKAGING}.exe"

SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSewDes} $(DESC_SecSewDes)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"
  
  Delete "$INSTDIR\HELP\dcsewerdesign.pdf"
  Delete "$INSTDIR\HELP\dcsewerdesign.chm"
  Delete "$INSTDIR\ext32\dcsewdes.avx"
  
  DeleteRegKey /ifempty HKCU "Software\${MUI_PRODUCT}"
  
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