module Pod
  class Command
    class Depend < Command
      self.abstract_command = true

      require 'pod/command/depend/add'
      require 'pod/command/depend/remove'
      require 'pod/command/depend/update'
      require 'pod/command/depend/list'

      self.summary = 'Manage Podfile dependencies'
      self.default_subcommand = 'list'

    end
  end
end
