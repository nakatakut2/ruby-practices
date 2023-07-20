# frozen_string_literal: true

require_relative 'file_detail'

class Outputter
  COLUMNS = 3
  CHAR_WIDTH = 30

  def initialize(file_names)
    @file_details = file_names.map { |file_name| FileDetail.new(file_name) }
  end

  def output(long: false)
    long ? long_output : no_option_output
  end

  private

  def long_output
    puts "total #{@file_details.sum(&:blocks)}"
    @file_details.each do |file_detail|
      puts long_format(file_detail)
    end
  end

  def no_option_output
    formatted_files.each do |files|
      files.compact.each { |file| print file.name.ljust(CHAR_WIDTH) }
      puts "\n"
    end
  end

  def long_format(file_detail)
    [
      file_detail.ftype,
      file_detail.permissions,
      file_detail.nlink.to_s.rjust(3),
      ' ',
      file_detail.owner,
      '  ',
      file_detail.group,
      file_detail.size.to_s.rjust(6),
      ' ',
      file_detail.mtime.strftime('%_m %_e %H:%M'),
      ' ',
      file_detail.name
    ].join
  end

  def formatted_files
    total_number = @file_details.size
    slice = (total_number.to_f / COLUMNS).ceil
    nested_file_details = @file_details.each_slice(slice).to_a
    nested_file_details[0].zip(*nested_file_details[1..])
  end
end
