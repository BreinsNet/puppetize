
def cmd command, opts = { :out => false , :err => true } 

  retval = nil
  error = nil

  begin

    status = Open4.popen4(command) do |pid,stdin,stdout,stderr|

      error = stderr.read
      retval = stdout.read
      STDOUT.puts stdout if opts[:out] 

    end

  rescue => e

    STDERR.puts "Error: #{e} #{error}"
    exit -1

  ensure

    if status.exitstatus > 0

      STDERR.puts "#{error}" if opts[:err] 
      exit -1

    end

  end

  retval

end

