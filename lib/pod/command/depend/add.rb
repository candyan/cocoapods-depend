module Pod
  class Command
    class Depend
      class Add < Depend
        self.summary = "Add podspec dependency"
        self.description = <<-DESC
              Add a podspec dependency to all targets or a target in working Podfile.

              Examples:

                  $ pod depend add AFNetworking
                  $ pod depend add AFNetworking "~> 1.0.0"
                  $ pod depend add AFNetworking https://github.com/gowalla/AFNetworking.git --tag=1.0.0
                  $ pod depend add AFNetworking ~/Documents/AFNetworking
                  $ pod depend add JSONKit https://example.com/JSONKit.podspec
        DESC

        self.arguments = [
          CLAide::Argument.new('NAME', true),
          CLAide::Argument.new(%w(REQUIREMENT GIT-URL SPEC-URL LOCALPATH), false),
        ]

        def self.options
          [
            ['--tag=TAG', 'The git tag you want to depend'],
            ['--commit=COMMIT', 'The git commit you want to depend'],
            ['--branch=BRANCH', 'The git branch you want to depend'],
          ].concat(super)
        end

        def initialize(argv)
          @git_tag = argv.option('tag')
          @git_commit = argv.option('commit')
          @git_branch = argv.option('branch')
          @name = argv.shift_argument
          @source = argv.shift_argument
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

          dependency = Dependency.new(@name, self.requirements)

          podfile.target_definitions.each do |name, definition|
            unless name == "Pods"
              newTargetContents = CocoapodsDepend::Converter.target_dependencies_to_ruby(definition.name, definition.dependencies.push(dependency))
              contents = contents.gsub(/^target\s[\"|']#{name}[\"|'].+?end\n[\n]?/m, (newTargetContents + "\n\n"))
            end
          end
          podfile_path.open('w') { |f| f << contents}
        end

        def requirements
          if not @source
            requirements = nil
          elsif git_url?(@source)
            requirements = {:git => @source}
            requirements[:tag] = @git_tag if @git_tag
            requirements[:commit] = @git_commit if @git_commit
            requirements[:branch] = @git_branch if @git_branch
          elsif podspec_url?(@source)
            requirements = {:podspec => @source}
          elsif local_path?(@source)
            requirements = {:path => @source}
          else
            requirements = @source
          end
          requirements
        end

        def http_url?(name)
          prefixs = ['http://', 'https://']
          prefixs.any? { |prefix| name.start_with?(prefix) }
        end

        def git_url?(name)
          http_url?(name) && name.end_with?('.git')
        end

        def podspec_url?(name)
          http_url?(name) && name.end_with?('.podspec')
        end

        def local_path?(name)
          prefixs = ['/', '~/', './']
          prefixs.any? { |prefix| name.start_with?(prefix) }
        end

      end
    end
  end
end
