# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe '::lxd' do

    let(:params) {{
        'lxd_auto_update_interval' => 0,
    }}
    # Test packages which should be installed
    it { is_expected.to contain_package('lxd').with_ensure('present')}
end
