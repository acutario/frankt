defmodule Frankt.TestApplicationWeb.ChatView do
  use Frankt.TestApplicationWeb, :view

  def frankt_channel(_assigns), do: tag(:meta, name: "channel", content: "chat:lobby")
end
