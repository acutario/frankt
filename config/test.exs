use Mix.Config

config :frankt, Frankt.TestApplication.Endpoint,
  pubsub: [name: Frankt.TestApplication.PubSub, adapter: Phoenix.PubSub.PG2]
