# SwarmBackgroundJob

```
iex --sname nX -S mix

# see whats registered
Swarm.registered

# kill the process
SwarmBackgroundJob.DatabaseCleaner |> Swarm.whereis_name |> GenServer.call(:derp)
```

It doesn't seem trivial to dynamically launch multiple cleaners
(similar to how the Horde example was modified).

From the docs:

> Swarm is intended to be used by registering processes before they are created, and letting Swarm start them for you on the proper node in the cluster