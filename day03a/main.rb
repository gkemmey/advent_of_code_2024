fail unless 161 == DATA.read.scan(/mul\((\d+),(\d+)\)/).sum { |a, b| a.to_i * b.to_i }

puts(File.read("#{__dir__}/input.txt").scan(/mul\((\d+),(\d+)\)/).sum { |a, b| a.to_i * b.to_i })

__END__
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
