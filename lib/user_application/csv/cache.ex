defmodule UserApplication.Csv.Cache do
    @moduledoc """
        This is a module to cache csv data
    """
    use GenServer

    def start_link(opts) do
        name = Keyword.get(opts, :name, __MODULE__)
        GenServer.start_link(__MODULE__, :ok, name: name)
    end

    def init(_) do
        table =
        :ets.new(table_name(), [
          :public,
          :named_table,
          :compressed,
          :set,
          read_concurrency: true,
          write_concurrency: true
        ])
  
      {:ok, %{table: table}, {:continue, :load_ets}}
    end

    def handle_continue(:load_ets, state) do
        plots = UserApplication.Plots.list_plots()
        Enum.map(plots, fn plot -> UserApplication.Csv.Parser.cache_csv(plot) end)
        
        {:noreply, state}
    end

    def insert(name, csv) do
        :ets.insert(table_name(), {name, csv})
    end

    def get(name) do
        :ets.lookup(table_name(), name)
    end

    defp table_name, do: Application.get_env(:user_application, :ets_table_name)
end