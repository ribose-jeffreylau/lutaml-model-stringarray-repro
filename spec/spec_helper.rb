# frozen_string_literal: true

require "bundler/setup"
require "rspec-command"
require "fileutils"
require "lutaml/model"

Dir["./spec/support/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Catch exit / abort calls in RSpec
  # @see https://github.com/rspec/rspec-core/issues/2508#issuecomment-541074954
  config.around(:each) do |example|
    example.run
  rescue SystemExit => e
    warn "\e[1;31mwarning:\e[m Caught SystemExit inside RSpec (exit status: #{e.status})"
    warn "\e[1;31m<backtrace>\e[m"
    e.backtrace.each { |line| warn "\e[2;31m   #{line}\e[m" }
    warn "\e[1;31m</backtrace>\e[m"
  end
end
