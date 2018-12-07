parse_coord = fn str ->
  [{x, _}, {y, _}] = String.split(str, ~r/[,\s]/, trim: true) |> Enum.map(&Integer.parse/1)
  {x, y}
end

manhattan = fn {x1, y1}, {x2, y2} -> abs(x2 - x1) + abs(y2 - y1) end

coords = File.stream!("day6.txt") |> Enum.map(parse_coord)

{xmin, xmax} = coords |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
{ymin, ymax} = coords |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

part1 = fn ->
  grid = for x <- xmin .. xmax, y <- ymin .. ymax do
    %{coord: {x, y}, 
      closest: coords
              |> Enum.group_by(& manhattan.({x,y}, &1))
              |> Enum.sort_by(fn {k, _v} -> k end)
              |> Enum.map(fn {_k, v} -> v end)
              |> hd() }
  end

  edges = Enum.concat([
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmin end),
      Enum.filter(grid, fn %{coord: {x, _}} -> x == xmax end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymin end),
      Enum.filter(grid, fn %{coord: {_, y}} -> y == ymax end)
    ])
    |> Enum.flat_map(fn %{closest: xy} -> xy end)
    |> Enum.uniq()

  grid
  |> Enum.reject(fn %{closest: xy} -> Enum.count(xy) != 1 end)
  |> Enum.map(fn %{closest: [xy]} -> xy end)
  |> Enum.reject(& Enum.member?(edges, &1))
  |> Enum.group_by(& &1)
  |> Enum.map(fn {_k, v} -> Enum.count(v) end)
  |> Enum.max()
end

IO.puts "Part 1: #{part1.()}"

part2 = fn ->
  grid = for x <- xmin .. xmax, y <- ymin .. ymax, do: {x, y}
  grid
  |> Enum.map(fn xy -> Enum.map(coords, & manhattan.(&1, xy)) |> Enum.sum() end)
  |> Enum.count(fn x -> x < 10000 end)
end

IO.puts "Part 2: #{part2.()}"