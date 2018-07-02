defmodule Frankt.TestApplicationWeb.Router do
  use Frankt.TestApplicationWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Frankt.TestApplicationWeb.Plugs.FakeUserId)
    plug(:put_secure_browser_headers)

    # CSRF protection has been disabled until we figure a way to automate it in Frankt. Until then,
    # implementors must choose to implement it.
    # plug(:protect_from_forgery)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Frankt.TestApplicationWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/greet", GreetController, :index)
    get("/filter", FilterController, :index)
    get("/chat", ChatController, :index)
    resources("/form", FormController, only: [:index, :create])
  end

  # Other scopes may use custom stacks.
  # scope "/api", Frankt.TestApplicationWeb do
  #   pipe_through :api
  # end
end
