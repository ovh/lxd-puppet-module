# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary LXD default parameters
#
# @api private
#
class lxd::params {
    $ensure = present
    $version = undef
    # additional apt install options
    $install_options = []
    # automatic update of cached images interval
    $lxd_auto_update_interval = 0
    $lxd_auto_update_interval_ensure = 'present'
    # address to for LXD API to listen on eg "[::]:8443"
    $lxd_core_https_address = undef
    $lxd_core_https_address_ensure = 'absent'
    # setting the server's trust password
    $lxd_core_trust_password = undef
    $lxd_core_trust_password_ensure = 'absent'
    $lxd_provider = 'package'
    $manage_snapd = true
}
