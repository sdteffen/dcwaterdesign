;;
;;  english.nsh
;;
;;  Default language strings for the Windows GSHPVORONOI NSIS installer.
;;  Windows Code page: 1252
;;
;;  Version 2
;;  Note: If translating this file, replace "!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING"
;;  with "!define".

; Make sure to update the GSHPVORONOI_MACRO_LANGUAGEFILE_END macro in
; langmacros.nsh when updating this file

; GTK+ was not found
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_NO_GTK			"Please install GTK+ version 2.6.0 or higher. It is available from GSHPVORONOI-installer.sourceforge.net"

; Don't install over pre 0.95 versions
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_NO_INSTALL_OVER		"Please remove gshpvoronoi installations before 0.95 completely or install GSHPVORONOI to a different location."

; License Page
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_LICENSE_BUTTON		"Next >"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_LICENSE_BOTTOM_TEXT		"$(^Name) is released under the GPL license. The license is provided here for information purposes only. $_CLICK"

; Components Page
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_SECTION_TITLE			"gshpvoronoi (required)"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING TRANSLATIONS_SECTION_TITLE	"Translations"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING TRANSLATIONS_SECTION_DESCRIPTION  "Optional translations of the GSHPVORONOI user interface"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_SECTION_DESCRIPTION		"Core GSHPVORONOI files and dlls"

; Installer Finish Page
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_FINISH_VISIT_WEB_SITE		"Visit the GSHPVORONOI for Windows Web Page"

; GSHPVORONOI Section Prompts and Texts
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_UNINSTALL_DESC		"GSHPVORONOI (remove only)"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_PROMPT_WIPEOUT		"Your old GSHPVORONOI directory is about to be deleted. Would you like to continue?$\r$\rNote: Any non-standard plugins that you may have installed will be deleted.$\rGSHPVORONOI user settings will not be affected."
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING GSHPVORONOI_PROMPT_DIR_EXISTS		"The installation directory you specified already exists. Any contents$\rwill be deleted. Would you like to continue?"

; Uninstall Section Prompts
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING un.GSHPVORONOI_UNINSTALL_ERROR_1		"The uninstaller could not find registry entries for GSHPVORONOI.$\rIt is likely that another user installed this application."
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING un.GSHPVORONOI_UNINSTALL_ERROR_2		"You do not have permission to uninstall this application."
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING un.GSHPVORONOI_UNINSTALLATION_WARNING	"This will completely delete $INSTDIR and all all subdirectories. Continue?"
!insertmacro GSHPVORONOI_MACRO_DEFAULT_STRING un.GSHPVORONOI_DOTGSHPVORONOI_WARNING		"This will completely delete $PROFILE\.GSHPVORONOI and all subdirectories. Continue?"
