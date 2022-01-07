## Installing LXD
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

class lxd::install {
    if $::lxd::provider == 'deb' {
      package { 'lxd':
        ensure          => $::lxd::ensure,
        install_options => $::lxd::install_options,
      }
    } else {
      package { 'snapd':
        ensure => $::lxd::ensure,
      }

      exec { 'install snap core':
        path    => '/usr/bin:/bin',
        command => '/usr/bin/snap install core',
        unless  => '/usr/bin/snap list core',
        require => Package['snapd']
      }

      exec { 'install lxd':
        path    => '/usr/bin:/bin',
        command => '/usr/bin/snap install lxd',
        unless  => '/usr/bin/snap list lxd',
        require => Exec['install snap core']
      }
    }
}
