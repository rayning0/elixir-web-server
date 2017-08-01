defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts "Head: #{head} Tail: #{inspect(tail)}"
    loopy(tail)
  end
end

Recurse.loopy([1, 2, 3, 4, 5])
