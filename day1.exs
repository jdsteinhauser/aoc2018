elements = Enum.map(File.stream!("day1.txt"), & (Integer.parse(&1) |> elem(0)))

part1 = Enum.sum(elements)

IO.puts "Part 1 Answer: #{part1}"

part2 = elements
  |> Stream.cycle()
  |> Stream.scan(0, & &1 + &2)
  |> Enum.reduce_while([], fn x, acc -> if Enum.member?(acc, x), do: {:halt, x}, else: {:cont, [x | acc]} end)

IO.puts "Part 2 Answer: #{part2}"