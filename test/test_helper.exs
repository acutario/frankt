# We must ensure that the Frankt action modules are properly loaded. I don't
# really know if this could be done in a better way but, until I find out, this
# works fine.
Code.ensure_loaded(Frankt.TestApplicationWeb.FranktActions)

Frankt.TestApplicationWeb.start(:normal, [])

# Run the test suite
ExUnit.start()
