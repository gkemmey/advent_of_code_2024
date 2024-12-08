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
  position = visited.keys.last
  next_position = step(position)

  until out_of_bounds?(grid, next_position) do
    if obstacle?(grid, next_position)
      position = turn(position)
      next_position = step(position)
    else
      yield(next_position) if block_given?

      position = next_position
      visited[position] = true

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
  visited = { start => true }
  loops = 0

  walk(grid, visited) do |next_position|
    # if i've been here before from any direction, i've already checked placing
    # an obstacle here. if i _do_ place an obstacle here, i'll have turned
    # away earlier in the path, so i don't need to try it from this direction.
    next if visited.keys.any? { |v| v[0] == next_position[0] && v[1] == next_position[1] }

    with_obstacle_at(grid, next_position) do
      loops += 1 if loops?(grid, visited.dup)
    end
  end

  loops
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
