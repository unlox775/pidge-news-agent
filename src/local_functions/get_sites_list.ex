def function(sites_as_map) do
  # we just need the values, but with a stable sort by the key names
  sites_as_map
  |> Map.values()
  |> Enum.sort_by(fn site -> site["url"] end)
end
