defmodule UserApplication.Csv.CacheTest do
    use UserApplication.DataCase

    alias UserApplication.Csv.Cache

    test "checks flow of cache" do
        csv_string = "Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome
        6,148,72,35,0,33.6,0.627,50,1"

        assert {:ok, _pid} = Cache.start_link([name: :test_server])
        assert true = Cache.insert("Iris", csv_string)
        assert [{_, ^csv_string}] = Cache.get("Iris")
    end
end