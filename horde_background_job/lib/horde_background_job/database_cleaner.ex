defmodule HordeBackgroundJob.DatabaseCleaner do
  use GenServer
  use HordeBackgroundJob.Logger

  alias __MODULE__.Runner

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))

    GenServer.start_link(__MODULE__, timeout, name: name)
  end

  @impl GenServer
  def init(timeout) do
    log_msg("starting")

    schedule(timeout)

    {:ok, timeout}
  end

  @impl GenServer
  def handle_info(:execute, timeout) do
    log_msg("deleting")
    Task.start(Runner, :execute, [])

    schedule(timeout)

    {:noreply, timeout}
  end

  @impl GenServer
  def handle_info({:swarm, :die}, state) do
    log_msg("recieved DIE")

    {:stop, :shutdown, state}
  end

  @impl GenServer
  def handle_call({:swarm, :begin_handoff}, from, state) do
    log_msg("received handoff call from #{inspect from}")

    {:reply, :restart, state}
  end

  @impl GenServer
  def handle_cast({:swarm, :resolve_conflict, _}, state) do
    log_msg("recieved resolve conflict cast")

    {:noreply, state}
  end

  defp schedule(timeout) do
    log_msg("scheduling")

    Process.send_after(self(), :execute, timeout)
  end

end
