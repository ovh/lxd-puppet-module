# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe 'lxd' do
    on_supported_os.each do | os, facts |
        context "on #{os}" do
            let(:facts) do
                facts
            end

            describe 'with ensure => present' do
                let(:params) do
                    {
                        'ensure' => 'present',
                        'lxd_auto_update_interval' => 0,
                    }
                end
                it do
                    is_expected.to contain_class('lxd::install').that_comes_before(
                        'Class[lxd::config]',
                    )
                end
                it do
                    is_expected.to contain_class('lxd::config')
                end

                describe 'with package install' do
                    let(:params) do
                        super().merge(
                            {
                                'provider' => 'package',
                            }
                        )
                    end
                    it do
                        is_expected.to contain_package('lxd').with(
                            'ensure' => 'present',
                            'install_options' => [],
                        )
                    end
                    it { is_expected.not_to contain_exec('install snap core') }
                    it { is_expected.not_to contain_exec('install lxd') }
                end
                describe 'with snap install' do
                    let(:params) do
                        super().merge(
                            {
                                'provider' => 'snap',
                            }
                        )
                    end

                    describe 'with manage_snapd => true' do
                        let(:params) do
                            super().merge({
                                'manage_snapd' => true,
                            })
                        end
                        it do
                            is_expected.to contain_package('snapd').with_ensure('present')
                        end
                    end

                    describe 'with manage_snapd => false' do
                        let(:params) do
                            super().merge({
                                'manage_snapd' => false,
                            })
                        end
                        it do
                            is_expected.not_to contain_package('snapd')
                        end
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

            describe 'with ensure => absent' do
                let(:params) do
                    {
                        'ensure' => 'absent',
                        'lxd_auto_update_interval' => 0,
                    }
                end
                it do
                    is_expected.to contain_class('lxd::install')
                end
                it do
                    is_expected.to contain_class('lxd::config').that_comes_before(
                        'Class[lxd::install]',
                    )
                end

                describe 'with package install' do
                    let(:params) do
                        super().merge(
                            {
                                'provider' => 'package',
                            }
                        )
                    end
                    it do
                        is_expected.to contain_package('lxd').with(
                            'ensure' => 'absent',
                            'install_options' => [],
                        )
                    end
                    it { is_expected.not_to contain_exec('install snap core') }
                    it { is_expected.not_to contain_exec('install lxd') }
                end
                describe 'with snap install' do
                    let(:params) do
                        super().merge(
                            {
                                'provider' => 'snap',
                            }
                        )
                    end

                    describe 'with manage_snapd => true' do
                        let(:params) do
                            super().merge({
                                'manage_snapd' => true,
                            })
                        end
                        it do
                            is_expected.to contain_package('snapd').with_ensure('absent')
                        end
                    end

                    describe 'with manage_snapd => false' do
                        let(:params) do
                            super().merge({
                                'manage_snapd' => false,
                            })
                        end
                        it do
                            is_expected.not_to contain_package('snapd')
                        end
                    end

                    it do
                        is_expected.to contain_exec('install snap core').with(
                            'path' => '/usr/bin:/bin',
                            'command' => '/usr/bin/snap install core',
                            'unless' => '/usr/bin/snap list core',
                        ).that_requires('Package[snapd]')
                    end
                    it do
                        is_expected.to contain_exec('remove lxd').with(
                            'path' => '/usr/bin:/bin',
                            'command' => '/usr/bin/snap remove lxd',
                            'unless' => '! /usr/bin/snap list lxd >/dev/null 2>&1',
                        )
                    end
                end
            end
        end
    end
end
