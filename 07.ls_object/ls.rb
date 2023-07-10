# frozen_string_literal: true

require 'optparse'
require_relative 'outputter'

options = ARGV.getopts('a', 'r', 'l')
file_names = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
file_names = file_names.reverse if options['r']
outputter = Outputter.new(file_names)
options['l'] ? outputter.long_option_output : outputter.output
