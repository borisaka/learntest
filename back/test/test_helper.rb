require 'securerandom'
require 'faker'
APP_ROOT = File.dirname(__dir__)
ENV['SECRET'] = SecureRandom.hex(32)
ENV['DATABASE_URL'] = 'sqlite:memory'


require_relative '../system/container'
require 'import'
Application.finalize!

require 'sequel'
Sequel.extension :migration
Sequel::Migrator.run(Application['db'], File.join(APP_ROOT,'db','migrations'))
Application['db'][:users].all
# require 'minitest/unit'
require 'minitest/autorun'
require 'mocha/mini_test'
