
module Puppetize

  class Controler

    def initialize

      # Check distribution dependency
      puts "\nSorry, Distribution not supported, only redhat based at the moment \n\n" unless File.exist?('/etc/redhat-release') 

      # Create config dir if it doesn't exists:
      @config_dir = File.join(File.expand_path('~'),'.puppetize')
      @module_dir = File.join(File.expand_path('~'),'puppetize-module')
      @rpm_db = File.join(@config_dir,'rpmlist.db')
      FileUtils.mkdir @config_dir if Dir.glob(@config_dir).empty?

    end

    def init

      rpm_list = cmd "rpm -qa"
      File.open(@rpm_db, 'w') {|f| f.write(rpm_list) }
      
    end

    def build

      # Verify necessary commands are installed:
      #

      commands = ['puppet','git']

      commands.each do |command|

        begin

          test = ENV['PATH'].split(':').map do |folder| 
            File.exists?(File.join(folder,command)) 
          end

          if ! test.include? true 
            puts "ERROR - #{command} is not installed or not available on default path"
            exit -1
          end

        rescue => e

          STDERR.puts "ERROR - #{e}"
          exit -1

        end

      end

      # Generate a standard empty module

      cmd "puppet module generate puppetize-module"
      

      #################################
      # Generate the Package resources:
     
      rpm_list = cmd("rpm -qa").split("\n")
      init_rpm_list = File.read(@rpm_db).split("\n")
      puppet_rpm_list = rpm_list - init_rpm_list 

      packagelist = []

      puppet_rpm_list.each do |rpm|
        name = cmd("rpm --query --qf %{NAME} #{rpm}")
        version = cmd("rpm --query --qf %{VERSION} #{rpm}")
        release = cmd("rpm --query --qf %{RELEASE} #{rpm}")
        packagelist << [name,version,release]
      end

      # Generate install.pp based on ERB template
      template = File.join(File.dirname(__FILE__), '..', '..', 'tpl', 'install.pp.erb')
      renderer = ERB.new(File.read(template))
      output = renderer.result(binding)
      File.open(File.join(@module_dir,'manifests','install.pp'),'w') {|f| f.write(output)}

      ######################################
      # Generate the configuration resources
      
    end

    def reset

      puts "reset"

    end

  end

end

