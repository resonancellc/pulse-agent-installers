;
; (c) 2016 siveo, http://www.siveo.net
;
; This file is part of Pulse 2, http://www.siveo.net
;
; Pulse 2 is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; Pulse 2 is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Pulse 2; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
; MA 02110-1301, USA.


; Make sure the installer runs as admin
RequestExecutionLevel admin

; Define a few variables
!define PRODUCT_NAME "Pulse Agent"
!define PRODUCT_PUBLISHER "SIVEO"
!define PRODUCT_WEB_SITE "http://www.siveo.net"
!define PRODUCT_VERSION "1.9.8"
!define PRODUCT_DIR_REGKEY "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define SSHDATA "c:\ProgramData"
!define USERDIR "c:\Users"
!define PROGRAMDATA "C:\ProgramData"

; Variables replaced by the script calling the nsi
!define DOWNLOADS_DIR "downloads"
!define PYTHON32_FILENAME "python-2.7.9.msi"
!define PYTHON64_FILENAME "python-2.7.9.amd64.msi"
!define PY_VCPYTHON27 "VCForPython27.msi"
!define LIBCURL_FILENAME "cygcurl-4.dll"
!define PY_WIN3232_FILENAME "pypiwin32-219-cp27-none-win32.whl"
!define PY_WIN3264_FILENAME "pypiwin32-219-cp27-none-win_amd64.whl"
!define PY_NETIFACES_FILENAME "netifaces-0.10.5.tar.gz"
!define PY_COMTYPES_FILENAME "comtypes-1.1.3-2.zip"
!define PY_CONFIGPARSER_FILENAME "configparser-3.5.0.tar.gz"
!define PY_UTILS_FILENAME "utils-0.9.0.tar.gz"
!define PY_SLEEKXMPP_FILENAME "sleekxmpp-1.3.1.tar.gz"
!define PY_WMI_FILENAME "WMI-1.4.9.zip"
!define PY_ZIPFILE_FILENAME "zipfile2-0.0.12-py2.py3-none-any.whl"
!define PY_CURL32_FILENAME "pycurl-7.43.0-cp27-none-win32.whl"
!define PY_CURL64_FILENAME "pycurl-7.43.0-cp27-none-win_amd64.whl"
!define PY_LXML32_FILENAME "lxml-3.6.0-cp27-none-win32.whl"
!define PY_LXML64_FILENAME "lxml-3.6.0-cp27-none-win_amd64.whl"
!define PY_CRYPTO_FILENAME "pycrypto-2.6.1.tar.gz"
!define PY_CRON_FILENAME "croniter-0.3.16.tar.gz"
!define PY_CRON_DEPS_1_FILENAME "python_dateutil-2.6.0-py2.py3-none-any.whl"
!define PY_CRON_DEPS_2_FILENAME "six-1.10.0-py2.py3-none-any.whl"
!define PY_PSUTIL32_FILENAME "psutil-5.4.3-cp27-none-win32.whl"
!define PY_PSUTIL64_FILENAME "psutil-5.4.3-cp27-none-win_amd64.whl"
!define PULSE_AGENT "pulse-xmpp-agent-1.9.8.tar.gz"
!define PULSE_AGENT_CONFFILE "agentconf.ini"
!define PULSE_SCHEDULER_CONFFILE "manage_scheduler.ini"
!define PULSE_INVENTORY_CONFFILE "inventory.ini"
!define PULSE_AGENT_NAME "pulse-xmpp-agent"
!define PULSE_AGENT_MODULE "pulse_xmpp_agent"
!define PULSE_AGENT_TASK_XML "pulse-agent-task.xml"
!define OPENSSH_NAME "OpenSSH"
!define OPENSSH32_FILENAME "OpenSSH-Win32.zip"
!define OPENSSH64_FILENAME "OpenSSH-Win64.zip"
!define LAUNCHER_SSH_KEY "/root/.ssh/id_rsa.pub"
!define FUSION_INVENTORY_AGENT32_FILENAME "fusioninventory-agent_windows-x86_2.4.2.exe"
!define FUSION_INVENTORY_AGENT64_FILENAME "fusioninventory-agent_windows-x64_2.4.2.exe"
!define INVENTORY_TAG ""
!define PULSE_AGENT_PLUGINS "pulse-agent-plugins-1.10.tar.gz"
!define PULSE_AGENT_PLUGINS_NAME "pulse-agent-plugins"
!define RSYNC_FILENAME "rsync.zip"
!define GENERATED_SIZE "FULL"
!define RDPWRAP_FILENAME "RDPWrap-v1.6.1.zip"
!define RDPWRAP_FOLDERNAME "RDPWrap-v1.6.1"
!define VNC_AGENT32_FILENAME "tightvnc-2.8.8-gpl-setup-32bit.msi"
!define VNC_AGENT64_FILENAME "tightvnc-2.8.8-gpl-setup-64bit.msi"
!define RFB_PORT "5900"
!define CREATE_PROFILE_NAME "create-profile.ps1"

SetCompressor lzma

