defmodule Servy.Handler do
  def handle(request) do
    request 
    |> parse 
    |> log
    |> route 
    |> format_response
  end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] =
      request 
      |> String.split("\n") 
      |> List.first    
      |> String.split(" ")

    %{ method: method, path: path, resp_body: "" }
  end

  def route(conv) do
    # TODO: Create a new map that also has the response body:
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  def format_response(conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

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



