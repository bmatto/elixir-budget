defmodule Budget.MixProject do
  use Mix.Project

  def project() do
    [
      app: :budget,
      version: "0.0.1",
      elixir: "~> 1.0",
      deps: deps(),
    ]
  end

  def application() do
    [mod: {Budget, []}]
  end

  defp deps() do
    [
      {:csv, "~> 2.0.0"}
    ]
  end
end
