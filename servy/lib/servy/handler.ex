defmodule Servy.Handler do

	alias Servy.Conv

	@moduledoc "Handles HTTP requests."
	@pages_path Path.expand("../../pages", __DIR__)	#constant: absolute path of current file

	import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]  # number is arity of each function
	#import Servy.Plugins  -- or import ALL functions in module
	import Servy.Parser, only: [parse: 1]
	import Servy.FileHandler, only: [handle_file: 2]

	require Logger

	@doc "Transforms request into a response"
	def handle(request) do
		# conv = parse(request)
		# conv = route(conv)
		# format_response(conv)

		request
		|> parse
		|> rewrite_path
		|> log
		|> route
		|> track
		|> format_response
	end

	def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
		%{ conv | status: 200, resp_body: "Lions, Tigers, Bears" }
	end

	def route(%Conv{method: "GET", path: "/bears"} = conv) do
		%{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
	end

	def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
		@pages_path
		|> Path.join("form.html")
		|> File.read
		|> handle_file(conv)
	end

	def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
		%{ conv | status: 200, resp_body: "Bear #{id}" }		
	end

	def route(%Conv{method: "GET", path: "/about"} = conv) do
		@pages_path
		|> Path.join("about.html")
		|> File.read
		|> handle_file(conv)
	end

	# define one generic route function that handles arbitrary requests:
	# 	/pages/contact
	# 	/pages/faq
	# 	/pages/any-other-page
	def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
		# regex = ~r{\/pages\/(?<page>[\w'-]+)}
		# page = Regex.named_captures(regex, path)["page"]
		@pages_path
		|> Path.join(page <> ".html")
		|> File.read
		|> handle_file(conv)
	end

	# def route(%Conv{method: "GET", path: "/about"} = conv) do
	# 	file =
	# 		Path.expand("../../pages", __DIR__)	#absolute path of current file
	# 		|> Path.join("about.html")

	# 	case File.read(file) do
	# 		{:ok, content} ->
	# 			%{ conv | status: 200, resp_body: content }

	# 		{:error, :enoent} ->
	# 			%{ conv | status: 404, resp_body: "File not found" }

	# 		{:error, reason} ->
	# 			%{ conv | status: 500, resp_body: "File error: #{reason}" }
	# 	end
	# end

	def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
		%{ conv | status: 403, resp_body: "You may not delete a bear" }		
	end

	def route(%Conv{path: path} = conv) do
		%{ conv | status: 404, resp_body: "No #{path} here!"}
	end

	def format_response(%Conv{} = conv) do
		# Use values in map to make HTTP response string
		"""
		HTTP/1.1 #{Conv.full_status(conv)}
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
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears?id=5 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /pages/any_other-page HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)
