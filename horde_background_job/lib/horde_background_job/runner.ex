defmodule HordeBackgroundJob.DatabaseCleaner.Runner do
  use HordeBackgroundJob.Logger
  require Logger

  def execute do
    random = :rand.uniform(1_000)

    Process.sleep(random)

    log_msg("#{random} records deleted")
  end
end
