
module Puppetize

  class Controler

    def initialize

      # Check distribution dependency
      puts "\nSorry, Distribution not supported, only redhat based at the moment \n\n" unless File.exist?('/etc/redhat-release') 

      # Create config dir if it doesn't exists:
      @config_dir = File.join(File.expand_path('~'),'.puppetize')
      @module_dir = File.join(File.expand_path('~'),'puppetize-module')
      @rpm_db = File.join(@config_dir,'rpmlist.db')
      @trackdirs = [
        {
        :path => '/etc',
        :ignoredir => [
          'group',
          'gshadow',
          'ld.so.cache',
          'passwd',
          'shadow',
          'group-',
          'gshadow-',
          'passwd-',
          'shadow-',
          'rc.d'
          
      ]
      }
      ]

      FileUtils.mkdir @config_dir if Dir.glob(@config_dir).empty?

    end

    def init

      # Remember what RPMs are installed
      
      rpm_list = cmd "rpm -qa"
      File.open(@rpm_db, 'w') {|f| f.write(rpm_list) }

      # Track all the files in the filesystem
      #
      
      @trackdirs.each do |track|

        File.open(File.join(track[:path],".gitignore"),'w') do |f|
          f.write(track[:ignoredir].join("\n"))
        end

        Dir.chdir track[:path] do 

          cmd 'git init .'
          cmd 'git add .'
          cmd "git commit -am'puppetize: Initial Commit'"

        end

      end
      
    end

    def build


      # Verify necessary commands are installed:

      commands = ['puppet','git']

      commands.each do |command|

        begin

          test = ENV['PATH'].split(':').map do |folder| 
            File.exists?(File.join(folder,command)) 
          end

          if ! test.include? true 
            puts "ERROR - #{command} is not installed or not available on default path"
            exit 1
          end

        rescue => e

          STDERR.puts "ERROR - #{e}"
          exit 1

        end

      end
 
      ##################################
      # Generate a standard empty module

      cmd "puppet module generate puppetize-module"
      FileUtils.mkdir File.join(@module_dir,'files')
      FileUtils.mkdir File.join(@module_dir,'templates')

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
         
      puppet_files = Array.new
      
      @trackdirs.each do |track|

        Dir.chdir track[:path] do

          file_list = %x[git status --porcelain].split("\n").map {|f| f[3..-1]}

          flisttmp = []

          # If a file is a directory recurse inside as git does not provide that listing
          file_list.each do |file|
            if File.directory? file 
              Find.find(File.join(track[:path],file)) do |f|
                flisttmp << f.split(File.join(track[:path],''))[1] if File.file? f
              end
            end
          end

          # Merge both lists:
          file_list = (file_list + flisttmp).uniq

          # If the file does not belong to any package or has been modified then include it in the list

          file_list.each do |file|

            filename = File.join(track[:path],file)

            if not system "rpm -qf #{filename} > /dev/null 2>&1" 
              puppet_files << filename
              next
            end

            puppet_files << filename if system "rpm -Vf #{filename}|grep #{filename} > /dev/null 2>&1" and File.file? file

          end

        end

      end

      # Copy the files to the files directory:
      

      puppet_files.each do |file|

        FileUtils.cp file, File.join(@module_dir,'files')

      end

      puppet_file_list = Array.new

      puppet_files.each do |file|

        stat = File.stat file
        mode = stat.mode.to_s 8
        owner = Etc.getpwuid(stat.uid).name
        group = Etc.getgrgid(stat.gid).name

        puppet_file_list << {
          :path  => file,
          :owner => owner,
          :group => group,
          :mode  => mode,
          :name  => file.split('/').last,
        }

      end

      # Generate config.pp based on ERB template
      template = File.join(File.dirname(__FILE__), '..', '..', 'tpl', 'config.pp.erb')
      renderer = ERB.new(File.read(template))
      output = renderer.result(binding)
      File.open(File.join(@module_dir,'manifests','config.pp'),'w') {|f| f.write(output)}

    end

    def reset

      @trackdirs.each do |track|
        FileUtils.rm_rf File.join(track[:path],'.git') if File.exists? File.join(track[:path],'.git')
      end

      FileUtils.rm @rpm_db if File.exists? @rpm_db
      FileUtils.rm_rf 'puppetize-module' if File.exists? 'puppetize-module'

    end

  end

end

