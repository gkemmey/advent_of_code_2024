def parse(input)
  input.lines(chomp: true).collect(&:chars)
end

def run(input)
  puzzle = parse(input)
  n_xmas = 0

  puzzle.each_with_index do |row, i|
    row.each_with_index do |char, j|
      next unless char == "X"

      n_xmas += 1 if xmas_up?(puzzle, i, j)
      n_xmas += 1 if xmas_diagonal_up_right?(puzzle, i, j)
      n_xmas += 1 if xmas_right?(puzzle, i, j)
      n_xmas += 1 if xmas_diagonal_down_right?(puzzle, i, j)
      n_xmas += 1 if xmas_down?(puzzle, i, j)
      n_xmas += 1 if xmas_diagonal_down_left?(puzzle, i, j)
      n_xmas += 1 if xmas_left?(puzzle, i, j)
      n_xmas += 1 if xmas_diagonal_up_left?(puzzle, i, j)
    end
  end

  n_xmas
end

def xmas_up?(puzzle, i, j)
  return false if i - 3 < 0

  puzzle[i - 1][j] == "M" &&
  puzzle[i - 2][j] == "A" &&
  puzzle[i - 3][j] == "S"
end

def xmas_diagonal_up_right?(puzzle, i, j)
  return false if i - 3 < 0 || j + 3 >= puzzle[0].size

  puzzle[i - 1][j + 1] == "M" &&
  puzzle[i - 2][j + 2] == "A" &&
  puzzle[i - 3][j + 3] == "S"
end

def xmas_right?(puzzle, i, j)
  return false if j + 3 >= puzzle.size

  puzzle[i][j + 1] == "M" &&
  puzzle[i][j + 2] == "A" &&
  puzzle[i][j + 3] == "S"
end

def xmas_diagonal_down_right?(puzzle, i, j)
  return false if i + 3 >= puzzle.size || j + 3 >= puzzle[0].size

  puzzle[i + 1][j + 1] == "M" &&
  puzzle[i + 2][j + 2] == "A" &&
  puzzle[i + 3][j + 3] == "S"
end

def xmas_down?(puzzle, i, j)
  return false if i + 3 >= puzzle.size

  puzzle[i + 1][j] == "M" &&
  puzzle[i + 2][j] == "A" &&
  puzzle[i + 3][j] == "S"
end

def xmas_diagonal_down_left?(puzzle, i, j)
  return false if i + 3 >= puzzle.size || j - 3 < 0

  puzzle[i + 1][j - 1] == "M" &&
  puzzle[i + 2][j - 2] == "A" &&
  puzzle[i + 3][j - 3] == "S"
end

def xmas_left?(puzzle, i, j)
  return false if j - 3 < 0

  puzzle[i][j - 1] == "M" &&
  puzzle[i][j - 2] == "A" &&
  puzzle[i][j - 3] == "S"
end

def xmas_diagonal_up_left?(puzzle, i, j)
  return false if i - 3 < 0 || j - 3 < 0

  puzzle[i - 1][j - 1] == "M" &&
  puzzle[i - 2][j - 2] == "A" &&
  puzzle[i - 3][j - 3] == "S"
end

fail unless 18 == run(DATA.read).tap { pp(_1) }

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
