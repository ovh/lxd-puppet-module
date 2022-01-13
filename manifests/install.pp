## Installing LXD
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

class lxd::install {
    if $::lxd::lxd_package_provider == 'deb' {
      package { 'lxd':
        ensure          => $::lxd::ensure,
        install_options => $::lxd::install_options,
      }
    } else {
      if $::lxd::manage_snapd {
        package { 'snapd':
          ensure => $::lxd::ensure,
          before => Exec['install lxd']
        }
      }

      if $::lxd::ensure == 'present' {
        exec { 'install lxd':
          path    => '/bin:/usr/bin',
          command => '/usr/bin/snap install lxd',
          unless  => '/usr/bin/snap list lxd',
        }
      } else {
        exec { 'remove lxd':
          path    => '/bin:/usr/bin',
          command => '/usr/bin/snap remove lxd',
          unless  => '! /usr/bin/snap list lxd >/dev/null 2>&1',
          before  => Package['snapd']
        }
      }
    }
}
