defmodule Frankt.TestApplicationWeb.FormView do
  use Frankt.TestApplicationWeb, :view

  import Ecto.Changeset, only: [get_field: 2]

  def gender_options do
    [{"Male", :male}, {"Female", :female}, {"Other", :other}]
  end
end
