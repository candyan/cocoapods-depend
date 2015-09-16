require 'cocoapods-depend/command/depend/add'
require 'cocoapods-depend/command/depend/remove'
require 'cocoapods-depend/command/depend/update'
require 'cocoapods-depend/command/depend/list'

module Pod
  class Command
    class Depend < Command
      self.abstract_command = true

      self.summary = "Manage podfile dependencies"
      self.default_subcommand = 'list'

    end
  end
end
