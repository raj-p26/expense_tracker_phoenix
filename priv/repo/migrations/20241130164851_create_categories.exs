defmodule ExpenseTracker.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :transaction_type, :string

      timestamps(type: :utc_datetime)
    end

    create index(:categories, [:user_id])
  end
end
