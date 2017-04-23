require "rmenu/version"
require "logger"
require "rmenu/daemon"
require "rmenu/dmenu/wrapper"

module Rmenu
  LOGGER = Logger.new STDERR

  def self.run(config)
    Dmenu::Wrapper.new(config).run
  end
end
