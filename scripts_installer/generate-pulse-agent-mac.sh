#!/bin/bash
# -*- coding: utf-8 -*-
#
# (c) 2017 siveo, http://www.siveo.net
# $Id$
#
# This file is part of Pulse 2, http://www.siveo.net
#
# Pulse 2 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Pulse 2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pulse 2. If not, see <http://www.gnu.org/licenses/>.
#

# """
# This script is designed to generate Pulse XMPP agent for MacOS
# It downloads the necessary dependencies, modifies the postflight file and finally
# creates the .pkg
# """

#	Files needed for the full version of the installer:
#	In /var/lib/pulse2/clients/mac/downloads/:
# https://github.com/Homebrew/brew/archive/1.5.12.tar.gz
# https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.4/FusionInventory-Agent-2.4-1.pkg.tar.gz
# https://github.com/stweil/OSXvnc/releases/download/V5_2_1/OSXvnc-5.2.1.dmg
#	In /var/lib/pulse2/clients/mac/downloads/python_modules/:
#	https://pypi.python.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d/netifaces-0.10.5.tar.gz
#	https://pypi.python.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz
#	https://pypi.python.org/packages/07/49/42c86388fed58455e7e18d3821d7687f4921e47a40cb312e69b82f75c660/utils-0.9.0.tar.gz
#	https://pypi.python.org/packages/2e/33/7adcc8d6b35cb72f9cc56785a3d9c63d540200c476b0cb3a0926f5b51102/sleekxmpp-1.3.1.tar.gz
#	https://pypi.python.org/packages/60/ad/d6bc08f235b66c11bbb76df41b973ce93544a907cc0e23c726ea374eee79/zipfile2-0.0.12-py2.py3-none-any.whl
#	https://pypi.python.org/packages/77/d9/d272b38e6e25d2686e22f6058820298dadead69340b1c57ff84c87ef81f0/pycurl-7.43.0.1.tar.gz
#	https://pypi.python.org/packages/f1/c7/e19d317cc948095abc872a6e6ae78ac80260f2b45771dfa7a7ce86865f5b/lxml-3.6.0.tar.gz
#	https://pypi.python.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz
# https://pypi.python.org/packages/40/8b/275015d7a9ec293cf1bbf55433258fbc9d0711890a7f6dc538bac7b86bce/python_dateutil-2.6.0-py2.py3-none-any.whl
# https://pypi.python.org/packages/c8/0a/b6723e1bc4c516cb687841499455a8505b44607ab535be01091c0f24f079/six-1.10.0-py2.py3-none-any.whl
# https://pypi.python.org/packages/58/2a/17d003f2a9a0188cf9365d63b3351c6522b7d83996b70270c65c789e35b9/croniter-0.3.16.tar.gz
# https://pypi.python.org/packages/e2/e1/600326635f97fee89bf8426fef14c5c29f4849c79f68fd79f433d8c1bd96/psutil-5.4.3.tar.gz
# https://pypi.python.org/packages/28/df/755dab9f83c37031aea1cd9915673b5633665c575d649e812657df95b944/plyvel-1.0.1.tar.gz

# To be defined for minimal install
BASE_URL="https://agents.siveo.net" # Overridden if --base-url is defined

# Go to own folder
cd "`dirname $0`"

# To be defined
AGENT_VERSION="1.9.4"
HOMEBREW_VERSION="1.5.12"
FUSION_INVENTORY_AGENT_NAME="FusionInventory-Agent"
FUSION_INVENTORY_AGENT_VERSION="2.4-1"
PY_NETIFACES_MODULE="netifaces"
PY_NETIFACES_VERSION="0.10.5"
PY_CONFIGPARSER_MODULE="configparser"
PY_CONFIGPARSER_VERSION="3.5.0"
PY_UTILS_MODULE="utils"
PY_UTILS_VERSION="0.9.0"
PY_SLEEKXMPP_MODULE="sleekxmpp"
PY_SLEEKXMPP_VERSION="1.3.1"
PY_ZIPFILE_MODULE="zipfile2"
PY_ZIPFILE_VERSION="0.0.12"
PY_CURL_MODULE="pycurl"
PY_CURL_VERSION="7.43.0.1"
PY_LXML_MODULE="lxml"
PY_LXML_VERSION="3.6.0"
PY_CRYPTO_MODULE="pycrypto"
PY_CRYPTO_VERSION="2.6.1"
PY_CRON_MODULE="croniter"
PY_CRON_VERSION="0.3.16"
PY_CRON_DEPS_1_MODULE="python_dateutil"
PY_CRON_DEPS_1_VERSION="2.6.0"
PY_CRON_DEPS_2_MODULE="six"
PY_CRON_DEPS_2_VERSION="1.10.0"
PY_PSUTIL_MODULE="psutil"
PY_PSUTIL_VERSION="5.4.3"
PY_PLYVEL_MODULE="plyvel"
PY_PLYVEL_VERSION="1.0.1"
PULSE_AGENT_NAME="pulse-xmpp-agent"
PULSE_AGENT_MODULE="pulse_xmpp_agent"
SSH_PUB_KEY="/root/.ssh/id_rsa.pub"
PULSE_AGENT_PLUGINS_NAME="pulse-agent-plugins"
PULSE_AGENT_PLUGINS_VERSION="1.6.1"
PKG_FOLDER_TMP="mac_package_tmp"
VNC_SERVER_NAME="OSXvnc"
VNC_SERVER_VERSION="5.2.1"
VNC_SERVER_MOUNTED="VineServer"
VNC_SERVER_APP="Vine Server.app"


