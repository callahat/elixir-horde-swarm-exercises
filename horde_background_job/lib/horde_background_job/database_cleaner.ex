defmodule HordeBackgroundJob.DatabaseCleaner do
  use GenServer
  use HordeBackgroundJob.Logger

  alias __MODULE__.Runner
  alias HordeBackgroundJob.{HordeRegistry, HordeSupervisor}

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))
    count = Keyword.get(opts, :count, 0)

    GenServer.start_link(__MODULE__, {timeout, name, count}, name: name)
  end

  @impl GenServer
  def init({timeout, name, count}) do
    Process.set_label(_name(name))
    polisher_name = "#{_name(name)}Polisher"
    log_msg("starting")

    schedule(timeout)

    {:ok, {timeout, name, count}}
  end

  @impl GenServer
  def handle_info(:execute, {timeout, name, count}) do
    log_msg("deleting - #{ _name name }")
    Task.start(Runner, :execute, [_name(name), count])

    schedule(timeout)

    {:noreply, {timeout, name, count + 1}}
  end

  defp schedule(timeout) do
    log_msg("scheduling")

    Process.send_after(self(), :execute, timeout)
  end

  defp _name({:via, Horde.Registry, {_, name}}), do: name
  defp _name(name), do: name


  defp _via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end
end
