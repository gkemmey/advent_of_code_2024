def distance(l_list, r_list)
  l_list.each_with_index.sum { |l, i| (l - r_list[i]).abs }
end

def parse(input)
  input.lines(chomp: true).map { |l| l.split(/\s+/).map(&:to_i) }.transpose.map(&:sort)
end

l_list, r_list = parse(DATA.read)
fail unless distance(l_list, r_list) == 11

l_list, r_list = parse(File.read("./input.txt"))
puts distance(l_list, r_list)

__END__
3   4
4   3
2   5
1   3
3   9
3   3
