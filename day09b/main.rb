def parse(input)
  input.chars.each_slice(2).with_index.with_object([]) { |((size, free), i), memo|
    size.to_i.times { memo << i.to_s }
    free.to_i.times { memo << "." } if free
  }
end

def compact(parsed)
  parsed.reject { |n| n == "." }.uniq.reverse.each do |target|
    # pp(target)

    free_start = parsed.index(".")
    free_end = free_start
    free_end += 1 until parsed[free_end + 1] != "."

    block_end = parsed.rindex { |id| id == target }
    block_start = block_end
    block_start -= 1 until parsed[block_start - 1] != parsed[block_end]

    while free_start < block_start do
      # puts(parsed.join)
      # pp({ free_start:, free_end:, block_start:, block_end: })

      if (free_end - free_start) >= block_end - block_start
        (block_end - block_start + 1).times do |i|
          parsed[free_start + i], parsed[block_start + i] = parsed[block_start + i], parsed[free_start + i]
        end

        break
      end

      free_start = free_end + 1
      free_start += 1 until parsed[free_start] == "."
      free_end = free_start
      free_end += 1 until parsed[free_end + 1] != "."
    end

  end

  parsed
end

def checksum(compacted)
  compacted.each.with_index.sum { |id, i| id == "." ? 0 : id.to_i * i }
end



parsed = parse(DATA.read.chomp)
compact(parsed)
fail unless "00992111777.44.333....5555.6666.....8888.." == parsed.join
fail unless 2858 == checksum(parsed).tap { pp(_1) }

# parsed = parse("12345")
# compacted = compact(parsed)
# fail unless "022111222......" == compacted
# puts(checksum(compacted))

parsed = parse(File.read("#{__dir__}/input.txt").chomp)
compact(parsed)
puts(checksum(parsed))

__END__
2333133121414131402
