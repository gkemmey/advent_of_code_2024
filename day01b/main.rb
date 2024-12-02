def similarity(l_list, r_list)
  r_tally = r_list.tally
  l_list.sum { |l| l * (r_tally[l] || 0) }
end

def parse(input)
  input.lines(chomp: true).map { |l| l.split(/\s+/).map(&:to_i) }.transpose
end

l_list, r_list = parse(DATA.read)
fail unless similarity(l_list, r_list).tap { puts(_1) } == 31

l_list, r_list = parse(File.read("./input.txt"))
puts similarity(l_list, r_list)

__END__
3   4
4   3
2   5
1   3
3   9
3   3
