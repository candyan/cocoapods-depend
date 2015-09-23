module Pod
  class Command
    class Depend
      class Remove < Depend
        self.summary = "Remove podspec dependency"
        self.description = <<-DESC
              Remove a podspec dependency at all targets or a target in working Podfile.

              Examples:

                  $ pod depend remove AFNetworking
                  $ pod depend remove AFNetworking --target=AppleWatch
        DESC

        self.arguments = [
          CLAide::Argument.new('NAME', true),
        ]

        def self.options
          [
            ['--target=TARGET', 'The target where you want to remove the dependency.'],
          ].concat(super)
        end

        def initialize(argv)
          @target = argv.option('target')
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          help! 'A Pod name is required.' unless @name
        end

        require 'converter'
        def run
          verify_podfile_exists!

          podfile_path = Pathname.pwd + 'Podfile'
          podfile = Podfile.from_file(podfile_path)
          contents ||= File.open(podfile_path, 'r:utf-8') { |f| f.read }

          podfile.target_definitions.each do |name, definition|
            if name != "Pods" && (@target == nil || @target == name)
              newTargetDependencies = definition.dependencies.delete_if { |d| d.name == @name }
              newTargetContents = CocoapodsDepend::Converter.target_dependencies_to_ruby(definition.name, newTargetDependencies)
              contents = contents.gsub(/^target\s[\"|']#{name}[\"|'].+?end\n[\n]?/m, (newTargetContents + "\n\n"))
            end
          end
          podfile_path.open('w') { |f| f << contents}
        end
      end
    end
  end
end
