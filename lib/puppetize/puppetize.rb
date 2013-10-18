
module Puppetize

  class Controler

    def initialize

      # Check distribution dependency
      puts "\nSorry, Distribution not supported, only redhat based at the moment \n\n" unless File.exist?('/etc/redhat-release') 

      # Create config dir if it doesn't exists:
      @config_dir = File.join(File.expand_path('~'),'.puppetize')
      FileUtils.mkdir @config_dir if Dir.glob(@config_dir).empty?

    end

    def init

      rpm_list = %x[rpm -qa]
      File.write(File.join(@config_dir,'rpmlist.db'), rpm_list)

    end


    def build

      puts "build"

    end

    def reset

      puts "reset"

    end

  end

end

