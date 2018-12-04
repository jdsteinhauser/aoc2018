alias NaiveDateTime, as: NDT

parse_line = fn str ->
  %{date: String.slice(str, 1, 16) <> ":00"|> NDT.from_iso8601!(), 
    action: String.slice(str, 18, 2000) |> String.trim() }
end

chunker = fn
  x, [last | rest] ->
    # If it's an hour and a half after the last event, probably a different day
    if NDT.compare(x[:date], NDT.add(last[:date], 5400)) == :gt do 
      {:cont, Enum.reverse([last | rest]), [x]}
    else
      {:cont, [x, last | rest]}
    end
  x, [] -> {:cont, [x]}
end

after_chunk = fn
  [] -> {:cont, []}
  acc -> {:cont, Enum.reverse(acc), []}
end

process_chunk = fn chunk ->
  {id, _} = hd(chunk)[:action] |> String.split(~r/[ #]/, trim: true) |> Enum.at(1) |> Integer.parse()

  chunk
  |> Enum.drop(1)
  |> Enum.chunk_every(2, 2, :discard)
  |> Enum.flat_map(fn [sleep, wake] -> sleep[:date].minute .. wake[:date].minute-1 end)
  |> Enum.map(& {id, &1})
end

data = fn -> 
  "day4.txt"
  |> File.stream!()
  |> Enum.map(parse_line)
  |> Enum.sort_by(& &1[:date], & NDT.compare(&2, &1) == :gt)
  |> Enum.chunk_while([], chunker, after_chunk)
  |> Enum.flat_map(process_chunk)
end

part1 = fn ->
  {guard, minutes} =
    data.()
    |> Enum.group_by(& elem(&1, 0))
    |> Enum.map(fn {k, v} -> {k, Enum.map(v, & elem(&1, 1))} end)
    |> Enum.max_by(fn {_ , v} -> Enum.count(v) end)
  {mode, count} =
    minutes
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.max_by(& elem(&1, 1))

  IO.puts "Guard #{guard} slept at minute #{mode} #{count} times. Answer: #{guard * mode}"
end

part1.()

part2 = fn ->
  {{guard, minute}, times} =
    data.()
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.max_by(fn {_k, v} -> v end)
  IO.puts "Guard #{guard} slept at minute #{minute} #{times} times. Answer: #{guard * minute}"
end

part2.()