# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :frankt,
  namespace: Frankt.TestApplication

# Configures the endpoint
config :frankt, Frankt.TestApplication.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cOybsz5VQM1ZWOIbRkiuWQ3Aj2D/XqFe7CUgUqUzs3gCff+zDCeoeydxqYCIOD6V",
  render_errors: [view: Frankt.TestApplication.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestApplication.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
