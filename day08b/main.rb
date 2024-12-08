def parse(input)
  map = input.lines(chomp: true).each.with_index.with_object({}) { |(line, row), memo|
    line.chars.each_with_index do |char, col|
      next unless char =~ /[\dA-Za-z]/
      memo[char] ||= []
      memo[char] << [row, col]
    end
  }

  return map, input.lines.size, input.lines(chomp: true).first.size
end

def run(input)
  map, rows, cols = parse(input)
  # pp({ map:, rows:, cols: })
  antinodes = {}

  map.keys.each do |antenna|
    # pp({ antenna: })
    map[antenna].combination(2).each do |loc_a, loc_b|
      # pp({ loc_a:, loc_b: })
      drfa = (loc_a[0] - loc_b[0])
      dcfa = (loc_a[1] - loc_b[1])

      antinode_a = [loc_a[0] + drfa, loc_a[1] + dcfa]
      count_a = 0

      while antinode_a[0] >= 0 && antinode_a[0] < rows && antinode_a[1] >= 0 && antinode_a[1] < cols
        (antinodes[antinode_a] ||= []) << antenna
        antinode_a = [antinode_a[0] + drfa, antinode_a[1] + dcfa]
        count_a += 1
      end

      antinode_b = [loc_b[0] - drfa, loc_b[1] - dcfa]
      count_b = 0

      while antinode_b[0] >= 0 && antinode_b[0] < rows && antinode_b[1] >= 0 && antinode_b[1] < cols
        (antinodes[antinode_b] ||= []) << antenna
        antinode_b = [antinode_b[0] - drfa, antinode_b[1] - dcfa]
        count_b += 1
      end

      (antinodes[loc_a] ||= []) << antenna
      (antinodes[loc_b] ||= []) << antenna
    end
  end

  antinodes.size
end

fail unless 34 == run(DATA.read).tap { pp(_1) }

puts(run(File.read("#{__dir__}/input.txt")))

__END__
##....#....#
.#.#....0...
..#.#0....#.
..##...0....
....0....#..
.#...#A....#
...#..#.....
#....#.#....
..#.....A...
....#....A..
.#........#.
...#......##
