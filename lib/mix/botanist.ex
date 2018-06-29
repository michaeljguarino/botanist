defmodule Mix.Botanist do
  @moduledoc false

  require Logger

  def repo do
    case Mix.env() do
      :test ->
        Botanist.Repo

      _ ->
        case Application.get_env(:botanist, :ecto_repo, nil) do
          nil ->
            Mix.raise(
              "A repo must be added to your Botanist config. Check your config.exs for the 'ecto_repo' field under botanist"
            )

          repo ->
            repo
        end
    end
  end

  def seed_path do
    seed_path =
      case Application.get_env(:botanist, :seeds_path, nil) do
        nil -> Path.join(["priv", "repo", "seeds"])
        seed_path -> seed_path
      end

    Path.join([File.cwd!(), seed_path])
  end

  def gather_seed_files() do
    Path.wildcard(Path.join(Mix.Botanist.seed_path(), "*.exs"))
  end

  def run_seed(seed_file) do
    basename = Path.basename(seed_file)

    case Code.load_file(seed_file) |> List.first() do
      {mod, _bin} ->
        case run_module(mod) do
          {:ok, _} ->
            Logger.info("#{basename} ran successfully")
            nil

          {:repeat, _} ->
            Logger.info("#{basename} has already run")
            nil

          {:error, error} ->
            Logger.error("Failed to run #{basename}")
            %{file: basename, msg: error}
        end

      _ ->
        Logger.error("Error loading #{seed_file}")
    end
  end

  defp run_module(mod) do
    try do
      mod.planter()
    rescue
      error -> {:error, Exception.message(error)}
    catch
      error when is_binary(error) -> {:error, error}
      error -> {:error, Exception.message(error)}
    end
  end
end
