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
            'log'  => {
                'path'   => '/var/log/',
                'source' => '/srv/log01',
                'type'   => 'disk',
            },
            'bluestore' => {
                'path'   => '/dev/bluestore',
                'source' => '/dev/sdb1',
                'type'   => 'unix-block',
            }
        }
    }
}