# Display usage
display_usage() {
	echo -e "\nUsage:\n$0 [--inventory-tag=<Tag added to the inventory>]\n"
	echo -e "\t [--minimal [--base-url=<URL for downloading agent and dependencies from>]]\n"
}

check_arguments() {
	for i in "$@"; do
		case $i in
      --inventory-tag=*)
        INVENTORY_TAG="${i#*=}"
        shift
        ;;
      --minimal*)
        MINIMAL=1
        shift
        ;;
      --base-url*)
        TEST_URL="${i#*=}"
        shift
        ;;
			*)
        # unknown option
        display_usage
        exit 0
    		;;
		esac
	done
	if [[ ${MINIMAL} ]] && [[ ${TEST_URL} ]]; then
		URL_REGEX='^https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
		if [[ ${TEST_URL} =~ ${URL_REGEX} ]]; then
			BASE_URL=${TEST_URL}
		else
			colored_echo red "The base-url parameter is not valid"
			colored_echo red "We will use ${BASE_URL}"
		fi
	fi
	if [[ ! ${MINIMAL} ]]; then
		exit 0 # Remove when we support full version as well
	fi
}

compute_parameters() {
	HOMEBREW_FILENAME="${HOMEBREW_VERSION}.tar.gz"
	PYTHON_FILENAME="python-${PYTHON_VERSION}-macosx10.6.pkg"
	PY_NETIFACES_FILENAME="${PY_NETIFACES_MODULE}-${PY_NETIFACES_VERSION}.tar.gz"
	PY_CONFIGPARSER_FILENAME="${PY_CONFIGPARSER_MODULE}-${PY_CONFIGPARSER_VERSION}.tar.gz"
	PY_UTILS_FILENAME="${PY_UTILS_MODULE}-${PY_UTILS_VERSION}.tar.gz"
	PY_SLEEKXMPP_FILENAME="${PY_SLEEKXMPP_MODULE}-${PY_SLEEKXMPP_VERSION}.tar.gz"
	PY_ZIPFILE_FILENAME="${PY_ZIPFILE_MODULE}-${PY_ZIPFILE_VERSION}-py2.py3-none-any.whl"
	PY_CURL_FILENAME="${PY_CURL_MODULE}-${PY_CURL_VERSION}.tar.gz"
	PY_LXML_FILENAME="${PY_LXML_MODULE}-${PY_LXML_VERSION}.tar.gz"
	PY_CRYPTO_FILENAME="${PY_CRYPTO_MODULE}-${PY_CRYPTO_VERSION}.tar.gz"
	PY_CRON_FILENAME="${PY_CRON_MODULE}-${PY_CRON_VERSION}.tar.gz"
	PY_CRON_DEPS_1_FILENAME="${PY_CRON_DEPS_1_MODULE}-${PY_CRON_DEPS_1_VERSION}-py2.py3-none-any.whl"
	PY_CRON_DEPS_2_FILENAME="${PY_CRON_DEPS_2_MODULE}-${PY_CRON_DEPS_2_VERSION}-py2.py3-none-any.whl"
	PY_PSUTIL_FILENAME="${PY_PSUTIL_MODULE}-${PY_PSUTIL_VERSION}.tar.gz"
	PY_PLYVEL_FILENAME="${PY_PLYVEL_MODULE}-${PY_PLYVEL_VERSION}.tar.gz"
	PULSE_AGENT_FILENAME="${PULSE_AGENT_NAME}-${AGENT_VERSION}.tar.gz"
	PULSE_AGENT_CONFFILE_FILENAME="agentconf.ini"
	PULSE_SCHEDULER_CONFFILE_FILENAME="manage_scheduler.ini"
	PULSE_INVENTORY_CONFFILE_FILENAME="inventory.ini"
	PULSE_AGENT_PLUGINS_FILENAME="${PULSE_AGENT_PLUGINS_NAME}-${PULSE_AGENT_PLUGINS_VERSION}.tar.gz"
	FUSION_INVENTORY_AGENT_PKG="${FUSION_INVENTORY_AGENT_NAME}-${FUSION_INVENTORY_AGENT_VERSION}.pkg"
	FUSION_INVENTORY_AGENT_ARCHIVE="${FUSION_INVENTORY_AGENT_PKG}.tar.gz"
	VNC_SERVER_FILENAME="${VNC_SERVER_NAME}-${VNC_SERVER_VERSION}.dmg"
	V_MAJOR=`echo ${AGENT_VERSION} | cut -d. -f1`
	V_MINOR=`echo ${AGENT_VERSION} | cut -d. -f2`
	BUILD_DATE=$(date +'%Y-%m-%dT%H:%M:%SZ')
}

