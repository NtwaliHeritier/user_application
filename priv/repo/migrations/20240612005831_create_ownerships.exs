defmodule UserApplication.Repo.Migrations.CreateOwnerships do
  use Ecto.Migration

  def change do
    create table(:ownerships) do
      add :account_id, references(:accounts, on_delete: :delete_all)
      add :plot_id, references(:plots, on_delete: :delete_all)
      add :ownership_status, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ownerships, [:account_id, :plot_id, :ownership_status])
  end
end
