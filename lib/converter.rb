require 'cocoapods-core'

module CocoapodsDepend
  class Converter
    def self.dependency_to_ruby(dependency)
      base_code = "pod '#{dependency.name}'"

      requirement_code = dependency.requirement.to_s
      unless requirement_code == ">= 0"
        base_code += ", '#{requirement_code}'"
      end

      if dependency.head
        base_code += ", #{dependency.head.to_s}"
      end

      extrnal_code = dependency.external_source.to_s.gsub(/[{}]/, "").gsub(/["]/, "'")
      base_code + ", #{extrnal_code}"
    end

    def self.target_definition_to_ruby(target_definition)
      target_code = "target \"#{target_definition.name}\" do\n\n"

      target_definition.dependencies.each do |dependency|
        target_code += "#{dependency_to_ruby(dependency)}\n"
      end

      target_code + "\nend"
    end
  end
end
