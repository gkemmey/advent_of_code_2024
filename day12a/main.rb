class Solution
  def initialize(input)
    @input = input
    parse

    @tallies = []
    @visited = Set.new
  end

  def run
    (0...rows).each do |r|
      (0...cols).each do |c|
        tally(r, c) unless @visited.include?([r, c])
      end
    end

    tallies.sum { |t| t[:plots] * t[:edges] }
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
      @tallies << { plots: 0, edges: 0 }

      area = [[row, col]]
      until area.empty? do
        position = area.pop
        next unless @visited.add?(position)

        @tallies.last[:plots] += 1

        neighbors = [[-1, 0], [0, 1], [1, 0], [0, -1]].map { |delta| delta.zip(position).map(&:sum) }
        neighbors.reject! do |(r, c)|
          (@tallies.last[:edges] += 1) if out_of_bounds?(r, c) || garden[[r, c]] != garden[position]
        end

        area.concat(neighbors)
      end
    end

    def out_of_bounds?(r, c)
      r < 0 || r >= rows || c < 0 || c >= cols
    end
end

fail unless 1930 == Solution.new(DATA.read).run.tap { pp(_1) }

puts Solution.new(File.read("#{__dir__}/input.txt")).run

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
