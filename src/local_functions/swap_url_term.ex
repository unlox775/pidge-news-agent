def function(url,term) do
  # Replace "[TERM]" with the search term
  url |> String.replace("[TERM]", term)
end
