def function(db, articles_grouped) do
  Map.keys(articles_grouped.months)
  |> Enum.map(fn month ->
    db.by_month[month]
  end)
end
