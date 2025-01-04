defmodule HordeBackgroundJob.DatabasePolisher do
  use GenServer
  use HordeBackgroundJob.Logger

  alias HordeBackgroundJob.HordeRegistry

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))

    log_msg("start_link polisher #{ inspect name}")

    {:ok, _pid} = GenServer.start_link(__MODULE__, {timeout, name}, name: via_tuple(name))
  end

  @impl GenServer
  def init({timeout, name}) do
    Process.set_label(name)
    log_msg("starting polisher")

    schedule(timeout)

    {:ok, {timeout, name}}
  end

  @impl GenServer
  def handle_info(:execute, {timeout, name}) do
    log_msg("polishing - #{ name }")
    Task.start(fn () ->
      random = :rand.uniform(300)

      Process.sleep(random)

      log_msg("#{random} indexes polished - #{ name }")
    end)

    schedule(timeout)

    {:noreply, {timeout, name}}
  end

  defp schedule(timeout) do
    log_msg("scheduling polisher")

    Process.send_after(self(), :execute, timeout)
  end

  defp via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end

end
