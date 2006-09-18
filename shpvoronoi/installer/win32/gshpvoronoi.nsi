; gshpvoronoi -- A GUI frontend to shpvoronoi
; Copyright (C) 2006 DC Water and Environment
;  
; gshpvoronoi.nsi : Nullsoft Installation System (NSIS) script
; Copyright (C) 2000-2004 Herman Bloggs, Steffen Macke
; Copyright (C) 2005,2006 Steffen Macke
; Copyright (C) 2006 DC Water and Environment
;  
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

; NOTE: this .NSI script is designed for NSIS v2.0

;--------------------------------
;Global Variables
Var name

;--------------------------------
;Configuration

;The name var is set in .onInit
Name $name

; Uninstall only the installed files and folders
!define UninstLog "uninstall.log"
Var UninstLog

; Where the GTK+ binares are installed. Set in .onInit 
Var GTKBIN

; Add file macro
!macro File FilePath FileName
 !define FileID ${__LINE__}
 ;IfFileExists "$OUTDIR\${FileName}" NoExtract_${FileID}
 File "${FilePath}${FileName}"
 NoExtract_${FileID}:
 FileWrite $UninstLog "$OUTDIR\${FileName}$\r$\n"
 !undef FileID
!macroend
!define File "!insertmacro File"
 
; Set output path macro
!macro SetOutPath Path
 SetOutPath "${Path}"
 FileWrite $UninstLog "${PATH}$\r$\n"
!macroend
!define SetOutPath "!insertmacro SetOutPath"
 
Section -openlogfile
 SetOutPath "$INSTDIR"
 ; Check if install directory is pre 0.95
 IfFileExists "$INSTDIR\bin\libgtk-win32-2.0-0.dll" abort_no_overinstall continue_install
 abort_no_overinstall:
   MessageBox MB_OK|MB_ICONEXCLAMATION $(GSHPVORONOI_NO_INSTALL_OVER)
   Abort $(GSHPVORONOI_NO_INSTALL_OVER)
 continue_install:
 IfFileExists "$INSTDIR\${UninstLog}" +3
 FileOpen $UninstLog "$INSTDIR\${UninstLog}" w
 Goto +4
  SetFileAttributes "$INSTDIR\${UninstLog}" NORMAL
  FileOpen $UninstLog "$INSTDIR\${UninstLog}" a
  FileSeek $UninstLog 0 END
SectionEnd

OutFile "gshpvoronoi-setup-${GSHPVORONOI_VERSION}.exe"

SetCompressor LZMA
;DirShow show
ShowInstDetails show
ShowUninstDetails show
SetDateSave on

; $name and $INSTDIR are set in .onInit function..

!include "MUI.nsh"
;!include "Sections.nsh"

;--------------------------------
;Defines

!define GSHPVORONOI_REG_KEY				"SOFTWARE\GSHPVORONOI"
!define GSHPVORONOI_UNINSTALL_KEY			"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\gshpvoronoi"
!define HKLM_APP_PATHS_KEY			"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gshpvoronoi.exe"
!define HKLM_CMD_PATHS_KEY			"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gshpvoronoi.exe"
!define GSHPVORONOI_STARTUP_RUN_KEY			"SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
!define GSHPVORONOI_UNINST_EXE				"gshpvoronoi-${GSHPVORONOI_VERSION}-uninstall.exe"

XPStyle On
  
VIAddVersionKey "ProductName" "gshpvoronoi"
VIAddVersionKey "CompanyName" "DC Water and Environment"
VIAddVersionKey "LegalCopyright" "(c) 2006 DC Water and Environment"
VIAddVersionKey "FileDescription" "gshpvoronoi installer"
VIAddVersionKey "FileVersion" "0.1.0.0"
VIProductVersion "0.1.0.0"

