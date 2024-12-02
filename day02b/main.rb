class Report
  def initialize(levels)
    @levels = levels
    determine_safety
  end

  def safe? = !!@safe

  private

    attr_reader :levels

    def determine_safety
      @safe = (increasingly_safe || decreasingly_safe)
    end

    def increasingly_safe = safe_with_dampener { |a, b| b - a }
    def decreasingly_safe = safe_with_dampener { |a, b| a - b }

    def safe_with_dampener(levels = self.levels, problems = 0, &block)
      levels.each_cons(2).each_with_index do |(a, b), i|
        next if (1..3).cover?(yield(a, b))

        problems += 1
        return false if problems > 1
        return safe_with_dampener(levels.reject.with_index { |_, j| j == i }, problems, &block) ||
               safe_with_dampener(levels.reject.with_index { |_, j| j == i + 1 }, problems, &block)
      end

      true
    end
end

def parse(input)
  input.lines(chomp: true).map { |l| Report.new(l.split(/\s+/).map(&:to_i)) }
end

reports = parse(DATA.read)
fail unless reports.select(&:safe?).count.tap { puts(_1) } == 4

reports = parse(File.read("#{__dir__}/input.txt"))
puts reports.select(&:safe?).count

__END__
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
