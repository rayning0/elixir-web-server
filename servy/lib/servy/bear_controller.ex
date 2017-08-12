defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items = 
      Wildthings.list_bears()
      # |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
      # |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      # |> Enum.map(fn(b) -> bear_item(b) end)
      #     OR
      # |> Enum.filter(&Bear.is_grizzly(&1))
      # |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
      # |> Enum.map(&bear_item(&1))
      #     OR
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2) # number is arity
      |> Enum.map(&bear_item/1)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear, #{name}!" }
              # resp_body: "Created a #{params["type"]} bear, #{params["name"]}!" }
  end

  def delete(conv, _params) do
    %{ conv | status: 403, resp_body: "You may not delete a bear" }
  end

end

# > Enum.map([1, 2, 3], fn(x) -> x * 3 end)
# [3, 6, 9]
# Here's the shorthand way using the & capture operator:

# > Enum.map([1, 2, 3], &(&1 * 3))
# [3, 6, 9]

# Notice we surrounded the expression &1 * 3 with parentheses and captured that expression. The result of &(&1 * 3) is an anonymous function.

# Alternatively, you can capture the expression as an anonymous function, bind it to a variable, and then pass the function to the higher-order map function:

# > triple = &(&1 * 3)

# > Enum.map([1, 2, 3], triple)
# [3, 6, 9]

# > repeat = &String.duplicate(&1, &2)

# > repeat.("Yo", 2)
# "YoYo"

# > repeat = &String.duplicate/2

# > repeat.("Go", 3)
# "GoGoGo"
