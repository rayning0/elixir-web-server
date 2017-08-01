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
			
		%{ method: method,
			 path: path,
			 resp_body: "",
			 status: nil
		 }
	end

	def route(conv) do
		route(conv, conv.method, conv.path)
	end

	def route(conv, "GET", "/wildthings") do
		%{ conv | status: 200, resp_body: "Lions, Tigers, Bears" }
	end

	def route(conv, "GET", "/bears") do
		%{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
	end

	def route(conv, "GET", "/bears/" <> id) do
		%{ conv | status: 200, resp_body: "Bear #{id}" }		
	end

	def route(conv, "DELETE", "/bears/" <> _id) do
		%{ conv | status: 403, resp_body: "You may not delete a bear" }		
	end

	def route(conv, _method, path) do
		%{ conv | status: 404, resp_body: "No #{path} here!"}
	end

	def format_response(conv) do
		# Use values in map to make HTTP response string
		"""
		HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
		Content-Type: text/html
		Content-Length: 20

		#{conv.resp_body}
		"""
	end

	defp status_reason(code) do
		%{
			200 => "OK",
			201 => "Created",
			401 => "Unauthorized",
			403 => "Forbidden",
			404 => "Not Found",
			500 => "Internal Server Error"
		}[code]
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
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response