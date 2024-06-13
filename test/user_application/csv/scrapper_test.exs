defmodule UserApplication.Csv.ScrapperTest  do
    use ExUnit.Case

    import Mox

    alias UserApplication.Csv.Scrapper

    setup :verify_on_exit!

    test "returns csv on 200" do
        csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
        6,148,72,35,0,33.6,0.627,50,1"
        
        expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %{body: csv_string, status_code: 200}} end)

        assert csv_string === Scrapper.get("iris")
    end

    test "returns error 404" do
        expect(HTTPoison.BaseMock, :get, fn _ -> {:error, :could_not_fetch_csv} end)
        assert :error === Scrapper.get("error_dataset")
    end
end