defmodule UserApplication.Csv.ParserTest do
    use UserApplication.DataCase
    import Mox

    alias UserApplication.Csv.{Cache, Parser}
    alias UserApplication.Plots

    setup :verify_on_exit!

    setup do
        Cache.start_link([name: :parser_test])
        :ok
    end

    test "save csv to cache" do
        csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
        6,148,72,35,0,33.6,0.627,50,1"

        {:ok, plot} = Plots.create_plot(%{dataset_name: "iris", name: "Iris", expression: "SepalWidth"})
        
        expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %{body: csv_string, status_code: 200}} end)

        assert true == Parser.cache_csv(plot)
        assert [{_key, ^csv_string}] = :ets.lookup(Application.get_env(:user_application, :ets_table_name), plot.name)
    end
end