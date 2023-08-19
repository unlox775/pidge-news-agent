def function(html, word_limit \\ nil) do
  # write the HTML to a random /tmp/ file
  tmp_file_path = "/tmp/#{System.unique_integer()}-news-agent.html"
  File.write!(tmp_file_path, html)

  word_limit_arg =
    case word_limit do
      nil -> ""
      _ -> "--limit-words #{word_limit}"
    end

  # Run the bin/html_to_markdown command-line script in a shell.
  #   pipe in html using bash, and return the result
  {markdown, 0} = System.cmd("bash", ["-c", "cat #{tmp_file_path} | bin/html_to_markdown #{word_limit_arg}"], into: "")

  # remove the temp file
  File.rm!(tmp_file_path)
end
