# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

Puppet::Type.newtype(:lxd_profile) do
    desc "Setting LXD profiles"

    ensurable

    newparam(:name, :namevar => true) do
        desc "Unique name of the profile"
    end

    newproperty(:config, :hash_matching => :all) do
        desc "Hash of profile config values"
        validate do |value|
            unless value.kind_of?Hash
                raise ArgumentError, "config is #{value.class}, expected Hash"
            end
        end
    end

    newproperty(:devices, :hash_matching => :all) do
        desc "Array of devices"
        validate do |value|
            unless value.kind_of?Hash
                raise ArgumentError, "devices are #{value.class}, expected Hash"
            end
        end
    end

    newproperty(:description) do
        desc "Array of devices"
        validate do |value|
            unless value.kind_of?String
                raise ArgumentError, "description is #{value.class}, expected String"
            end
        end
    end
end
