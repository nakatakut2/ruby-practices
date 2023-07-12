# frozen_string_literal: true

require_relative 'file_detail'

class Outputter
  COLUMNS = 3

  def initialize(file_names)
    @file_names = file_names
  end

  def output(long: false)
    if long
      puts "total #{total_blocks}"
      @file_names.each do |file_name|
        puts long_format(file_detail(file_name))
      end
    else
      formatted_names.each do |names|
        names.compact.each { |name| print name.ljust(30) }
        puts "\n"
      end
    end
  end

  private

  def file_detail(file_name)
    FileDetail.new(file_name)
  end

  def formatted_names
    total_number = @file_names.size
    slice = (total_number / COLUMNS).ceil
    molding_array = @file_names.each_slice(slice).to_a
    molding_array[0].zip(*molding_array[1..])
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
end
