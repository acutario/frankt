defmodule Frankt.ConfigurationError do
  @moduledoc """
  Represents an error in the Frankt configuration.
  """
  defexception [:message]

  def exception(module: module, message: message) do
    %__MODULE__{message: "[#{module}] #{message}"}
  end
end
