require "matrix"

module Chars
  GUARD = "^"
  OBSTACLE = "#"
end

module Directions
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
end

def parse(input)
  position = nil

  grid = input.lines(chomp: true).each.with_index.with_object([]) do |(line, r), memo|
    memo << []
    line.chars.each_with_index do |char, c|
      memo.last << char
      position = Vector[r, c, Directions::UP] if char == Chars::GUARD
    end
  end

  fail unless position
  return grid, position
end

def out_of_bounds?(grid, position)
  position[0] < 0 ||
    position[0] >= grid.size ||
    position[1] < 0 ||
    position[1] >= grid[position[0]].size
end

def obstacle?(grid, position)
  grid[position[0]][position[1]] == Chars::OBSTACLE
end

def peek(grid, position)
  {
    Directions::UP    => Vector[-1,  0, 0],
    Directions::RIGHT => Vector[ 0,  1, 0],
    Directions::DOWN  => Vector[ 1,  0, 0],
    Directions::LEFT  => Vector[ 0, -1, 0]
  }[position[2]] + position
end

def turn(position)
  position.dup.tap { |p| p[2] = p[2].next % 4 }
end

def run(input)
  grid, position = parse(input)
  visited = Set.new

  until out_of_bounds?(grid, peek(grid, position)) do
    visited << position

    position = turn(position) while obstacle?(grid, peek(grid, position))
    position = peek(grid, position)
  end

  visited << position
  visited.uniq { |p| [p[0], p[1]] }.size
end

fail unless 41 == run(DATA.read).tap { pp(_1) }

puts(run(File.read("#{__dir__}/input.txt")))

__END__
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
