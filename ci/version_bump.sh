#!/bin/sh

set -evx

gem update --system $(grep rubygems omnibus_overrides.rb | cut -d'"' -f2)
gem install bundler -v $(grep bundler omnibus_overrides.rb | cut -d'"' -f2)
bundle install

bundle exec rake version:bump
