module CommandTest
  class Parser
    #
    # Parse the given command line into words.
    #
    # Supports backslash escaping, single quoting, double quoting, and
    # redirects, a la bash.
    #
    def parse(line)
      # Implementation heavily inspired by Ruby's Shellwords.
      line = line.lstrip
      words = []
      while (word = extract_word_skipping_redirects(line))
        words << word
      end
      words
    end

    def extract_word_skipping_redirects(line)
      while true
        if line.sub!(/\A\d*>>?(&\d+)?\s*/, '')
          if $1.nil?
            extract_word(line) or
              raise ArgumentError, "missing redirection target: #{line}"
          end
          next
        elsif line.sub!(/\A\d*<\s*/, '')
          extract_word(line) or
            raise ArgumentError, "missing redirection source: #{line}"
          next
        end

        return extract_word(line)
      end
    end

    def extract_word(line)
      return nil if line.empty?
      word = ''
      loop do
        if line.sub!(/\A"(([^"\\]|\\.)*)"/, '')
          chunk = $1.gsub(/\\(.)/, '\1')
        elsif line =~ /\A"/
          raise ArgumentError, "unmatched double quote: #{line}"
        elsif line.sub!(/\A'([^']*)'/, '')
          chunk = $1
        elsif line =~ /\A'/
          raise ArgumentError, "unmatched single quote: #{line}"
        elsif line.sub!(/\A\\(.)?/, '')
          chunk = $1 || ''
        elsif line.sub!(/\A([^\s\\'"<>]+)/, '')
          chunk = $1
        else
          line.lstrip!
          break
        end
        word << chunk
      end
      word
    end
  end
end