;--------------------------------
;Modern UI Configuration

  !define MUI_ICON				"dc.ico"
  !define MUI_UNICON				"dc.ico"
  !define MUI_WELCOMEFINISHPAGE_BITMAP 		"dc-intro.bmp"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP		"dc-header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP		"dc-header.bmp"

  ; Alter License section
  !define MUI_LICENSEPAGE_BUTTON		$(GSHPVORONOI_LICENSE_BUTTON)
  !define MUI_LICENSEPAGE_TEXT_BOTTOM		$(GSHPVORONOI_LICENSE_BOTTOM_TEXT)

  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_ABORTWARNING

  ;Finish Page config
  !define MUI_FINISHPAGE_RUN			"$INSTDIR\bin\gshpvoronoi.exe"
  !define MUI_FINISHPAGE_RUN_NOTCHECKED
  !define MUI_FINISHPAGE_LINK			$(GICONV_FINISH_VISIT_WEB_SITE)
  !define MUI_FINISHPAGE_LINK_LOCATION          "http://dcwaterdesign.sourceforge.net/"

;--------------------------------
;Pages
  
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE			"..\..\COPYING"
  !insertmacro MUI_PAGE_COMPONENTS

  ; GSHPVORONOI install dir page
  !insertmacro MUI_PAGE_DIRECTORY

  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages
 
  ;; English goes first because its the default. The rest are
  ;; in alphabetical order (at least the strings actually displayed
  ;; will be).

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Translations

  !define GSHPVORONOI_DEFAULT_LANGFILE "locale\english.nsh"

  !include "langmacros.nsh"
  
  !insertmacro GSHPVORONOI_MACRO_INCLUDE_LANGFILE "ENGLISH" "locale\english.nsh"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start Install Sections ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;--------------------------------
;GSHPVORONOI Install Section

