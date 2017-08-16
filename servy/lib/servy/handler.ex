defmodule Servy.Handler do
  alias Servy.Conv
  alias Servy.BearController

  @moduledoc "Handles HTTP requests"
  @pages_path Path.expand("../../pages", __DIR__) #constant: absolute path of current file

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]  # number is arity of each function
  #import Servy.Plugins  -- or import ALL functions in module
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2, markdown_to_html: 1]

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
    |> Conv.put_conv_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Lions, Tigers, Bears" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  # one generic route function that handles routes like this:
  #   /pages/contact
  #   /pages/faq
  #   /pages/any-other-page

  def route(%Conv{method: "GET", path: ("/pages/" <> page)} = conv) do
    # regex = ~r{\/pages\/(?<page>[\w'-]+)}
    # page = Regex.named_captures(regex, path)["page"]

    files = File.ls("pages") |> elem(1)

    # If page is HTML, returns it
    # If page is Markdown, converts it to HTML first
    ext =
      cond do
        Enum.any?(files, fn(file) -> file =~ ~r/#{page}.html/ end) ->
          ".html"
        Enum.any?(files, fn(file) -> file =~ ~r/#{page}.md/ end) ->
          ".md"
        true ->
          ""
      end

    conv = @pages_path
           |> Path.join(page <> ext)
           |> File.read
           |> handle_file(conv)

    if ext == ".md" do
      conv |> markdown_to_html
    else
      conv
    end
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    # Use values in map to make HTTP response string
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{Conv.format_response_headers(conv)}\r
    #{conv.resp_body}
    """
  end
end
