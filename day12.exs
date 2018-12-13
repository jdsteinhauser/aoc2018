lines = File.stream!("day12.txt")

init_state = 
  lines
  |> Enum.at(0)
  |> String.trim()
  |> String.to_charlist()
  |> Enum.drop(15)

transforms = 
  lines
  |> Enum.drop(2)
  |> Enum.map(& String.split(&1, ~r/[ =>\n]/, trim: true))
  |> Map.new(fn [k,v] -> { k, String.to_charlist(v) } end)

next_gen = fn gen ->
  '....' ++ gen ++ '....'
  |> Enum.chunk_every(5, 1, :discard)
  |> Enum.map(&to_string/1)
  |> Enum.map(& Map.fetch!(transforms, &1))
end

gen_stream = Stream.iterate(init_state, next_gen) |> Stream.with_index()


pot_sum = fn {pots, idx} -> 
  pots
  |> Enum.with_index(idx * -2)
  |> Enum.filter(fn {x, _idx} -> x == '#' end)
  |> Enum.map(& elem(&1, 1))
  |> Enum.sum()
end

part1 =
  gen_stream
  |> Enum.at(20)
  |> pot_sum.()

part2 = fn -> 
  # Assuming convergence on increase around 200 generations
  [x198, x199] =
    gen_stream
    |> Stream.map(pot_sum)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.at(200)
  x199 + (50_000_000_000 - 201) * (x199 - x198)
end

IO.puts "Part 1: #{part1}"
IO.puts "Part 2: #{part2.()}"