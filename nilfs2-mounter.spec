Name:           nilfs2-mounter
Version:        1.0
Release:        1%{?dist}
Summary:        NILFS2 filesystem mounter tool

License:        GPLv3
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  golang
BuildRequires:  systemd-rpm-macros

Provides:       %{name} = %{version}

%description
This tool allows you to mount NILFS2 filesystems, without root

%global debug_package %{nil}

%prep
%autosetup
#%setup -q


%build
go build -v -o %{name}


%install
install -Dpm 0755 %{name} %{buildroot}%{_bindir}/%{name}
install -Dpm 0755 nilfs2.sh %{buildroot}%{_bindir}/nilfs2.sh

install -d %{buildroot}/usr/share/applications
install -m 644 .applications/*.desktop %{buildroot}/usr/share/applications/

%check
# go test should be here... :)

%post
setcap cap_sys_admin=ep /usr/bin/nilfs2-mounter

%preun

%files
%{_bindir}/%{name}
%{_bindir}/nilfs2.sh
/usr/share/applications/create-snapshot.desktop
/usr/share/applications/mount-snapshot.desktop
/usr/share/applications/unmount-snapshots.desktop


%changelog
* Wed May 19 2021 John Doe - 1.0-1
- First release%changelog
