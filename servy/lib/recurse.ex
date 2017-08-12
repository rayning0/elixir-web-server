defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts "Head: #{head}, Tail: #{inspect(tail)}"
    loopy(tail)
  end

  def loopy([]), do: IO. puts "Done!"

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []

  # Easiest way to do "triple":
  # Enum.map(array, &(&1 * 3))

  # your own version of Enum.map
  def my_map([head | tail], f) do
    [f.(head) | my_map(tail, f)]
  end

  def my_map([], _), do: []
end

Recurse.loopy([1, 2, 3, 4, 5])

# OUTPUT:

# Head: 1, Tail: [2, 3, 4, 5]
# Head: 2, Tail: [3, 4, 5]
# Head: 3, Tail: [4, 5]
# Head: 4, Tail: [5]
# Head: 5, Tail: []
# Done!

nums = [1, 2, 3, 4, 5]
IO.inspect Recurse.triple(nums)
IO.inspect Recurse.my_map(nums, &(&1 * 4))