; Modern UI installer stuff
!include "MUI2.nsh"
!define MUI_ABORTWARNING
#!define MUI_ICON "artwork/install.ico"
!define MUI_WELCOMEPAGE_TITLE_3LINES
#!define MUI_HEADERIMAGE
#!define MUI_HEADERIMAGE_RIGHT
#!define MUI_HEADERIMAGE_BITMAP "artwork/header.bmp"
#!define MUI_WELCOMEFINISHPAGE_BITMAP "artwork/wizard.bmp"

; UI pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

; Other useful modules
!addincludedir libs
!include "WinVer.nsh"
!include "FileFunc.nsh"
!include "zipdll.nsh"
!include "LogicLib.nsh"
!include "Trim.nsh"
!Include "LogString.nsh"
!Include "StrTok.nsh"
!Include "psexec.nsh"
!include "x64.nsh"
!include "TextReplace.nsh"
!include "StrRep.nsh"


Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!If "${INVENTORY_TAG}" == ''
  OutFile "Pulse-Agent-windows-${GENERATED_SIZE}-${PRODUCT_VERSION}.exe"
!Else
  OutFile "Pulse-Agent-windows-${GENERATED_SIZE}-${PRODUCT_VERSION}-${INVENTORY_TAG}.exe"
!EndIf
!If "$PROGRAMFILES64" != ""
  InstallDir "$PROGRAMFILES64\Pulse"
!Else
  InstallDir "$PROGRAMFILES\Pulse"
!EndIf
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show

; Define a few settings
Section -SETTINGS
  SetOutPath "$INSTDIR"
SectionEnd

!define DownloadFile "!insertmacro DownloadFile"
!macro DownloadFile url filename
  inetc::get /NOCANCEL ${url} ${filename} /END
  Pop $0 ;Get the return value
  StrCmp $0 "OK" +3
    MessageBox MB_OK "Download of ${url} failed: $0"
    Quit
!macroend

