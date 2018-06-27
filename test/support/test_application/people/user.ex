defmodule Frankt.TestApplication.People.User do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:gender, :string)
    field(:email, :string)
    field(:has_email?, :boolean, virtual: true, default: false)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:gender, :name, :email, :has_email?])
    |> validate_required([:gender, :name])
  end
end
