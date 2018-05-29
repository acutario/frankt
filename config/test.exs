use Mix.Config

config :frankt, Frankt.TestApplication.Endpoint,
  pubsub: [name: Frankt.TestApplication.PubSub, adapter: Phoenix.PubSub.PG2]

config :frankt, Frankt.TestApplication.FranktChannel,
  handlers: [
    frankt_actions: Frankt.TestApplication.FranktActions
  ]
