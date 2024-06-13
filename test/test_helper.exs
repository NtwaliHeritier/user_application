ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(UserApplication.Repo, :manual)
# Mock http
Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Application.put_env(:user_application, :http_client, HTTPoison.BaseMock)
Application.put_env(:user_application, :ets_table_name, :csv_cache_test)
