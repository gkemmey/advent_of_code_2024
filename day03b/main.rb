def run(input)
  total = 0
  counts = true

  input.scan(/(do\(\)|don't\(\)|mul\(\d+,\d+\))/).flatten.each do |instruction|
    if instruction == "do()"
      counts = true
    elsif instruction == "don't()"
      counts = false
    else
      total += instruction.scan(/\d+/).map(&:to_i).inject(:*) if counts
    end
  end

  total
end

fail unless 48 == run(DATA.read)

puts(run(File.read("#{__dir__}/input.txt")))

__END__
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