Section $(GSHPVORONOI_SECTION_TITLE) SecGSHPVORONOI
  SetOverwrite On
  SectionIn 1 RO

  ; Check install rights..
  Call CheckUserInstallRights
  Pop $R0

  StrCmp $R0 "NONE" GSHPVORONOI_none
  StrCmp $R0 "HKLM" GSHPVORONOI_hklm GSHPVORONOI_hkcu
   
  GSHPVORONOI_hklm:
    WriteRegStr HKLM "${HKLM_APP_PATHS_KEY}" "" "$INSTDIR\bin\gshpvoronoi.exe"
    WriteRegStr HKLM "${HKLM_APP_PATHS_KEY}" "Path" "$R1\bin;$GTKBIN"
    WriteRegStr HKLM ${GSHPVORONOI_REG_KEY} "" "$INSTDIR"
    WriteRegStr HKLM ${GSHPVORONOI_REG_KEY} "Version" "${GSHPVORONOI_VERSION}"
    WriteRegStr HKLM "${GSHPVORONOI_UNINSTALL_KEY}" "DisplayName" $(GSHPVORONOI_UNINSTALL_DESC)
    WriteRegStr HKLM "${GSHPVORONOI_UNINSTALL_KEY}" "UninstallString" "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    WriteRegStr HKLM "${GSHPVORONOI_UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    ; Sets scope of the desktop and Start Menu entries for all users.
    SetShellVarContext "all"
    Goto GSHPVORONOI_install_files

  GSHPVORONOI_hkcu:
    WriteRegStr HKCU ${GSHPVORONOI_REG_KEY} "" "$INSTDIR"
    WriteRegStr HKCU ${GSHPVORONOI_REG_KEY} "Version" "${GSHPVORONOI_VERSION}"
    WriteRegStr HKCU "${GSHPVORONOI_UNINSTALL_KEY}" "DisplayName" $(GSHPVORONOI_UNINSTALL_DESC)
    WriteRegStr HKCU "${GSHPVORONOI_UNINSTALL_KEY}" "UninstallString" "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    WriteRegStr HKCU "${GSHPVORONOI_UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"

    Goto GSHPVORONOI_install_files

  GSHPVORONOI_none:

  GSHPVORONOI_install_files:
  
${SetOutPath} "$INSTDIR\bin"
; jEdit replacement: (^.*\\)(.*)$ 
; \${File} "$1" "$2"
${File} "..\..\devcpp\" "gshpvoronoi.exe"
${File} "..\..\devcpp\" "shpvoronoi.exe"
${File} "..\..\devcpp\" "shapelib.dll"
${File} "..\..\devcpp\" "qvoronoi.exe"
    
    SetShellVarContext all
    
${SetOutPath} "$INSTDIR\doc"
${SetOutPath} "$INSTDIR\doc\en"
${File} "..\..\doc\en\" "gshpvoronoi.pdf"
${File} "..\..\doc\en\" "gshpvoronoi.chm"
    
    CreateDirectory "$SMPROGRAMS\gshpvoronoi"
    ${SetOutPath} "$INSTDIR\bin"
    CreateShortCut "$SMPROGRAMS\gshpvoronoi\gshpvoronoi.lnk" "$INSTDIR\bin\gshpvoronoi.exe"
    CreateShortCut "$DESKTOP\gshpvoronoi.lnk" "$INSTDIR\bin\gshpvoronoi.exe"
    CreateShortCut "$SMPROGRAMS\gshpvoronoi\gshpvoronoi Documentation (PDF).lnk" "$INSTDIR\doc\en\gshpvoronoi.pdf"
    CreateShortCut "$SMPROGRAMS\gshpvoronoi\gshpvoronoi Documentation (CHM).lnk" "$INSTDIR\doc\en\gshpvoronoi.chm"
    SetOutPath "$INSTDIR"

    ; write out uninstaller
    SetOverwrite on
    WriteUninstaller "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    SetOverwrite off
    CreateShortCut "$SMPROGRAMS\GSHPVORONOI\Uninstall.lnk" "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    
  done:
SectionEnd ; end of default GSHPVORONOI section
  
Section -closelogfile
 FileClose $UninstLog
 SetFileAttributes "$INSTDIR\${UninstLog}" READONLY|SYSTEM|HIDDEN
SectionEnd

;--------------------------------
;Uninstaller Section

Section Uninstall
  
  Call un.CheckUserInstallRights
  Pop $R0
  StrCmp $R0 "NONE" no_rights
  StrCmp $R0 "HKCU" try_hkcu try_hklm

  try_hkcu:
    ReadRegStr $R0 HKCU ${GSHPVORONOI_REG_KEY} ""
    StrCmp $R0 $INSTDIR 0 cant_uninstall
      ; HKCU install path matches our INSTDIR.. so uninstall
      DeleteRegKey HKCU ${GSHPVORONOI_REG_KEY}
      DeleteRegKey HKCU "${GSHPVORONOI_UNINSTALL_KEY}"
      Goto cont_uninstall

  try_hklm:
    ReadRegStr $R0 HKLM ${GSHPVORONOI_REG_KEY} ""
    StrCmp $R0 $INSTDIR 0 try_hkcu
      ; HKLM install path matches our INSTDIR.. so uninstall
      DeleteRegKey HKLM ${GSHPVORONOI_REG_KEY}
      DeleteRegKey HKLM "${GSHPVORONOI_UNINSTALL_KEY}"
      DeleteRegKey HKLM "${HKLM_APP_PATHS_KEY}"
      DeleteRegKey HKLM "${HKLM_CMD_PATHS_KEY}"
      ; Sets start menu and desktop scope to all users..
      SetShellVarContext "all"

  cont_uninstall:
    
    ; The WinPrefs plugin may have left this behind..
    DeleteRegValue HKCU "${GSHPVORONOI_STARTUP_RUN_KEY}" "GSHPVORONOI"
    DeleteRegValue HKLM "${GSHPVORONOI_STARTUP_RUN_KEY}" "GSHPVORONOI"
    ; Remove Language preference info
    DeleteRegKey HKCU ${GSHPVORONOI_REG_KEY} ;${MUI_LANGDLL_REGISTRY_ROOT} ${MUI_LANGDLL_REGISTRY_KEY}
    
    ; Can't uninstall if uninstall.log is missing!
 IfFileExists "$INSTDIR\${UninstLog}" +3
  MessageBox MB_OK|MB_ICONSTOP "${UninstLog} not found!"
  Goto no_uninstlog
 
 Push $R0
 SetFileAttributes "$INSTDIR\${UninstLog}" NORMAL
 FileOpen $UninstLog "$INSTDIR\${UninstLog}" r
 
 LoopRead:
  ClearErrors
   FileRead $UninstLog $R0
   IfErrors LoopDone
 
   Push $R0
    Call un.TrimNewLines
   Pop $R0
   IfFileExists "$R0\*.*" 0 +3
    RMDir $R0  #is dir
   Goto LoopRead
    Delete $R0 #is file
 
    Goto LoopRead
   LoopDone:
   FileClose $UninstLog
   Delete "$INSTDIR\${UninstLog}"
   Pop $R0
    Delete "$INSTDIR\${GSHPVORONOI_UNINST_EXE}"
    
    no_uninstlog:
    ; Shortcuts..
    Delete "$SMPROGRAMS\gshpvoronoi\GSHPVORONOI.lnk"
    Delete "$SMPROGRAMS\gshpvoronoi\Uninstall.lnk"
    Delete "$SMPROGRAMS\gshpvoronoi\gshpvoronoi Documentation (CHM).lnk"
    Delete "$SMPROGRAMS\gshpvoronoi\gshpvoronoi Documentation (PDF).lnk"
    RMDir "$SMPROGRAMS\gshpvoronoi"
    Delete "$DESKTOP\gshpvoronoi.lnk"
    
    IfSilent done
    MessageBox MB_YESNO|MB_ICONEXCLAMATION $(un.GSHPVORONOI_UNINSTALLATION_WARNING) IDNO done
    skip_warning:
    RMDir /r "$INSTDIR"
        
    Goto done

  cant_uninstall:
    IfSilent skip_mb
    MessageBox MB_OK $(un.GSHPVORONOI_UNINSTALL_ERROR_1) IDOK
    skip_mb:
    Quit

  no_rights:
    IfSilent skip_mb1
    MessageBox MB_OK $(un.GSHPVORONOI_UNINSTALL_ERROR_2) IDOK
    skip_mb1:
    Quit

  done:
SectionEnd ; end of uninstall section

;--------------------------------
;Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGSHPVORONOI} \
	$(GSHPVORONOI_SECTION_DESCRIPTION)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecTranslations} \
  	$(TRANSLATIONS_SECTION_DESCRIPTION)	
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Functions

