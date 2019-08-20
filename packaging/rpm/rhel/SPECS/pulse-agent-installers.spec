%define   rel   22

%define branch  BRANCH

%define VERSION_XMPP_AGENT 2.0.1
%define VERSION_AGENT_PLUGINS 1.12

Summary:	Files to create pulse windows installer
Name:		pulse-agent-installers
Version:	2.0.1
Release:	%{rel}%{?dist}
Source0:    pulse-agent-installers-%version.tar.gz
License:	MIT
Group:		Development/Other
Url:		http://www.siveo.net/

BuildRequires:  git

Requires:    pulse-xmpp-agent-deps

Requires:   dos2unix
Requires:   unzip
Requires:   zip

Requires:   nsis-plugins-ZipDLL
Requires:   nsis-plugins-Pwgen
Requires:   nsis-plugins-AccessControl
Requires:   nsis-plugins-Inetc
Requires:   nsis-plugins-TextReplace

%description
The random number facilities already available for NSIS do
not generate good entropy. If these facilities are used to
generate passwords (as an installer might do when setting
up a user account to run a service), the passwords they
generate will be very predictable.
But Microsoft provides the CryptoAPI in Windows, which we
can use to collect crypto-grade entropy from the operating
system. This plugin exports just one API call, which can
be used to generate a password of arbitrary length (1 to
255 characters) using secure entropy provided to us by the
OS. We restrict the generated password to the 62-character
set consisting of upper and lower-case alphanumerics.

%prep
%setup -q

%build

GIT_SSL_NO_VERIFY=true git clone https://github.com/pulse-project/pulse-xmpp-agent.git
cd pulse-xmpp-agent
git checkout %branch
cd ..

mv pulse-xmpp-agent pulse-xmpp-agent-%version
tar czvf pulse-xmpp-agent-%version.tar.gz pulse-xmpp-agent-%version

GIT_SSL_NO_VERIFY=true git clone https://github.com/pulse-project/pulse-agent-plugins.git
cd pulse-agent-plugins
git checkout %branch
cd ..

mv pulse-agent-plugins pulse-agent-plugins-1.12
tar czvf pulse-agent-plugins-1.12.tar.gz pulse-agent-plugins-1.12

GIT_SSL_NO_VERIFY=true git clone https://github.com/pulse-project/pulse-filetree-generator.git

mv pulse-filetree-generator pulse-filetree-generator-0.1
g++ -O3 -std=c++11 pulse-filetree-generator-0.1/linux_macos/pulse-filetree-generator.cpp -o pulse-filetree-generator


%install
mkdir -p %{buildroot}/var/lib/pulse2/clients
mv pulse-xmpp-agent-%version.tar.gz %{buildroot}/var/lib/pulse2/clients/

