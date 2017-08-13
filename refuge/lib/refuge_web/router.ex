defmodule RefugeWeb.Router do
  use RefugeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RefugeWeb do
    pipe_through :browser # Use the default browser stack

    resources "/bears", BearController

    # get "/", PageController, :index
    # get "/bears", BearController, :index
    # get "/bears/new", BearController, :new
    # get "/bears/:id", BearController, :show
    # get "/bears/:id/edit", BearController, :edit
    # post "/bears", BearController, :create
    # put "/bears/:id", BearController, :update
    # patch "/bears/:id", BearController, :update
    # delete "/bears/:id", BearController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", RefugeWeb do
  #   pipe_through :api
  # end
end
