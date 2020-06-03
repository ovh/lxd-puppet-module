# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

Puppet::Type.newtype(:lxd_config) do
    desc "Setting basic LXD configuration"

    ensurable

    newparam(:config_name, :namevar => true) do
        desc "Unique name of the config resource"
    end

    newparam(:config, :array_matching => :all) do
        desc "Array of config which needs to be passed to lxc config"
    end

    newproperty(:value) do
        desc "Values that needs to be set in lxc config"
    end
end
