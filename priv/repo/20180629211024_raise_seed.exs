defmodule Botanist.Repo.Seeds.RaiseSeed do
  import Botanist

  def planter do
    seed do
      raise "bang"
    end
  end
end
