require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end

SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'oh_my_embed'
