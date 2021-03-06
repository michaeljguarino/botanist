use Mix.Config

config :botanist, ecto_repos: [Botanist.Repo], ecto_repo: Botanist.Repo

config :botanist, Botanist.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "botanist_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
