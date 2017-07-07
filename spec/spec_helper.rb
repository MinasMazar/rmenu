require "bundler/setup"
require "helpers"
require "rmenu"
require "pry"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.add_setting :tmp_dir
  config.add_setting :history_file
  config.tmp_dir = File.expand_path(File.join("..", "..", "tmp"), __FILE__)
  config.history_file = File.expand_path(File.join(config.tmp_dir, "history.yml"))
end
