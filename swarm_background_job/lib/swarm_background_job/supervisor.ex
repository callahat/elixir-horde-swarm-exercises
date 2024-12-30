defmodule SwarmBackgroundJob.DatabaseCleaner.Supervisor do
  use DynamicSupervisor
  use SwarmBackgroundJob.Logger

  def start_link(state) do
    log_msg("Start link")
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    log_msg("init")
    DynamicSupervisor.init(strategry: :one_for_one)
  end

  def start_child(opts) do
    log_msg("start child")
    child_spec = %{
      id: SwarmBackgroundJob.DatabaseCleaner,
      start: {SwarmBackgroundJob.DatabaseCleaner, :start_link, [opts]},
      restart: :temporary,
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
