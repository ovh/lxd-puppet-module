# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary Performs install actions for LXD
#
# @api private
#
class lxd::install {
    if $::lxd::provider == 'package' {
      package { 'lxd':
        ensure          => $::lxd::ensure,
        install_options => $::lxd::install_options,
      }
    } else {
      if $lxd::manage_snapd {
        package { 'snapd':
          ensure => $::lxd::ensure,
          before => Exec['install snap core']
        }
      }

      exec { 'install snap core':
        path    => '/usr/bin:/bin',
        command => '/usr/bin/snap install core',
        unless  => '/usr/bin/snap list core',
      }

      if $lxd::ensure == 'present' {
        exec { 'install lxd':
          path    => '/usr/bin:/bin',
          command => '/usr/bin/snap install lxd',
          unless  => '/usr/bin/snap list lxd',
          require => Exec['install snap core']
        }
      } else {
        exec { 'remove lxd':
          path    => '/usr/bin:/bin',
          command => '/usr/bin/snap remove lxd',
          unless  => '! /usr/bin/snap list lxd >/dev/null 2>&1',
        }
      }
    }
}
