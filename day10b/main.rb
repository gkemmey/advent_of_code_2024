def parse(input)
  map = input.lines(chomp: true).each.with_index.with_object({}) { |(line, row), memo|
          line.chars.each_with_index do |height, col|
            memo[[row, col]] = height != "." ? height.to_i : -1
          end
        }

  return map, input.lines(chomp: true).size, input.lines(chomp: true)[0].size
end

def run(input)
  map, rows, cols = parse(input)

  map.each_key.sum do |position|
    next 0 unless map[position].zero?
    trailhead_rating(map, rows, cols, position)
  end
end

def trailhead_rating(map, rows, cols, position, visited = Set.new)
  return 1 if map[position] == 9

  visited << position

  nexts = [[-1, 0], [0, 1], [1, 0], [0, -1]].map { |delta| delta.zip(position).map(&:sum) }
  nexts.select! do |n_pos|
    n_pos[0] >= 0 && n_pos[0] < rows && n_pos[1] >= 0 && n_pos[1] < cols &&
      map[n_pos] == map[position] + 1 &&
      !visited.include?(n_pos)
  end

  paths = nexts.sum { |n_pos| trailhead_rating(map, rows, cols, n_pos, visited) }

  visited.delete(position)
  return paths
end

fail unless 81 == run(DATA.read).tap { pp(_1) }

puts run(File.read("#{__dir__}/input.txt"))

__END__
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
