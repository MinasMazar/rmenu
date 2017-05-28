require "rmenu/version"
require "logger"
require "yaml"
require "rmenu/monkey_patch"
require "rmenu/interactors"
require "rmenu/instance"
require "rmenu/daemon"

module Rmenu
  LOGGER = Logger.new STDERR
end
