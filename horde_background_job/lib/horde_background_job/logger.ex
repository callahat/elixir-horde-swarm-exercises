defmodule HordeBackgroundJob.Logger do
  defmacro __using__(_) do
    quote do
      require Logger

      defp log_msg(msg) do
        mod_short_name = __MODULE__ |> to_string() |> String.split(".") |> List.last()
        Logger.info("--- #{ node() } - #{ mod_short_name } - #{ msg }")
      end
    end
  end
end
