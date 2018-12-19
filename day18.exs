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
  |> Enum.reject(& &1 == :nothing)
  |> Enum.group_by(& &1)
  |> Enum.map(fn {k, xs} -> {k, Enum.count(xs)} end)
  |> Map.new()
end

update_acre = fn
  {:open,  %{:trees => trees} when trees >= 3} -> :trees
  {:trees, %{:lumber => lumber} when lumber >= 3} -> :lumber
  {:lumber, %{:trees => trees, :lumber => lumber} when trees >= 1 and lumber >= 1} -> :lumber
  {:lumber, _} -> :open
  {x, _} -> x
end

update_field = fn field ->
  Enum.map
end