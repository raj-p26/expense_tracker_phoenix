defmodule ExpenseTracker.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExpenseTracker.Transactions` context.
  """

  @doc """
  Generate a income.
  """
  def income_fixture(attrs \\ %{}) do
    {:ok, income} =
      attrs
      |> Enum.into(%{
        add_date: ~D[2024-12-01],
        amount: 42,
        description: "some description"
      })
      |> ExpenseTracker.Transactions.create_income()

    income
  end
end
