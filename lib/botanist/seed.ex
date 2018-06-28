defmodule Botanist.Seed do
  use Ecto.Schema

  @moduledoc false

  @opts [timeout: :infinity, log: false]

  @primary_key false
  schema "seed" do
    field(:name, :string)
    field(:inserted_at, :naive_datetime)
  end

  def ensure_seed_table!(repo) do
    table = %Ecto.Migration.Table{name: :seed}

    commands = [
      {:add, :name, :text, primary_key: true},
      {:add, :inserted_at, :naive_datetime, []}
    ]

    # DDL queries do not log, so we do not need to pass log: false here.
    repo.__adapter__.execute_ddl(repo, {:create_if_not_exists, table, commands}, @opts)
  end
end
