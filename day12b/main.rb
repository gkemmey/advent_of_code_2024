class Area
  DIR = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  #      RIGHT   DOWN    LEFT     UP
  TRY = { 0 => 3, 1 => 0, 2 => 1, 3 => 2 }

  def initialize
    @plots = []
    @contains = []
  end

  def add(position)
    @plots << position
  end

  def contains(area)
    @contains << area
  end

  def cost
    @plots.size * (sides + @contains.sum(&:sides))
  end

  def include?(plot)
    @plots.include?(plot)
  end

  def contained_by?(b)
    neighbors = @plots.each_with_object(Set.new) { |p, m|
                  DIR.map { |delta| delta.zip(p).map(&:sum) }.each { |n| m << n }
                }

    neighbors.all? { |n| include?(n) || b.include?(n) }
  end

  def sides
    sides = 0
    start = find_start
    start_dir = dir = 0

    position = start
    next_position = nil

    loop do
      # pp({ dir:, position: })
      break if next_position != nil && position == start && dir == start_dir

      next_position = DIR[TRY[dir]].zip(position).map(&:sum)
      # pp({ conidering: DIR[TRY[dir]], next_position: })

      if @plots.include?(next_position)
        dir = TRY[dir]
        # pp({ new_dir: dir, taking_try: next_position })
        sides += 1
        position = next_position
        next
      end

      next_position = DIR[dir].zip(position).map(&:sum)

      if !@plots.include?(next_position)
        dir = (dir + 1) % 4
        # pp({ new_dir: dir, turning: true })
        sides += 1
      else
        # pp({ moving_to: next_position })
        position = next_position
      end
    end

    # sides += 1
    sides
  end

  def find_start
    start = [Float::INFINITY, Float::INFINITY]
    @plots.each { |p| start = p if p[0] <= start[0] && p[1] <= start[1] }

    start
  end
end

class Solution
  def initialize(input)
    @input = input
    parse

    @areas = []
    @visited = Set.new
  end

  def run
    (0...rows).each do |r|
      (0...cols).each do |c|
        tally(r, c) unless @visited.include?([r, c])
      end
    end

    @areas.each.with_index do |a, i|
      @areas.each.with_index do |b, j|
        next if j == i # that's me
        b.contains(a) if a.contained_by?(b)
      end
    end

    @areas.sum(&:cost)
  end

  private

    attr_reader :input, :garden, :rows, :cols, :tallies

    def parse
      @garden = input.lines(chomp: true).each.with_index.with_object({}) { |(line, row), memo|
        line.chars.each_with_index do |value, col|
          memo[[row, col]] = value
        end
      }

      @rows = input.lines(chomp: true).size
      @cols = input.lines(chomp: true)[0].size
    end

    def tally(row, col)
      @areas << Area.new

      area = [[row, col]]
      until area.empty? do
        position = area.pop
        next unless @visited.add?(position)

        @areas.last.add(position)

        neighbors = [[-1, 0], [0, 1], [1, 0], [0, -1]].map { |delta| delta.zip(position).map(&:sum) }
        neighbors.reject! do |(r, c)|
           out_of_bounds?(r, c) || garden[[r, c]] != garden[position]
        end

        area.concat(neighbors)
      end
    end

    def out_of_bounds?(r, c)
      r < 0 || r >= rows || c < 0 || c >= cols
    end
end

other = <<~TEXT
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
TEXT

fail unless  368 == Solution.new(other).run.tap { pp(_1) }
fail unless 1206 == Solution.new(DATA.read).run.tap { pp(_1) }

puts Solution.new(File.read("#{__dir__}/input.txt")).run # 874174, 905878

__END__
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
