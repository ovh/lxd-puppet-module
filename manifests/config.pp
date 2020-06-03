## Basic configuration of LXD
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

class lxd::config{

    # params from main module
    $lxd_auto_update_interval = $lxd::lxd_auto_update_interval
    $lxd_auto_update_interval_ensure = $lxd::lxd_auto_update_interval_ensure
    $lxd_core_https_address_ensure = $lxd::lxd_core_https_address_ensure
    $lxd_core_trust_password_ensure = $lxd::lxd_core_trust_password_ensure

    lxd_config { 'global_images.auto_update_interval':
        ensure => $lxd_auto_update_interval_ensure,
        config => [ 'images.auto_update_interval',],
        value  => $lxd_auto_update_interval,
    }

    lxd_config { 'global_core.https_address':
        ensure => $lxd_core_https_address_ensure,
        config => [ 'core.https_address',],
    }

    lxd_config { 'global_core.trust_password':
        ensure => $lxd_core_trust_password_ensure,
        config => [ 'core.trust_password',],
    }
}
