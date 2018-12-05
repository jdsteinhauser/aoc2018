data = File.read!("day5.txt") |> String.trim() |> String.to_charlist()

reducer = fn 
  x, [] -> [x]
  x, [last | rest] -> if abs(x - last) == 32, do: rest, else: [x, last | rest]
end

part1 = data |> Enum.reduce([], reducer) |> Enum.count()

IO.puts "Part 1: #{part1}"

part2 =
  ?A..?Z
  |> Enum.map(fn x -> 
      data
      |> Enum.reject(& &1 == x or &1 == x + 32)
      |> Enum.reduce([], reducer)
      |> Enum.count() end)
  |> Enum.min()

IO.puts "Part 2: #{part2}"