# Concepts

Frankt works around just three main concepts: triggers, responses and actions. This guide explains how they fit together.

## Triggers

Frankt is designed to enhance the existing HTML of your application. This is achieved by adding some data attributes known as triggers into HTML elements.

```html
<button data-frankt-action="example:say-hello">
  Say hello
</button>
```

In the previous example, the `data-frankt-action` data attribute ties the button to Frankt. Clicking on the button triggers Frankt event and sends the `example:say-hello` message to the backend.

## Responses

When the backend receives a message from the client, it is expected to run a response. Responses also receive the parameters sent by the client.

The backend can do anything in responses: query the database, update schemas, render templates, start processes, send messages to other processes, etc.

Every response automatically returns a `{:noreply, socket}` tuple to inform the client that the execution has finished. Optionally, responses can also push one or more actions to be executed in the client.
Keep in mind that actions don't have to be pushed at the end of the response, they can be pushed from anywhere. In fact, the best approach is to push actions to the client as soon as possible in order to produce the quickest feedback possible.

## Actions

As we've just seen, responses can push actions to be executed by the client. Actions are identified by their name and are usualy accompanied by some parameters.

Frankt currently supports 5 different actions, but we expect this list to keep growing.

### `redirect`

This action redirects the client to the target path.

  ```elixir
  push(socket, "redirect", %{
    target: home_path(MyApp.Endpoint, :index),
  })
  ```

### `replace_with`

This actions replaces the target element with the given HTML. You can reuse your existing Phoenix templates by calling `Phoenix.View.render_to_string/3`.

  ```elixir
  push(socket, "replace_with", %{
    target: "#my-index-table",
    html: Phoenix.View.render_to_string(MyApp.IndexView, "table.html", []),
  })
  ```

### `append`

This action appends the given HTML after the target element. As with every other action, you can reuse your existing Phoenix templates.

  ```elixir
  push(socket, "append", %{
    target: "#flash-container",
    html: Phoenix.View.render_to_string(MyApp.FlashView, "flash_msg.html", message: "Hello from Frankt"),
  })
  ```

### `prepend`

This action works exactly as `append`, but the given HTML will be put before the target element instead of after.

### `mod_class`

This action modifies the class list of the target elements.

  ```elixir
  push(socket, "mod_class", %{
    action: "add", # Or "toggle" or "remove"
    target: ".my-class",
    klass: "selected",
  })
  ```
