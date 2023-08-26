def function(html, article_name, first_few_words_of_each_piece_of_text_in_article_listing) do
  # write the HTML to a random /tmp/ file
  tmp_file_path = "/tmp/#{System.unique_integer()}-news-agent.html"
  File.write!(tmp_file_path, html)

  # Run the bin/get_subhtml command-line script
  IO.puts("Running: bin/get_subhtml --input #{tmp_file_path} --article_name #{article_name} #{first_few_words_of_each_piece_of_text_in_article_listing |> Enum.join(" ")}}")
  {subhtml, 0} = System.cmd("bin/get_subhtml", ["--input", tmp_file_path, "--article_name", article_name] ++ first_few_words_of_each_piece_of_text_in_article_listing, into: "")

  # parse subhtml as a JSON object
  subhtml_json = Jason.decode!(subhtml)

  # remove the temp file
  File.rm!(tmp_file_path)

  subhtml_json
end
