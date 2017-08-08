defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts "Head: #{head}, Tail: #{inspect(tail)}"
    loopy(tail)
  end

  def loopy([]), do: IO. puts "Done!"
end

Recurse.loopy([1, 2, 3, 4, 5])

# OUTPUT:

# Head: 1, Tail: [2, 3, 4, 5]
# Head: 2, Tail: [3, 4, 5]
# Head: 3, Tail: [4, 5]
# Head: 4, Tail: [5]
# Head: 5, Tail: []
# Done!