def parse(input)
  input.split.map(&:to_i)
end

def run(input)
  stones = parse(input)

  25.times do |n|
    pp(stones) if n < 6

    i = 0
    while i < stones.size do
      if stones[i].zero?
        stones[i] = 1
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

  stones.size
end

fail unless 55312 == run(DATA.read).tap { pp(_1) }

puts run(File.read("#{__dir__}/input.txt"))

__END__
125 17
