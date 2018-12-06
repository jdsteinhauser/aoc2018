parse_coord = fn str ->
  [{x, _}, {y, _}] = String.split(str, ~r/[,\s]/, trim: true) |> Enum.map(&Integer.parse/1)
  {x, y}
end

manhattan = fn {x1, y1}, {x2, y2} -> abs(x2 - x1) + abs(y2 - y1) end

coords = File.stream!("day6.txt") |> Enum.map(parse_coord)

{xmin, xmax} = coords |> Enum.map(&elem(&1, 0)) |> Enum.minmax()
{ymin, ymax} = coords |> Enum.map(&elem(&1, 1)) |> Enum.minmax()

grid = for x <- xmin .. xmax, y <- ymin .. ymax do
  %{coord: {x, y}, closest: coords |> Enum.sort_by(& manhattan.({x,y}, &1)) |> Enum.chunk_by(& manhattan.({x,y}, &1)) |> hd() }
end

part1 = fn ->
  edges = Enum.concat([
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmin end),
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmax end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymin end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymax end)
    ])
    |> Enum.flat_map(fn %{closest: xy} -> xy end)
    |> Enum.uniq()

  grid
  |> Enum.flat_map(fn %{closest: xy} -> xy end)
  |> Enum.reject(& Enum.member?(edges, &1))
  |> Enum.group_by(& &1)
  |> Enum.max_by(fn {_k, v} -> Enum.count(v) end)
  |> (& elem(&1, 1)).()
  |> Enum.count()
end

IO.puts "Part 1: #{part1.()}"