def parse(input)
  input.split.map(&:to_i)
end

def count(stones, ticks, table = {})
  # pp({ stones:, ticks: })
  if ticks == 0
    (table[stones] ||= {})[ticks] = stones.size
    return stones.size
  elsif (answer = table.dig(stones, ticks))
    answer
  else
    split(stones).sum { |s| count([s], ticks - 1, table) }
  end
end

def split(stone)
  if stone.zero?
    1
  elsif (s_stone = stone.to_s).size.even?
    s_stone.chars.each_slice(s_stone.size / 2).map { |s| s.join.to_i }
  else
    stone * 2024
  end
end

def count(stones, n, memo)
  stones.each { |s| (memo[s] ||= {})[n] = 1 if n == 0 }
  stones.sum { |s|
    next answer if (answer = memo.dig(s, n))
    split()
  }
end

def run(input)
  stones = parse(input)
  memo = {}

  (0...1).each do |i|
    25.times do |n|
      left, right = split(stones[i])

      stones[i] = left
      stones.insert(i + 1, [right, 25 - n - 1]) if right
    end
  end

  puts("#{stones}")
end

fail unless 55312 == run(DATA.read).tap { pp(_1) }

puts run(File.read("#{__dir__}/input.txt"))
__END__
125 17
