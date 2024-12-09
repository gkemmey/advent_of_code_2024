def parse(input)
  input.chars.each_slice(2).with_index.with_object([]) { |((size, free), i), memo|
    size.to_i.times { memo << i.to_s }
    free.to_i.times { memo << "." } if free
  }
end

def compact(parsed)
  i = parsed.index(".")
  j = parsed.rindex { |id| id != "." }


  while i < j do
    parsed[i], parsed[j] = parsed[j], parsed[i]

    i = parsed.index(".")
    j = parsed.rindex { |id| id != "." }
  end

  parsed
end

def checksum(compacted)
  compacted.each.with_index.sum { |id, i| id == "." ? 0 : id.to_i * i }
end



parsed = parse(DATA.read.chomp)
fail unless "0099811188827773336446555566.............." == (compacted = compact(parsed)).join
fail unless 1928 == checksum(compacted).tap { pp(_1) }

# parsed = parse("12345")
# compacted = compact(parsed)
# fail unless "022111222......" == compacted
# puts(checksum(compacted))

parsed = parse(File.read("#{__dir__}/input.txt").chomp)
compacted = compact(parsed)
puts(checksum(compacted))

__END__
2333133121414131402