mkdir -p %{buildroot}/tmp
tar xzvf %{buildroot}/var/lib/pulse2/clients/pulse-xmpp-agent-%version.tar.gz -C %{buildroot}/tmp
mkdir -p %{buildroot}/var/lib/pulse2/xmpp_baseremoteagent
cp -frv %{buildroot}/tmp/pulse-xmpp-agent-%version/pulse_xmpp_agent/* %{buildroot}/var/lib/pulse2/xmpp_baseremoteagent/
rm -fr %{buildroot}/tmp

# We create pulse-agent-plugins tarball
mv pulse-agent-plugins-1.12.tar.gz %{buildroot}/var/lib/pulse2/clients

mkdir -p %{buildroot}/etc/mmc/plugins/
mkdir -p %{buildroot}/var/lib/pulse2/clients/config/

cp pulse-xmpp-agent-%version/pulse_xmpp_agent/config/agentconf.ini.in %{buildroot}/var/lib/pulse2/clients/config/
cp pulse-xmpp-agent-%version/pulse_xmpp_agent/config/manage_scheduler.ini %{buildroot}/var/lib/pulse2/clients/config/
cp scripts_installer/generate-pulse-agent.sh %{buildroot}/var/lib/pulse2/clients
cp scripts_installer/generate-agent-package %{buildroot}/var/lib/pulse2/clients
cp scripts_installer/generate-agent-deps-package %{buildroot}/var/lib/pulse2/clients
cp scripts_installer/HEADER.html %{buildroot}/var/lib/pulse2/clients
cp scripts_installer/style.css %{buildroot}/var/lib/pulse2/clients

mkdir -p %{buildroot}/var/lib/pulse2/clients/win
cp scripts_installer/win/generate-pulse-agent-win.sh %{buildroot}/var/lib/pulse2/clients/win
cp scripts_installer/win/agent-installer.nsi.in %{buildroot}/var/lib/pulse2/clients/win
cp scripts_installer/win/pulse-agent-task.xml %{buildroot}/var/lib/pulse2/clients/win
cp scripts_installer/win/pulse-filetree-generator.exe %{buildroot}/var/lib/pulse2/clients/win
cp scripts_installer/generate-kiosk-package %{buildroot}/var/lib/pulse2/clients/win

mkdir -p %{buildroot}/var/lib/pulse2/clients/lin
cp scripts_installer/lin/generate-pulse-agent-linux.sh %{buildroot}/var/lib/pulse2/clients/lin
cp scripts_installer/lin/install-pulse-agent-linux.sh.in %{buildroot}/var/lib/pulse2/clients/lin

mkdir -p %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/generate-pulse-agent-mac.sh %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/Info.plist.in %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/postflight.in %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/net.siveo.pulse_xmpp_agent.plist %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/rbash %{buildroot}/var/lib/pulse2/clients/mac
cp scripts_installer/mac/runpulseagent %{buildroot}/var/lib/pulse2/clients/mac

mkdir -p %{buildroot}/var/lib/pulse2/clients/win/libs
cp -fr scripts_installer/win/nsis_libs/* %{buildroot}/var/lib/pulse2/clients/win/libs

mkdir -p %{buildroot}/var/lib/pulse2/clients/win/artwork
cp -fr scripts_installer/win/artwork/* %{buildroot}/var/lib/pulse2/clients/win/artwork

chmod +x %{buildroot}/var/lib/pulse2/clients/*.sh
chmod +x %{buildroot}/var/lib/pulse2/clients/generate-agent-package
chmod +x %{buildroot}/var/lib/pulse2/clients/generate-agent-deps-package
chmod +x %{buildroot}/var/lib/pulse2/clients/win/generate-kiosk-package


mkdir -p %{buildroot}/var/lib/pulse2/clients/lin/deb/pulse-agent-linux/usr/sbin
cp pulse-filetree-generator %{buildroot}/var/lib/pulse2/clients/lin/deb/pulse-agent-linux/usr/sbin

chmod +x %{buildroot}/var/lib/pulse2/clients/lin/deb/pulse-agent-linux/usr/sbin/pulse-filetree-generator
mkdir -p %{buildroot}/var/lib/pulse2/clients/lin/rpm/package/SOURCES

cp pulse-filetree-generator %{buildroot}/var/lib/pulse2/clients/lin/rpm/package/SOURCES
chmod +x %{buildroot}/var/lib/pulse2/clients/lin/rpm/package/SOURCES/pulse-filetree-generator

cp  pulse-filetree-generator %{buildroot}/var/lib/pulse2/clients/mac
chmod +x %{buildroot}/var/lib/pulse2/clients/mac/pulse-filetree-generator

mkdir -p %{buildroot}/var/lib/pulse2/clients/win/downloads/
cp scripts_installer/win/create-profile.ps1 %{buildroot}/var/lib/pulse2/clients/win/

cp scripts_installer/win/pulse-service.py %{buildroot}/var/lib/pulse2/clients/win/


%pre
rm -fv /var/lib/pulse2/imaging/postinst/winutils/Pulse-Agent*latest*

if [ ! -d "/var/lib/pulse2/clients/win" ]; then
    mkdir /var/lib/pulse2/clients/win
fi

if [ -d "/var/lib/pulse2/clients/win32" ]; then
    mv /var/lib/pulse2/clients/win32/*.exe /var/lib/pulse2/clients/win/
    rm -fr /var/lib/pulse2/clients/win32/
fi

if [ -d "/var/lib/pulse2/clients/linux" ]; then
    rm -fr /var/lib/pulse2/clients/linux/
fi


%post
if [ $1 == 2 ]; then
	if [ -f %_var/lib/pulse2/clients/config/agentconf.ini ]; then
		%_var/lib/pulse2/clients/generate-pulse-agent.sh
		%_var/lib/pulse2/clients/generate-pulse-agent.sh --minimal
		%_var/lib/pulse2/clients/generate-agent-package
	fi
fi

%files
%_var/lib/pulse2/clients
/var/lib/pulse2/xmpp_baseremoteagent/
