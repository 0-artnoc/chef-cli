#!/bin/sh

gem install bundler -v $(grep bundler omnibus_overrides.rb | cut -d'"' -f2)
bundle install
