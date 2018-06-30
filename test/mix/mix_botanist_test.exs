defmodule Botanist.MixBotanistTest do
  use Botanist.Case

  alias Botanist.Seed

  test "gather seed files" do
    # -- Given
    #

    # -- When
    #
    seed_files = Mix.Botanist.gather_seed_files()

    # -- Then
    #
    assert length(seed_files) == 3

    assert Enum.at(seed_files, 0) ==
             Path.join([File.cwd!(), "priv", "repo", "seeds", "20180628181051_test_seed_1.exs"])

    assert Enum.at(seed_files, 1) ==
             Path.join([File.cwd!(), "priv", "repo", "seeds", "20180628181054_test_seed_2.exs"])

    assert Enum.at(seed_files, 2) ==
             Path.join([File.cwd!(), "priv", "repo", "seeds", "20180628181057_test_seed_3.exs"])
  end

  test "running seed" do
    # -- Given
    #

    # -- When
    #
    out =
      Mix.Botanist.run_seed(
        Path.join([File.cwd!(), "priv", "repo", "20180628181057_test_seed_1.exs"])
      )

    # -- Then
    #
    seed =
      from(
        s in Seed,
        where: s.name == "20180628181057_test_seed_1"
      )
      |> Repo.one()

    assert not is_nil(seed)
    assert is_nil(out)
  end

  test "raising seed" do
    # -- Given
    #

    # -- When
    #
    error =
      Mix.Botanist.run_seed(
        Path.join([File.cwd!(), "priv", "repo", "20180629211024_raise_seed.exs"])
      )

    # -- Then
    #
    assert error.file == "20180629211024_raise_seed.exs"
    assert error.msg == "bang"
  end

  test "throwing seed" do
    # -- Given
    #

    # -- When
    #
    error =
      Mix.Botanist.run_seed(
        Path.join([File.cwd!(), "priv", "repo", "20180629211110_throw_seed.exs"])
      )

    # -- Then
    #
    assert error.file == "20180629211110_throw_seed.exs"
    assert error.msg == "bang bang"
  end

  test "multi module seed" do
    # -- Given
    #

    # -- When
    #
    output =
      Mix.Botanist.run_seed(
        Path.join([File.cwd!(), "priv", "repo", "20180630000025_test_multi_module.exs"])
      )

    # -- Then
    #
    seed =
      from(
        s in Seed,
        where: s.name == "20180630000025_test_multi_module"
      )
      |> Repo.one()

    assert is_nil(output)
    assert not is_nil(seed)
  end
end
