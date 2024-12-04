defmodule ExpenseTracker.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias ExpenseTracker.Repo

  alias ExpenseTracker.Categories.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_categories_by_user_id(user_id) do
    Category
    |> where([c], c.user_id == ^user_id)
    |> select([c], %{name: c.name, type: c.transaction_type, id: c.id})
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_category(id) do
    Category
    |> where([c], c.id == ^id)
    |> select([c], %{name: c.name, type: c.transaction_type, id: c.id})
    |> Repo.one()
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def get_category_by_user_id(user_id, type \\ "income") do
    Category
    |> where([c], c.user_id == ^user_id and c.transaction_type == ^type)
    |> select([c], {c.name, c.id})
    |> Repo.all()
  end

  def add_default_categories(user_id) do
    create_category(%{name: "Food", user_id: user_id, transaction_type: "expense"})
    create_category(%{name: "Entertainment", user_id: user_id, transaction_type: "expense"})
    create_category(%{name: "Rent", user_id: user_id, transaction_type: "expense"})
    create_category(%{name: "Transportation", user_id: user_id, transaction_type: "expense"})
    create_category(%{name: "Utilties", user_id: user_id, transaction_type: "expense"})

    create_category(%{name: "Salary", user_id: user_id, transaction_type: "income"})
    create_category(%{name: "Business", user_id: user_id, transaction_type: "income"})
    create_category(%{name: "Investment", user_id: user_id, transaction_type: "income"})
    create_category(%{name: "Freelance", user_id: user_id, transaction_type: "income"})
  end
end
