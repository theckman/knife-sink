# -*- coding: UTF-8 -*-
require 'spec_helper'

describe Knife::Sink::Librarians::Berkshelf3 do
  before(:each) { @pwd = Dir.pwd }
  let(:berkshelf3) { Knife::Sink::Librarians::Berkshelf3.new }

  describe '::DEFAULT_VENDOR_PATH' do
    subject { Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH }

    it { should be_an_instance_of String }

    it { should eql "#{@pwd}/vendor" }
  end

  describe '::DEFAULT_BERKSFILE_PATH' do
    subject { Knife::Sink::Librarians::Berkshelf3::DEFAULT_BERKSFILE_PATH }

    it { should be_an_instance_of String }

    it { should eql "#{@pwd}/Berksfile" }
  end

  describe '.load_opts' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.send(:load_opts, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.send(:load_opts)
        end.to raise_error ArgumentError
      end
    end

    context 'when not given a hash' do
      it 'should raise NoMethodError' do
        expect do
          berkshelf3.send(:load_opts, nil)
        end.to raise_error NoMethodError
      end
    end

    context 'when given an option hash that has the ui key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@ui)
      end

      it 'should unset @ui in the before do block' do
        expect(berkshelf3.instance_variable_get(:@ui)).to be_nil
      end

      it 'should set @ui to the ui class from the options' do
        berkshelf3.send(:load_opts, ui: 'TestString')
        expect(berkshelf3.instance_variable_get(:@ui)).to eql 'TestString'
      end
    end

    context 'when given an option hash that has no ui key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@ui)
      end

      it 'should unset @ui in the before do block' do
        expect(berkshelf3.instance_variable_get(:@ui)).to be_nil
      end

      it 'should set @ui to a generic Chef::Knife:UI obj' do
        berkshelf3.send(:load_opts, {})
        expect(berkshelf3.instance_variable_get(:@ui))
          .to be_an_instance_of Chef::Knife::UI
      end
    end

    context 'when given an option hash with a vendor_path key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@vendor_path)
      end

      it 'should unset @vendor_path in the before do block' do
        expect(berkshelf3.instance_variable_get(:@vendor_path)).to be_nil
      end

      it 'should set @vendor_path based on the one in options' do
        berkshelf3.send(:load_opts, vendor_path: '/dev/null')
        expect(berkshelf3.instance_variable_get(:@vendor_path))
          .to eql '/dev/null'
      end
    end

    context 'when given an option hash without a vendor_path key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@vendor_path)
      end

      it 'should unset @vendor_path in the before do block' do
        expect(berkshelf3.instance_variable_get(:@vendor_path)).to be_nil
      end

      it 'should set @vendor_path to the default value' do
        berkshelf3.send(:load_opts, {})
        expect(berkshelf3.instance_variable_get(:@vendor_path))
          .to eql Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH
      end
    end

    context 'when given an option hash with a berksfile_path key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@berksfile_path)
      end

      it 'should unset @berksfile_path in the before do block' do
        expect(berkshelf3.instance_variable_get(:@berksfile_path)).to be_nil
      end

      it 'should set @berksfile_path to the one in options' do
        berkshelf3.send(:load_opts, berksfile_path: '/dev/null')
        expect(berkshelf3.instance_variable_get(:@berksfile_path))
          .to eql '/dev/null'
      end
    end

    context 'when given an option hash without a berksfile_path key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@berksfile_path)
      end

      it 'should unset @berksfile_path in the before do block' do
        expect(berkshelf3.instance_variable_get(:@berksfile_path)).to be_nil
      end

      it 'should set @berksfile_path to the default path' do
        berkshelf3.send(:load_opts, {})
        expect(berkshelf3.instance_variable_get(:@berksfile_path))
          .to eql Knife::Sink::Librarians::Berkshelf3::DEFAULT_BERKSFILE_PATH
      end
    end

    context 'when given an option hash with a debug key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@debug)
      end

      it 'should unset @debug in the before do block' do
        expect(berkshelf3.instance_variable_get(:@debug)).to be_nil
      end

      it 'should set @debug to the one in options' do
        expect(berkshelf3.instance_variable_get(:@debug))
        berkshelf3.send(:load_opts, debug: true)
        expect(berkshelf3.instance_variable_get(:@debug))
          .to be_truthy
      end
    end

    context 'when given an option hash without a debug key' do
      before do
        berkshelf3.send(:remove_instance_variable, :@debug)
      end

      it 'should unset @debug in the before do block' do
        expect(berkshelf3.instance_variable_get(:@debug)).to be_nil
      end

      it 'should set @debug to false' do
        berkshelf3.send(:load_opts, {})
        expect(berkshelf3.instance_variable_get(:@debug)).to be_falsey
      end
    end
  end

  describe '.load_deps' do
    context 'when given more than zero args' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.send(:load_deps, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given no args' do
      it 'should explicitly load the correct dependencies' do
        expect(berkshelf3).to receive(:require).with('fileutils')
        expect(berkshelf3).to receive(:require).with('berkshelf')
        expect(berkshelf3).to receive(:require).with('chef/knife')
        expect(berkshelf3).not_to receive(:require).with(any_args)

        berkshelf3.send(:load_deps)
      end
    end
  end

  describe '.rm_vendor' do
    context 'when given more than zero args' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.send(:rm_vendor, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when not debug' do
      before do
        @chef_ui = Chef::Knife.ui
        allow_any_instance_of(Chef::Knife::UI).to receive(:color)
          .and_return('thing1')
        allow_any_instance_of(Chef::Knife::UI).to receive(:msg)
          .and_return(nil)
        allow(FileUtils).to receive(:rm_rf).and_return(nil)
      end

      let(:berkshelf3) do
        Knife::Sink::Librarians::Berkshelf3.new(ui: @chef_ui)
      end

      it 'should not trigger a ui.msg() call' do
        expect(berkshelf3).to_not receive(:msg)
        berkshelf3.send(:rm_vendor)
      end

      it 'should not trigger a ui.color() call' do
        expect(berkshelf3).to_not receive(:color)
        berkshelf3.send(:rm_vendor)
      end

      it 'should have a FileUtils.rm_rf() call' do
        path = Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH
        expect(FileUtils).to receive(:rm_rf).with(path)
        berkshelf3.send(:rm_vendor)
      end
    end

    context 'when debug' do
      before do
        @chef_ui = Chef::Knife.ui
        allow_any_instance_of(Chef::Knife::UI).to receive(:color)
          .and_return('thing2')
        allow_any_instance_of(Chef::Knife::UI).to receive(:msg)
          .and_return(nil)
        allow(FileUtils).to receive(:rm_rf).and_return(nil)
      end

      let(:berkshelf3) do
        Knife::Sink::Librarians::Berkshelf3.new(
          ui: @chef_ui,
          debug: true
        )
      end

      it 'should trigger a ui.msg() call' do
        expect(@chef_ui).to receive(:msg).with('thing2')
        berkshelf3.send(:rm_vendor)
      end

      it 'should have a ui.color() call' do
        path = Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH
        expect(@chef_ui).to receive(:color).with(
          "removing #{path}", :bold, :blue
        )
        berkshelf3.send(:rm_vendor)
      end

      it 'should have a FileUtils.rm_rf() call' do
        path = Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH
        expect(FileUtils).to receive(:rm_rf).with(path)
        berkshelf3.send(:rm_vendor)
      end
    end
  end

  describe '.vendor' do
    context 'when given more than zero args' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.send(:vendor, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when not debug' do
      before do
        @chef_ui = Chef::Knife.ui
        @berksfile = double('berksfile')
        allow(@chef_ui).to receive(:color).and_return(nil)
        allow(@chef_ui).to receive(:msg).and_return('thing1')
        allow(@berksfile).to receive(:vendor).and_return(nil)
        allow(Berkshelf::Berksfile).to receive(:from_file)
          .and_return(@berksfile)
      end

      let(:berkshelf3) do
        Knife::Sink::Librarians::Berkshelf3.new(ui: @chef_ui)
      end

      it 'should not have a ui.color() call' do
        expect(@chef_ui).to_not receive(:color)
        berkshelf3.send(:vendor)
      end

      it 'should not have a ui.msg() call' do
        expect(@chef_ui).to_not receive(:msg)
        berkshelf3.send(:vendor)
      end

      it 'should instantiate a Berksfile object' do
        expect(Berkshelf::Berksfile).to receive(:from_file).with(
          Knife::Sink::Librarians::Berkshelf3::DEFAULT_BERKSFILE_PATH
        )
        berkshelf3.send(:vendor)
      end

      it 'should call .vendor on Berkshelf::Berksfile' do
        expect(@berksfile).to receive(:vendor)
          .with(Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH)
        berkshelf3.send(:vendor)
      end
    end

    context 'when debug' do
      before do
        @chef_ui = Chef::Knife.ui
        @berksfile = double('berksfile')
        allow(@chef_ui).to receive(:color).and_return('thing2')
        allow(@chef_ui).to receive(:msg).and_return(nil)
        allow(@berksfile).to receive(:vendor).and_return(nil)
        allow(Berkshelf::Berksfile).to receive(:from_file)
          .and_return(@berksfile)
      end

      let(:berkshelf3) do
        Knife::Sink::Librarians::Berkshelf3.new(ui: @chef_ui, debug: true)
      end

      it 'should have a ui.color() call' do
        path = Knife::Sink::Librarians::Berkshelf3::DEFAULT_BERKSFILE_PATH
        expect(@chef_ui).to receive(:color).with("using '#{path}'", :yellow)
        berkshelf3.send(:vendor)
      end

      it 'should have a ui.msg() call' do
        expect(@chef_ui).to receive(:msg).with('thing2')
        berkshelf3.send(:vendor)
      end

      it 'should instantiate a Berksfile object' do
        expect(Berkshelf::Berksfile).to receive(:from_file).with(
          Knife::Sink::Librarians::Berkshelf3::DEFAULT_BERKSFILE_PATH
        )
        berkshelf3.send(:vendor)
      end

      it 'should call .vendor on Berkshelf::Berksfile' do
        expect(@berksfile).to receive(:vendor)
          .with(Knife::Sink::Librarians::Berkshelf3::DEFAULT_VENDOR_PATH)
        berkshelf3.send(:vendor)
      end
    end
  end

  describe '.run' do
    context 'when given more than zero args' do
      it 'should raise ArgumentError' do
        expect do
          berkshelf3.run(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when the vendor directory exists' do
      before do
        allow(File).to receive(:directory?).and_return(true)
        allow(berkshelf3).to receive(:rm_vendor).and_return(nil)
        allow(berkshelf3).to receive(:vendor).and_return(nil)
      end

      it 'should call .rm_vendor' do
        expect(berkshelf3).to receive(:rm_vendor)
        berkshelf3.run
      end

      it 'should call .vendor' do
        expect(berkshelf3).to receive(:vendor)
        berkshelf3.run
      end
    end

    context 'when the vendor directory does not exist' do
      before do
        allow(File).to receive(:directory?).and_return(false)
        allow(berkshelf3).to receive(:rm_vendor).and_return(nil)
        allow(berkshelf3).to receive(:vendor).and_return(nil)
      end

      it 'should not call .rm_vendor' do
        expect(berkshelf3).to_not receive(:rm_vendor)
        berkshelf3.run
      end

      it 'should call .vendor' do
        expect(berkshelf3).to receive(:vendor)
        berkshelf3.run
      end
    end
  end
end
