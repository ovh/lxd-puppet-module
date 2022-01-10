# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary Manage LXD container
#
# @param ensure
#   Ensure the state of the resource
# @param image
#   Image from which to create the container
# @param config
#   Config values for the container
# @param devices
#   Devices to be attached to container
# @param profiles
#   Profiles to be assigned to container
# @param state
#   State of the container
#
define lxd::container(
    $image,
    $config = {},
    $devices = {},
    $profiles = ['default'],
    $state = 'started',
    $ensure = 'present',
) {
    # creating lxd container

    lxd_container { $name:
        ensure   => $ensure,
        state    => $state,
        config   => $config,
        devices  => $devices,
        profiles => $profiles,
        image    => $image,
    }

    case $ensure {
        'present': {
            Lxd::Image[$image]
            -> Lxd::Container[$name]
        }
        'absent': {
            Lxd::Container[$name]
            -> Lxd::Image[$image]
        }
        default : {
            fail("Unsuported ensure value ${ensure}")
        }
    }
}
