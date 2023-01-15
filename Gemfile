source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"
gem "rails", "~> 7.0.4"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "will_paginate", "~> 3.3"
gem "enumerate_it", "~> 3.2"
gem "jbuilder", "~> 2.11"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "byebug"
  gem "factory_bot_rails"
end

group :test do
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
end
