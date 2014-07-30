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

require 'rubygems'
require 'rspec/mocks'
require 'test_helpers'

RSpec.configure do |c|
  c.include ChefDK
  c.include TestHelpers

  c.after(:all) { clear_tempdir }

  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true

  c.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
end
