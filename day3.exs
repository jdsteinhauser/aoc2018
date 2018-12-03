file = File.stream!("day3.txt")

parse_claim = fn line ->
  line
  |> String.split(~r/[#@,:x\n ]/, trim: true)
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(& elem(&1,0))
end  

part1 = fn ->
  file
  |> Enum.map(&parse_claim.(&1))
  |> Enum.flat_map(fn [claim, left, top, width, height] -> 
        for x <- left..left+width-1, y <- top..top+height-1, do: {Integer.to_string(claim), x, y} end)
  |> Enum.reduce(%{}, fn {claim, x, y}, acc -> Map.update(acc, {x,y}, [claim], &[claim | &1]) end)
  # |> Enum.each(fn {{x, y}, claims} -> IO.puts "#{x},#{y}: #{claims}" end)
  |> Enum.count(fn {_k,v} -> Enum.count(v) > 1 end)
end

IO.puts "Part 1: #{part1.()}"