; Python installation
Section "Python" sec_py
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/${PYTHON32_FILENAME}"
  File "${DOWNLOADS_DIR}/${PYTHON64_FILENAME}"
  File "${DOWNLOADS_DIR}/${PY_VCPYTHON27}"
  ${LogString} "Python Installation...."
  ${LogString} "------------------------------------------------------"

  ; On win32 clean old python if installed
  ${If} ${RunningX64}
    ClearErrors
    ExecWait '"python" -V'
    ${IfNot} ${Errors}
        ; Seems Python is installed. We'll try to uninstall the 32bit version
        ${LogString} "Uninstalling 32bit python if found..."
        StrCpy $0 `msiexec /x "$INSTDIR\tmp\${PYTHON32_FILENAME}" /qn REBOOT=R`
        ${LogString} "Running $0"
        nsExec::ExecToLog $0
        Pop $1 # return value/error/timeout
        ${LogString} "Return code was: $1"
        ${LogString} ""
    ${EndIf}
  ${EndIf}

  ; Install of Python
  ; Get location
  Var /GLOBAL PYTHON_FILENAME
  ${If} ${RunningX64}
    StrCpy $PYTHON_FILENAME "${PYTHON64_FILENAME}"
  ${Else}
    StrCpy $PYTHON_FILENAME "${PYTHON32_FILENAME}"
  ${EndIf}
  ; Install Python
  StrCpy $0 `msiexec /i "$INSTDIR\tmp\$PYTHON_FILENAME" /quiet /qn /norestart ALLUSERS=1 ADDLOCAL=ALL REMOVE="pip_feature"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  ; Install pip
  StrCpy $0 `C:\Python27\python.exe -m ensurepip`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Visual C++ Compiler for Python
  StrCpy $0 `msiexec /i "$INSTDIR\tmp\${PY_VCPYTHON27}" /quiet /qn /norestart ALLUSERS=1`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  Delete $INSTDIR\tmp\${PYTHON32_FILENAME}
  Delete $INSTDIR\tmp\${PYTHON64_FILENAME}
  Delete $INSTDIR\tmp\${PY_VCPYTHON27}
SectionEnd

; Installation of Python modules needed by Pulse Agent
Section "Python Modules" sec_pymod
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/python_modules/${PY_WIN3232_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_WIN3264_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_NETIFACES_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_COMTYPES_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CONFIGPARSER_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_UTILS_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_SLEEKXMPP_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_WMI_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_ZIPFILE_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CURL32_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CURL64_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_LXML32_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_LXML64_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CRYPTO_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CRON_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CRON_DEPS_1_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_CRON_DEPS_2_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_PSUTIL32_FILENAME}"
  File "${DOWNLOADS_DIR}/python_modules/${PY_PSUTIL64_FILENAME}"
  File "${DOWNLOADS_DIR}/usr/bin/${LIBCURL_FILENAME}"
  ${LogString} "Python modules Installation...."
  ${LogString} "------------------------------------------------------"

  ; Install of Python module for Windows Extensions (pywin32)
  ${If} ${RunningX64}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_WIN3264_FILENAME}`
  ${Else}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_WIN3232_FILENAME}`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python netifaces module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_NETIFACES_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python comtypes module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_COMTYPES_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python configparser module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --pre --no-index --find-links="$INSTDIR\tmp" ${PY_CONFIGPARSER_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python utils module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_UTILS_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python sleekxmpp module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_SLEEKXMPP_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python wmi module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_WMI_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python zipfile module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_ZIPFILE_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Copy libcurl DLL to system32 folder
  CopyFiles /SILENT "$INSTDIR\tmp\${LIBCURL_FILENAME}" "$SYSDIR"
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  ; This requires a reboot
  SetRebootFlag true

  ; Install of Python curl module (pycurl)
  ${If} ${RunningX64}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_CURL64_FILENAME}`
  ${Else}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_CURL32_FILENAME}`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python lxml module
  ${If} ${RunningX64}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_LXML64_FILENAME}`
  ${Else}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_LXML32_FILENAME}`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python crypto module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_CRYPTO_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python croniter module
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_CRON_FILENAME}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Python psutil module
  ${If} ${RunningX64}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_PSUTIL64_FILENAME}`
  ${Else}
    StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PY_PSUTIL32_FILENAME}`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  Delete $INSTDIR\tmp\${PY_WIN3232_FILENAME}
  Delete $INSTDIR\tmp\${PY_WIN3264_FILENAME}
  Delete $INSTDIR\tmp\${PY_NETIFACES_FILENAME}
  Delete $INSTDIR\tmp\${PY_COMTYPES_FILENAME}
  Delete $INSTDIR\tmp\${PY_CONFIGPARSER_FILENAME}
  Delete $INSTDIR\tmp\${PY_UTILS_FILENAME}
  Delete $INSTDIR\tmp\${PY_SLEEKXMPP_FILENAME}
  Delete $INSTDIR\tmp\${PY_WMI_FILENAME}
  Delete $INSTDIR\tmp\${PY_ZIPFILE_FILENAME}
  Delete $INSTDIR\tmp\${PY_CURL32_FILENAME}
  Delete $INSTDIR\tmp\${PY_CURL64_FILENAME}
  Delete $INSTDIR\tmp\${PY_LXML32_FILENAME}
  Delete $INSTDIR\tmp\${PY_LXML64_FILENAME}
  Delete $INSTDIR\tmp\${PY_CRYPTO_FILENAME}
  Delete $INSTDIR\tmp\${PY_CRON_FILENAME}
  Delete $INSTDIR\tmp\${PY_CRON_DEPS_1_FILENAME}
  Delete $INSTDIR\tmp\${PY_CRON_DEPS_2_FILENAME}
  Delete $INSTDIR\tmp\${PY_PSUTIL32_FILENAME}
  Delete $INSTDIR\tmp\${PY_PSUTIL64_FILENAME}
  Delete $INSTDIR\tmp\${LIBCURL_FILENAME}
SectionEnd

; OpenSSH installation
Section "OpenSSH" sec_openssh
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/${OPENSSH32_FILENAME}"
  File "${DOWNLOADS_DIR}/${OPENSSH64_FILENAME}"
  File "${DOWNLOADS_DIR}/${RSYNC_FILENAME}"

  ; Remove previous Pulse profile 
  Var /GLOBAL P_PROFILE
  !insertmacro StrRep $0 ${USERDIR} "\" "\\"
  Pop $0
  StrCpy $P_PROFILE $0
  StrCpy $0 `wmic /node:localhost path win32_UserProfile where "LocalPath like '$P_PROFILE\\pulse%%'" Delete`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  RMDir /r "${USERDIR}\pulse*"


  ; Create Pulse user and copy laucher public key
  pwgen::GeneratePassword 12
  Pop $0
  Var /GLOBAL Password
  StrCpy $Password "$0"
  StrCpy $0 `net user "pulse" "$Password" /ADD /COMMENT:"Pulse user with admin rights on the system"`
  ${LogString} "Running net user pulse ************ /ADD /COMMENT:Pulse user with admin rights on the system "
  nsExec::ExecToLog $0

  ; Create pulse user profile
  File "${DOWNLOADS_DIR}/${CREATE_PROFILE_NAME}"
  ${LogString} "-------------------"
  ${LogString} "Create pulse profile"
  ${PowerShellExecLog} "cd $\"${SSH_DATA}$\" ; import-module .\${CREATE_PROFILE_NAME}; New-Profile -Account pulse"
  sleep 2000

  ; Create Pulse user and copy laucher public key
  CreateDirectory ${USERDIR}\pulse\.ssh
  AccessControl::GRANTONFILE /NOINHERIT "${USERDIR}\pulse" "(BA)" "FullAccess"
  AccessControl::GRANTONFILE /NOINHERIT "${USERDIR}\pulse\.ssh" "(BA)" "FullAccess"
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  ${LogString} "OpenSSH Installation...."
  ${LogString} "------------------------------------------------------"

  ; Install of OpenSSH
  ; Get location
  Var /GLOBAL SSH_PATH
  Var /GLOBAL OPENSSH_FILENAME
  Var /GLOBAL OPENSSH_CONTENTS_FOLDER
  ${If} ${RunningX64}
    StrCpy $OPENSSH_FILENAME "${OPENSSH64_FILENAME}"
    StrCpy $SSH_PATH "$PROGRAMFILES64\${OPENSSH_NAME}"
    StrCpy $OPENSSH_CONTENTS_FOLDER "${OPENSSH_NAME}-Win64"
  ${Else}
    StrCpy $OPENSSH_FILENAME "${OPENSSH32_FILENAME}"
    StrCpy $SSH_PATH "$PROGRAMFILES\${OPENSSH_NAME}"
    StrCpy $OPENSSH_CONTENTS_FOLDER "${OPENSSH_NAME}-Win32"
  ${EndIf}
  ; Uninstall OpenSSH if found
  IfFileExists "$SSH_PATH" 0 +3
  ${PowerShellExecFileLog} "$SSH_PATH\uninstall-sshd.ps1"
  RMDir /r "$SSH_PATH"
  ; Uninstall Mandriva SSH if found
  IfFileExists $PROGRAMFILES\Mandriva\OpenSSH 0 +5
  StrCpy $0 `$PROGRAMFILES\Mandriva\OpenSSH\uninst.exe /S`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  RMDir /r "$PROGRAMFILES\Mandriva\OpenSSH"
  ; Extract OpenSSH
  ZipDLL::extractall "$INSTDIR\tmp\$OPENSSH_FILENAME" "$INSTDIR\tmp\"
  Rename "$INSTDIR\tmp\$OPENSSH_CONTENTS_FOLDER" "$SSH_PATH"
  ${LogString} "-------------------"
  ;SetOutPath "$SSH_PATH"
  SetOutPath "${USERDIR}\pulse\.ssh"


  File /oname=authorized_keys "${LAUNCHER_SSH_KEY}"


  ;CopyFiles /SILENT "${SSH_PATH}\authorized_keys" "${USERDIR}\pulse\.ssh\"
  StrCpy $0 `attrib +h ${USERDIR}\pulse`
  ${LogString} "Running ATTR $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${PowerShellExecFileLog} "$SSH_PATH\install-sshd.ps1"

  ; Generate config file of SSH server
  StrCpy $0 `icacls "$SSH_PATH\sshd_config" /save "$WINDIR\Temp\aclfile"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"

  CreateDirectory "${SSHDATA}\ssh"
  CopyFiles /SILENT "$SSH_PATH\sshd_config_default" "${SSHDATA}\ssh\sshd_config"

  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "#PubkeyAuthentication yes" "PubkeyAuthentication yes" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "#PasswordAuthentication yes" "PasswordAuthentication no" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "#PidFile /var/run/sshd.pid" "PidFile C:\Windows\Temp\sshd.pid" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "AuthorizedKeysFile	.ssh/authorized_keys" "AuthorizedKeysFile	$\"${USERDIR}\pulse\.ssh\authorized_keys$\"" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "#SyslogFacility AUTH" "SyslogFacility LOCAL0" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "#LogLevel INFO" "LogLevel DEBUG3" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "Match Group administrators" "#Match Group administrators" "/S=1 /C=1 /AO=1" $0
  ${textreplace::ReplaceInFile} "${SSHDATA}\ssh\sshd_config" "${SSHDATA}\ssh\sshd_config" "       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys" "#       AuthorizedKeysFile __{SSHDATA}__/ssh/administrators_authorized_keys" "/S=1 /C=1 /AO=1" $0

  ${LogString} "SED $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"


  ; Configure SSH server to start automatically at boot
  StrCpy $0 `sc.exe config ssh-agent start= auto`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  StrCpy $0 `sc.exe config sshd start= auto`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Generate SSH Keys
  SetOutPath "$SSH_PATH"
  StrCpy $0 `"$SSH_PATH\ssh-keygen.exe" -A`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ${LogString} "Setting permissions on pulse user profile folder"
  StrCpy $0 `wmic useraccount where name="pulse" get sid /VALUE`
  ${LogString} "Running $0"
  nsExec::ExecToStack $0
  Pop $0
  ${If} $0 = 0
    Pop $1
    ${Trim} $0 $1
    ${StrTok} $0 "$0" "=" "L" "1"
    Var /GLOBAL SID
    StrCpy $SID "$0"
    ${LogString} "User SID: $SID"
    WriteRegExpandStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" "ProfileImagePath" "${USERDIR}\pulse"
  ${Else}
    ${LogString} "Return code was: $0"
  ${EndIf}
  Pop $R0
  ${If} $R0 == error
    Pop $R0
    ${LogString} "AccessControl error: $R0"
  ${EndIf}
  ${LogString} "-------------------"
  ; Set pulse account password to not expire
  StrCpy $0 `wmic useraccount where "Name='pulse'" set PasswordExpires=False`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  ; Add pulse user to administrators group in English, French and Portugese
  StrCpy $0 `net localgroup administrators "pulse" /ADD`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `net localgroup administrateurs "pulse" /ADD`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  StrCpy $0 `net localgroup administradores "pulse" /ADD`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ; Hide the account
  WriteRegDWORD HKLM "Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" "pulse" 0

  ${PowerShellExecLog} "cd $\"$SSH_PATH$\" ; .\FixHostFilePermissions.ps1 -Confirm:$$false"
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"

  ; Start the service
  StrCpy $0 `sc start ssh-agent`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  StrCpy $0 `sc start sshd`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Setup of Windows firewall to allow ssh
  ${If} ${IsWinXP}
    StrCpy $0 `netsh firewall add portopening TCP 22 "SSH for Pulse"`
  ${Else}
    StrCpy $0 `netsh advfirewall firewall add rule name="SSH for Pulse" dir=in action=allow protocol=TCP localport=22`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of rsync
  ; Extract rsync
  ZipDLL::extractall "$INSTDIR\tmp\${RSYNC_FILENAME}" "$INSTDIR\tmp\"
  ; Copy rsync files to System32/SysWOW64 folder
  ${DisableX64FSRedirection}
  ${If} ${RunningX64}
    CopyFiles /SILENT "$INSTDIR\tmp\rsync\*.*" "$WINDIR\SysWOW64\"
  ${Else}
    CopyFiles /SILENT "$INSTDIR\tmp\rsync\*.*" "$WINDIR\System32\"
  ${EndIf}
  ${EnableX64FSRedirection}
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"
  ; This requires a reboot
  SetRebootFlag true

  Delete $INSTDIR\tmp\${OPENSSH32_FILENAME}
  Delete $INSTDIR\tmp\${OPENSSH64_FILENAME}
  Delete $INSTDIR\tmp\${RSYNC_FILENAME}
  Delete $INSTDIR\tmp\${CREATE_PROFILE_NAME}
  RMDir /r $INSTDIR\tmp\rsync
  RMDir /r "$INSTDIR\tmp\$OPENSSH_CONTENTS_FOLDER"
