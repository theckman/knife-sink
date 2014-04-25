# -*- coding: UTF-8 -*-
# Author:: Tim Heckman <t@heckman.io>
# Copyright:: Copyright (c) 2014 Tim Heckman
# License:: Apache License, Version 2.0
#
# Copyright 2014 Tim Heckman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Knife
  module Sink
    module Librarians
      # The class for vendoring via Berkshelf
      class Berkshelf3
        DEFAULT_VENDOR_PATH = File.join(Dir.pwd, 'vendor')
        DEFAULT_BERKSFILE_PATH = File.join(Dir.pwd, 'Berksfile')

        attr_accessor :vendor_path, :berksfile_path, :debug
        alias_method :debug?, :debug

        def initialize(opts = {})
          load_deps
          load_opts(opts)
        end

        def run
          rm_vendor if File.directory?(@vendo_path)
          vendor
        end

        private

        def load_deps
          require 'fileutils'
          require 'berkshelf'
          require 'chef/knife'
        end

        def load_opts(opts)
          @ui = opts[:ui] || Chef::Knife.ui
          @vendor_path = opts[:vendor_path] || DEFAULT_VENDOR_PATH
          @berksfile_path = opts[:berksfile_path] || DEFAULT_BERKSFILE_PATH
          @debug = opts[:debug] || false
        end

        def rm_vendor
          @ui.msg(@ui.color("removing #{@vendor_path}", :bold, :blue))
          FileUtils.rm_rf(@vendor_path)
        end

        def vendor
          @ui.msg(@ui.color("using '#{@berksfile_path}'", :yellow)) if debug?
          Berkshelf::Berksfile.from_file(@berksfile_path).vendor(@vendor_path)
        end
      end
    end
  end
end
