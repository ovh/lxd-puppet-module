# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe '::lxd' do

    let(:params) {{
        'lxd_auto_update_interval' => 0,
    }}

    it do
        is_expected.to contain_class('lxd::install').that_comes_before('lxd::config')
    end
    it do
        is_expected.to contain_class('lxd::config').that_comes_after('lxd::install')
    end

    context 'with install from deb package' do
        let(:params) do
            super().merge({
                'provider' => 'deb',
            })
        end
        # Test packages which should be installed
        it { is_expected.to contain_package('lxd').with_ensure('present')}
    end

    context 'with install from snap' do
        let(:params) do
            super().merge({
                'provider' => 'snap',
            })
        end
        it do
            is_expected.to contain_package('snapd').with_ensure('present')
        end
        it do
            is_expected.to contain_exec('install snap core').with(
                'path' => '/usr/bin:/bin',
                'command' => '/usr/bin/snap install core',
                'unless' => '/usr/bin/snap list core',
            ).that_requires('Package[snapd]')
        end
        it do
            is_expected.to contain_exec('install lxd').with(
                'path' => '/usr/bin:/bin',
                'command' => '/usr/bin/snap install lxd',
                'unless' => '/usr/bin/snap list lxd',
            ).that_requires('Exec[install snap core]')
        end
    end
end