SectionEnd

; Setup of RDP & Firewall
Section "RDP Setup" sec_rdp
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/${RDPWRAP_FILENAME}"
  ${LogString} "RDP setup for remote control of machine via Pulse...."
  ${LogString} "------------------------------------------------------"

  ; Setup of RDPWrap
  ; Extract RDPWrap
  CreateDirectory $INSTDIR\tmp\${RDPWRAP_FOLDERNAME}
  ZipDLL::extractall "$INSTDIR\tmp\${RDPWRAP_FILENAME}" "$INSTDIR\tmp\${RDPWRAP_FOLDERNAME}"
  ; Install
  StrCpy $0 `"$INSTDIR\tmp\${RDPWRAP_FOLDERNAME}\RDPWInst.exe" -i`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Setup of rdp
  WriteRegDWORD HKLM "SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" 0
  WriteRegDWORD HKLM "SYSTEM\CurrentControlSet\Control\Terminal Server" "fSingleSessionPerUser" 0
  ${If} ${AtLeastWin7}
    WriteRegDWORD HKLM "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "UserAuthentication" 0
  ${EndIf}
  ${If} ${AtLeastWin7}
    WriteRegDWORD HKLM "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "SecurityLayer" 0
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Setup of Windows firewall to allow vnc
  ${If} ${IsWinXP}
    StrCpy $0 `netsh firewall add portopening TCP ${RFB_PORT} "Remote Desktop for Pulse"`
  ${Else}
    StrCpy $0 `netsh advfirewall firewall add rule name="Remote Desktop for Pulse VNC" dir=in action=allow protocol=TCP localport=${RFB_PORT}`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Setup of Windows firewall to allow rdp
  ${If} ${IsWinXP}
    StrCpy $0 `netsh firewall add portopening TCP 3389 "Remote Desktop for Pulse RDP"`
  ${Else}
    StrCpy $0 `netsh advfirewall firewall add rule name="Remote Desktop for Pulse RDP" dir=in action=allow protocol=TCP localport=3389`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  Delete $INSTDIR\tmp\${RDPWRAP_FILENAME}
  RMDir /r $INSTDIR\tmp\${RDPWRAP_FOLDERNAME}
