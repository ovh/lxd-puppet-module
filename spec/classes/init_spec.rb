# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe '::lxd' do

    let(:params) {{
        'lxd_auto_update_interval' => 0,
    }}

    describe 'when installed from deb package' do
      let(:params) do
        super().merge(
            {
              'lxd_package_provider' => 'deb',
            }
        )
      end
      # Test packages which should be installed
      it { is_expected.to contain_package('lxd').with_ensure('present')}
    end

    describe 'when installed via snap' do
      let(:params) do
        super().merge(
          {
            'lxd_package_provider' => 'snap',
          }
        )
      end
      context 'and $lxd::manage_snapd is true' do
        let(:params) do
          super().merge(
            {
              'manage_snapd' => true,
            }
          )
        end
        it { is_expected.not_to contain_package('lxd') }
        it { is_expected.to contain_package('snapd').with_ensure('present')}
        it { is_expected.to contain_exec('install lxd') }
      end
      context 'and $lxd::manage_snapd is false' do
        let(:params) do
          super().merge(
            {
              'manage_snapd' => false,
            }
          )
        end
        it { is_expected.not_to contain_package('lxd') }
        it { is_expected.not_to contain_package('snapd') }
        it { is_expected.to contain_exec('install lxd') }
      end
    end
end
