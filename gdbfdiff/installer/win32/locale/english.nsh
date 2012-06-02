;;
;;  english.nsh
;;
;;  Default language strings for the Windows GDBFDIFF NSIS installer.
;;  Windows Code page: 1252
;;
;;  Version 2
;;  Note: If translating this file, replace "!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING"
;;  with "!define".

; Make sure to update the GDBFDIFF_MACRO_LANGUAGEFILE_END macro in
; langmacros.nsh when updating this file

; GTK+ was not found
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_NO_GTK			"Please install GTK+ version 2.6.0 or higher. It is available from GDBFDIFF-installer.sourceforge.net"

; Don't install over pre 0.95 versions
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_NO_INSTALL_OVER		"Please remove GDBFDIFF installations before 0.95 completely or install GDBFDIFF to a different location."

; License Page
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_LICENSE_BUTTON		"Next >"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_LICENSE_BOTTOM_TEXT		"$(^Name) is released under the GPL license. The license is provided here for information purposes only. $_CLICK"

; Components Page
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_SECTION_TITLE			"GDBFDIFF GDBFDIFFgram Editor (required)"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING TRANSLATIONS_SECTION_TITLE	"Translations"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING TRANSLATIONS_SECTION_DESCRIPTION  "Optional translations of the GDBFDIFF user interface"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_SECTION_DESCRIPTION		"Core GDBFDIFF files and dlls"

; Installer Finish Page
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_FINISH_VISIT_WEB_SITE		"Visit the GDBFDIFF for Windows Web Page"

; GDBFDIFF Section Prompts and Texts
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_UNINSTALL_DESC		"GDBFDIFF (remove only)"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_PROMPT_WIPEOUT		"Your old GDBFDIFF directory is about to be deleted. Would you like to continue?$\r$\rNote: Any non-standard plugins that you may have installed will be deleted.$\rGDBFDIFF user settings will not be affected."
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING GDBFDIFF_PROMPT_DIR_EXISTS		"The installation directory you specified already exists. Any contents$\rwill be deleted. Would you like to continue?"

; Uninstall Section Prompts
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING un.GDBFDIFF_UNINSTALL_ERROR_1		"The uninstaller could not find registry entries for GDBFDIFF.$\rIt is likely that another user installed this application."
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING un.GDBFDIFF_UNINSTALL_ERROR_2		"You do not have permission to uninstall this application."
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING un.GDBFDIFF_UNINSTALLATION_WARNING	"This will completely delete $INSTDIR and all all subdirectories. Continue?"
!insertmacro GDBFDIFF_MACRO_DEFAULT_STRING un.GDBFDIFF_DOTGDBFDIFF_WARNING		"This will completely delete $PROFILE\.GDBFDIFF and all subdirectories. Continue?"
