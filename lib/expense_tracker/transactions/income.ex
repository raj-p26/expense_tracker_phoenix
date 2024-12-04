defmodule ExpenseTracker.Transactions.Income do
  alias ExpenseTracker.Categories.Category
  alias ExpenseTracker.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "incomes" do
    field :description, :string
    field :amount, :integer
    field :add_date, :date
    belongs_to :category, Category
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(income, attrs) do
    income
    |> cast(attrs, [:amount, :description, :add_date, :user_id, :category_id])
    |> validate_required([:amount, :add_date, :user_id])
    |> validate_number(:amount, greater_than: 0.0)
  end
end
