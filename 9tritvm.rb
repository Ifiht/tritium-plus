require 'fox16'
require './window.rb'
require './cpu.rb'

$data_mem = "".rjust(10, '0')


def runApp
  # Make application
  application = FXApp.new("DirList", "FoxTest")

  # Make window
  EightBitVM.new(application)

  # Create app
  application.create

  # Run
  application.run
end

t = Thread.new {runApp}
t.join