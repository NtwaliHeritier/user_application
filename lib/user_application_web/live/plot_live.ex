defmodule UserApplicationWeb.PlotLive do
  use UserApplicationWeb, :live_view

  alias UserApplication.Plots
  alias UserApplication.Plots.Plot

  def mount(_params, session, socket) do
    current_user = UserApplication.Accounts.get_user_by_session_token(session["user_token"])
    {:ok, socket |> assign_new(:current_user, fn -> current_user end) |> assign(form: nil, edit: false, plot: nil)}
  end

  def handle_params(%{"plot_id" => plot_id}, _, socket) do
    plot = Plots.get_plot!(plot_id)
    changeset = Plots.change_plot(plot)
    {:noreply, socket |> assign(form: to_form(changeset), edit: true, plot: plot)}
  end

  def handle_params(_, _, socket) do
    changeset = Plots.change_plot(%Plot{})
    {:noreply, socket |> assign(form: to_form(changeset))}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    ownership = %{"account_id" => socket.assigns.current_user.account.id, "ownership_status" => :creator}
    
    plot = 
      if socket.assigns.edit do
        Plots.update_plot(socket.assigns.plot, plot_params)
      else
        plot_params
          |> Map.put("created_ownership", ownership)
          |> Plots.create_plot()
      end

    case plot do
      {:ok, plot} -> UserApplication.Csv.Parser.cache_csv(plot)
      error -> 
        error
    end

    {:noreply, redirect(socket, to: "/")}
  end
end
