defmodule Servy.BearController do
  alias Servy.Wildthings

  def index(conv) do
    items = 
      Wildthings.list_bears()
      |> Enum.filter(fn(b) -> b.type == "Grizzly" end)
      |> Enum.sort(fn(b1, b2) -> b1.name <= b2.name end)
      |> Enum.map(fn(b) -> "<li>#{b.name} - #{b.type}</li>" end)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear, #{name}!" }
              # resp_body: "Created a #{params["type"]} bear, #{params["name"]}!" }
  end

end
