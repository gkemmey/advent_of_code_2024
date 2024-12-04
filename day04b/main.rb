def parse(input)
  input.lines(chomp: true).collect(&:chars)
end

def run(input)
  puzzle = parse(input)
  n_x_mas = 0

  puzzle.each_with_index do |row, i|
    row.each_with_index do |char, j|
      next unless char == "A"

      n_x_mas += 1 if x_mas?(puzzle, i, j)
    end
  end

  n_x_mas
end

def x_mas?(puzzle, i, j)
  left_diagonal_mas_or_sam?(puzzle, i, j) && right_diagonal_mas_or_sam?(puzzle, i, j)
end

def left_diagonal_mas_or_sam?(puzzle, i, j)
  return false if i - 1 < 0 || j - 1 < 0
  return false if i + 1 >= puzzle.size || j + 1 >= puzzle[0].size

  puzzle[i - 1][j - 1] == "S" && puzzle[i + 1][j + 1] == "M" ||
  puzzle[i - 1][j - 1] == "M" && puzzle[i + 1][j + 1] == "S"
end

def right_diagonal_mas_or_sam?(puzzle, i, j)
  return false if i - 1 < 0 || j + 1 >= puzzle[0].size
  return false if i + 1 >= puzzle.size || j - 1 >= puzzle[0].size

  puzzle[i - 1][j + 1] == "S" && puzzle[i + 1][j - 1] == "M" ||
  puzzle[i - 1][j + 1] == "M" && puzzle[i + 1][j - 1] == "S"
end

fail unless 9 == run(DATA.read).tap { pp(_1) }

puts(run(File.read("#{__dir__}/input.txt")))

__END__
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
