## Configuration of storage pools for LXD
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

define lxd::storage(
    $driver,
    $config,
    $description = '',
    $ensure = 'present',
) {
    lxd_storage { $name:
        ensure      => $ensure,
        driver      => $driver,
        config      => $config,
        description => $description,
    }
}
