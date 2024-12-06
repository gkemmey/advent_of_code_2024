# frozen_string_literal: true

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

  STEP_DELTAS = {
    UP    => Vector[-1,  0, 0],
    RIGHT => Vector[ 0,  1, 0],
    DOWN  => Vector[ 1,  0, 0],
    LEFT  => Vector[ 0, -1, 0]
  }.transform_values(&:freeze).freeze

  def self.step(position)
    position + STEP_DELTAS[position[2]]
  end

  def self.turn(position)
    Vector[position[0], position[1], position[2].next % 4]
  end
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

def step(position)
  Directions.step(position)
end

def turn(position)
  Directions.turn(position)
end

def walk(grid, visited)
  position = visited.last
  next_position = step(position)

  until out_of_bounds?(grid, next_position) do
    if obstacle?(grid, next_position)
      position = turn(position)
      next_position = step(position)
    else
      yield(next_position) if block_given?

      position = next_position
      visited << position

      next_position = step(position)
    end
  end
end

def with_obstacle_at(grid, position)
  original = grid[position[0]][position[1]]
  grid[position[0]][position[1]] = Chars::OBSTACLE
  yield
ensure
  grid[position[0]][position[1]] = original if original
end

def loops?(grid, visited)
  walk(grid, visited) do |next_position|
    return true if visited.include?(next_position)
  end

  false
end

def run(input)
  grid, start = parse(input)
  visited = [start]
  obstacles = Set.new

  walk(grid, visited) do |next_position|
    obstacle = [next_position[0], next_position[1]]
    next if obstacles.include?(obstacle)

    with_obstacle_at(grid, next_position) do
      obstacles << obstacle if loops?(grid, visited.dup)
    end
  end

  obstacles.size
end

fail unless 6 == run(DATA.read).tap { pp(_1) }

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
