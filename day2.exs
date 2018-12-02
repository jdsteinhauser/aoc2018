checksum = fn str ->
  groups = str
    |> String.to_charlist()
    |> Enum.group_by(fn x -> x end)
  { Enum.any?(groups, fn {_k, v} -> Enum.count(v) == 2 end), Enum.any?(groups, fn {_k, v} -> Enum.count(v) == 3 end) }
end

similar_chars = fn x, y ->
  Enum.zip(String.to_charlist(x), String.to_charlist(y))
  |> Enum.filter(fn {a,b} -> a == b end)
  |> Enum.map(& elem(&1,0))
  |> to_string()
end

data = File.stream!("day2.txt") |> Enum.map(&String.trim/1)

part1 = fn -> 
  data
  |> Enum.map(& checksum.(&1))
  |> (& [Enum.count(&1, fn {l,_r} -> l end), Enum.count(&1, fn {_l,r} -> r end)]).()
  |> Enum.reduce(&Kernel.*/2)
end

part2 = fn ->
  data
  |> Enum.with_index(1)
  |> Enum.flat_map(fn {str, idx} -> Enum.drop(data, idx) |> Enum.map(& similar_chars.(str, &1)) end)
  |> Enum.sort_by(&String.length/1)
  |> Enum.reverse()
  |> hd()
end

IO.puts "Part 1: #{part1.()}"
IO.puts "Part 2: #{part2.()}"