parse_coord = fn str ->
  [{x, _}, {y, _}] = String.split(str, ~r/[,\s]/, trim: true) |> Enum.map(&Integer.parse/1)
  {x, y}
end

manhattan = fn {x1, y1}, {x2, y2} -> abs(x2 - x1) + abs(y2 - y1) end

coords = File.stream!("day6.txt") |> Enum.map(parse_coord)

{xmin, xmax} = coords |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
{ymin, ymax} = coords |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

grid = for x <- xmin .. xmax, y <- ymin .. ymax do
  %{coord: {x, y}, closest: Enum.min_by(coords, & manhattan.({x,y}, &1))}
end

part1 = fn ->
  edges = Enum.concat([
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmin end),
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmax end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymin end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymax end)
    ])
    |> Enum.map(fn %{closest: xy} -> xy end)
    |> Enum.uniq()

  grid
  |> Enum.reject(& Enum.member?(edges, &1))
  |> Enum.group_by(fun )