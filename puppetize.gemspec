require File.join(File.dirname(__FILE__), "lib/puppetize/version")

Gem::Specification.new do |spec|

  files = []
  dirs = %w{lib bin tpl}
  dirs.each do |dir|
    files += Dir["#{dir}/**/*"]
  end

  files << "README.md"
  files << "LICENSE"
  files << "CONTRIBUTORS"

  # Sort out dependencies:
  
  spec.add_dependency("trollop", ">= 2.0") 
 
  spec.name              = 'puppetize'
  spec.version           = '0.0.4'
  spec.executables       = 'puppetize'
  spec.date              = '2013-11-04'
  spec.summary           = "A puppet module generation tool"
  spec.description       = "Puppetize is a tool that can generate complete modules from systems"
  spec.authors           = ["Juan Breinlinger"]
  spec.email             = 'juan.brein@breins.net'
  spec.require_paths     = ['lib']
  spec.files             = files
  spec.homepage          = 'https://github.com/BreinsNet/puppetize'
  spec.license           = 'GPL v3'
  spec.rubyforge_project = "puppetize"
end
