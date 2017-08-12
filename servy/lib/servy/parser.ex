defmodule Servy.Parser do
  alias Servy.Conv
  # alias Servy.Conv, as: Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)

    IO.inspect header_lines
    IO.puts ""

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers, key, value)
    end)
  end

  # def parse_headers([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_headers(tail, headers)
  # end

  # def parse_headers([], headers), do: headers

  # pattern match: only run method if "Content-Type" is "application/x-www-form-urlencoded"
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  # Default for all other Content-Types:
  def parse_params(_, _), do: %{}
end
