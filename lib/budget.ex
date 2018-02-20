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

  def groupByCategory (transactions) do
    transactions
    |> Enum.group_by(fn ({ :ok, row }) -> row |> rowValue(:category) end)
  end

  def sumCategory({name, transactions}) do
    sum = Enum.reduce(transactions, 0, fn({:ok, transaction}, acc) ->
      amount = transaction |> rowValue(:amount) |> parseAmount()
      acc + amount
    end)

    { :ok, name, sum }
  end

  def run (path) do
    getFileContents(path)
      |> groupByCategory
      |> Enum.map(&sumCategory/1)
  end

  @spec parseAmount(String.t()) :: float
  defp parseAmount(amount) do
    amount
      |> String.replace("--", "")
      |> Float.parse()
      |> (fn ({ float, _respose }) -> float end).()
  end

  defp rowValue(row, col) do
    Enum.at(row, @reportMap[col])
  end

end
