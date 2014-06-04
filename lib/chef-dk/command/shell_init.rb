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
require 'mixlib/shellout'

module ChefDK
  module Command
    class ShellInit < ChefDK::Command::Base
      banner(<<-HELP)
Usage: chef shell-init

`chef shell-init` modifies your shell environment to make ChefDK your default
ruby.

  To enable for just the current shell session:

    eval "$(chef shell-init SHELL_NAME)"

  To permanently enable:

    echo 'eval "$(chef shell-init SHELL_NAME)"' >> ~/.YOUR_SHELL_RC_FILE

OPTIONS:

HELP

      option :omnibus_dir,
        :long         => "--omnibus-dir OMNIBUS_DIR",
        :description  => "Alternate path to omnibus install (used for testing)"

      def omnibus_root
        config[:omnibus_dir] || super
      end

      def run(argv)
        # Currently we don't have any shell-specific features, so we ignore the
        # shell name. We'll need it if we add completion.
        _shell_name = parse_options(argv)

        env = omnibus_env.dup
        path = env.delete("PATH")
        msg("export PATH=#{path}")
        env.each do |var_name, value|
          msg("export #{var_name}=#{value}")
        end
        0
      end
    end
  end
end


