# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary Manage LXD and its configuration
#
# @param ensure
#   Ensure the state of the resources
# @param version
#   Version to be installed
# @param install_options
#   Additional install options passed to apt eg. `-t trusty-backports`
# @param lxd_auto_update_interval_ensure
#   Manage Auto Update Interval
# @param lxd_auto_update_interval
#   Default interval to update remote images, 0 to disable
# @param lxd_core_https_address_ensure
#   Manage LXD Core HTTPS Address
# @param lxd_core_https_address
#   HTTPS address on which LXD to listen to
# @param lxd_core_trust_password_ensure
#   Manage LXD default trust password for clustering
# @param lxd_core_trust_password
#   LXD trust password for clusters
#
class lxd(
    Optional[String]          $version                         = $lxd::params::version,
    Enum['present', 'absent'] $ensure                          = $lxd::params::ensure,
    Array[String]             $install_options                 = $lxd::params::install_options,
    Integer                   $lxd_auto_update_interval        = $lxd::params::lxd_auto_update_interval,
    Enum['present', 'absent'] $lxd_auto_update_interval_ensure = $lxd::params::lxd_auto_update_interval_ensure,
    Optional[String]          $lxd_core_https_address          = $lxd::params::lxd_core_https_address,
    Enum['present', 'absent'] $lxd_core_https_address_ensure   = $lxd::params::lxd_core_https_address_ensure,
    Optional[String]          $lxd_core_trust_password         = $lxd::params::lxd_core_trust_password,
    Enum['present', 'absent'] $lxd_core_trust_password_ensure  = $lxd::params::lxd_core_trust_password_ensure,
    Enum['package', 'snap']   $provider                        = $lxd::params::lxd_provider
) inherits lxd::params {
    contain lxd::install
    contain lxd::config

    if $ensure == 'present' {
      Class['lxd::install']
      -> Class['lxd::config']
    } else {
      Class['lxd::config']
      -> Class['lxd::install']
    }

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
