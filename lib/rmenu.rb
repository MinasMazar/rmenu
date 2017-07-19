require "rmenu/version"
require "logger"
require "yaml"
require "rmenu/monkey_patch"
require "rmenu/interactors"
require "rmenu/instance"
require "rmenu/daemon"

module Rmenu
  LOGGER = Logger.new STDERR

  def self.load_source(filename, binding)
    require filename
    LOGGER.debug "Successfully loaded source file at #{filename}"
  rescue LoadError
    LOGGER.debug "Failed loading source file at #{filename}: #{$!.message}"
  end
end
