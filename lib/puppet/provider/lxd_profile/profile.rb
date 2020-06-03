# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'json'

Puppet::Type.type(:lxd_profile).provide(:profile) do
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
        begin
            response = JSON.parse(output)
        rescue JSON::ParserError
            response = {}
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
        profile_array = get_api_node(['profiles'])
        return profile_array.include? return_api_path(['profiles', resource[:name]])
    end

    # ensure absent handling
    def destroy
        return delete_api_node(['profiles', resource[:name]])
    end

    # ensure present handling
    def create
        call_body = {
            'name' => resource[:name],
            'description' => resource[:description],
            'config' => resource[:config],
            'devices' => resource[:devices],
        }
        create_api_node(['profiles'], call_body)
    end

    # getter method for property config
    def config
        profile_hash = get_api_node(['profiles', resource[:name]])
        config_hash = profile_hash['config']
        return config_hash
    end

    # setter method for property config
    def config=(config_hash)
        profile_hash = get_api_node(['profiles', resource[:name]])
        call_body = {
            'description' => profile_hash['description'],
            'config' => config_hash,
            'devices' => profile_hash['devices'],
        }
        put_api_node(['profiles', resource[:name]], call_body)
    end

    # getter method for property config
    def devices
        profile_hash = get_api_node(['profiles', resource[:name]])
        devices_hash = profile_hash['devices']
        return devices_hash
    end

    # setter method for property config
    def devices=(devices_hash)
        profile_hash = get_api_node(['profiles', resource[:name]])
        call_body = {
            'description' => profile_hash['description'],
            'config' => profile_hash['config'],
            'devices' => devices_hash,
        }
        put_api_node(['profiles', resource[:name]], call_body)
    end

    # getter method for property description
    def description
        profile_hash = get_api_node(['profiles', resource[:name]])
        desc = profile_hash['description']
        return desc
    end

    # setter method for property description
    def description=(desc)
        modify_api_node(['profiles', resource[:name]], {'description' => desc})
    end

end
