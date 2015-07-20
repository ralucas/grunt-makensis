; example2.nsi
;
; This script is based on example1.nsi, but it remember the directory,
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "<%= appName %><%= setupName %>"

; The file to write
OutFile "<%= buildDir %><%= appName %><%= setupName %>.exe"

; The default installation directory
InstallDir $PROGRAMFILES\<%= appName %>

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_<%= appName %>" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "<%= appName %>"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  <% _.each(files, function(file) { %>
  File "<%= srcDir %><%- file %>"
  <% }) %>
  File "created_template.nsi"

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_<%= appName %> "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\<%= appName %>" "DisplayName" ""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\<%= appName %>" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\<%= appName %>" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\<%= appName %>" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\<%= appName %>"
  CreateShortcut "$SMPROGRAMS\<%= appName %>\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\<%= appName %>\<%= appName %>.lnk" "$INSTDIR\<%= exeFile %>" "" "$INSTDIR\<%= exeFile %>" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\<%= appName %>"
  DeleteRegKey HKLM SOFTWARE\NSIS_<%= appName %>

  ; Remove files and uninstaller
  Delete $INSTDIR\<%= appName %>.nsi
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\<%= appName %>\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\<%= appName %>"
  RMDir "$INSTDIR"

SectionEnd

