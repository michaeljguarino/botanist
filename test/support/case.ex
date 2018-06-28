defmodule Botanist.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Botanist.Repo
      import Ecto.Query
      import Mock
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Botanist.Repo)
  end
end
