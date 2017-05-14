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

#install -m 0755 check_plugin1 %{buildroot}/%{_bindir}/check_plugin1
%clean
#rm -rf $RPM_BUILD_ROOT
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
#%attr(0777,root,root)/root/bin/check_plugin1
#/usr/bin/check_plugin1
/usr/lib64/nagios/plugins/check_plugin1

%post
sudo chown nagios:nagios /usr/lib64/nagios/plugins/check_plugin1
sudo chmod +x /usr/lib64/nagios/plugins/check_plugin1
sudo sed -i "215i command[check_plugin1]=\/usr\/lib64\/nagios\/plugins\/check_plugin1 -w 66 -c 902" /etc/nagios/nrpe.cfg
