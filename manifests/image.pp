## Manage lxd images
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

define lxd::image(
    $repo_url,
    $image_file,
    $image_alias,
    $ensure = 'present',
) {
    validate_re($repo_url, "[^;']+")
    validate_re($image_file, "[^;']+")
    validate_re($image_alias, "[^;']+")

    case $ensure {
        'present': {
            # unfortunately no way to import image from stdin
            exec { "lxd image present ${repo_url}/${image_file}":
                command => "rm -f /tmp/puppet-download-lxd-image && wget -qO - '${repo_url}/${image_file}' > /tmp/puppet-download-lxd-image && lxc image import /tmp/puppet-download-lxd-image --alias '${image_alias}' && rm -f /tmp/puppet-download-lxd-image",  # lint:ignore:140chars
                unless  => "lxc image ls -cl --format csv | grep '^${image_alias}$'",
                timeout => 600,
            }
        }

        'absent': {
            exec { "lxd image absent ${repo_url}/${image_file}":
                command => "lxc image rm '${image_alias}'",
                onlyif  => "lxc image ls -cl --format csv | grep '^${image_alias}$'",
                timeout => 600,
            }
        }

        default: {
            fail("Wrong ensure value: ${ensure}")
        }
    }
}
