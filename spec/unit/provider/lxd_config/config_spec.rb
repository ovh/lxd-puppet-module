# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe Puppet::Type.type(:lxd_config).provider(:config) do

    before(:each) do
        @resource = Puppet::Type.type(:lxd_config).new(
            {
                :ensure      => 'present',
                :config_name => 'global_images.auto_update_interval',
                :config      => ['images.auto_update_interval'],
                :value       => 0,
            }
        )
        @provider = described_class.new(@resource)
    end

    context 'without lxc config' do
        before :each do
            described_class.expects(:lxc).with(["config", "get", "images.auto_update_interval"]).returns("\n")
        end
        it 'will check for appropriate config' do
            expect(@provider.exists?).to be false
        end
    end
    context 'with lxc config' do
        before :each do
            described_class.expects(:lxc).with(["config", "get", "images.auto_update_interval"]).returns("0")
        end
        it 'will check for appropriate config' do
            expect(@provider.exists?).to be true
        end
    end
    context 'with setting lxc config' do
        before :each do
            described_class.expects(:lxc).with(["config", "get", "images.auto_update_interval"]).returns("\n")
            described_class.expects(:lxc).with(["config", "set", "images.auto_update_interval", 0]).returns("")
        end
        it 'will create appropriate config' do
            expect(@provider.exists?).to be false
            expect(@provider.create).to be true
        end
    end
end
