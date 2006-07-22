; DC Processing Extension Installer
; NSIS 2.0 Script
; (c) 2004 - 2006 DORSCH Consult

!define MUI_PRODUCT "DC Processing Extension"
!define MUI_VERSION "1.2.9"
!define MUI_PACKAGING "1"

!include "MUI.nsh"

;--------------------------------
;Configuration

  ;General
  Name "${MUI_PRODUCT} ${MUI_VERSION}"
  OutFile "dcprocessing-setup-${MUI_VERSION}-${MUI_PACKAGING}.exe"

  ;Folder selection page
  InstallDir "c:\esri\av_gis30\arcview"
  
  ;Remember install folder
  InstallDirRegKey HKCU "Software\${MUI_PRODUCT}" ""
  
  !define MUI_HEADERIMAGE_BITMAP "images\installer-header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "images\installer-header.bmp"
  !define MUI_HEADERIMAGE
  !define MUI_ICON "images\dc.ico"
  !define MUI_UNICON "images\dc.ico"
  !define MUI_COMPONENTSPAGE_CHECKBITMAP "${NSISDIR}\Contrib\Graphics\Checks\colorful.bmp"

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
  LangString DESC_SecSewDes ${LANG_ENGLISH} "Install the DC Processing Extension."

;--------------------------------
;Installer Sections

Section "DC Processing" SecSewDes
 SetOutPath "$INSTDIR\ext32"
 File "c:\esri\av_gis30\arcview\ext32\dcprocessing.avx"  
 
 SetOutPath "$INSTDIR\help"
 File "doc\en\dcprocessing.chm"
 File "doc\en\dcprocessing.pdf"
 
 ; Store install folder
 WriteRegStr HKCU "Software\${MUI_PRODUCT}" "" $INSTDIR
  
 ; Create uninstaller
 WriteUninstaller "$INSTDIR\uninstall-dcprocessing-${MUI_VERSION}-${MUI_PACKAGING}.exe"

SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSewDes} $(DESC_SecSewDes)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"
  
  Delete "$INSTDIR\HELP\dcprocessing.pdf"
  Delete "$INSTDIR\HELP\dcprocessing.chm"
  Delete "$INSTDIR\ext32\dcprocessing.avx"
  
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