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

require 'chef-dk/command/base'
require 'chef-dk/command/ui'
require 'chef-dk/policyfile_services/push'

module ChefDK
  module Command

    class Push < Base

      banner(<<-E)
Usage: chef push POLICY_GROUP [ POLICY_FILE ] [options]

`chef push` Uploads an existing Policyfile.lock.json to a Chef Server, along
with all the cookbooks contained in the policy lock. The policy lock is applied
to a specific POLICY_GROUP, which is a set of nodes that share the same
run_list and cookbooks.

The Policyfile feature is incomplete and beta quality. See our detailed README
for more information.

https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

Options:

E

      option :config_file,
        short:       "-c CONFIG_FILE",
        long:        "--config CONFIG_FILE",
        description: "Path to configuration file"

      option :debug,
        short:       "-D",
        long:        "--debug",
        description: "Enable stacktraces and other debug output",
        default:     false

      attr_reader :policyfile_relative_path
      attr_reader :policy_group

      attr_writer :ui

      def initialize(*args)
        super
        @push = nil
        @ui = nil
        @policy_group = nil
        @policyfile_relative_path = nil
        @chef_config = nil
      end

      def ui
        @ui ||= UI.new
      end

      def run(params = [])
        remaining_args = parse_options(params)
        if remaining_args.size < 1 or remaining_args.size > 2
          err(banner)
          return 1
        else
          @policy_group = remaining_args[0]
          @policyfile_relative_path = remaining_args[1]
        end
        push.run
        0
      rescue PolicyfileServiceError => e
        handle_error(e)
        1
      end

      def chef_config
        return @chef_config if @chef_config
        Chef::WorkstationConfigLoader.new(config[:config_file]).load
        @chef_config = Chef::Config
      end

      def push
        @push ||= PolicyfileServices::Push.new(policyfile: policyfile_relative_path,
                                               ui: ui,
                                               policy_group: policy_group,
                                               config: chef_config,
                                               root_dir: Dir.pwd)
      end

      def handle_error(error)
        err("Error: #{error.message}")
        if error.respond_to?(:cause) && error.cause
          cause = error.cause
          err("Reason: #{cause.class.name}")
          err("")
          err(cause.message)
          err(cause.backtrace.join("\n")) if config[:debug]
        end
      end

    end
  end
end

