defmodule Frankt.TestApplicationWeb.LayoutView do
  use Frankt.TestApplicationWeb, :view

  def frankt_channel(view_module, assigns = %{user_id: user_id}) do
    if function_exported?(view_module, :frankt_channel, 1) do
      view_module.frankt_channel(assigns)
    else
      tag(:meta, name: "channel", content: "frankt:#{user_id}")
    end
  end
end
