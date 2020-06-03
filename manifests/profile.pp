## Creating LXD profiles
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

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
