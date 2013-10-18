#!/usr/bin/env ruby

require 'trollop'

module Puppetize

  class CommandLine

    SUB_COMMANDS = %w(init build reset)

    def initialize(usage_msg = nil)


      opts = Trollop::options do
        version "puppetize 0.0.1 (c) 2013 Breinlinger Juan Paulo"
        banner <<-EOS

Puppetize is a tool to automate puppet module development

Usage:
       puppetize <subcommand> [options] 

where <subcommands> are:

  init              Initialize the environment
  build             Build the puppet module
  reset             Reset the inital state

And [options] are:

        EOS


        #opt :ignore, "Ignore incorrect values"
        #opt :file, "Extra data filename to read in, with a very long option description like this one", :type => String
        #opt :volume, "Volume level", :default => 3.0
        #opt :iters, "Number of iterations", :default => 5
      end


      cmd = ARGV.shift # get the subcommand
      cmd_opts = case cmd
                 when "init"
                   Puppetize::Controler.new.init
                 when "build"
                   Puppetize::Controler.new.build
                 when "reset"
                   Puppetize::Controler.new.reset
                 else
                   Trollop::die "Unknown subcommand #{cmd.inspect}"
                 end      

    end

  end

end

