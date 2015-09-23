require 'cocoapods-core'

module CocoapodsDepend
  class Converter
    def self.dependency_to_ruby(dependency)
      base_code = "pod '#{dependency.name}'"
      requirement_code = dependency.requirement.to_s
      extrnal_code = dependency.external_source.to_s.gsub(/[{}]/, "").gsub(/["]/, "'")

      base_code += ", '#{requirement_code}'" unless requirement_code == ">= 0"
      base_code += ", #{dependency.head.to_s}" if dependency.head
      base_code += ", #{extrnal_code}" unless extrnal_code.empty?

      base_code
    end

    def self.target_dependencies_to_ruby(target_name, dependencies)
      target_code = "target '#{target_name}' do\n\n"

      dependencies.each do |dependency|
        target_code += "#{dependency_to_ruby(dependency)}\n"
      end

      target_code + "\nend"
    end

    def self.target_definition_to_ruby(target_definition)
      target_dependencies_to_ruby(target_definition.name, target_definition.dependencies)
    end
  end
end
