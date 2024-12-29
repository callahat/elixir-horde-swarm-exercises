defmodule GlobalBackgroundJob.DatabaseCleaner.Starter do
  use GenServer
  use GlobalBackgroundJob.Logger

  alias GlobalBackgroundJob.DatabaseCleaner

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    pid = start_and_monitor(opts)

    {:ok, {pid, opts}}
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, reason}, {pid, opts} = _state) do
    log_msg("DOWN message received - #{ inspect pid } - #{ inspect reason }")
    {:noreply, {start_and_monitor(opts), opts}}
  end

  defp start_and_monitor(opts) do
    pid =
      case GenServer.start_link(DatabaseCleaner, opts, name: {:global, DatabaseCleaner}) do
        {:ok, pid} ->
          log_msg("started DatabaseCleaner - #{ inspect pid }")
          pid
        {:error, {:already_started, pid}} ->
          log_msg("DatabaseCleaner already started - #{ inspect pid }")
          pid
      end

    Process.monitor(pid)

    pid
  end
end
