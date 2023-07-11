# frozen_string_literal: true

require 'etc'

class FileDetail
  attr_reader :file_name, :file_stat

  TYPES = { 'file' => '-', 'directory' => 'd', 'link' => 'l' }.freeze
  PERMISSIONS = { '0' => '---', '1' => '--X', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

  def initialize(file_name)
    @file_name = file_name
    @file_stat = File.stat(file_name)
  end

  def ftype
    ftype_key = File.ftype(file_name)
    TYPES[ftype_key]
  end

  def permissions
    permission_numbers = file_stat.mode.to_s(8).slice(-3, 3).chars
    permission_numbers.map { |num| PERMISSIONS[num] }.join
  end

  def nlink
    file_stat.nlink.to_s.rjust(3)
  end

  def owner
    Etc.getpwuid(file_stat.uid).name
  end

  def group
    Etc.getgrgid(file_stat.gid).name
  end

  def size
    file_stat.size.to_s.rjust(6)
  end

  def mtime
    file_stat.mtime.strftime('%m %e %H:%M')
  end

  def name
    file_name
  end
end
