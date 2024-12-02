class Report
  def initialize(levels)
    @levels = levels
    determine_safety
  end

  def safe? = !!@safe

  private

    attr_reader :levels

    def determine_safety
      @safe =
        levels.each_cons(2).all? { |a, b| (1..3).cover?(b - a) } ||
        levels.each_cons(2).all? { |a, b| (1..3).cover?(a - b) }
    end
end

def parse(input)
  input.lines(chomp: true).map { |l| Report.new(l.split(/\s+/).map(&:to_i)) }
end

reports = parse(DATA.read)
fail unless reports.select(&:safe?).count == 2

reports = parse(File.read("./input.txt"))
puts reports.select(&:safe?).count

__END__
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
