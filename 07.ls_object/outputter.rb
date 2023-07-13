# frozen_string_literal: true

require_relative 'file_detail'

class Outputter
  COLUMNS = 3

  def initialize(file_names)
    @file_names = file_names
  end

  def output(long: false)
    long ? long_output : no_option_output
  end

  private

  def long_output
    puts "total #{total_blocks}"
    @file_names.each do |file_name|
      puts long_format(file_detail(file_name))
    end
  end

  def no_option_output
    formatted_names.each do |names|
      names.compact.each { |name| print name.ljust(30) }
      puts "\n"
    end
  end

  def file_detail(file_name)
    FileDetail.new(file_name)
  end

  def total_blocks
    @file_names.sum { |file_name| file_detail(file_name).blocks }
  end

  def long_format(file)
    [
      file.ftype,
      file.permissions,
      file.nlink.to_s.rjust(3),
      ' ',
      file.owner,
      '  ',
      file.group,
      file.size.to_s.rjust(6),
      ' ',
      file.mtime.strftime('%m %e %H:%M'),
      ' ',
      file.name
    ].join
  end

  def formatted_names
    total_number = @file_names.size
    slice = (total_number.to_f / COLUMNS).ceil
    nested_file_names = @file_names.each_slice(slice).to_a
    nested_file_names[0].zip(*nested_file_names[1..])
  end

end
