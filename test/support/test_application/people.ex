defmodule Frankt.TestApplication.People do
  alias Frankt.TestApplication.People.User

  @users [
    %User{name: "Bret Slater", gender: "male"},
    %User{name: "Annamarie Herrera", gender: "female"},
    %User{name: "Isabel Fry", gender: "female"},
    %User{name: "Jamila Cohen", gender: "female"},
    %User{name: "Blair Roy", gender: "male"}
  ]

  def filter_users(params \\ %{}) do
    @users
    |> filter_by_name(params)
    |> filter_by_gender(params)
  end

  defp filter_by_name(users, %{"name" => name}) when name != "" do
    downcased_name = String.downcase(name)

    Enum.filter(users, fn user ->
      user.name
      |> String.downcase()
      |> String.contains?(downcased_name)
    end)
  end

  defp filter_by_name(users, _), do: users

  defp filter_by_gender(users, %{"gender" => gender}) when gender != "" do
    Enum.filter(users, &Kernel.==(&1.gender, gender))
  end

  defp filter_by_gender(users, _), do: users
end
