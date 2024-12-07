def run(input)
  total = 0

  input.lines(chomp: true).each do |line|
    answer, digits = line.split(": ").then { |s| [s[0].to_i, s[1].split(" ").map(&:to_i)] }

    total += answer if %i(* +).repeated_permutation(digits.size - 1).any? { |operations|
                      digits[1..].each_with_index.reduce(digits[0]) { |memo, (d, i)|
                        memo.send(operations[i - 1], d)
                      } == answer
                    }
  end

  total
end

fail unless 3749 == run(DATA.read).tap { pp(_1) }

puts(run(File.read("#{__dir__}/input.txt")))

__END__
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
