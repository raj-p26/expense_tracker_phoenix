defmodule ExpenseTracker.Transactions.Expense do
  alias ExpenseTracker.Accounts.User
  alias ExpenseTracker.Categories.Category
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :description, :string
    field :amount, :integer
    field :add_date, :date
    belongs_to :category, Category
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :description, :add_date, :category_id, :user_id])
    |> validate_required([:amount, :add_date, :user_id, :category_id])
    |> validate_number(:amount, greater_than: 0)
  end
end
