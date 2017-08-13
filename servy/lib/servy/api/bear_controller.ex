defmodule Servy.Api.BearController do
  def index(conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Poison.encode!

    %{ conv | status: 200, resp_body: json, resp_content_type: "application/json" }
  end
end