Function CheckUserInstallRights
	ClearErrors
	UserInfo::GetName
	IfErrors Win9x
	Pop $0
	UserInfo::GetAccountType
	Pop $1

	StrCmp $1 "Admin" 0 +3
                StrCpy $1 "HKLM"
		Goto done
	StrCmp $1 "Power" 0 +3
                StrCpy $1 "HKLM"
		Goto done
	StrCmp $1 "User" 0 +3
		StrCpy $1 "HKCU"
		Goto done
	StrCmp $1 "Guest" 0 +3
		StrCpy $1 "NONE"
		Goto done
	; Unknown error
	StrCpy $1 "NONE"
        Goto done

	Win9x:
		StrCpy $1 "HKLM"

	done:
        Push $1
FunctionEnd

Function un.CheckUserInstallRights
	ClearErrors
	UserInfo::GetName
	IfErrors Win9x
	Pop $0
	UserInfo::GetAccountType
	Pop $1

	StrCmp $1 "Admin" 0 +3
                StrCpy $1 "HKLM"
		Goto done
	StrCmp $1 "Power" 0 +3
                StrCpy $1 "HKLM"
		Goto done
	StrCmp $1 "User" 0 +3
		StrCpy $1 "HKCU"
		Goto done
	StrCmp $1 "Guest" 0 +3
		StrCpy $1 "NONE"
		Goto done
	; Unknown error
	StrCpy $1 "NONE"
        Goto done

	Win9x:
		StrCpy $1 "HKLM"

	done:
        Push $1
