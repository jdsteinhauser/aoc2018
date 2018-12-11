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
  {xmin, xmax} = Enum.map(points, fn %{:pos => {x, _}} -> x end) |> Enum.min_max()
  {ymin, ymax} = Enum.map(points, fn %{:pos => {_, y}} -> y end) |> Enum.min_max()

  print_lines = List.duplicate(List.duplicate(?., xmax - xmin + 1) ++ '\n', ymax - ymin + 1)
  Enum.reduce(points, print_lines, 
              fn %{:pos => {x, y}}, lines -> 
                  List.update_at(lines, y - ymin, 
                  fn line -> List.replace_at(line, x - xmin, ?#) end) end)
end

score = fn points ->
  count = Enum.count(points)
  dists = for a <- 0 .. count - 2, b <- a + 1 .. count - 1, do: manhattan.(Enum.at(points, a)[:pos], Enum.at(points, b)[:pos])
  IO.puts Enum.sum(dists)
end

part1 = fn ->
  states = Enum.scan(1..5, points, fn _, pts -> Enum.map(pts, propagate) end)
  Enum.each(states, score)
  List.last(states)
end

IO.puts "#{print_points.(part1.())}"