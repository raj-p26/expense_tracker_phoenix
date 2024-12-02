defmodule ExpenseTracker.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExpenseTracker.Accounts.User

  schema "categories" do
    field :name, :string
    belongs_to :user, User
    field :transaction_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :user_id, :transaction_type])
    |> validate_required([:name, :user_id, :transaction_type])
    |> validate_inclusion(:transaction_type, ["incomes", "expenses"])
  end
end
