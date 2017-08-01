defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)

    %Conv{ 
       method: method, 
       path: path,
       params: params
     }
  end

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

end





