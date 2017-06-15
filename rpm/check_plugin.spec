Name:   check_plugin
Version:        0.1
Release:        1%{?dist}
Summary:        GOOD
Group:          NTI-320
License:         GNUv2
URL:            https://github.com/fjemal/nti-320
#Source0:       
source:         check_plugin-0.1.tar.gz
BuildRequires:  gcc
Requires:       bash
%description
THIS IS AWESOME
%prep
%setup -q
%build
echo " OK "

%install

#make install DESTDIR=%{buildroot}
#rm -rf $RPM_BUILD_ROOT
#mkdir -p $RPM_BUILD_ROOT/root/bin
#cp check_plugin1 $RPM_BUILD_ROOT/root/bin

rm -rf %{buildroot}
#mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/usr/lib64/nagios/plugins
install -m 0755 check_plugin1 %{buildroot}/usr/lib64/nagios/plugins/check_plugin1
install -m 0755 check_diskspace %{buildroot}/usr/lib64/nagios/plugins/check_diskspace
install -m 0755 check_ldap %{buildroot}/usr/lib64/nagios/plugins/check_ldap
install -m 0755 check_ssl %{buildroot}/usr/lib64/nagios/plugins/check_ssl
#install -m 0755 check_diskspace %{buildroot}/%{_bindir}/check_diskspace

%clean
#rm -rf $RPM_BUILD_ROOT
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
#%attr(0777,root,root)/root/bin/check_plugin1
#/usr/bin/check_plugin1
/usr/lib64/nagios/plugins/check_plugin1
/usr/lib64/nagios/plugins/check_ldap
/usr/lib64/nagios/plugins/check_diskspace
/usr/lib64/nagios/plugins/check_ssl

%post
#installing packages
sudo yum install wget
sudo yum -y install httpd nrpe nagios-plugins-all 

#add check_mem plugin from github
sudo cd /usr/lib64/nagios/plugins/
sudo wget https://raw.githubusercontent.com/justintime/nagios-plugins/master/check_mem/check_mem.pl
sudo mv check_mem.pl check_mem
sudo chmod +x check_mem

#adjust nrpe command definitions
sudo sed -i "215i command[check_plugin1]=\/usr\/lib64\/nagios\/plugins\/check_plugin1 -w 66 -c 902" /etc/nagios/nrpe.cfg
sudo sed -i "216i command[check_disk]=\/usr\/lib64\/nagios\/plugins\/check_disk -w 20% -c 10% -p \/dev\/sda1" /etc/nagios/nrpe.cfg
sudo sed -i "217i command[check_procs]=\/usr\/lib64\/nagios\/plugins\/check_procs -w 150 -c 200" /etc/nagios/nrpe.cfg
sudo sed -i "218i command[check_mem]=/usr/lib64/nagios/plugins/check_mem  -f -w 20 -c 10" /etc/nagios/nrpe.cfg
sudo sed -i "219i command[check_usedspace]=/usr/lib64/nagios/plugins/check_usedspace" /etc/nagios/nrpe.cfg
sudo sed -i "220i command[check_ssl]=/usr/lib64/nagios/plugins/check_ssl" /etc/nagios/nrpe.cfg
sudo sed -i "221i command[check_ldap]=/usr/lib64/nagios/plugins/check_ldap" /etc/nagios/nrpe.cfg

#chenage the owner to nagios
sudo chown nagios:nagios /usr/lib64/nagios/plugins/check_plugin1
sudo chown nagios:nagios /usr/lib64/nagios/plugins/check_ldap
sudo chown nagios:nagios /usr/lib64/nagios/plugins/check_usedspace
sudo chown nagios:nagios /usr/lib64/nagios/plugins/check_ssl

sudo chmod +x /usr/lib64/nagios/plugins/check_plugin1
sudo chmod +x /usr/lib64/nagios/plugins/check_ldap
sudo chmod +x /usr/lib64/nagios/plugins/check_usedspace
sudo chmod +x /usr/lib64/nagios/plugins/check_ssl


#modify the nrpe file configuration to connect with the server
sudo sed -i "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1,10.128.0.0\/24/" /etc/nagios/nrpe.cfg
sudo sed -i "s/dont_blame_nrpe=0/dont_blame_nrpe=1/" /etc/nagios/nrpe.cfg

#star and enable all the services
sudo systemctl enable nrpe httpd
sudo systemctl start nrpe httpd
