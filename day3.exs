parse_claim = fn line ->
  line
  |> String.split(~r/[#@,:x\n ]/, trim: true)
  |> Enum.map(& (Integer.parse(&1) |> elem(0)))
end  

claims = Enum.map(File.stream!("day3.txt"), parse_claim)

grid = 
  claims
  |> Enum.flat_map(fn [claim, left, top, width, height] -> 
        for x <- left..left+width-1, y <- top..top+height-1, do: {claim, x, y} end)
  |> Enum.reduce(%{}, fn {claim, x, y}, acc -> Map.update(acc, {x,y}, [claim], &[claim | &1]) end)

part1 = fn -> Enum.count(grid, fn {_k,v} -> Enum.count(v) > 1 end) end

IO.puts "Part 1: #{part1.()}"

part2 = fn ->
  singles = 
    grid
    |> Enum.filter(fn {_k,v} -> Enum.count(v) == 1 end)
    |> Enum.group_by(fn {_k,[v]} -> v end, fn _ -> true end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v, & &1)} end)
    |> Map.new()

  claims
  |> Enum.find(fn [claim, _, _, w, h] -> Map.get(singles, claim) == w * h end)
  |> hd()
  |> Integer.to_string()
end

IO.puts "Part 2: #{part2.()}"