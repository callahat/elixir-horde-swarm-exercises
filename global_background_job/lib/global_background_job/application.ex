defmodule GlobalBackgroundJob.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: GlobalBackgroundJob.ClusterSupervisor]]},
      {GlobalBackgroundJob.DatabaseCleaner.Starter, [timeout: :timer.seconds(2)]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GlobalBackgroundJob.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      # the first keyword is just a name and can be whatever
      background_job: [
        strategy: Cluster.Strategy.Gossip,
      ]
    ]
  end
end
