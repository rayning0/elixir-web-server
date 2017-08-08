defmodule Servy.Parser do

	alias Servy.Conv
	# alias Servy.Conv, as: Conv

	def parse(request) do
		[top, params_string] = String.split(request, "\n\n")
		[request_line | header_lines] = String.split(top, "\n")
		[method, path, _] = String.split(request_line, " ")
		headers = parse_headers(header_lines, %{})
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

	def parse_headers([head | tail], headers) do
		#IO.puts "Head: #{inspect(head)}, Tail: #{inspect(tail)}"
		[key, value] = String.split(head, ": ")
		#IO.puts "Key: #{inspect(key)}, Value: #{inspect(value)}"
		headers = Map.put(headers, key, value)
		#IO.inspect headers
		parse_headers(tail, headers)
	end

	def parse_headers([], headers), do: headers

	# pattern match: only run method if "Content-Type" is "application/x-www-form-urlencoded"
	def parse_params("application/x-www-form-urlencoded", params_string) do
		params_string |> String.trim |> URI.decode_query
	end

	# Default for all other Content-Types:
	def parase_params(_, _), do: %{}
end