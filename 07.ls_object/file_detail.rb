# frozen_string_literal: true

require 'etc'

class FileDetail
  attr_reader :name

  TYPES = { 'file' => '-', 'directory' => 'd', 'link' => 'l' }.freeze
  PERMISSIONS = { '0' => '---', '1' => '--X', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def blocks
    @stat.blocks
  end

  def ftype
    ftype_key = File.ftype(@name)
    TYPES[ftype_key]
  end

  def permissions
    permission_numbers = @stat.mode.to_s(8).slice(-3, 3)
    permission_numbers.gsub(/[0-7]/, PERMISSIONS)
  end

  def nlink
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end
end
