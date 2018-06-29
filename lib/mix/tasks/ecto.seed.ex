defmodule Mix.Tasks.Ecto.Seed do
  require Logger

  @shortdoc "Runs all pending seeds"

  @moduledoc """
  Runs all pending seeds in `priv/repo/seeds` or, if configured, the `seeds_path` directory.

  If a seed has already run, it cannot be rerun unless it's a perennial seed. Failed seeds of any flavor however, can be rerun.

  ### Example
  ```elixir
  mix ecto.seed
  ```
  """

  @doc false
  def run(_args) do
    Logger.configure(level: :info)

    Mix.Task.run("app.start", [])

    case run_seeds() do
      {:ok, failed_seeds} ->
        cond do
          length(failed_seeds) > 0 ->
            Logger.error("The following seeds failed to run:")

            Enum.each(failed_seeds, fn fs ->
              Logger.error("#{fs.file}")
              Logger.error("#{fs.msg}")
            end)

          true ->
            Logger.info("All seeds ran successfully.")
        end
    end
  end

  defp run_seeds() do
    failed_seeds =
      Enum.reject(
        Enum.map(Mix.Botanist.gather_seed_files(), fn seed_file ->
          Logger.info("Running seed #{seed_file}")
          Mix.Botanist.run_seed(seed_file)
        end),
        &is_nil/1
      )

    {:ok, failed_seeds}
  end
end
