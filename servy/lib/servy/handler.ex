defmodule Servy.Handler do
	def handle(request) do
		# conv = parse(request)
		# conv = route(conv)
		# format_response(conv)

		request
		|> parse
		|> log
		|> route
		|> format_response
	end

	def log(conv), do: IO.inspect conv

	def parse(request) do
		# Parse request string into map
		# first_line = request |> String.split("\n") |> List.first
		# [method, path, _] = String.split(first_line, " ")

		[method, path, _] =
			request
			|> String.split("\n")
			|> List.first
			|> String.split(" ")
			
		%{method: method, path: path, resp_body: ""}
	end

	def route(conv) do
		route(conv, conv.method, conv.path)
	end

	def route(conv, "GET", "/wildthings") do
		%{ conv | resp_body: "Lions, Tigers, Bears" }
	end

	def route(conv, "GET", "/bears") do
		%{ conv | resp_body: "Teddy, Smokey, Paddington" }
	end

	def format_response(conv) do
		# Use values in map to make HTTP response string
		"""
		HTTP/1.1 200 OK
		Content-Type: text/html
		Content-Length: 20

		#{conv.resp_body}
		"""
	end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response