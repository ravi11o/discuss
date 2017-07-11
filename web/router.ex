defmodule Discusss.Router do
  use Discusss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discusss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discusss do
    pipe_through :browser # Use the default browser stack

    resources "/", TopicController do 
      resources "/comments", CommentController
    end
    
    
  end

  scope "/auth", Discusss do
    pipe_through :browser

    get "/logout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discusss do
  #   pipe_through :api
  # end
end
