defmodule Servy.Wildthings do
  alias Servy.Bear
  import Servy.FileHandler, only: [read_json: 1]

  def list_bears do
    Path.expand("../../db", __DIR__)
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")

    # [
    #   %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
    #   %Bear{id: 2, name: "Smokey", type: "Black"},
    #   %Bear{id: 3, name: "Paddington", type: "Brown"},
    #   %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
    #   %Bear{id: 5, name: "Snow", type: "Polar"},
    #   %Bear{id: 6, name: "Brutus", type: "Grizzly"},
    #   %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
    #   %Bear{id: 8, name: "Roscoe", type: "Panda"},
    #   %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
    #   %Bear{id: 10, name: "Kenai", type: "Grizzly"}
    # ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  # is_binary means "is string", since strings are binary
  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
