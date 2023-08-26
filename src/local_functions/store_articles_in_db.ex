def function(all_articles, db) do
  db
  |> Enum.reduce(db, fn {article, article_i}, acc ->
    # Normalize the URL, as we use it as our unique key
    article = Map.put(article, :url, Local.normalize_url(article.url))

    # search if an article by this url is already in the db
    existing_article = db.all_urls.has_key?(article.url)

    case existing_article do
      true ->
        # get the date as the value of the all_urls map
        date = db.all_urls[article.url]
        article = db.by_date[date][article.url]

        meta = Map.get(article, :meta, %{})

        updated_meta =
          meta
          |> Map.put(:recrawl_count, Map.get(meta, :crawl_count, 0) + 1)
          |> Map.put(:recrawl_summaries, Map.get(meta, :crawl_summaries, []) ++ [article.one_thorough_sentence_summary])

        # update the article in the db
        Util.deep_put(acc, [:by_date, article.url], Map.put(article, :meta, updated_meta))
      false ->
        new_by_date =
          Map.get(db.by_date, article.date, %{})
          |> Map.put(article.url, article)

        db
        |> Map.put(:all_urls, Map.put(db.all_urls, article.url, article.date))
        |> Map.put(:by_date, Map.put(db.by_date, article.date, new_by_date))
    end
  end)
end
