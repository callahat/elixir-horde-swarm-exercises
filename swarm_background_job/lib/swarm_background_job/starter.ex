defmodule SwarmBackgroundJob.DatabaseCleaner.Starter do
  use SwarmBackgroundJob.Logger

  alias SwarmBackgroundJob.DatabaseCleaner
  alias SwarmBackgroundJob.DatabaseCleaner.Supervisor, as: DatabaseCleanerSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
    }
  end

  def start_link(opts) do
    Swarm.register_name(DatabaseCleaner, DatabaseCleanerSupervisor, :start_child, [opts])
    log_msg("Swarm registered name for Supervisor")

    :ignore
  end
end
