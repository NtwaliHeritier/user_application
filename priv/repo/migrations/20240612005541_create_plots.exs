defmodule UserApplication.Repo.Migrations.CreatePlots do
  use Ecto.Migration

  def change do
    create table(:plots) do
      add :name, :string
      add :dataset_name, :string
      add :expression, :string

      timestamps(type: :utc_datetime)
    end
  end
end
