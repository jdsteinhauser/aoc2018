directions = [:north, :east, :south, :west]

def turn = fn
  :left, dir -> Enum.at(directions, rem(Enum.find_index(dir) + 3, 4))
  :straight, dir -> dir
  :right, dir -> Enum.at(directions, rem(Enum.find_index(dir) + 1, 4))
end

def orient_cart = fn
  cart, ?- -> cart
  cart, ?| -> cart
  cart, ?/ when cart[:direction] == :north -> Map.update!(cart, :direction, :east)
  cart, ?/ when cart[:direction] == :south -> Map.update!(cart, :direction, :west)
  cart, ?/ when cart[:direction] == :west  -> Map.update!(cart, :direction, :south)
  cart, ?/ when cart[:direction] == :east  -> Map.update!(cart, :direction, :north)
  cart, ?\ when cart[:direction] == :north -> Map.update!(cart, :direction, :west)
  cart, ?\ when cart[:direction] == :south -> Map.update!(cart, :direction, :east)
  cart, ?\ when cart[:direction] == :west  -> Map.update!(cart, :direction, :north)
  cart, ?\ when cart[:direction] == :east  -> Map.update!(cart, :direction, :south)
  cart, ?+ when cart[:next_turn] == :left  -> cart |> Map.update!(:direction, ) |> Map.update!(:next_turn, :right)
end