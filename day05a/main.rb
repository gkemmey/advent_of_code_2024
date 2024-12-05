def split_input(input)
  rules, _, updates = input.lines(chomp: true).chunk_while { |a, b| !a.empty? && !b.empty? }.to_a
  return rules, updates
end

def parse_rules(lines)
  lines.each_with_object({}) do |line, rules|
    before, after = line.split("|").map(&:to_i)
    rules[before] ||= {}
    rules[before][after] = true
  end
end

def parse_updates(lines)
  lines.map { |l| l.split(",").map(&:to_i) }
end

def valid_ordering?(update, rules)
  update.reverse.each_with_index do |page, i|
    (update.size - 1 - i).downto(0) do |j|
      return false if rules[page]&.[](update[j])
    end
  end

  true
end

def midpoint(update)
  fail if update.size.even?
  update[update.size / 2]
end

input_rules, input_updates = split_input(DATA.read)
rules = parse_rules(input_rules)
updates = parse_updates(input_updates)

fail unless 143 == updates.filter_map { |u| midpoint(u) if valid_ordering?(u, rules) }.sum.tap { pp(_1) }

input_rules, input_updates = split_input(File.read("#{__dir__}/input.txt"))
rules = parse_rules(input_rules)
updates = parse_updates(input_updates)

puts(updates.filter_map { |u| midpoint(u) if valid_ordering?(u, rules) }.sum)

__END__
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
