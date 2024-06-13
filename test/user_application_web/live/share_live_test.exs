defmodule UserApplicationWeb.ShareLiveTest do
    use UserApplicationWeb.ConnCase

    import Phoenix.LiveViewTest

    alias UserApplication.{Accounts, Plots}

    test "redirects to / after a plot is edited", %{conn: conn} do
        %{conn: conn} = register_and_log_in_user(%{conn: conn})

        user = Accounts.get_user_by_session_token(conn.private.plug_session["user_token"])
        {:ok, plot} = Plots.create_plot(%{dataset_name: "iris", name: "Iris", expression: "SepalWidth", ownership: %{account_id: user.account.id, ownership_status: :creator}})
        
        {:ok, user2} = Accounts.register_user(%{email: "kevin@gmail.com", password: "kevine@12345", account: %{name: "Kevin"}})
        {:ok, view, html} = live(conn, "/share_plot?plot_id=#{plot.id}")
        assert html =~ "Share plot"

        form_data = %{
            "email" => user2.email
          }
      
          {:ok, conn} = 
            view
            |> form("form", form_data)
            |> render_submit()
            |> follow_redirect(conn, "/")

        assert conn.assigns.live_module == UserApplicationWeb.IndexLive
        
        user2 = Accounts.get_user_by_email(user2.email) |> UserApplication.Repo.preload([account: [shared_ownerships: :plot]])
        assert length(user2.account.shared_ownerships) === 1

        # retry to share
        {:ok, view, html} = live(conn, "/share_plot?plot_id=#{plot.id}")
        assert html =~ "Share plot"

        form_data = %{
            "email" => user2.email
          }
      
          {:ok, conn} = 
            view
            |> form("form", form_data)
            |> render_submit()
            |> follow_redirect(conn, "/")

        assert conn.assigns.live_module == UserApplicationWeb.IndexLive
        assert conn.assigns.flash == %{"error" => "User does not exist or plot already shared with them"}
    end
end