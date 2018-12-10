parse_point = fn line ->
  [x, y, vx, vy] =
    line
    |> String.split(~r/[a-z=<>, \n]/, trim: true)
    |> Enum.map(& (elem(Integer.parse(&1), 0)))
  %{pos: {x, y}, vel: {vx, vy}}
end

manhattan = fn {x1, y1}, {x2, y2} -> abs(x2 - x1) + abs(y2 - y1) end

points = Enum.map(File.stream!("day10.txt"), parse_point)

propagate = fn %{:pos => {x, y}, :vel => {vx, vy}} -> %{pos: { x + vx, y + vy }, vel: { vx, vy }} end

print_points = fn points ->
  {xmin, xmax} = Enum.map(points, fn %{:pos => {x, _}} -> x end) |> Enum.minmax()
  {ymin, ymax} = Enum.map(points, fn %{:pos => {_, y}} -> y end) |> Enum.minmax()

  print_lines = List.duplicate(List.duplicate(?., xmax - xmin + 1) ++ '\n', ymax - ymin + 1)
  points
  |> Enum.reduce(print_lines, fn %{:pos => {x, y}}, lines -> List.update_at(lines, y - ymin, fn line -> List.replace_at(line, x - xmin, ?#) end) end)
end

score = fn points ->
  
end

part1 = fn ->

end