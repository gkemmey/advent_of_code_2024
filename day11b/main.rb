def parse(input)
  input.split.map(&:to_i)
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

def run(input)
  stones = parse(input)
  stones.map! { |s| [s, 75] }
  _stones = stones.dup.map(&:dup)

  memos = {}
  parts = []

  until stones.empty? do
    # puts("🦋 #{{memos:, parts:, stones: }}")
    part = stones.shift
    while !parts.empty? && parts.last.last <= part.last do
      parts.pop
    end

    if (seen = memos[part])
      parts.each { |p| memos[p] += seen }
    else
      parts << part
      memos[part] = 0

      stone, splits = part
      splits.times do |n|
        # puts("🐛 #{{count:, stone:, splits:, stones: }}")
        left, right = split(stone)

        stone = left
        stones.unshift([right, splits - n - 1]) if right
      end

      parts.each { |p| memos[p] += 1 }
    end
  end

  _stones.sum { |part| memos[part] }
end

fail unless 65601038650482 == run(DATA.read).tap { pp(_1) }

puts run(File.read("#{__dir__}/input.txt"))
__END__
125 17
