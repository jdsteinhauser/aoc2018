serial_number = 4172

calc_power = fn x, y, serial ->
  rack_id = x + 10
  rack_id * y + serial
  |> (& &1 * rack_id).()
  |> Integer.digits()
  |> Enum.at(-3)
  |> (& &1 - 5).()  
end

grid = Enum.map(1..300, fn x -> Enum.map(1..300, fn y -> calc_power.(x,y, serial_number) end) end)

largest_segment = fn grid, size ->
  for x <- 1..(300-size+1), y <- 1..(300-size+1) do
    value = grid |> Enum.slice(x-1, size) |> Enum.flat_map(fn ys -> Enum.slice(ys, y-1, size) end) |> Enum.sum()
    {x, y, size, value}
  end
  |> Enum.max_by(fn {_,_,_,value} -> value end)
end

IO.puts "Part 1: #{largest_segment.(grid, 3)}"

part2 = 
  1..300
  |> Enum.map(fn size -> largest_segment.(grid, size) end)
  |> Enum.max_by(fn {_,_,_,value} -> value end)

IO.puts "Part 2: #{part2}"