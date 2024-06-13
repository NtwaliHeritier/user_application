defmodule UserApplicationWeb.IndexLive do
  use UserApplicationWeb, :live_view

  alias UserApplication.Accounts
  alias UserApplication.Csv.{Cache, Scrapper}

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, socket |> assign_new(:current_user, fn -> current_user end) |> assign(plots: [], share: true)}
  end

  def handle_params(%{"path" => "shared-plots"}, _, socket) do
      plots = 
      socket.assigns.current_user.account.shared_ownerships
      |> get_plots()

    {:noreply, socket |> assign(plots: plots, share: false) |> push_event("show", %{response: plots})}
  end

  def handle_params(_, _, socket) do
    plots =
      socket.assigns.current_user.account.created_ownerships
      |> get_plots()

    {:noreply, socket |> assign(plots: plots, share: true) |> push_event("show", %{response: plots})}
  end

  defp get_plots(ownerships) do
    ownerships
    |> Enum.map(fn ownership ->
      %{id: ownership.plot.id, dataset_name: ownership.plot.dataset_name, name: ownership.plot.name, expression: ownership.plot.expression}
    end)
    |> Enum.map(fn plot ->
      csv = 
        case Cache.get(plot.name) do
          [] -> 
            Scrapper.get(plot.dataset_name)
          [{_key, csv}] -> 
            csv
        end
      %{csv: csv, expression: plot.expression, name: plot.name, id: plot.id}
    end)
  end
end
