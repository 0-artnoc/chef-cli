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

require 'mixlib/cli'
require 'chef-dk/command/base'
require 'chef-dk/chef_runner'
require 'chef-dk/generator'

module ChefDK
  module Command
    module GeneratorCommands

      def self.build(class_name, params)
        const_get(class_name).new(params)
      end

      class Base < Command::Base

        attr_reader :params

        def initialize(params)
          super()
          @params = params
        end

        def chef_runner
          @chef_runner ||= ChefRunner.new(skeleton_cookbook_path, ["code_generator::#{recipe}"])
        end

        def skeleton_cookbook_path
          File.expand_path("../../skeletons", __FILE__)
        end

        def setup_context
        end

        def generator_context
          Generator.context
        end

      end

      # chef generate cookbook path/to/basename --skel=path/to/skeleton --example
      class Cookbook < Base

        banner "Usage: chef generate cookbook NAME [options]"

        attr_reader :errors

        attr_reader :cookbook_name_or_path

        def initialize(params)
          @params_valid = true
          @cookbook_name = nil
          super
        end

        def run
          read_and_validate_params
          if params_valid?
            setup_context
            chef_runner.converge
          else
            msg(banner)
            1
          end
        end

        def setup_context
          generator_context.root = cookbook_root
          generator_context.cookbook_name = cookbook_name
        end

        def recipe
          "cookbook"
        end

        def cookbook_name
          File.basename(cookbook_full_path)
        end

        def cookbook_root
          File.dirname(cookbook_full_path)
        end

        def cookbook_full_path
          File.expand_path(cookbook_name_or_path, Dir.pwd)
        end

        def read_and_validate_params
          arguments = parse_options(params)
          @cookbook_name_or_path = arguments[0]
          @params_valid = false unless @cookbook_name_or_path
        end

        def params_valid?
          @params_valid
        end

      end

      # chef generate recipe [path/to/cookbook/root] name
      class Recipe < Base

        banner "Usage: chef generate recipe [path/to/cookbook] NAME [options]"

        attr_reader :errors
        attr_reader :cookbook_path
        attr_reader :recipe_name

        def initialize(params)
          @params_valid = true
          @cookbook_full_path = nil
          @recipe_name = nil
          @errors = []
          super
        end

        def run
          read_and_validate_params
          if params_valid?
            setup_context
            chef_runner.converge
          else
            errors.each {|error| err("Error: #{error}") }
            msg(banner)
            1
          end
        end

        def setup_context
          generator_context.root = cookbook_root
          generator_context.cookbook_name = cookbook_name
          generator_context.recipe_name = recipe_name
        end

        def cookbook_root
          File.dirname(cookbook_path)
        end

        def cookbook_name
          File.basename(cookbook_path)
        end

        def recipe
          'recipe'
        end

        def read_and_validate_params
          arguments = parse_options(params)
          case arguments.size
          when 1
            @recipe_name = arguments[0]
            @cookbook_path = Dir.pwd
            validate_cookbook_path
          when 2
            @cookbook_path = arguments[0]
            @recipe_name = arguments[1]
          else
            @params_valid = false
          end
        end

        def validate_cookbook_path
          unless File.directory?(File.join(cookbook_path, "recipes"))
            @errors << "Directory #{cookbook_path} is not a cookbook"
            @params_valid = false
          end
        end

        def params_valid?
          @params_valid
        end
      end
    end
  end
end

