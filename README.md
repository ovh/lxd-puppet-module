Puppet LXD mangament module
===

### Table of Contents
* [Overview](#overview)
* [Module Description](#module-description)
* [Requirements](#requirements)
* [Reference](#reference)
    * [Public classes](#public-classes)
    * [Defines](#defines)
* [Example usage](#example-usage)
* [Known limitations](#known-limitations)
* [Development](#development)


# Overview
This is a Puppet Module which manages the state of LXD on the host including basic LXD daemon configuration, containers, profiles, storage pools.

# Module Description
This module installs LXD and is able to manage container states as well as most of container related configuration.

This module adds the following resources defines to Puppet:
 - `lxd::profile`
 - `lxd::image`
 - `lxd::storage`
 - `lxd::container`
 
# Requirements

This module has been tested on:
 * Ubuntu 14.04 with Puppet 3.7
 * Ubuntu 16.04 with Puppet 3.8
 * Ubuntu 18.04 with Puppet 5.4

It works with LXD versions:  
 * series 2.2X
 * series 3.X

It need the following packages to be installed:
 * `wget`  

It needs the follwing Puppet modules to operate:
 * `stdlib`

# Reference

## Public classes

### lxd 

Init class. Installs LXD itself and provision basic configuration. It also forces correct resource order.  
It has the following params:
 * `version` - which version of the package should be installed,
 * `ensure` - defaults to present,
 * `install_options` - additional install options passed to apt eg. `-t trusty-backports`,
 * `lxd_auto_update_interval` - default interval to update remote images, 0 to disable,
 * `lxd_auto_update_interval_ensure` - enabling above feature,
 * `lxd_core_https_address` - default port for LXD daemon to listen on when in online mode,
 * `lxd_core_https_address_ensure` - enabling above feature,
 * `lxd_core_trust_password` - default trust password for LXD daemon for clustering,
 * `lxd_core_trust_password_ensure` - enabling above feature.

All this params have default values in `params.pp`.

## Defines


### lxd::container

Defines used to create/manage state of the containers.  
Params are:
 * `state` - Can either be `started` or `stopped`, defaults to `started`.
 * `ensure` - defaults to present,
 * `profiles` - list of profiles that will be used for the container.
 * `image` - image alias from which the container has to be created,
 * `config` - hash `{}` of config values,
 * `devices` - hash `{}` of devices,

For available config and devices options please please consult [LXD REST API docs](https://github.com/lxc/lxd/blob/master/doc/rest-api.md#10containers)

### lxd::profile

This define creates LXD profiles. It has the following parameters:
 * `ensure` - defaults to present,
 * `config` - config values for the profile,
 * `devices` - devices for the profile.

For the values that can be configuration or devices please consult [LXD REST API docs](https://github.com/lxc/lxd/blob/master/doc/rest-api.md#10profiles)

### lxd::image

This define is responsible for adding images to your LXD daemon. It is prepared to be used with simple flat file hosting of images in .tar.gz format.  
Just host your files in a directory on file server reachable through http(s) like:
`https://images.example.com/lxd-images/`

This define works by first downloading the image with wget to `/tmp` directory. Then it loads it into LXD with `lxd image import` command.

It does not allow fetching images from upstream image server at the moment.

This define has the following parameters:
 * `repo_url` - repository server URL where you host your images. Example: `https://images.example.com/lxd-images/`.
 * `image_file` - image in the tar.gz format. Example: `myawesomeimage.tar.gz`.
 * `image_alias` - image alias. Example: `prod_image`.

### lxd::storage

This define configures LXD storage pools. It is similar to `lxd::profile` define in terms of usage. It has the following parameters:
 * `ensure` - defaults to present
 * `driver` - driver for storage backend for more information on available backends check LXD REST API docs.
 * `config` - config of the storage backend
 * `description` - human friendly description for the storage backend.

For the values that can be configuration or avaialbe drivers please consult [LXD REST API docs](https://github.com/lxc/lxd/blob/master/doc/rest-api.md#10storage-pools)

# Example usage:

```
class mymodule {
 
    class {'::lxd': }
 
    lxd::storage { 'default':
        driver => 'dir',
        config => {
            'source' => '/var/lib/lxd/storage-pools/default'
        }
    }
 
    lxd::profile { 'exampleprofile':
        ensure  => 'present',
        config  => {
            'environment.http_proxy' => '',
            'limits.memory' => '2GB',
        },
        devices => {
            'root' => {
                'path' => '/',
                'pool' => 'default',
                'type' => 'disk',
            },
            'eth0' => {
                'nictype' => 'bridged',
                'parent'  => 'br0',
                'type'    => 'nic',
            }
        }
    }
 
    lxd::image { 'ubuntu1804':
        ensure      => 'present',
        repo_url    => 'http://example.net/lxd-images/',
        image_file  => 'ubuntu1804.tar.gz',
        image_alias => 'ubuntu1804',
    }
 
    lxd::container { 'container01':
        state   => 'started',
        config  => {
            'user.somecustomconfig' => 'My awesome custom env variable',
        },
        profiles => ['exampleprofile'],
        image   => 'ubuntu1804',
        devices => {
            'data' => {
                'path'   => '/data',
                'source' => '/srv/data01',
                'type'   => 'disk',
            }
        }
    }
}
```

# Known limitations

For the moment known limitations of this module include:
* support for x86_64 container architecture only.

# Development

We welcome contributions through GitHub, bug reports and pull requests are welcome.

## Testing

If you develop new feature please write appropriate tests. To run tests you have to make a link in `spec/fixtures/modules`.
