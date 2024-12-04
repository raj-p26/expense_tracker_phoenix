defmodule ExpenseTracker.Repo.Migrations.CreateIncomes do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :amount, :integer
      add :description, :text
      add :add_date, :date
      add :category_id, references(:categories, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:incomes, [:category_id])
    create index(:incomes, [:user_id])
  end
end