create_folder_structure() {
	# Clean temporary folder
	if [ -d ${PKG_FOLDER_TMP} ]; then
		rm -rf ${PKG_FOLDER_TMP}
	fi
	# Create folder structure and add necessary files
	if ! [ -d ${PKG_FOLDER_TMP}/Contents ]; then
		mkdir -p ${PKG_FOLDER_TMP}/Contents
	fi
	if ! [ -d ${PKG_FOLDER_TMP}/Contents/Resources ]; then
		mkdir -p ${PKG_FOLDER_TMP}/Contents/Resources
	fi
	# Copy restricted shell
	cp rbash ${PKG_FOLDER_TMP}/Contents/Resources/
	# Copy Pulse public key
	if [ -f ${SSH_PUB_KEY} ]; then
		cp ${SSH_PUB_KEY} ${PKG_FOLDER_TMP}/Contents/Resources/id_rsa.pub
	else
		colored_echo red "The SSH public key could not be found."
		colored_echo red "Please make sure there is a valid key at ${SSH_PUB_KEY}."
		exit 0
	fi
	# Copy config files
	cp ../config/${PULSE_AGENT_CONFFILE_FILENAME} ${PKG_FOLDER_TMP}/Contents/Resources/
	cp ../config/${PULSE_SCHEDULER_CONFFILE_FILENAME} ${PKG_FOLDER_TMP}/Contents/Resources/
	cp ../config/${PULSE_INVENTORY_CONFFILE_FILENAME} ${PKG_FOLDER_TMP}/Contents/Resources/
	# Create package_version
	echo "Major: ${V_MAJOR}" > ${PKG_FOLDER_TMP}/Contents/package_version
	echo "Minor: ${V_MINOR}" >> ${PKG_FOLDER_TMP}/Contents/package_version
	# Copy service descriptor
	cp net.siveo.pulse_xmpp_agent.plist ${PKG_FOLDER_TMP}/Contents/Resources/
	# Copy launcher
	cp runpulseagent ${PKG_FOLDER_TMP}/Contents/Resources/
}

colored_echo() {
  local color=$1;
  if ! [[ $color =~ '^[0-9]$' ]] ; then
		case $(echo $color | tr '[:upper:]' '[:lower:]') in
			black) color=0 ;;
			red) color=1 ;;
			green) color=2 ;;
			yellow) color=3 ;;
			blue) color=4 ;;
			magenta) color=5 ;;
			cyan) color=6 ;;
			white|*) color=7 ;; # white or invalid color
		esac
  fi
  tput setaf $color;
  echo "${@:2}";
  tput sgr0;
}

exit_code() {
  return=$?
  if [ $return -ne 0 ];then colored_echo red "### DEBUG Exit code" $return; fi
}

sed_escape() {
	echo "$@" |sed -e 's/[\/&\$"]/\\&/g'
}

