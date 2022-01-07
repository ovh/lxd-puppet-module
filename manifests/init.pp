## Init class
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

class lxd(
    $version = $lxd::params::version,
    $ensure  = $lxd::params::ensure,
    $install_options = $lxd::params::install_options,
    $lxd_auto_update_interval = $lxd::params::lxd_auto_update_interval,
    $lxd_auto_update_interval_ensure = $lxd::params::lxd_auto_update_interval_ensure,
    $lxd_core_https_address = $lxd::params::lxd_core_https_address,
    $lxd_core_https_address_ensure = $lxd::params::lxd_core_https_address_ensure,
    $lxd_core_trust_password = $lxd::params::lxd_core_trust_password,
    $lxd_core_trust_password_ensure = $lxd::params::lxd_core_trust_password_ensure,
    Enum['deb', 'snap'] $provider = $lxd::params::lxd_provider
) inherits lxd::params {
    contain ::lxd::install
    contain ::lxd::config

    Class['lxd::install']
    -> Class['lxd::config']

    # Every container has to be created after LXD is installed, of course
    # Container can have multiple profiles so better make sure that
    # ever profile is created before creating
    Class['::lxd']
    -> Lxd::Storage <| ensure == 'present' |>
    -> Lxd::Profile <| ensure == 'present' |>
    -> Lxd::Container <| ensure == 'present' |>

    Class['::lxd']
    -> Lxd::Container <| ensure == 'absent' |>
    -> Lxd::Profile <| ensure == 'absent' |>
    -> Lxd::Storage <| ensure == 'absent' |>
}
