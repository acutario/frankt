# We must ensure that the Frankt action modules are properly loaded. I don't
# really know if this could be done in a better way but, until I find out, this
# works fine.
Code.ensure_loaded(Frankt.TestApplication.FranktActions)

# Configure and start our test application so it is accepting connection before
# starting the tests.
Application.put_env(
  :frankt,
  Frankt.TestApplication.Endpoint,
  pubsub: [name: Frankt.TestApplication.PubSub, adapter: Phoenix.PubSub.PG2]
)

Frankt.TestApplication.start(:normal, [])

# Run the test suite
ExUnit.start()
