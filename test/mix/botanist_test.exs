defmodule Botanist.MixBotanistTest do
  use Botanist.Case

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
end
