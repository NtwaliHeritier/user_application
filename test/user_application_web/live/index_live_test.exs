defmodule UserApplicationWeb.IndexLiveTest do
    use UserApplicationWeb.ConnCase

    import Phoenix.LiveViewTest
    import Mox
    
    alias UserApplication.{Accounts, Plots}

    setup :verify_on_exit!

    setup do
        UserApplication.Csv.Cache.start_link([name: :parser_test])
        :ok
    end

    test "displays the index page", %{conn: conn} do
        %{conn: conn} = register_and_log_in_user(%{conn: conn})
        {:ok, view, html} = live(conn, "/")
        assert html =~ "Your plots"
        assert render(view) =~ "No plots to show"
        assert not has_element?(view, ".share")
    end

    test "display content on the index page", %{conn: conn} do
        %{conn: conn} = register_and_log_in_user(%{conn: conn})
        user = Accounts.get_user_by_session_token(conn.private.plug_session["user_token"])
        {:ok, _plot} = Plots.create_plot(%{dataset_name: "iris", name: "Iris", expression: "SepalWidth", created_ownership: %{account_id: user.account.id, ownership_status: :creator}})

        csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
        6,148,72,35,0,33.6,0.627,50,1"
        expect(HTTPoison.BaseMock, :get, 2, fn _ -> {:ok, %{body: csv_string, status_code: 200}} end)
        
        {:ok, view, _html} = live(conn, "/")
        assert has_element?(view, ".share")
    end
end