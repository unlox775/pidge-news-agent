def function(url) do
  # More later...
  url
  # Just lowercase for now
  |> String.downcase()
  # and strip all query params
  |> String.split("?") |> List.first()
end
