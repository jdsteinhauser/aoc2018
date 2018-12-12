data = 
  File.read!("day8.txt")
  |> String.split(~r/\s+/, trim: true)
  |> Enum.map(& Integer.parse(&1) |> elem(0))

make_child = fn f, children, built_children, meta_count, numbers ->
  if children == Enum.count(built_children) do
    { meta, rest } = Enum.split(numbers, meta_count)
    { Enum.reverse(built_children), meta, rest }
  else
    [child_count, meta_length | rest] = numbers
    { grandkids, meta, tail } = f.(f, child_count, [], meta_length, rest)
    f.(f, children, [[grandkids, meta] | built_children], meta_count, tail)
  end
end

calc_value = fn
  _f, 0 -> 0
  _f, [[], meta] -> Enum.sum(meta)
  f, [children, meta] -> Enum.map(meta, fn x -> f.(f, Enum.at(children, x - 1, 0)) end) |> Enum.sum()
end

{[tree | _], _, _} = make_child.(make_child, 1, [], 0, data)

part1 = List.flatten(tree) |> Enum.sum()

part2 = calc_value.(calc_value, tree)

IO.puts "Part 1: #{part1}"
IO.puts "Part 2: #{part2}"