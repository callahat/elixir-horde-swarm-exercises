defmodule HordeBackgroundJob.DatabaseCleaner do
  use GenServer
  use HordeBackgroundJob.Logger

  alias __MODULE__.Runner

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))

    GenServer.start_link(__MODULE__, {timeout, name}, name: name)
  end

  @impl GenServer
  def init({timeout, name}) do
    log_msg("starting")

    schedule(timeout)

    {:ok, {timeout, name}}
  end

  @impl GenServer
  def handle_info(:execute, {timeout, name}) do
    log_msg("deleting - #{ _name name }")
    Task.start(Runner, :execute, [_name(name)])

    schedule(timeout)

    {:noreply, {timeout, name}}
  end

  defp schedule(timeout) do
    log_msg("scheduling")

    Process.send_after(self(), :execute, timeout)
  end

  defp _name({:via, Horde.Registry, {_, name}}), do: name
  defp _name(name), do: name

end
