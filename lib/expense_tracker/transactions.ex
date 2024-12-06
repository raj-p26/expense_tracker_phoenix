defmodule ExpenseTracker.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias ExpenseTracker.Categories.Category
  alias ExpenseTracker.Repo

  alias ExpenseTracker.Transactions.Income

  @doc """
  Returns the list of incomes by user id.

  ## Examples

      iex> list_incomes(1)
      [%Income{}, ...]

  """
  def list_incomes(user_id) do
    Income
    |> where([i], i.user_id == ^user_id)
    |> join(:left, [i], c in Category, on: c.id == i.category_id)
    |> Repo.all()
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single income.

  Raises `Ecto.NoResultsError` if the Income does not exist.

  ## Examples

      iex> get_income!(123)
      %Income{}

      iex> get_income!(456)
      ** (Ecto.NoResultsError)

  """
  def get_income!(id), do: Repo.get!(Income, id)

  def get_income(id) do
    query =
      from i in Income,
        join: c in Category,
        on: c.id == i.category_id,
        where: i.id == ^id,
        preload: :category

    Repo.one(query)
  end

  @doc """
  Creates a income.

  ## Examples

      iex> create_income(%{field: value})
      {:ok, %Income{}}

      iex> create_income(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_income(attrs \\ %{}) do
    %Income{}
    |> Income.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a income.

  ## Examples

      iex> update_income(income, %{field: new_value})
      {:ok, %Income{}}

      iex> update_income(income, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_income(%Income{} = income, attrs) do
    income
    |> Income.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a income.

  ## Examples

      iex> delete_income(income)
      {:ok, %Income{}}

      iex> delete_income(income)
      {:error, %Ecto.Changeset{}}

  """
  def delete_income(%Income{} = income) do
    Repo.delete(income)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking income changes.

  ## Examples

      iex> change_income(income)
      %Ecto.Changeset{data: %Income{}}

  """
  def change_income(%Income{} = income, attrs \\ %{}) do
    Income.changeset(income, attrs)
  end

  alias ExpenseTracker.Transactions.Expense

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses(user_id) do
    Expense
    |> where([e], e.user_id == ^user_id)
    |> join(:left, [e], c in Category, on: c.id == e.category_id)
    |> Repo.all()
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  @doc """
  Gets a single expense from the database and preloads the category.

  Returns single record from the database or nil.
  """
  def get_expense(id) do
    query =
      from e in Expense,
        join: c in Category,
        on: c.id == e.category_id,
        where: e.id == ^id,
        preload: :category

    Repo.one(query)
  end

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  def get_avg_income(user_id) do
    Income
    |> join(:inner, [i], c in Category, on: c.id == i.category_id)
    |> where([i, c], i.user_id == ^user_id)
    |> group_by([i, c], c.name)
    |> select([i, c], {c.name, avg(i.amount)})
    |> Repo.all()
  end

  def get_avg_expense(user_id) do
    Expense
    |> join(:inner, [e], c in Category, on: c.id == e.category_id)
    |> where([e, c], e.user_id == ^user_id)
    |> group_by([e, c], e.category_id)
    |> select([e, c], {c.name, avg(e.amount)})
    |> Repo.all()
  end
end
