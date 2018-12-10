num_players = 404
last_marble_points = 71852

next = fn
  { [], current, [] } -> { [], current, [] }
  { left, current, [] } ->
    right = Enum.reverse([current | left])
    { [], hd(right), tl(right) }
  { left, current, right } -> { [current | left], hd(right), tl(right) }
end

previous = fn
  { [], current, right } ->
    left = Enum.reverse([current | right])
    { tl(left), hd(left), [] }
  { left, current, right } -> { tl(left), hd(left), [current | right] }
end

add_marble = fn x, marbles ->
  { left, current, right } = next.(marbles)
  { [current | left], x, right }
end  

remove_marble = fn marbles ->
  { left, current, right } = 
    Enum.reduce(1..7, marbles, fn _, ms -> previous.(ms) end)
  { current, {left, hd(right), tl(right) }}
end

place_marble = fn 
  x, %{:marbles => marbles, :players => players} when rem(x, 23) == 0 -> 
    { removed, new_marbles } = remove_marble.(marbles)
    points = x + removed
    %{points: removed, marbles: new_marbles, players: Map.update(players, rem(x - 1, num_players) + 1, points, & &1 + points)}
  x, %{:marbles => marbles, :players => players} ->
    %{points: 0, marbles: add_marble.(x, marbles), players: players}
end

part1 = fn ->
  final_state =
    1..last_marble_points
    |> Enum.reduce(%{marbles: {[], 0, []}, players: %{}}, fn n, acc -> place_marble.(n, acc) end)
  Enum.max_by(final_state[:players], fn {_k, v} -> v end)
end

part2 = fn ->
  final_state =
    1..last_marble_points * 100
    |> Enum.reduce(%{marbles: {[], 0, []}, players: %{}}, fn n, acc -> place_marble.(n, acc) end)
  Enum.max_by(final_state[:players], fn {_k, v} -> v end)
end

IO.puts "Part 1: #{elem(part1.(), 1)}"
IO.puts "Part 2: #{elem(part2.(), 1)}"