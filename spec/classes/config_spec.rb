# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe '::lxd::config' do

    let(:pre_condition) {"
        class {'lxd': }
    "}


    # it should compile
    it { is_expected.to compile}
    it { is_expected.to contain_lxd_config('global_images.auto_update_interval').with(
        'ensure' => 'present',
        'value'  => 0,
    )}
    it { is_expected.to contain_lxd_config('global_core.https_address').with(
        'ensure' => 'absent',
    )}
    it { is_expected.to contain_lxd_config('global_core.trust_password').with(
        'ensure' => 'absent',
    )}
end