FunctionEnd

;
; Usage:
;   Push $0 ; Path string
;   Call VerifyDir
;   Pop $0 ; 0 - Bad path  1 - Good path
;
Function VerifyDir
  Pop $0
  Loop:
    IfFileExists $0 dir_exists
    StrCpy $1 $0 ; save last
    Push $0
    Call GetParent
    Pop $0
    StrLen $2 $0
    ; IfFileExists "C:" on xp returns true and on win2k returns false
    ; So we're done in such a case..
    StrCmp $2 "2" loop_done
    Goto Loop

  loop_done:
    StrCpy $1 "$0\GSHPVORONOIooB"
    ; Check if we can create dir on this drive..
    ClearErrors
    CreateDirectory $1
    IfErrors DirBad DirGood

  dir_exists:
    ClearErrors
    FileOpen $1 "$0\GSHPVORONOIfoo.bar" w
    IfErrors PathBad PathGood

    DirGood:
      RMDir $1
      Goto PathGood1

    DirBad:
      RMDir $1
      Goto PathBad1

    PathBad:
      FileClose $1
      Delete "$0\GSHPVORONOIfoo.bar"
      PathBad1:
      StrCpy $0 "0"
      Push $0
      Return

    PathGood:
      FileClose $1
      Delete "$0\GSHPVORONOIfoo.bar"
      PathGood1:
      StrCpy $0 "1"
      Push $0
FunctionEnd

Function .onVerifyInstDir
  Push $INSTDIR
  Call VerifyDir
  Pop $0
  StrCmp $0 "0" 0 dir_good
    Abort
  dir_good:
FunctionEnd

; GetParent
; input, top of stack  (e.g. C:\Program Files\Poop)
; output, top of stack (replaces, with e.g. C:\Program Files)
; modifies no other variables.
;
; Usage:
;   Push "C:\Program Files\Directory\Whatever"
;   Call GetParent
;   Pop $R0
;   ; at this point $R0 will equal "C:\Program Files\Directory"
Function GetParent
   Exch $0 ; old $0 is on top of stack
   Push $1
   Push $2
   StrCpy $1 -1
   loop:
     StrCpy $2 $0 1 $1
     StrCmp $2 "" exit
     StrCmp $2 "\" exit
     IntOp $1 $1 - 1
   Goto loop
   exit:
     StrCpy $0 $0 $1
     Pop $2
     Pop $1
     Exch $0 ; put $0 on top of stack, restore $0 to original value
FunctionEnd

Function .onInit
  StrCpy $name "gshpvoronoi ${GSHPVORONOI_VERSION}"
  !insertmacro MUI_LANGDLL_DISPLAY
  ClearErrors
  ReadRegStr $GTKBIN HKLM "Software\GTK\2.0" "DllPath"
  ReadRegStr $0 HKLM "Software\GTK\2.0" "Version"
  StrCpy $1 $0 4
  StrCmp $1 "2.0." outdated_gtk
  StrCmp $1 "2.1." outdated_gtk
  StrCmp $1 "2.2." outdated_gtk
  StrCmp $1 "2.3." outdated_gtk
  StrCmp $1 "2.4." outdated_gtk
  StrCmp $1 "2.5." outdated_gtk
  Goto has_gtk
  no_gtk:
  Push "GTKBIN"         ; push the search string onto the stack
  Push "C:\Program Files\Common Files\GTK\2.0\bin"   ; push a default value onto the stack
  Call GetParameterValue
  Pop $GTKBIN
  IfFileExists "$GTKBIN\libgtk-win32-2.0-0.dll" has_gtk 
  outdated_gtk:
  MessageBox MB_OK|MB_ICONEXCLAMATION $(GSHPVORONOI_NO_GTK)
  Abort $(GSHPVORONOI_NO_GTK)
  
  has_gtk:
    
  ; If install path was set on the command, use it.
  StrCmp $INSTDIR "" 0 instdir_done

  Call CheckUserInstallRights
  Pop $0

  StrCmp $0 "HKLM" 0 user_dir
    StrCpy $INSTDIR "$PROGRAMFILES\GSHPVORONOI"
    Goto instdir_done
  user_dir:
    StrCpy $2 "$SMPROGRAMS"
    Push $2
    Call GetParent
    Call GetParent
    Pop $2
    StrCpy $INSTDIR "$2\GSHPVORONOI"

  instdir_done:

