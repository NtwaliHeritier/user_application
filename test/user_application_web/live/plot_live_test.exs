defmodule UserApplicationWeb.PlotLiveTest do
    use UserApplicationWeb.ConnCase

    import Phoenix.LiveViewTest
    import Mox

    alias UserApplication.{Accounts, Plots}

    setup :verify_on_exit!

    setup do
        UserApplication.Csv.Cache.start_link([name: :parser_test])
        :ok
    end

    test "redirects to / after a plot is created", %{conn: conn} do
        %{conn: conn} = register_and_log_in_user(%{conn: conn})
        {:ok, view, html} = live(conn, "/plot")
        assert html =~ "Create plot"

        csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
        6,148,72,35,0,33.6,0.627,50,1"

        expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %{body: csv_string, status_code: 200}} end)

        form_data = %{
            "plot[name]" => "My Plot",
            "plot[dataset_name]" => "My Dataset",
            "plot[expression]" => "x + y"
          }
      
          {:ok, conn} = 
            view
            |> form("form", form_data)
            |> render_submit()
            |> follow_redirect(conn, "/")

          assert conn.assigns.live_module == UserApplicationWeb.IndexLive
          [plot] = UserApplication.Plots.list_plots()
          assert plot.dataset_name === "My Dataset"
    end

    test "redirects to / after a plot is edited", %{conn: conn} do
      %{conn: conn} = register_and_log_in_user(%{conn: conn})

      user = Accounts.get_user_by_session_token(conn.private.plug_session["user_token"])
      {:ok, plot} = Plots.create_plot(%{dataset_name: "iris", name: "Iris", expression: "SepalWidth", ownership: %{account_id: user.account.id, ownership_status: :creator}})
      
      {:ok, view, html} = live(conn, "/plot?plot_id=#{plot.id}")
      assert html =~ "Save"
      assert html =~ plot.dataset_name

      csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
      6,148,72,35,0,33.6,0.627,50,1"

      expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %{body: csv_string, status_code: 200}} end)

      form_data = %{
          "plot[name]" => "My Plot",
          "plot[dataset_name]" => "My Dataset",
          "plot[expression]" => "x + y"
        }
    
        {:ok, conn} = 
          view
          |> form("form", form_data)
          |> render_submit()
          |> follow_redirect(conn, "/")

        assert conn.assigns.live_module == UserApplicationWeb.IndexLive
        [plot] = UserApplication.Plots.list_plots()
        assert plot.dataset_name === "My Dataset"
  end
end