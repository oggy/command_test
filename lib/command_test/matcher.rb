module CommandTest
  class Matcher
    def match?(expected, actual, e=0, a=0)
      while e < expected.length
        case (specifier = expected[e])
        when nil
          return false  # passed end of actual
        when String, Regexp
          if specifier === actual[a]
            a += 1
          else
            return false
          end
        when Integer
          specifier >= 0 or
            raise ArgumentError, "negative integer matcher: #{specifier}"
          a += specifier
        when Range, :*, :+
          case specifier
          when :*
            specifier = 0...(actual.length - a)
          when :+
            specifier = 1...(actual.length - a)
          end
          specifier.end >= specifier.begin or
            raise ArgumentError, "descending range matcher: #{specifier}"
          specifier.begin >= 0 or
            raise ArgumentError, "negative range bounds: #{specifier}"
          specifier.each do |n|
            if match?(expected, actual, e + 1, a + n)
              return true
            end
          end
          return false
        else
          raise ArgumentError, "invalid matcher: #{specifier}"
        end
        e += 1
      end
      a == actual.length
    end
  end
end