update_postflight_script_mini() {
	colored_echo blue "### INFO Updating postflight script..."
	sed -e "s/@@BASE_URL@@/$(sed_escape ${BASE_URL})/" \
		-e "s/@@FUSION_INVENTORY_AGENT_PKG@@/${FUSION_INVENTORY_AGENT_PKG}/" \
		-e "s/@@FUSION_INVENTORY_AGENT_ARCHIVE@@/${FUSION_INVENTORY_AGENT_ARCHIVE}/" \
		-e "s/@@VNC_SERVER_FILENAME@@/${VNC_SERVER_FILENAME}/" \
		-e "s/@@VNC_SERVER_MOUNTED@@/${VNC_SERVER_MOUNTED}/" \
		-e "s/@@VNC_SERVER_APP@@/${VNC_SERVER_APP}/" \
		-e "s/@@INVENTORY_TAG@@/${INVENTORY_TAG}/" \
		-e "s/@@HOMEBREW_FILENAME@@/${HOMEBREW_FILENAME}/" \
		-e "s/@@PYTHON_FILENAME@@/${PYTHON_FILENAME}/" \
		-e "s/@@PY_NETIFACES_FILENAME@@/${PY_NETIFACES_FILENAME}/" \
		-e "s/@@PY_CONFIGPARSER_FILENAME@@/${PY_CONFIGPARSER_FILENAME}/" \
		-e "s/@@PY_UTILS_FILENAME@@/${PY_UTILS_FILENAME}/" \
		-e "s/@@PY_SLEEKXMPP_FILENAME@@/${PY_SLEEKXMPP_FILENAME}/" \
		-e "s/@@PY_ZIPFILE_FILENAME@@/${PY_ZIPFILE_FILENAME}/" \
		-e "s/@@PY_CURL_FILENAME@@/${PY_CURL_FILENAME}/" \
		-e "s/@@PY_LXML_FILENAME@@/${PY_LXML_FILENAME}/" \
		-e "s/@@PY_CRYPTO_FILENAME@@/${PY_CRYPTO_FILENAME}/" \
		-e "s/@@PY_CRON_FILENAME@@/${PY_CRON_FILENAME}/" \
		-e "s/@@PY_CRON_DEPS_1_FILENAME@@/${PY_CRON_DEPS_1_FILENAME}/" \
		-e "s/@@PY_CRON_DEPS_2_FILENAME@@/${PY_CRON_DEPS_2_FILENAME}/" \
		-e "s/@@PY_PSUTIL_FILENAME@@/${PY_PSUTIL_FILENAME}/" \
		-e "s/@@PY_PLYVEL_FILENAME@@/${PY_PLYVEL_FILENAME}/" \
		-e "s/@@PULSE_AGENT_FILENAME@@/${PULSE_AGENT_FILENAME}/" \
		-e "s/@@PULSE_AGENT_PLUGINS_FILENAME@@/${PULSE_AGENT_PLUGINS_FILENAME}/" \
		-e "s/@@PULSE_AGENT_CONFFILE_FILENAME@@/${PULSE_AGENT_CONFFILE_FILENAME}/" \
		-e "s/@@PULSE_SCHEDULER_CONFFILE_FILENAME@@/${PULSE_SCHEDULER_CONFFILE_FILENAME}/" \
		-e "s/@@PULSE_INVENTORY_CONFFILE_FILENAME@@/${PULSE_INVENTORY_CONFFILE_FILENAME}/" \
		postflight.in \
		> ${PKG_FOLDER_TMP}/Contents/Resources/postflight
		chmod 0755 ${PKG_FOLDER_TMP}/Contents/Resources/postflight
	colored_echo green "### INFO Updating postflight script... Done"
}

update_postflight_script_full() {
	#TBD
	colored_echo blue "### INFO Updating postflight script..."
	colored_echo green "### INFO Updating postflight script... Done"
}

update_info_plist() {
	colored_echo blue "### INFO Updating Info.plist..."
	sed -e "s/@@AGENT_VERSION@@/${AGENT_VERSION}/" \
		-e "s/@@V_MAJOR@@/${V_MAJOR}/" \
		-e "s/@@V_MINOR@@/${V_MINOR}/" \
		-e "s/@@BUILD_DATE@@/${BUILD_DATE}/" \
		Info.plist.in \
		> ${PKG_FOLDER_TMP}/Contents/Info.plist
	colored_echo green "### INFO Updating Info.plist... Done"
}

generate_agent_pkg() {
	colored_echo blue "### INFO Generating installer..."
	# generate package
	if [[ ${MINIMAL} -eq 1 ]]; then
		if [ -f Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg ]; then
			rm -rf Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg
		fi
		mv ${PKG_FOLDER_TMP} Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg
		tar -cf Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg.tar.gz Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg
		rm -rf Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg
	else
		if [ -f Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg ]; then
			rm -rf Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg
		fi
		mv ${PKG_FOLDER_TMP} Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg
		tar -cf Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg.tar.gz Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg
		rm -rf Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg
	fi
	if [ ! $? -eq 0 ]; then
		colored_echo red "### ER... Generation of agent failed. Please restart"
		exit 1
	fi

    # Create symlinks to latest version
    if [[ ${INVENTORY_TAG} == '' ]]; then
        if [[ ${MINIMAL} -eq 1 ]]; then
            ln -s -f Pulse-Agent-mac-MINIMAL-${AGENT_VERSION}.pkg.tar.gz Pulse-Agent-mac-MINIMAL-latest.pkg.tar.gz
        else
            ln -s -f Pulse-Agent-mac-FULL-${AGENT_VERSION}.pkg.tar.gz Pulse-Agent-mac-FULL-latest.pkg.tar.gz
        fi
    fi

	colored_echo green "### INFO  Generating installer... Done"
}

# Run the script
check_arguments "$@"
compute_parameters
create_folder_structure
if [[ ${MINIMAL} -eq 1 ]]; then
	update_postflight_script_mini
else
	update_postflight_script_full
fi
update_info_plist
generate_agent_pkg
