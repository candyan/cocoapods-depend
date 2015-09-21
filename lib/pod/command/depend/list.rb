module Pod
  class Command
    class Depend
      class List < Depend
        self.summary = "list dependencies"

        self.description = <<-DESC
          List all dependencies in working podfile
        DESC

        def self.options
          [
            ['--target=TARGET', 'list all dependencies in `TARGET`'],
          ].concat(super)
        end

        def initialize(argv)
          @target = argv.option('target')
          super
        end

        def run
          verify_podfile_exists!

          pod_file_path = Pathname.pwd + 'Podfile'
          target_definitions = Podfile.from_file(Pathname.pwd + 'Podfile').target_definitions
          if @target
            unless target_definitions.has_key?(@target)
              help! 'The target is not exist'
            else
              print_target_dependencies(target_definitions[@target])
            end
          else
            target_definitions.each do |name, definition|
              unless name == 'Pods'
                print_target_dependencies(definition)
              end
            end
          end
        end

        def print_target_dependencies(target_definition)
          UI.title "Target #{target_definition.name}" do
            target_definition.dependencies.each do |dependency|
              UI.puts "- #{dependency.to_s}"
            end
          end
          UI.puts "\n"
        end

      end
    end
  end
end
