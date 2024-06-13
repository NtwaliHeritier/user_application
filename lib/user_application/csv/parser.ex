defmodule UserApplication.Csv.Parser do
  @moduledoc """
    This module gets csv from Github and save it into :ets cache
  """

  alias UserApplication.Csv.Scrapper

  def cache_csv(plot) do
    case Scrapper.get(plot.dataset_name) do
      :error -> {:error, :no_data}
      csv -> UserApplication.Csv.Cache.insert(plot.name, csv)
    end
  end
end
