## LXD container define
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

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
