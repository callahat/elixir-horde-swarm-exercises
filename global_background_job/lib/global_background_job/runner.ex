defmodule GlobalBackgroundJob.DatabaseCleaner.Runner do
  use GlobalBackgroundJob.Logger
  require Logger

  def execute do
    random = :rand.uniform(1_000)

    Process.sleep(random)

    log_msg("#{random} records deleted")
  end
end
