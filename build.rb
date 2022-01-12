#!/usr/bin/env ruby
require 'open-uri'

digraphs = []

url = 'https://raw.githubusercontent.com/vim/vim/master/runtime/doc/digraph.txt'
local = './digraph.txt'
if not File.file?(local)
  File.open(local, 'w:UTF-8') do |file|
    file << URI.parse(url).open.read
  end
end

digraph_txt = File.open(local)
in_table = false
read_header = false
digraph_txt.each_with_index do |line,i|
  if line =~ /^\t\t*\*digraph-table/
    in_table = true
    read_header = true
    next
  end
  if read_header
    read_header = false
    next
  end
  if in_table and not read_header
    match = line.match(/^([^\t]*)\t(..)\t(....)/)
    if match.nil?
      in_table = false
    else
      symbol,digraph,hex,desc = match.captures
      hex.sub!('x','0')
      #puts "#{i}: #{line}"
      digraphs.append([digraph,hex])
    end
  end
end

vimrc = File.open(File.expand_path("~/.vimrc"))
vimrc.each_with_index do |line,i|
  match = line.match(/^digr (..) ([0-9][0-9]*)/)
  if not match.nil?
    digraph,dec = match.captures
    hex = "%04X" % dec.to_i
    digraphs.append([digraph,hex])
  end
end

digraphs.sort!

out = File.open("DefaultKeyBinding.dict","w:UTF-8")
out.puts "{"
  # CTRL+SHIFT+F12
  compose = "^$\\UF70F"
  out.puts "    \"%s\" = {" % compose
  
    first_key = nil
    digraphs.each do |entry|
      digraph = entry[0]
      hex = entry[1]
      symbol = [hex.to_i(16)].pack("U")
      if digraph[0] != first_key
        if not first_key.nil?
          out.puts "        };"
        end
        first_key = digraph[0]
        out.puts "        \"\\U00%X\" = {" % first_key.ord
      end
      # "\U0020" = ("insertText:", "\U00A0"); /* Compose, SPACE, SPACE: NO-BREAK SPACE */
      #out.puts "            \"\\U00%X\" = (\"insertText:\", \"\\U#{hex.upcase}\"); \/* #{digraph} → #{symbol} *\/" % digraph[1].ord
      out.puts "            \"\\U00%X\" = (\"insertText:\", \"\\U#{hex.upcase}\"); \/* %s → #{symbol} *\/" % [digraph[1].ord, digraph]
    end
    out.puts "        };"
  out.puts "    };"
out.puts "}"
