# -*- coding: UTF-8 -*-
require 'spec_helper'

describe Knife::Sink do
  describe '::VERSION' do
    subject { Knife::Sink::VERSION }

    it { should be_an_instance_of String }

    it 'should look like a valid version' do
      expect(/^\d+\.\d+\.\d+$/.match(subject)).to_not be_nil
    end
  end

  describe '::MAJOR' do
    subject { Knife::Sink::MAJOR }

    it { should be_an_instance_of String }

    it 'should be a digit' do
      expect(/^\d+$/.match(subject)).to_not be_nil
    end
  end

  describe '::MINOR' do
    subject { Knife::Sink::MINOR }

    it { should be_an_instance_of String }

    it 'should be a digit' do
      expect(/^\d+$/.match(subject)).to_not be_nil
    end
  end

  describe '::REVISION' do
    subject { Knife::Sink::REVISION }

    it { should be_an_instance_of String }

    it 'should be a digit' do
      expect(/^\d+$/.match(subject)).to_not be_nil
    end
  end
end
