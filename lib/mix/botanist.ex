defmodule Mix.Botanist do
  @moduledoc false
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
end
