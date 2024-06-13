defmodule UserApplication.Plots.Ownership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ownerships" do
    belongs_to :account, UserApplication.Accounts.Account
    belongs_to :plot, UserApplication.Plots.Plot
    field :ownership_status, Ecto.Enum, values: [:creator, :collaborator]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ownership, attrs) do
    ownership
    |> cast(attrs, [:account_id, :plot_id, :ownership_status])
    |> validate_required([:account_id, :ownership_status])
    |> unique_constraint([:plot_id, :account_id, :ownership_status])
  end
end
