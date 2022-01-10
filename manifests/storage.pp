# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.
#
# @summary Manage LXD storage pool
#
# @param ensure
#   Ensure the state of the resource
# @param driver
#   Backend storage driver
# @param config
#   Config values for the storage
# @param description
#   Description of the storage backend
#
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
