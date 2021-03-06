mapping = %{?. => :open, ?| => :trees, ?# => :lumber }

field = 
  File.stream!("day18.txt")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(fn line -> Enum.map(line, & mapping[&1]) |> Enum.with_index() end)
  |> Enum.with_index()
  |> Enum.flat_map(fn {list,y} -> Enum.map(list, fn {a, x} -> {[x,y], a} end) end)
  |> Map.new()

get_surroundings = fn field, [x,y] ->
  [[x-1, y-1], [x, y-1], [x+1, y-1],
    [x-1, y],             [x+1, y],
    [x-1, y+1], [x, y+1], [x+1, y+1]]
  |> Enum.map(&Map.get(field, &1, :nothing))
  |> Enum.group_by(& &1)
  |> Enum.map(fn {k, xs} -> {k, Enum.count(xs)} end)
  |> Map.new()
end

update_acre = fn
  :open,  %{:trees => trees} when trees >= 3 -> :trees
  :trees, %{:lumber => lumber} when lumber >= 3 -> :lumber
  :lumber, %{:trees => trees, :lumber => lumber} when trees >= 1 and lumber >= 1 -> :lumber
  :lumber, _ -> :open
  x, _ -> x
end

update_field = fn field ->
  Enum.map(field, fn {coord, state} -> {coord, update_acre.(state, get_surroundings.(field, coord))} end)
  |> Enum.reduce(%{}, fn {k,v}, acc -> Map.put_new(acc, k, v) end)
  # Map.new(Enum.map(field, fn {coord, state} -> update_acre.(state, get_surroundings.(field, coord)) end))
end

part1 = fn ->
  Stream.iterate(field, update_field)
  |> Stream.take(11)
  |> Enum.to_list()
  |> List.last()
  |> Enum.group_by(fn {_k, v} -> v end)
  |> Enum.map(fn {k, xs} -> {k, Enum.count(xs)} end)
end

IO.inspect part1.()

part2 = fn ->
  data =
    field 
    |> Stream.iterate(update_field)
    |> Stream.map(fn f -> Enum.group_by(f, fn {_k, v} -> v end) |> Enum.map(fn {k, xs} -> {k, Enum.count(xs)} end) |> Map.new() end)
    |> Stream.with_index()
    |> Enum.take(1000)
    |> Enum.reverse()
  
  # Series converges to a repeating sequence of 28 items
  {%{:trees => trees, :lumber => lumber}, _idx} = Enum.find(data, fn {_vals, idx} -> rem(idx, 28) == rem(1_000_000_000, 28) end)
  lumber * trees
end

IO.puts part2.()