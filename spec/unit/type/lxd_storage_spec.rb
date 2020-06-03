# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
# Copyright 2020 The LXD Puppet module Authors. All rights reserved.

require 'spec_helper'

describe Puppet::Type.type(:lxd_storage), 'when validating attributes' do
 [:name].each do |param|
    it "should have a #{param} parameter" do
      expect(Puppet::Type.type(:lxd_storage).attrtype(param)).to eq(:param)
    end
  end 
  
  [:ensure, :config, :driver].each do |prop|
    it "should have a #{prop} property" do
      expect(Puppet::Type.type(:lxd_storage).attrtype(prop)).to eq(:property)
    end
  end
  describe 'driver' do
    it 'checks if driver has some sane values' do
      expect(
        described_class.new(
          name:    'some',
          driver: 'dir',
          description: 'Some desc',
          config: {},
        )[:driver]
      ).to include('dir')
    end
  end
end
