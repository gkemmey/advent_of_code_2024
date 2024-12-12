def parse(input)
  input.split.map(&:to_i)
end

def run(input)
  stones = parse(input)
  zeroes = []
  ones = []

  25.times do |n|
    # if n < 13
      # puts("==================== #{n} =====================")
      # puts("(#{stones.size}) #{stones}")
      # puts("zeroes: #{zeroes}")
      # puts("ones: #{ones}")
      # puts("============================================")
    # end

    i = 0
    while i < stones.size do
      if stones[i].zero?
        # stones[i] = 1
        zeroes << n
        stones.delete_at(i)
        i -= 1
      # elsif stones[i] == 1
      #   ones << n
      #   # stones[i] = stones[i] * 2024
      #   stones.delete_at(i)
      #   i -= 1
      elsif (size = stones[i].to_s.size).even?
        left, right = stones[i].to_s.chars.each_slice(size / 2).map { |s| s.join.to_i }

        stones[i] = left
        stones.insert(i + 1, right)
        i += 1
      else
        stones[i] = stones[i] * 2024
      end

      i += 1
    end
  end

  binding.irb
  stones.size
end

fail unless 55312 == run(DATA.read).tap { pp(_1) }

# puts run(File.read("#{__dir__}/input.txt"))
# 125 17
__END__
125 17
