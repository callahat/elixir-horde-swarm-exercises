defmodule HordeBackgroundJob.DatabaseCleaner.Runner do
  use HordeBackgroundJob.Logger
  require Logger

  def execute(server_name) do
    random = :rand.uniform(1_000)

    Process.sleep(random)

    log_msg("#{random} records deleted - #{ server_name }")
  end
end
