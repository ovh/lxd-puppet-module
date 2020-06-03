# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe "lxd::container", :type => 'define' do

    let(:title) { 'container01' }

    let(:params) {{
        'image'  => 'bionic'
    }}

    let(:pre_condition) {"
        Exec {
            path => '/usr/bin:/bin:/usr/sbin:/sbin',
        }

        lxd::image { 'bionic':
            repo_url    => 'http://somerepo.url/lxd-images',
            image_file  => 'bionicimage.tar.gz',
            image_alias => 'bionic',
        }
    "}

    context "ensure present" do
        it { is_expected.to compile }
        it {
            is_expected.to contain_lxd__container("container01")
            .that_requires("Lxd::Image[bionic]")
        }
    end

    context "ensure absent" do
        let(:params) { super().merge({ 'ensure' => 'absent' }) }
        it {
            is_expected.to contain_lxd__container("container01")
            .that_comes_before("Lxd::Image[bionic]")
        }
    end

end

