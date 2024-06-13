defmodule UserApplicationWeb.ShareLive do
  use UserApplicationWeb, :live_view

  alias UserApplication.{Plots, Accounts}

  def mount(_params, session, socket) do
    current_user = UserApplication.Accounts.get_user_by_session_token(session["user_token"])
    {:ok, socket |> assign(plot_id: nil) |> assign_new(:current_user, fn -> current_user end)}
  end

  def handle_params(%{"plot_id" => plot_id}, _, socket) do
    {:noreply, socket |> assign(plot_id: plot_id)}
  end

  def handle_event("share", %{"email" => email}, socket) do
    user = Accounts.get_user_by_email(email)
    
    if user && socket.assigns.current_user.email !== user.email && is_nil(Plots.get_ownership_by_plot_and_account(socket.assigns.plot_id, user.account.id)) do
      Plots.create_ownership(%{plot_id: socket.assigns.plot_id, ownership_status: :collaborator, account_id: user.account.id})
      {:noreply, redirect(socket, to: "/")}
    else
      {:noreply, redirect(socket, to: "/") |> put_flash(:error, "User does not exist or plot already shared with them")}
    end
  end
end
