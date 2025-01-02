# HordeBackgroundJob

```
iex --sname nX -S mix

# to kill the process
HordeBackgroundJob.DatabaseCleaner.Starter.whereis("CleanerX") |> GenServer.cast(:boom)

# to see where the process is/get the PID
HordeBackgroundJob.DatabaseCleaner.Starter.whereis

# launch additional named cleaner processes, (the first 6 are created during
# application startup):
Enum.each(7..30, fn(i) -> HordeBackgroundJob.DatabaseCleaner.Starter.start_link([name: "Cleaner#{ i }"]) end)

```
