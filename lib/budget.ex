defmodule Budget do
  use Application

  @reportMap %{
    status: 0,
    date: 2,
    description: 4,
    category: 5,
    amount: 6
  }

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec getFileContents(String.t()) :: list
  def getFileContents (path) do
    File.stream!(path)
      |> CSV.decode
      |> Enum.to_list
  end

  def groupByCategory (posts) do
    posts
    |> Enum.group_by(fn ({ :ok, post }) -> post |> Enum.at(@reportMap.category) end)
  end

  def sumCategory({name, posts}) do
    sum = posts
      |> Enum.reduce(0, fn({:ok, post}, acc) ->
          float = case post |> Enum.at(@reportMap.amount) |> Float.parse do
            {float, _remainder} -> abs(float)
            :error -> acc
          end

          acc + float
        end
      )

    { :ok, name, sum }
  end

  def amountByCategory (categories) do
    categories
      |> Enum.map(
        fn(category) ->
          sumCategory(category)
        end
      )
  end

  def run (path) do
    getFileContents(path)
      |> groupByCategory
      |> amountByCategory
  end
end
