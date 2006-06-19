;;
;;  german.nsh
;;
;;  German language strings for the Windows GDBFDIFF NSIS installer.
;;  Windows Code page: 1252
;;
;;  Author: Bjoern Voigt <bjoern@cs.tu-berlin.de>, 2003.
;;  Version 2
;;

; No GTK+ was found
!define GDBFDIFF_NO_GTK				"Bitte installieren sie GTK+ Version 2.6.0 oder besser. Es kann unter http://GDBFDIFF-installer.sourceforge.net heruntergeladen werden."

; Don't install over pre 0.95 versions
!define GDBFDIFF_NO_INSTALL_OVER			"Bitte deinstallieren Sie GDBFDIFF Versionen vor 0.95 komplett oder installieren Sie GDBFDIFF unter einem anderen Pfad."

; License Page
!define GDBFDIFF_LICENSE_BUTTON			"Weiter >"
!define GDBFDIFF_LICENSE_BOTTOM_TEXT		"$(^Name) wird unter der GPL Lizenz veröffentlicht. Die Lizenz hier dient nur der Information. $_CLICK"
 
; Components Page
!define GDBFDIFF_SECTION_TITLE			"GDBFDIFF GDBFDIFFgrameditor (erforderlich)"
!define GDBFDIFF_SECTION_DESCRIPTION			"GDBFDIFF Dateien und -DLLs"
!define TRANSLATIONS_SECTION_TITLE		"Übersetzungen"
!define TRANSLATIONS_SECTION_DESCRIPTION 	"Optional Übersetzungen der GDBFDIFF-Benutzeroberfläche fuer verschiedene Sprachen"
  
; Installer Finish Page
!define GDBFDIFF_FINISH_VISIT_WEB_SITE		"Besuchen Sie die GDBFDIFF für Windows Webseite"
 
; GDBFDIFF Section Prompts and Texts
!define GDBFDIFF_UNINSTALL_DESC			"GDBFDIFF (nur entfernen)"
!define GDBFDIFF_PROMPT_WIPEOUT			"Ihre altes GDBFDIFF-Verzeichnis soll gelöscht werden. Möchten Sie fortfahren?$\r$\rHinweis: Alle nicht-Standard Plugins, die Sie evtl. installiert haben werden$\rgelöscht. GDBFDIFF-Benutzereinstellungen sind nicht betroffen."
!define GDBFDIFF_PROMPT_DIR_EXISTS		"Das Installationsverzeichnis, dass Sie angegeben haben, existiert schon. Der Verzeichnisinhalt$\rwird gelöscht. Möchten Sie fortfahren?"
  
; GTK+ Themes section
!define GTK_NO_THEME_INSTALL_RIGHTS		"Sie haben keine Berechtigung, um ein GTK+ Theme zu installieren."
 
; Uninstall Section Prompts
!define un.GDBFDIFF_UNINSTALL_ERROR_1		"Der Deinstaller konnte keine Registrierungschlüssel für GDBFDIFF finden.$\rEs ist wahrscheinlich, dass ein anderer Benutzer diese Anwendunng installiert hat."
!define un.GDBFDIFF_UNINSTALL_ERROR_2		"Sie haben keine Berechtigung, diese Anwendung zu deinstallieren."
!define un.GDBFDIFF_UNINSTALLATION_WARNING		"Die Deinstallation wird $INSTDIR und alle Unterverzeichnisse komplett löschen. Fortfahren?"
!define un.GDBFDIFF_DOTGDBFDIFF_WARNING			"Die Deinstallation wird $PROFILE\.GDBFDIFF und all Unterverzeichnisse komplett löschen. Fortfahren?"

