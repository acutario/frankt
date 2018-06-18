defmodule Frankt.ConfigurationError do
  @moduledoc """
  Represents an error in the Frankt configuration.

  For more information about how to handle configuration errors take a look at the `handle_error/3`
  callback in the `Frankt` behaviour.
  """
  defexception [:message]

  @doc false
  def exception(module: module, message: message) do
    %__MODULE__{message: "[#{module}] #{message}"}
  end
end
