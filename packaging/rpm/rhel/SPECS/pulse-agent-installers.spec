%define   rel   1

%define branch  BRANCH

Summary:	Files to create pulse windows installer
Name:		pulse-agent-installers
Version:	1.9.0
Release:	%{rel}%{?dist}
Source0:        pulse-agent-installers-%version.tar.gz
License:	MIT
Group:		Development/Other
Url:		http://www.siveo.net/
BuildArch:	noarch

BuildRequires:  git

Requires:       pulse-xmpp-agent-deps 

Requires:       dos2unix 
Requires:       unzip 
Requires:       zip

Requires:       nsis-plugins-ZipDLL 
Requires:       nsis-plugins-Pwgen 
Requires:       nsis-plugins-AccessControl
Requires:       nsis-plugins-Inetc
Requires:       nsis-plugins-TextReplace

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

mv pulse-agent-plugins pulse-agent-plugins-1.4
tar czvf pulse-agent-plugins-1.4.tar.gz pulse-agent-plugins-1.4


%install
mkdir -p %{buildroot}/var/lib/pulse2/clients
mv pulse-xmpp-agent-%version.tar.gz %{buildroot}/var/lib/pulse2/clients/


	# We create pulse-agent-plugins tarball
        mv pulse-agent-plugins-1.4.tar.gz %{buildroot}/var/lib/pulse2/clients

        mkdir -p %{buildroot}/etc/mmc/plugins/
        mkdir -p %{buildroot}/var/lib/pulse2/clients/config/

        cp pulse-xmpp-agent-%version/pulse_xmpp_agent/config/agentconf.ini.in %{buildroot}/var/lib/pulse2/clients/config/
        cp pulse-xmpp-agent-%version/pulse_xmpp_agent/config/relayconf.ini.in %{buildroot}/var/lib/pulse2/clients/config/
        cp pulse-xmpp-agent-%version/pulse_xmpp_agent/config/manage_scheduler.ini %{buildroot}/var/lib/pulse2/clients/config/
        cp scripts_installer/generate-pulse-agent.sh %{buildroot}/var/lib/pulse2/clients
        cp scripts_installer/generate-agent-package %{buildroot}/var/lib/pulse2/clients
        mkdir -p %{buildroot}/var/lib/pulse2/clients/win32
        cp scripts_installer/generate-pulse-agent-win.sh %{buildroot}/var/lib/pulse2/clients/win32
        cp scripts_installer/agent-installer.nsi.in %{buildroot}/var/lib/pulse2/clients/win32
        cp scripts_installer/pulse-agent-task.xml %{buildroot}/var/lib/pulse2/clients/win32
        mkdir -p %{buildroot}/var/lib/pulse2/clients/linux
        cp scripts_installer/*linux* %{buildroot}/var/lib/pulse2/clients/linux
        mkdir -p %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/generate-pulse-agent-mac.sh %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/Info.plist.in %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/postflight.in %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/net.siveo.pulse_xmpp_agent.plist %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/rbash %{buildroot}/var/lib/pulse2/clients/mac
        cp scripts_installer/runpulseagent %{buildroot}/var/lib/pulse2/clients/mac
        mkdir -p %{buildroot}/var/lib/pulse2/clients/win32/libs
        cp -fr scripts_installer/nsis_libs/* %{buildroot}/var/lib/pulse2/clients/win32/libs
        chmod +x %{buildroot}/var/lib/pulse2/clients/*.sh
        chmod +x %{buildroot}/var/lib/pulse2/clients/generate-agent-package

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
