# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'json'

Puppet::Type.type(:lxd_storage).provide(:storage) do
    commands :lxc => 'lxc'

    ### Helper methods

    # returns correct path to API
    def return_api_path(array)
        api_version = '1.0'
        return "/#{api_version}/#{array.join('/')}"
    end

    # GET call to API that take type, name arguments but can also take more
    def get_api_node(path_array)
        return JSON.parse(lxc(['query', '--wait', '-X', 'GET', return_api_path(path_array)]))
    end

    # LXD api can return '' empty string which cannot be parsed as JSON
    def parse_api_output(output)
        if output.empty?
            response = {}
        else
            response = JSON.parse(output)
        end
        return response
    end

    # POST call
    def create_api_node(path_array, values_hash)
        return parse_api_output(lxc(['query', '--wait', '-X', 'POST', '-d', "#{values_hash.to_json}", return_api_path(path_array)]))
    end

    # PUT call
    def put_api_node(path_array, values_hash)
        return parse_api_output(lxc(['query', '--wait', '-X', 'PUT', '-d', "#{values_hash.to_json}", return_api_path(path_array)]))
    end

    # PATCH call
    def modify_api_node(path_array, values_hash)
        lxc(['query', '--wait', '-X', 'PATCH', '-d', "#{values_hash.to_json}", return_api_path(path_array)])
        return true
    end

    # DELETE call
    def delete_api_node(path_array)
        return parse_api_output(lxc(['query', '--wait', '-X', 'DELETE', return_api_path(path_array)]))
    end


    ### Provider methods

    # checking if the resource exists
    def exists?
        # if the entry '/storage-pools/somename' is present within array returned from /storage-pools
        # then the storage pool somename exists
        storage_array = get_api_node(['storage-pools'])
        return storage_array.include? return_api_path(['storage-pools', resource[:name]])
    end

    # ensure absent handling
    def destroy
        return delete_api_node(['storage-pools', resource[:name]])
    end

    # ensure present handling
    def create
        call_body = {
            'name' => resource[:name],
            'driver' => resource[:driver],
            'description' => resource[:description],
            'config' => resource[:config],
        }
        create_api_node(['storage-pools'], call_body)
    end

    # getter method for property config
    def config
        storage_hash = get_api_node(['storage-pools', resource[:name]])
        config_hash = storage_hash['config']
        # Remove volatile.initial_source key from config as 
        config_hash.delete("volatile.initial_source")
        return config_hash
    end

    # setter method for property config
    def config=(config_hash)
        storage_hash = get_api_node(['storage-pools', resource[:name]])
        call_body = {
            'config' => config_hash,
        }
        put_api_node(['storage-pools', resource[:name]], call_body)
    end

    # getter method for property description
    def description
        storage_hash = get_api_node(['storage-pools', resource[:name]])
        desc = storage_hash['description']
        return desc
    end

    # setter method for property description
    def description=(desc)
        modify_api_node(['storage-pools', resource[:name]], {'description' => desc})
    end

    # getter method for property driver
    def driver
        storage_hash = get_api_node(['storage-pools', resource[:name]])
        driver = storage_hash['driver']
        return driver
    end

    # setter method for property driver
    def driver=(driver)
        # TODO throw some exception as modyfing driver is not supported
        raise NotImplementedError, "You cannot modify driver of already created storage!"
    end
end
