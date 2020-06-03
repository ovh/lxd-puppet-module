## Installing LXD
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

class lxd::install {
    package { 'lxd':
        ensure          => $::lxd::ensure,
        install_options => $::lxd::install_options,
    }
}
