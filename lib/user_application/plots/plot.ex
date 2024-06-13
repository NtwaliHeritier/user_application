defmodule UserApplication.Plots.Plot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plots" do
    field :name, :string
    field :dataset_name, :string
    field :expression, :string
    has_one :created_ownership, UserApplication.Plots.Ownership

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, attrs) do
    plot
    |> cast(attrs, [:name, :dataset_name, :expression])
    |> validate_required([:name, :dataset_name, :expression])
    |> cast_assoc(:created_ownership, with: &UserApplication.Plots.Ownership.changeset/2)
  end
end
