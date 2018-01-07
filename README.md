# Frankt

### Run client side actions from Phoenix

Frankt is a small package that allows Phoenix applications to run actions on client browsers without writing a single line of JavaScript. Instead, it provides a thin JavaScript layer that triggers responses on the backend and execute the corresponding actions in the client.
Frankt pairs with [Phoenix Channels](https://hexdocs.pm/phoenix/channels.html) to provide a quick, two-way communication with the server.

How does it work? Annotate your HTML with the Frankt action that must be triggered.

```html
<button data-frankt-action="example:say-hello" id="example-frankt-button">
  Say hello
</button>
```

Then write the corresponding response and Frankt will make it alive:

```elixir
defmodule MyApp.Frankt.Example do

  defresponse "example:say-hello", fn _params, socket ->
    # Do whathever work is needed: query the database, update schemas, render templates, etc

    push(socket, "mod_class", %{action: "add", target: "#example-frankt-button", klass: "updated-class"})
  end

end
```

When clicking the button, Frankt will automatically trigger the response in the backend and then
execute the corresponding action in the client. The result would be:

```html
<button data-frankt-action="example:say-hello" id="example-frankt-button" class="updated-class">
  Say hello
</button>
```

You can learn more about how Frankt works by taking a look at our [concepts guide](guides/Concepts.md).

For more complex examples with different actions, form submissions and i18n take a look at our [getting started guide](TODO).

## Installing Frankt

Frankt is available in [hex.pm](https://hex.pm/packages/frankt). The documentation is also available on [hexdocs.pm](https://hexdocs.pm/frankt).

To install Frankt on your project add it as a dependency on your `mix.exs`:

```elixir
def deps do
  [
    # Your project dependencies
    {:frankt, "~> 1.0.0"},
  ]
end
```

## Contributing to Frankt

Frankt is an open-source project with [MIT license](https://github.com/acutario/frankt/blob/master/LICENSE) from [Acutario](https://www.acutar.io/).

If you have a question about Frankt or want to report a bug or an improvement, please take a look at our [issue tracker](https://github.com/acutario/frankt/issues).
[Pull requests](https://github.com/acutario/frankt/pulls) are also more than welcome.

Keep in mind that interactions in this project must follow the [Elixir Code of Conduct](https://github.com/elixir-lang/elixir/blob/master/CODE_OF_CONDUCT.md).
