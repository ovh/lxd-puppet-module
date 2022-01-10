# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary Manage LXD profiles
#
# @param ensure
#   Ensure the state of the resource
# @param devices
#   Devices to be included in the profile
# @param config
#   Config values to be included in the profile
# @param description
#   Description for the profile
#
define lxd::profile(
    $devices,
    $config,
    $description = '',
    $ensure = 'present',
) {
    lxd_profile { $name:
        ensure      => $ensure,
        description => $description,
        devices     => $devices,
        config      => $config,
    }
}
