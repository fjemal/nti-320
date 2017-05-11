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
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/root/bin
cp check_plugin1 $RPM_BUILD_ROOT/root/bin
%clean
rm -rf $RPM_BUILD_ROOT
%files
%defattr(-,root,root,-)
%attr(0777,root,root)/root/bin/check_plugin1
