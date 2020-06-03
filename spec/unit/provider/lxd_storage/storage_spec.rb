# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe Puppet::Type.type(:lxd_storage).provider(:storage) do

  context 'with ensure present' do
    before(:each) do
        @resource = Puppet::Type.type(:lxd_storage).new(
            {
                :ensure      => 'present',
                :name        => 'somestorage',
                :driver      => 'dir',
                :description => 'desc',
                :config      => { "source" => "/tmp/somestoragepool" },
            }
        )
        @provider = described_class.new(@resource)
    end

    context 'without storage-pools' do
        before :each do
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'GET', '/1.0/storage-pools']).returns('{}')
        end
        it 'will check if storage exists' do
            expect(@provider.exists?).to be false
        end
    end
    context 'with storage-pools' do
        before :each do
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'GET', '/1.0/storage-pools']).returns(
                '[ "/1.0/storage-pools/somestorage" ]'
            )
        end
        it 'will check for appropriate output' do
            expect(@provider.exists?).to be true
        end
    end
    context 'with creating storage' do
        before :each do
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'GET', '/1.0/storage-pools']).returns('{}')
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'POST', '-d', '{"name":"somestorage","driver":"dir","description":"desc","config":{"source":"/tmp/somestoragepool"}}', '/1.0/storage-pools']).returns('{}')
        end
        it 'will create appropriate config' do
            expect(@provider.exists?).to be false
            expect(@provider.create).to eq({})
        end
    end
  end

  context 'with ensure absent' do
    before(:each) do
        @resource = Puppet::Type.type(:lxd_storage).new(
            {
                :ensure      => 'absent',
                :name        => 'somestorage',
                :driver      => 'dir',
                :description => 'desc',
                :config      => { "source" => "/tmp/somestoragepool" },
            }
        )
        @provider = described_class.new(@resource)
    end

    context 'with creating storage' do
        before :each do
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'GET', '/1.0/storage-pools']).returns('["/1.0/storage-pools/somestorage"]')
            described_class.expects(:lxc).with(['query', '--wait', '-X', 'DELETE', '/1.0/storage-pools/somestorage']).returns('{}')
        end
        it 'will create appropriate config' do
            expect(@provider.exists?).to be true
            expect(@provider.destroy).to eq({})
        end
    end
  end
end