SectionEnd

Section "VNC Setup" sec_vnc
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/${VNC_AGENT32_FILENAME}"
  File "${DOWNLOADS_DIR}/${VNC_AGENT64_FILENAME}"
  ${LogString} "VNC setup for remote control of machine via Pulse...."
  ${LogString} "------------------------------------------------------"

  ; On win64 clean old 32bit TightVNC if installed
  ${If} ${RunningX64}
    IfFileExists $PROGRAMFILES\TightVNC\tvnserver.exe 0 +8
    ${LogString} "TightVNC seems to be installed. Uninstalling..."
    StrCpy $0 `msiexec /x "$INSTDIR\tmp\${VNC_AGENT32_FILENAME}" /qn REBOOT=R`
    ${LogString} "Running $0"
    nsExec::ExecToLog $0
    Pop $1 # return value/error/timeout
    ${LogString} "Return code was: $1"
    ${LogString} ""
  ${EndIf}

  ; Get location
  Var /GLOBAL VNC_AGENT_FILENAME
  ${If} ${RunningX64}
    StrCpy $VNC_AGENT_FILENAME "${VNC_AGENT64_FILENAME}"
  ${Else}
    StrCpy $VNC_AGENT_FILENAME "${VNC_AGENT32_FILENAME}"
  ${EndIf}
  ; Install VNC
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Create installation command line                                                          ;
  ; http://www.tightvnc.com/doc/win/TightVNC_2.7_for_Windows_Installing_from_MSI_Packages.pdf ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  StrCpy $0 `msiexec /i "$INSTDIR\tmp\$VNC_AGENT_FILENAME" /quiet /qn /norestart`
  StrCpy $0 `$0 ADDLOCAL=Server SERVER_REGISTER_AS_SERVICE=1 SERVER_ADD_FIREWALL_EXCEPTION=1 SERVER_ALLOW_SAS=1`
  ; Disable embedded Java WebSrv on port 5800
  StrCpy $0 `$0 SET_ACCEPTHTTPCONNECTIONS=1 VALUE_OF_ACCEPTHTTPCONNECTIONS=0`
  ; Enable RFB on port 5900
  StrCpy $0 `$0 SET_ACCEPTRFBCONNECTIONS=1 VALUE_OF_ACCEPTRFBCONNECTIONS=1`
  ; Enable loopback connection
  StrCpy $0 `$0 SET_ALLOWLOOPBACK=1 VALUE_OF_ALLOWLOOPBACK=1`
  ; Allow on all interfaces
  StrCpy $0 `$0 SET_LOOPBACKONLY=1 VALUE_OF_LOOPBACKONLY=0`
  ; Only allow from 127.0.0.1 and query user
  StrCpy $0 `$0 SET_IPACCESSCONTROL=1 VALUE_OF_IPACCESSCONTROL=0.0.0.0-255.255.255.255:2`
  ; Default answser on timeout is reject
  StrCpy $0 `$0 SET_QUERYACCEPTONTIMEOUT=1 VALUE_OF_QUERYACCEPTONTIMEOUT=0`
  ; Timeout is 20s
  StrCpy $0 `$0 SET_QUERYTIMEOUT=1 VALUE_OF_QUERYTIMEOUT=20`
  ; Show service icon
  StrCpy $0 `$0 SET_RUNCONTROLINTERFACE=1 VALUE_OF_RUNCONTROLINTERFACE=1`
  ; Hide wallpaper
  StrCpy $0 `$0 SET_REMOVEWALLPAPER=1 VALUE_OF_REMOVEWALLPAPER=1`
  ; Share between multiple connection
  StrCpy $0 `$0 SET_ALWASHARED=1 SET_NEVERSHARED=1 VALUE_OF_ALWASHARED=1 VALUE_OF_NEVERSHARED=0`
  ; Disable authentication
  StrCpy $0 `$0 SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=0`
  ; Ensure remote inputs are enabled
  StrCpy $0 `$0 SET_BLOCKREMOTEINPUT=1 VALUE_OF_BLOCKREMOTEINPUT=0`
  ; Don't do anything when terminating VNC session
  StrCpy $0 `$0 SET_DISCONNECTACTION=1 VALUE_OF_DISCONNECTACTION=0`
  ; Set the server listening port
  StrCpy $0 `$0 SET_RFBPORT=1 VALUE_OF_RFBPORT=${RFB_PORT}`


  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  Delete $INSTDIR\tmp\${VNC_AGENT32_FILENAME}
  Delete $INSTDIR\tmp\${VNC_AGENT64_FILENAME}
