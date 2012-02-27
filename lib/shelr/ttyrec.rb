module Shelr
  class TTYRec

    def initialize(ttyrec)
      @io = ttyrec
      @timeline = []
    end

    def parse
      while !@io.eof?
        frame = {}
        
        sec, usec, len = @io.read(12).unpack('VVV')
        data = @io.read(len)
        
        prev_timestamp ||= [ sec, usec ].join('.').to_f
        curr_timestamp   = [ sec, usec ].join('.').to_f
        
        offset = curr_timestamp - prev_timestamp

        frame = {
          :offset => "%5.6f" % offset,
          :data   => data,
          :length => len
        }
        
        @timeline << frame

        prev_timestamp = curr_timestamp
        prev_data = data
      end
      
      self
    end

    def to_typescript
      script = { :typescript => "Script started...\n", :timing => "" }

      @timeline.each do |frame|
        script[:timing] += [frame[:offset], ' ', frame[:length], "\n"].join
        script[:typescript] += frame[:data]
      end

      script
    end
  end
end
