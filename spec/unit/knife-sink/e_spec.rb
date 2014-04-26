# -*- coding: UTF-8 -*-
require 'spec_helper'

describe Knife::Sink::E do
  describe '::SinkException' do
    subject { Knife::Sink::E::SinkErr }

    it { should < StandardError }
  end

  describe '::InvalidOption' do
    subject { Knife::Sink::E::InvalidOpt }

    it { should < Knife::Sink::E::SinkErr }
  end
end
