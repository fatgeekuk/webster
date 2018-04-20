# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :webster_web,
  namespace: WebsterWeb

# Configures the endpoint
config :webster_web, WebsterWebWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XByJM4usc6y0WXABHa965Nac/EXUrwhFnj35CUjZAYk5WPN2Cdz2M9gfgKvOPO5+",
  render_errors: [view: WebsterWebWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebsterWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
