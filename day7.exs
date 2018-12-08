lines = File.stream!("day7.txt")

parse_line = fn str ->
  chars = String.to_charlist(str)
  %{pre: Enum.at(chars, 5), step: Enum.at(chars,36)}
end

tasks = 
  lines
  |> Enum.map(parse_line)
  |> Enum.reduce(Map.new(?A..?Z, & {&1, []}), 
                 fn %{:pre => pre, :step => step},
                 acc -> Map.update(acc, step, [pre], &[pre | &1]) end)

next_task_id = fn done, remaining -> 
  case Enum.filter(remaining, fn {_k, v} -> Enum.all?(v, & Enum.member?(done, &1)) end) do
    [] -> {:error, nil}
    id -> {:ok, Enum.map(id, & elem(&1,0)) |> Enum.sort() |> hd()}
  end
end

part1 = fn
  _f, done, remaining when map_size(remaining) == 0 -> to_string done
  f, done, remaining -> 
    {:ok, id} = next_task_id.(done, remaining)
    f.(f, done ++ [id], Map.delete(remaining, id))
end

IO.puts("Part 1: #{part1.(part1, [], tasks)}")

part2 = fn
  _f, workers, remaining when map_size(remaining) == 0 -> Enum.map(workers, & &1[:time]) |> Enum.max()
  f, workers, remaining ->
    chosen_worker = Enum.min_by(workers, & &1[:time])
    done = Enum.flat_map(workers, (& if &1[:time] > chosen_worker[:time], do: Enum.drop(&1[:done], 1), else: &1[:done] ))
    case next_task_id.(done, remaining) do
      {:ok, task_id} ->
        f.(f, List.update_at(workers,
                             chosen_worker[:id] - 1,
                             fn %{:id => id, :time => time, :done => done} -> 
                                %{id: id, time: time + task_id - 4, done: [task_id | done]} end),
           Map.delete(remaining, task_id))
      {:error, _} ->      # There are no remaining tasks that can be done at this time. Advance time.
        next_time =
          workers
          |> Enum.reject(& &1[:time] == chosen_worker[:time])
          |> Enum.map(& &1[:time])
          |> Enum.sort()
          |> List.first()
        f.(f, Enum.map(workers, fn worker -> Map.update!(worker, :time, & max(&1, next_time)) end), remaining)
    end
end

workers = 1..5 |> Enum.map(& %{id: &1, time: 0, done: []})

IO.puts("Part 2: #{part2.(part2, workers, tasks)}")