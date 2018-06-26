defmodule Frankt.Handler do
  @moduledoc """
  Provides useful helpers for Frankt handlers.

  To use this functions you can `import Frankt.Handler` in your own module.
  """

  @doc """
  Renders the given template as an HTML string.

  This function renders the given template as an HTML string and combines the given assigns with
  the socket assigns, in a similar way as `Phoenix.Controller` does.

  The string returned by this function can be used in Frankt actions such as `replace-with`.
  """
  def render(socket, view, template, assigns \\ []) when is_list(assigns) do
    Phoenix.View.render_to_string(view, template, Enum.into(socket.assigns, assigns))
  end
end
