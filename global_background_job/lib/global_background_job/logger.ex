defmodule GlobalBackgroundJob.Logger do
  defmacro __using__(_) do
    quote do
      require Logger

      defp log_msg(msg) do
        Logger.info("--- #{ node() } - #{ __MODULE__ } - #{ msg }")
      end
    end
  end
end
