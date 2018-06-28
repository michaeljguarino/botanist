Mix.Task.run("ecto.drop", ~w(-r Botanist.Repo --quiet))
Mix.Task.run("ecto.create", ~w(-r Botanist.Repo --quiet))
Mix.Task.run("ecto.migrate", ~w(-r Botanist.Repo --quiet))

ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()
Botanist.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Botanist.Repo, :manual)
