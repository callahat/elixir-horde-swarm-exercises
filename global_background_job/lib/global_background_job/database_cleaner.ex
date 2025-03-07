defmodule GlobalBackgroundJob.DatabaseCleaner do
  use GenServer
  use GlobalBackgroundJob.Logger

  alias __MODULE__.Runner

  @impl GenServer
  def init(args \\ []) do
    log_msg("starting")
    timeout = Keyword.get(args, :timeout)

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

  defp schedule(timeout) do
    log_msg("scheduling")

    Process.send_after(self(), :execute, timeout)
  end

end
