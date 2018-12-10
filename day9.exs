num_players = 10 # 404
last_marble_points = 1618 # 71852
players = 1..num_players |> Map.new(& {&1, 0})

next = fn
  {[], current, [] } ->
    {[], current, [] }
  {left, current, []} ->
    right = Enum.reverse([current | left])
    {[], hd(right), tl(right)}
  {left, current, right} ->
    {[current | left], hd(right), tl(right)}
end

previous = fn
  {[], current, right} ->
    left = Enum.reverse([current | next])
    {tl(left), hd(left, [])}
  {left, current, right} ->
    {tl(left), hd(left), [current | next]}
end



place_marble = fn
  to_place, state when rem(to_place, 23) == 0 ->
    length = Enum.count(state[:board])
    new_current = rem(state[:current_pos] - 7 + length, length)
    {removed, new_board} = List.pop_at(state[:board], new_current)
    player = rem(to_place - 1, num_players) + 1
    IO.puts "@#{to_place}: #{removed + to_place} points scored by Player #{player}"
    state
    |> Map.replace!(:current_pos, new_current)
    |> Map.replace!(:board, new_board)
    |> Map.replace!(:points, removed + to_place)
    |> Map.update!(:players, fn old -> Map.update!(old, player, & &1 + removed + to_place) end)
  to_place, state ->
    new_pos = rem(state[:current_pos] + 1, Enum.count state[:board]) + 1
    state
    |> Map.replace!(:current_pos, new_pos)
    |> Map.update!(:board, & List.insert_at(&1, new_pos, to_place))
    |> Map.replace!(:points, 0)
end

part1 = fn ->
  final_state =
    Stream.interval(1)
    |> Stream.drop(1)
    |> Enum.reduce_while(%{current_pos: 0, board: [0], points: 0, players: players}, 
                        fn n, acc -> 
                          state = place_marble.(n, acc)
                          if state[:points] == last_marble_points, do: {:halt, state}, else: {:cont, state}
                        end)
  Enum.max_by(final_state[:players], fn {_k, v} -> v end)
end

IO.puts "Part 1: #{IO.inspect(part1.())}"