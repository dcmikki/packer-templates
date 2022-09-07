#!/usr/bin/env bash

# Get output one 'redhat' 'centos' 'oraclelinux'
distro="`rpm -qf --queryformat '%{NAME}' /etc/redhat-release | cut -f 1 -d '-'`"

major_version="`sed 's/^.\+ release \([.0-9]\+\)./\1/' /etc/redhat-release | awk -F. '{print $1}'`"; 

# Make sure we use dnf on RHEL8+
if [ "$major_version" -ge 8 ]; then
  pkg_cmd="dnf"
else
  pkg_cmd="yum"
fi

# Remove development and kernel source packages
echo "Remove development and kernel source packages..."
$pkg_cmd -y remove gcc kernel-devel kernel-headers glibc-devel elfutils-libelf-devel glibc-headers

if [ "$major_version" -ge 8 ]; then
  echo "Remove orphaned packages"
  dnf -y autoremove
  echo "Remove previous kernels that preserved for rollbacks..."
  dnf -y remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)
else
  echo "Remove previous kernels that preserved for rollbacks..."
  if ! commnand -v package-cleanup > /dev/null 2>&1 ; then
  	yum -y install yum-utils
  fi
  package-cleanup --oldkernels --count=1 -y
fi

# Avoid~200 mg firmware package we don't need
echo "Removing extra firmware packages..."
$pkg_cmd -y remove linux-firmware

if [ "$distro" != 'redhat' ]; then
  echo "clean all package cache information..."
  $pkg_cmd -y clean all --enablerepo=\*
fi

echo "truncate any logs that have built up during the installation"
find /var/log -type f -exec truncate --size=0 {} \;

echo "remove the install log ..."
rm -vf /root/anaconda-ks.cfg /root/original-ks.cfg

echo "remove all content of /tmp and /var/tmp"
rm -rvf /tmp/* /var/tmp/*


if [ "$major_version" -ge 7 ]; then
  echo "Force a new random seed to be generated"
  rm -vf /var/lib/systemd/random-seed

  echo "Wipe netplan machine-id, so machines get unique ID generated on boot"
  truncate -s 0 /etc/machine-id
fi

echo "Clear the history so our commands aren't there"
rm -vf /root/.wget-hsts