defmodule UserApplication.Csv.Scrapper do
    def get(name) do
        with {:ok, %{status_code: 200, body: body}} <- http_client().get("https://raw.githubusercontent.com/plotly/datasets/master/#{name}.csv") do
          body
        else
          _ -> :error
        end
      end

      def http_client do
        Application.get_env(:user_application, :http_client)
      end
end