FunctionEnd

Function un.TrimNewlines
   Exch $R0
   Push $R1
   Push $R2
   StrCpy $R1 0
 
 loop:
   IntOp $R1 $R1 - 1
   StrCpy $R2 $R0 1 $R1
   StrCmp $R2 "$\r" loop
   StrCmp $R2 "$\n" loop
   IntOp $R1 $R1 + 1
   IntCmp $R1 0 no_trim_needed
   StrCpy $R0 $R0 $R1
 
 no_trim_needed:
   Pop $R2
   Pop $R1
   Exch $R0
 FunctionEnd

; GetParameterValue
; Chris Morgan<cmorgan@alum.wpi.edu> 5/10/2004
; -Updated 4/7/2005 to add support for retrieving a command line switch
;  and additional documentation
;
; Searches the command line input, retrieved using GetParameters, for the
; value of an option given the option name.  If no option is found the
; default value is placed on the top of the stack upon function return.
;
; This function can also be used to detect the existence of just a
; command line switch like /OUTPUT  Pass the default and "OUTPUT"
; on the stack like normal.  An empty return string "" will indicate
; that the switch was found, the default value indicates that
; neither a parameter or switch was found.
;
; Inputs - Top of stack is default if parameter isn't found,
;  second in stack is parameter to search for, ex. "OUTPUT"
; Outputs - Top of the stack contains the value of this parameter
;  So if the command line contained /OUTPUT=somedirectory, "somedirectory"
;  will be on the top of the stack when this function returns
;
; Register usage
;$R0 - default return value if the parameter isn't found
;$R1 - input parameter, for example OUTPUT from the above example
;$R2 - the length of the search, this is the search parameter+2
;      as we have '/OUTPUT='
;$R3 - the command line string
;$R4 - result from StrStr calls
;$R5 - search for ' ' or '"'
 
Function GetParameterValue
  Exch $R0  ; get the top of the stack(default parameter) into R0
  Exch      ; exchange the top of the stack(default) with
            ; the second in the stack(parameter to search for)
  Exch $R1  ; get the top of the stack(search parameter) into $R1
 
  ;Preserve on the stack the registers used in this function
  Push $R2
  Push $R3
  Push $R4
  Push $R5
 
  Strlen $R2 $R1+2    ; store the length of the search string into R2
 
  Call GetParameters  ; get the command line parameters
  Pop $R3             ; store the command line string in R3
 
  # search for quoted search string
  StrCpy $R5 '"'      ; later on we want to search for a open quote
  Push $R3            ; push the 'search in' string onto the stack
  Push '"/$R1='       ; push the 'search for'
  Call StrStr         ; search for the quoted parameter value
  Pop $R4
  StrCpy $R4 $R4 "" 1   ; skip over open quote character, "" means no maxlen
  StrCmp $R4 "" "" next ; if we didn't find an empty string go to next
 
  # search for non-quoted search string
  StrCpy $R5 ' '      ; later on we want to search for a space since we
                      ; didn't start with an open quote '"' we shouldn't
                      ; look for a close quote '"'
  Push $R3            ; push the command line back on the stack for searching
  Push '/$R1='        ; search for the non-quoted search string
  Call StrStr
  Pop $R4
 
  ; $R4 now contains the parameter string starting at the search string,
  ; if it was found
