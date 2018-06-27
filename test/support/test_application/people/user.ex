defmodule Frankt.TestApplication.People.User do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:gender, :string)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:gender, :name])
    |> validate_required([:gender, :name])
  end
end
