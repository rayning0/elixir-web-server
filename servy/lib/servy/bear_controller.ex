defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearView
  import Servy.View, only: [render: 3]

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2) # number is arity
      # |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
      # |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      # |> Enum.map(fn(b) -> bear_item(b) end)
      #     OR
      # |> Enum.filter(&Bear.is_grizzly(&1))
      # |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
      # |> Enum.map(&bear_item(&1))

    %{ conv | status: 200, resp_body: BearView.index(bears) } # precompiled template
    # render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    # %{ conv | status: 200, resp_body: BearView.show(bear) }
    render(conv, "show.eex", bear: bear)
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
