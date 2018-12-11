parse_point = fn line ->
  [x, y, vx, vy] =
    line
    |> String.split(~r/[a-z=<>, \n]/, trim: true)
    |> Enum.map(& (elem(Integer.parse(&1), 0)))
  %{pos: {x, y}, vel: {vx, vy}}
end

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
  {xmin, xmax} = Enum.map(points, fn %{:pos => {x, _}} -> x end) |> Enum.min_max()
  {ymin, ymax} = Enum.map(points, fn %{:pos => {_, y}} -> y end) |> Enum.min_max()
  (xmax - xmin) * (ymax - ymin)
end

find_msg = fn ->
  Stream.iterate(points, & Enum.map(&1,propagate))
  |> Stream.drop(1)
  |> Enum.reduce_while({0, score.(points), points}, fn x, {iter, min_so_far, best} -> 
      current_score = score.(x)
      if current_score <= min_so_far, do: {:cont, {iter + 1, current_score, x}}, else: {:halt, {iter, best}} end)
end

{time, points} = find_msg.()
IO.puts "Part 1:\n#{print_points.(points)}"
IO.puts "Part 2: #{time} seconds"