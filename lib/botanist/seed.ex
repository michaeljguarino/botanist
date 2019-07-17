defmodule Botanist.Seed do
  use Ecto.Schema

  @moduledoc false

  @opts [timeout: :infinity, log: false]
  @dt_type Application.get_env(:botanist, :datetime_type) || :utc_datetime_usec

  @primary_key false
  schema "seed" do
    field(:name, :string)
    field(:inserted_at, @dt_type)
  end

  def ensure_seed_table!(repo) do
    table = %Ecto.Migration.Table{name: :seed}

    commands = [
      {:add, :name, :text, primary_key: true},
      {:add, :inserted_at, @dt_type, []}
    ]

    # DDL queries do not log, so we do not need to pass log: false here.
    repo.__adapter__.execute_ddl(repo, {:create_if_not_exists, table, commands}, @opts)
  end

  def now(), do: current_time(@dt_type)

  def current_time(:utc_datetime_usec), do: DateTime.utc_now()
  def current_time(:naive_datetime_usec), do: NaiveDateTime.utc_now()
end
