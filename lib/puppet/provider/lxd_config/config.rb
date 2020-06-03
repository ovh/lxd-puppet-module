# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

Puppet::Type.type(:lxd_config).provide(:config) do
    commands :lxc => 'lxc'

    # custom function that will get config values
    def get_lxd_config_value(config_array)
        begin
            output = lxc(['config', 'get', config_array].flatten)
        rescue Puppet::ExecutionFailure => e
            Puppet.debug("Cannot get config with lxc config: #{e.inspect}")
            return nil
        end
        if output == "\n"
            return nil
        else
            return output.strip
        end
    end

    # custom function that will set config values
    def set_lxd_config_value(config_array, config_value)
        begin
            output = lxc(['config', 'set', config_array, config_value].flatten)
        rescue Puppet::ExecutionFailure => e
            Puppet.debug("Cannot get config with lxc config: #{e.inspect}")
            return nil
        # no exception ocurred so returning true
        else
            return true
        end
    end

    # custom function that will unset config values
    def unset_lxd_config_value(config_array)
        begin
            output = lxc(['config', 'unset', config_array].flatten!)
        rescue Puppet::ExecutionFailure => e
            Puppet.debug("Cannot unset config with lxc config: #{e.inspect}")
            return nil
        else
            return true
        end
    end

    # checking if the resource exists
    def exists?
        get_lxd_config_value(resource[:config]) != nil
    end

    # ensure absent handling
    def destroy
        unset_lxd_config_value(resource[:config])
    end

    # ensure present handling
    def create
        set_lxd_config_value(resource[:config], resource[:value])
    end

    # getter method for getting config value
    def value
        get_lxd_config_value(resource[:config])
    end

    # setter method for setting config value
    def value=(config_value)
        set_lxd_config_value(resource[:config], config_value)
    end
end
