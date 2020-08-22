defmodule WebsterWebWeb.Router do
  use WebsterWebWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://frontend:5000"
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", WebsterWebWeb do
    pipe_through :api

    post "/upload-signature", UploadSignerController, :create
  end
end