SectionEnd

; Setup of Fusion Inventory agent
Section "Fusion Inventory agent" sec_fusinv
  SetOutPath "$INSTDIR\tmp"
  File "${DOWNLOADS_DIR}/${FUSION_INVENTORY_AGENT32_FILENAME}"
  File "${DOWNLOADS_DIR}/${FUSION_INVENTORY_AGENT64_FILENAME}"
  ${LogString} "Fusion Inventory agent setup...."
  ${LogString} "------------------------------------------------------"

  ; Clean old Fusion Inventory agent if installed
  ClearErrors
  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FusionInventory-Agent" "UninstallString"
  ${IfNot} ${Errors}
    ; Seems Fusion Inventory agent is installed
    ${LogString} "Fusion Inventory agent seems to be installed. Uninstalling..."
    ; Silent uninstall
    StrCpy $0 `"$0" /S`
    ${LogString} "Running $0"
    nsExec::ExecToLog $0
    Pop $1 # return value/error/timeout
    ${LogString} "Return code was: $1"
    ${LogString} ""
  ${EndIf}

  ; Install of Fusion Inventory agent
  ; Get location
  Var /GLOBAL FUSION_INVENTORY_AGENT_FILENAME
  ${If} ${RunningX64}
    StrCpy $FUSION_INVENTORY_AGENT_FILENAME "${FUSION_INVENTORY_AGENT64_FILENAME}"
  ${Else}
    StrCpy $FUSION_INVENTORY_AGENT_FILENAME "${FUSION_INVENTORY_AGENT32_FILENAME}"
  ${EndIf}
  ; Install Fusion Inventory agent
  !If "${INVENTORY_TAG}" == ''
    StrCpy $0 `"$INSTDIR\tmp\$FUSION_INVENTORY_AGENT_FILENAME" /S /acceptlicense /no-start-menu /execmode=Manual`
  !Else
    StrCpy $0 `"$INSTDIR\tmp\$FUSION_INVENTORY_AGENT_FILENAME" /S /acceptlicense /no-start-menu /execmode=Manual /tag="${INVENTORY_TAG}"`
  !EndIf
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  Delete $INSTDIR\tmp\${FUSION_INVENTORY_AGENT32_FILENAME}
  Delete $INSTDIR\tmp\${FUSION_INVENTORY_AGENT64_FILENAME}
