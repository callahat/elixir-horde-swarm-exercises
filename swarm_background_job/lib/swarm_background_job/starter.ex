defmodule SwarmBackgroundJob.DatabaseCleaner.Starter do
  use GenServer
  use SwarmBackgroundJob.Logger

  alias SwarmBackgroundJob.DatabaseCleaner
  alias SwarmBackgroundJob.DatabaseCleaner.Supervisor, as: DatabaseCleanerSupervisor

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    {:ok, opts, {:continue, {:start_and_monitor, 1}}}
  end

  @impl GenServer
  def handle_continue({:start_and_monitor, retry}, opts) do
    case Swarm.whereis_or_register_name(
           DatabaseCleaner,
           DatabaseCleanerSupervisor,
           :start_child,
           [opts]
         ) do
      {:ok, pid} ->
        log_msg("found supervisor, monitoring - #{ inspect pid }")
        Process.monitor(pid)

        {:noreply, {pid, opts}}

      other ->
        log_msg("unable to register or find supervisor - #{ inspect other }")
        Process.sleep(500)

        {:noreply, opts, {:continue, {:start_and_monitor, retry + 1}}}
    end
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, reason}, {pid, opts}) do
    log_msg("DOWN recieved from #{ inspect pid } - #{ inspect reason }")

    {:noreply, opts, {:continue, {:start_and_monitor, 1}}}
  end

end