next:
  StrCmp $R4 "" check_for_switch ; if we didn't find anything then look for
                                 ; usage as a command line switch
  # copy the value after /$R1= by using StrCpy with an offset of $R2,
  # the length of '/OUTPUT='
  StrCpy $R0 $R4 "" $R2  ; copy commandline text beyond parameter into $R0
  # search for the next parameter so we can trim this extra text off
  Push $R0
  Push $R5            ; search for either the first space ' ', or the first
                      ; quote '"'
                      ; if we found '"/output' then we want to find the
                      ; ending ", as in '"/output=somevalue"'
                      ; if we found '/output' then we want to find the first
                      ; space after '/output=somevalue'
  Call StrStr         ; search for the next parameter
  Pop $R4
  StrCmp $R4 "" done  ; if 'somevalue' is missing, we are done
  StrLen $R4 $R4      ; get the length of 'somevalue' so we can copy this
                      ; text into our output buffer
  StrCpy $R0 $R0 -$R4 ; using the length of the string beyond the value,
                      ; copy only the value into $R0
  goto done           ; if we are in the parameter retrieval path skip over
                      ; the check for a command line switch
 
; See if the parameter was specified as a command line switch, like '/output'
check_for_switch:
  Push $R3            ; push the command line back on the stack for searching
  Push '/$R1'         ; search for the non-quoted search string
  Call StrStr
  Pop $R4
  StrCmp $R4 "" done  ; if we didn't find anything then use the default
  StrCpy $R0 ""       ; otherwise copy in an empty string since we found the
                      ; parameter, just didn't find a value
 
done:
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0 ; put the value in $R0 at the top of the stack
FunctionEnd

 ; GetParameters
 ; input, none
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies no other variables.
 
Function GetParameters
 
  Push $R0
  Push $R1
  Push $R2
  Push $R3
  
  StrCpy $R2 1
  StrLen $R3 $CMDLINE
  
  ;Check for quote or space
  StrCpy $R0 $CMDLINE $R2
  StrCmp $R0 '"' 0 +3
    StrCpy $R1 '"'
    Goto loop
  StrCpy $R1 " "
  
  loop:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 get
    StrCmp $R2 $R3 get
    Goto loop
  
  get:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " get
    StrCpy $R0 $CMDLINE "" $R2
  
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
 
FunctionEnd

!define StrStr "!insertmacro StrStr"
 
!macro StrStr ResultVar String SubString
  Push `${String}`
  Push `${SubString}`
  Call StrStr
  Pop `${ResultVar}`
!macroend
 
Function StrStr
/*After this point:
  ------------------------------------------
  $R0 = SubString (input)
  $R1 = String (input)
  $R2 = SubStringLen (temp)
  $R3 = StrLen (temp)
  $R4 = StartCharPos (temp)
  $R5 = TempStr (temp)*/
 
  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
 
  ;Get "String" and "SubString" length
  StrLen $R2 $R0
  StrLen $R3 $R1
  ;Start "StartCharPos" counter
  StrCpy $R4 0
 
  ;Loop until "SubString" is found or "String" reaches its end
  loop:
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R5 $R1 $R2 $R4
 
    ;Compare "TempStr" with "SubString"
    StrCmp $R5 $R0 done
    ;If not "SubString", this could be "String"'s end
    IntCmp $R4 $R3 done 0 done
    ;If not, continue the loop
    IntOp $R4 $R4 + 1
    Goto loop
  done:
 
/*After this point:
  ------------------------------------------
  $R0 = ResultVar (output)*/
 
  ;Remove part before "SubString" on "String" (if there has one)
  StrCpy $R0 $R1 `` $R4
 
  ;Return output to user
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd
