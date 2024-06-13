defmodule UserApplication.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    belongs_to :user, UserApplication.Accounts.User
    has_many :created_ownerships, UserApplication.Plots.Ownership, where: [ownership_status: :creator]
    has_many :shared_ownerships, UserApplication.Plots.Ownership, where: [ownership_status: :collaborator]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end
end
