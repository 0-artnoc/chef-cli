#
# Copyright:: Copyright (c) 2014 Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef-dk/exceptions'
require 'chef-dk/policyfile_compiler'
require 'chef-dk/policyfile/storage_config'
require 'chef-dk/policyfile_lock'

module ChefDK
  module PolicyfileServices

    class Install

      attr_reader :root_dir
      attr_reader :ui

      def initialize(policyfile: nil, ui: nil, root_dir: nil)
        @policyfile_relative_path = policyfile
        @ui = ui
        @root_dir = root_dir

        @policyfile_content = nil
        @policyfile_compiler = nil
      end

      def run
        unless File.exist?(policyfile_path)
          # TODO: suggest next step. Add a generator/init command? Specify path to Policyfile.rb?
          raise PolicyfileNotFound, "Policyfile not found at path #{policyfile_path}"
        end

        if File.exist?(lockfile_path)
          install_from_lock
        else
          generate_lock_and_install
        end
      end

      def policyfile_relative_path
        @policyfile_relative_path || "Policyfile.rb"
      end

      def policyfile_path
        File.expand_path(policyfile_relative_path, root_dir)
      end

      def lockfile_relative_path
        policyfile_relative_path.gsub(/\.rb\Z/, '') + ".lock.json"
      end

      def lockfile_path
        File.expand_path(lockfile_relative_path, root_dir)
      end

      def policyfile_content
        @policyfile_content ||= IO.read(policyfile_path)
      end

      def policyfile_compiler
        @policyfile_compiler ||= ChefDK::PolicyfileCompiler.evaluate(policyfile_content, policyfile_path)
      end

      def expanded_run_list
        policyfile_compiler.expanded_run_list.to_s
      end

      def policyfile_lock_content
        @policyfile_lock_content ||= IO.read(lockfile_path) if File.exist?(lockfile_path)
      end

      def policyfile_lock
        return nil if policyfile_lock_content.nil?
        @policyfile_lock ||= begin
          lock_data = FFI_Yajl::Parser.new.parse(policyfile_lock_content)
          PolicyfileLock.new(storage_config).build_from_lock_data(lock_data)
        end
      end

      def storage_config
        # TODO: prefer to use #use_policyfile_lock method?
        @storage_config ||= Policyfile::StorageConfig.new(relative_paths_root: root_dir)
      end

      def generate_lock_and_install
        policyfile_compiler.error!

        ui.msg "Expanded run list: " + expanded_run_list + "\n"

        policyfile_compiler.graph_solution.sort.each do |name, version|
          ui.msg "Using #{name} #{version}"
        end

        ui.msg "Caching Cookbooks"
        policyfile_compiler.install

        lock_data = policyfile_compiler.lock.to_lock

        File.open(lockfile_path, "w+") do |f|
          f.print(FFI_Yajl::Encoder.encode(lock_data, pretty: true ))
        end

        ui.msg ""

        ui.msg "Lockfile written to #{lockfile_path}"
      rescue => error
        raise PolicyfileInstallError.new("Failed to generate Policyfile.lock", error)
      end

      def install_from_lock
        ui.msg "Installing cookbooks from lock"

        policyfile_lock.cookbook_locks.each do |name, lock_info|
          ui.msg "Using #{name} #{lock_info.version}"
        end

        policyfile_lock.install_cookbooks
      rescue => error
        raise PolicyfileInstallError.new("Failed to install cookbooks from lockfile", error)
      end

    end
  end
end
