# We must ensure that the Frankt action modules are properly loaded. I don't
# really know if this could be done in a better way but, until I find out, this
# works fine.
Code.ensure_loaded(Frankt.TestApplication.FranktActions)

# Our Phoenix test application must be started before running the tests.
Frankt.TestApplication.start(:normal, [])

ExUnit.start()
