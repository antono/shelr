# encoding: utf-8
module Shelr
  class Terminal
    def size
      height, width = `stty size`.split(' ')
      { :height => height.to_i, :width => width.to_i }
    end

    def puts_line
      STDOUT.puts "-=" * (size[:width] / 2)
    end
  end
end
