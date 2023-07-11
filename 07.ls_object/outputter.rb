# frozen_string_literal: true

require_relative 'file_detail'

class Outputter
  COLUMNS = 3

  def initialize(file_names)
    @file_names = file_names
  end

  def output
    formatted_names.each do |names|
      names.compact.each { |name| print name.ljust(30) }
      puts "\n"
    end
  end

  def long_option_output
    puts "total #{total_blocks}"
    @file_names.each do |file_name|
      puts long_format(FileDetail.new(file_name)).join
    end
  end

  private

  def formatted_names
    total_number = @file_names.size
    slice = total_number / COLUMNS
    slice += 1 unless (total_number % COLUMNS).zero?
    names_slice = @file_names.each_slice(slice).to_a
    names_slice[0].zip(*names_slice[1..])
  end

  def total_blocks
    @file_names.map { |file_name| FileDetail.new(file_name).blocks }.sum
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
      file.file_name
    ]
  end
end
