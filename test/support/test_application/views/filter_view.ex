defmodule Frankt.TestApplication.FilterView do
  use Frankt.TestApplication, :view

  @form_id "filter-form"
  @frankt_data [action: "filter:filter", target: "##{@form_id}", auto: true]

  def filter_form(conn) do
    gender_options = [{"Male", :male}, {"Female", :female}, {"Other", :other}]

    form_for(conn, nil, [id: @form_id, as: :filters, csrf_token: false], fn form ->
      [
        text_input(form, :name, placeholder: "Name", data: [frankt: @frankt_data]),
        select(form, :gender, gender_options, prompt: "Any", data: [frankt: @frankt_data])
      ]
    end)
  end
end
