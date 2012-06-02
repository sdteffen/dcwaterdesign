;;
;;  french.nsh
;;
;;  French language strings for the Windows GDBFDIFF NSIS installer.
;;  Windows Code page: 1252
;;
;;  Version 2
;;  Author: Yannick LE NY <y.le.ny@ifrance.com>, 2005.
;;  Author: Steffen Macke <sdteffen@gmail.com> 2006

; No GTK+ was found
!define GDBFDIFF_NO_GTK				"Please install GTK+ Version 2.6.0 or higher. It is available from http://GDBFDIFF-installer.sourceforge.net." 

; Don't install over pre 0.95 versions
!define GDBFDIFF_NO_INSTALL_OVER			"Please remove GDBFDIFF installations before 0.95 completely or install GDBFDIFF to a different location."

; License Page
!define  GDBFDIFF_LICENSE_BUTTON			"Suivant >"
!define  GDBFDIFF_LICENSE_BOTTOM_TEXT		"$(^Name) est publi� sous la licence GPL. La licence est fourni ici uniquement pour information. $_CLICK"

; Components Page
!define  GDBFDIFF_SECTION_TITLE			"Editeur de GDBFDIFFgramme GDBFDIFF (requis)"
!define  GDBFDIFF_SECTION_DESCRIPTION		"Fichiers principaux GDBFDIFF et dlls"
!define  TRANSLATIONS_SECTION_TITLE		"Translations"
!define  TRANSLATIONS_SECTION_DESCRIPTION	"Optional translations of the GDBFDIFF user interface."
; Installer Finish Page
!define  GDBFDIFF_FINISH_VISIT_WEB_SITE		"Visiter la page Web de GDBFDIFF pour Windows"

; GDBFDIFF Section Prompts and Texts
!define  GDBFDIFF_UNINSTALL_DESC			"GDBFDIFF (supprimer uniquement)"
!define  GDBFDIFF_PROMPT_WIPEOUT			"Votre ancien repertoire GDBFDIFF est sur le point d'etre supprime. Voulez-vous continuer?$\r$\rNote: Tous les plugins non-standard que vous avez installe seront supprim�s.$\rLes parametres utilisateur ne seront pas affectes."
!define  GDBFDIFF_PROMPT_DIR_EXISTS		"Le repertoire d'installation que vous aves indique existe deja. Tout le contenu de $\rsera supprime. Voulez-vous continuer?"

; Uninstall Section Prompts
!define  un.GDBFDIFF_UNINSTALL_ERROR_1		"Le desinstalleur ne peut pas trouver les entrees de registre pour GDBFDIFF.$\rIl est probable qu'un autre utilisateur a installe cette application."
!define  un.GDBFDIFF_UNINSTALL_ERROR_2		"Vous n'avez pas la permission de desinstaller cette application."
!define  un.GDBFDIFF_UNINSTALLATION_WARNING		"Cela supprimera completement $INSTDIR et tous ses sous-repertoire. Continuer?"
!define  un.GDBFDIFF_DOTGDBFDIFF_WARNING 			"Cela supprimera completement $PROFILE\.GDBFDIFF et tous ses sous-repertoire. Continuer?"