SectionEnd

; Installation of Pulse Agent
Section "!${PRODUCT_NAME}" sec_app
  SetOutPath "$INSTDIR\tmp"
  File "../${PULSE_AGENT}"
  File "../${PULSE_AGENT_PLUGINS}"
  ${LogString} "Pulse Agent Installation...."
  ${LogString} "------------------------------------------------------"

  ; Remove Pulse folder if present
  ClearErrors
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  ${IfNot} ${Errors}
    ; Remove pulse parameters Folder
    Delete "$INSTDIR\etc\*.*"
  ${EndIf}

  ; Install of Pulse agent
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PULSE_AGENT}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Install of Pulse agent plugins
  StrCpy $0 `C:\Python27\Scripts\pip install --quiet --upgrade --no-index --find-links="$INSTDIR\tmp" ${PULSE_AGENT_PLUGINS}`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Copy of pulse filetree generator
  SetOutPath "$INSTDIR\bin"
  File "pulse-filetree-generator.exe"

  ; Copy of agent config file
  SetOutPath "$INSTDIR\etc"
  File "../config/${PULSE_AGENT_CONFFILE}"

  ; Copy of agent scheduler config file only if it does not already exist (using overwrite flag)
  SetOutPath "$INSTDIR\etc"
  SetOverwrite off
  File "../config/${PULSE_SCHEDULER_CONFFILE}"
  SetOverwrite on

  ; Copy of inventory config file
  SetOutPath "$INSTDIR\etc"
  File "../config/${PULSE_INVENTORY_CONFFILE}"

  ; Creation of the task
  SetOutPath "$INSTDIR\tmp"
  File "${PULSE_AGENT_TASK_XML}"
  ${If} ${AtLeastWin7}
    StrCpy $0 `SCHTASKS /Create /XML "$INSTDIR\tmp\${PULSE_AGENT_TASK_XML}" /TN "${PRODUCT_NAME}"`
  ${Else}
    StrCpy $0 `SCHTASKS /Create /SC ONSTART /RU "System" /TN "${PRODUCT_NAME}" /TR "C:\Python27\python.exe C:\Python27\Lib\site-packages\${PULSE_AGENT_MODULE}\launcher.py -t machine"`
  ${EndIf}
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  ; Create log folder to hold agent logs
  CreateDirectory $INSTDIR\var\log
  ; Create packages folder to hold packages to be deployed on client
  CreateDirectory $INSTDIR\var\tmp\packages
  ; Create bin folder
  CreateDirectory $INSTDIR\bin

  ; Run the agent
  StrCpy $0 `SCHTASKS /Run /TN "${PRODUCT_NAME}"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} "-------------------"

  SectionIn RO
  WriteUninstaller $INSTDIR\uninstall.exe
  ; Add ourselves to Add/remove programs
  ${If} ${RunningX64}
      SetRegView 64
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
      WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoModify" 1
      WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoRepair" 1
  ${Else}
      SetRegView 32
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
      WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
      WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoModify" 1
      WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoRepair" 1
  ${EndIf}

  ; Write the version installed in registry
  ${If} ${RunningX64}
      SetRegView 64
      WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "CurrentVersion" "${PRODUCT_VERSION}"
      WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallLocation" "$INSTDIR"
  ${Else}
      SetRegView 32
      WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "CurrentVersion" "${PRODUCT_VERSION}"
      WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallLocation" "$INSTDIR"
  ${EndIf}

  Delete $INSTDIR\tmp\${PULSE_AGENT}
  Delete $INSTDIR\tmp\${PULSE_AGENT_TASK_XML}
  Delete $INSTDIR\tmp\${PULSE_AGENT_PLUGINS}

  ${If} ${RunningX64}
    RMDir /r "$PROGRAMFILES\Pulse"
  ${EndIf}

  Sleep 20000
SectionEnd

; What needs to be done for uninstalling
Section "Uninstall"

  ; Stop Pulse agent
  StrCpy $0 `taskkill /F /IM python.exe`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"

  ; Remove pulse user
  StrCpy $0 `net user "pulse" /DELETE`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  RMDir /r "${USERDIR}/pulse*"
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "RMDir Return code was: $1"

  ; Remove OpenSSH
  StrCpy $0 `sc.exe stop sshd`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `sc.exe stop ssh-agent`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `sc.exe delete ssh-agent`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `sc.exe delete sshd`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  Delete "$SYSDIR\ssh-lsa.dll"

  ; Uninstall OpenSSH
  ${If} ${FileExists} "$PROGRAMFILES64\${OPENSSH_NAME}\uninstall-sshd.ps1"
    ${LogString} "OpenSSH uninstall.."
    ${LogString} "------------------------------------------------------"
    ${PowerShellExecFileLog} "$PROGRAMFILES64\${OPENSSH_NAME}\uninstall-sshd.ps1"
    RMDir /r "$PROGRAMFILES64\OpenSSH"
  ${Else}
    ${LogString} "OpenSSH uninstall.."
    ${LogString} "------------------------------------------------------"
    ${PowerShellExecFileLog} "$PROGRAMFILES\${OPENSSH_NAME}\uninstall-sshd.ps1"
    RMDir /r "$PROGRAMFILES\${OPENSSH_NAME}"
  ${EndIf}
  RMDir /r "${PROGRAMDATA}\ssh"
  ; Remove libcurl
  Delete "$SYSDIR\${LIBCURL_FILENAME}"

  ; Uninstall agent
  StrCpy $0 `SCHTASKS /Delete /TN "Pulse Agent" -f`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `netsh.exe advfirewall firewall delete rule name="Remote Desktop for Pulse"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `netsh.exe advfirewall firewall delete rule name="SSH for Pulse"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `C:\Python27\Scripts\pip uninstall "${PULSE_AGENT_PLUGINS_NAME}" -y`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  StrCpy $0 `C:\Python27\Scripts\pip uninstall "${PULSE_AGENT_MODULE}" -y`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  RMDir /r "C:\Python27\Lib\site-packages\pulse_xmpp_agent\"
  RMDir /r "C:\Program Files\OpenSSH"
  RMDir /r "$INSTDIR"

  ; Remove Pulse profile
  !insertmacro StrRep $0 ${USERDIR} "\" "\\"
  Pop $0
  StrCpy $P_PROFILE $0

  StrCpy $0 `wmic /node:localhost path win32_UserProfile where "LocalPath like '$P_PROFILE\\pulse%%'" Delete`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  RMDir /r /REBOOTOK "${USERDIR}\pulse*"

  DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

SectionEnd

; Functions

Function .onInit
  ; XP or later
  ${IfNot} ${AtLeastWinXP}
    MessageBox MB_OK|MB_ICONEXCLAMATION "XP and above required for running ${PRODUCT_NAME}"
    Quit
  ${EndIf}

  ; Make sure we are running as admin
  UserInfo::GetAccountType
  pop $0
  ${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
  ${EndIf}

  ; Create registry keys in 64bit section
  SetRegView 64

  ; Install log initialization
  !If "$PROGRAMFILES64" != ""
    StrCpy $INSTDIR "$PROGRAMFILES64\Pulse"
  !Else
    StrCpy $INSTDIR "$PROGRAMFILES\Pulse"
  !EndIf
  CreateDirectory "$INSTDIR\tmp"
  ${LogInit} "$INSTDIR\tmp\install.log"
  ${LogString} "Starting install..."
  !insertmacro GetTime
  ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
  ${LogString} "Start time: $3 $0/$1/$2 at $4:$5:$6"

  ; Stop the agent if it is already running and kill all python tasks
  ${LogString} "Trying to stop agent if it is running"
  StrCpy $0 `SCHTASKS /End /TN "${PRODUCT_NAME}"`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} ""
  StrCpy $0 `taskkill /F /IM python.exe /T`
  ${LogString} "Running $0"
  nsExec::ExecToLog $0
  Pop $1 # return value/error/timeout
  ${LogString} "Return code was: $1"
  ${LogString} ""
FunctionEnd

Function un.onInit
  ; Create registry keys in 64bit section
  SetRegView 64
FunctionEnd

Function .onGUIEnd
  ; Write the log file
  !insertmacro Log_Close
FunctionEnd

Function .onMouseOverSection
  ; Find which section the mouse is over, and set the corresponding description.
  FindWindow $R0 "#32770" "" $HWNDPARENT
  GetDlgItem $R0 $R0 1043 ; description item (must be added to the UI)

  StrCmp $0 ${sec_py} 0 +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:The Python interpreter. \
          This is required for ${PRODUCT_NAME} to run."

  StrCmp $0 ${sec_pymod} 0 +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Python modules required by ${PRODUCT_NAME}."

  StrCmp $0 ${sec_openssh} 0 +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:OpenSSH required for deployment, backup, etc."

  StrCmp $0 ${sec_rdp} "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Setup RDP protocol required for remote control"

  StrCmp $0 ${sec_vnc} "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Setup VNC required for remote control"

  StrCmp $0 ${sec_fusinv} "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Fusion inventory agent required for inventory"

  StrCmp $0 ${sec_app} "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:${PRODUCT_NAME}"
FunctionEnd
