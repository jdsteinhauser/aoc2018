data = 
  File.read!("day8.txt")
  |> String.split(~r/\s+/, trim: true)
  |> Enum.map(& Integer.parse(&1) |> elem(0))

parse_tree = fn
  _f, tree, [] -> tree
  f, tree, nums ->
    [child_count, meta_count | rest] = nums
    
end