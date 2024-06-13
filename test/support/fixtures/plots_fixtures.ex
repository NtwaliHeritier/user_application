defmodule UserApplication.PlotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UserApplication.Plots` context.
  """

  @doc """
  Generate a plot.
  """
  def plot_fixture(attrs \\ %{}) do
    {:ok, plot} =
      attrs
      |> Enum.into(%{
        dataset_name: "some dataset_name",
        expression: "some expression",
        name: "some name"
      })
      |> UserApplication.Plots.create_plot()

    plot
  end

  @doc """
  Generate a ownership.
  """
  def ownership_fixture(attrs \\ %{}) do
    {:ok, ownership} =
      attrs
      |> Enum.into(%{

      })
      |> UserApplication.Plots.create_ownership()

    ownership
  end
end
