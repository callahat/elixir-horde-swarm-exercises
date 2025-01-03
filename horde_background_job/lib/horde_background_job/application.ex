defmodule HordeBackgroundJob.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: HordeBackgroundJob.ClusterSupervisor]]},
      HordeBackgroundJob.HordeRegistry,
      HordeBackgroundJob.HordeSupervisor,
      HordeBackgroundJob.NodeObserver,
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner1", timeout: :timer.seconds(2)]},
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner2", timeout: :timer.seconds(2)]},
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner3", timeout: :timer.seconds(2)]},
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner4", timeout: :timer.seconds(2)]},
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner5", timeout: :timer.seconds(2)]},
      {HordeBackgroundJob.DatabaseCleaner.Starter, [name: "Cleaner6", timeout: :timer.seconds(2)]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HordeBackgroundJob.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip,
      ]
    ]
  end
end
