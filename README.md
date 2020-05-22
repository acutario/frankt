# <img src="logo.png?raw=true" width="30" height="42" alt="Frankt"> Frankt
> **Run client side actions from Phoenix**

[![Build Status](https://travis-ci.com/acutario/frankt.svg?branch=master)](https://travis-ci.com/acutario/frankt)

Frankt is a small package that allows you to run client side actions from your [Phoenix Framework][1] project.

## ⚠ Frankt is now deprecated ⚠

Frankt has worked great for us and solved a lot of problems, but it is not maintaned anymore and we don't recommend using it in production.

Since we initially created Frankt, we have discovered better approaches to provide the same functionality.  
- [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) fulfills the same role that Frankt did, and also works with websockets. But it is maintained and developed by the Phoenix creators and the entire Elixir community.
- [Intercooler.js](https://github.com/bigskysoftware/intercooler-js) and [Unpoly](https://github.com/unpoly/unpoly) are minimal and stable libraries that can provide dynamism in the client while still using our beloved controllers. Those libraries can be used with any framework and language, so they have really strong communities behind them.

## How does it work?
Contrary to other solutions Frankt only provides a thin layer over Phoenix channels. If you already know how Phoenix channels work, there are no new concpets to learn. **You can use your existing code**, you have access to your templates, business logic and any other resource of your application.

For more detailed information and some examples take a look at [the official documentation and guides][2].

## Installing Frankt

Frankt is available in [hex.pm][3].

To install Frankt on your project add it as a dependency on your `mix.exs`:

```elixir
def deps do
  [
    # Your other project dependencies
    {:frankt, "~> 1.0.0"},
  ]
end
```

## Contributing to Frankt

Frankt is an open-source project with [MIT license][4] from [Acutario][5].

If you have a question about Frankt or want to report a bug or an improvement, please take a look at our [issue tracker][6].
[Pull requests][7] are also more than welcome.

Keep in mind that interactions in this project must follow the [Elixir Code of Conduct][8].


[1]: https://github.com/phoenixframework/phoenix
[2]: https://hexdocs.pm/frankt
[3]: https://hex.pm/packages/frankt
[4]: https://github.com/acutario/frankt/blob/master/LICENSE
[5]: https://www.acutar.io/
[6]: https://github.com/acutario/frankt/issues
[7]: https://github.com/acutario/frankt/pulls
[8]: https://github.com/elixir-lang/elixir/blob/master/CODE_OF_CONDUCT.md
