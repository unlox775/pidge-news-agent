def function(html, json_extractor_definition) do
  # write the HTML to a random /tmp/ file
  tmp_html_file_path = "/tmp/#{System.unique_integer()}-news-agent.html"
  File.write!(tmp_html_file_path, html)

  # convert the json_extractor_definition to a JSON string if is it a map
  json_extractor_definition_txt =
    case json_extractor_definition do
      %{} -> Jason.encode!(json_extractor_definition)
      _ -> json_extractor_definition
    end

  # write the json_extractor_definition to a random /tmp/ file
  tmp_json_extractor_definition_file_path = "/tmp/#{System.unique_integer()}-news-agent.json"
  File.write!(tmp_json_extractor_definition_file_path, json_extractor_definition_txt)

  # Run the bin/dom_extractor command-line script in a shell.
  #   pipe in html using bash, and return the result
  IO.puts("Running: bin/dom_extractor #{tmp_html_file_path} #{tmp_json_extractor_definition_file_path}")
  args = [
    tmp_html_file_path,
    tmp_json_extractor_definition_file_path
    ]

  result =
    with 1 <- 1,
      {extract_json, 0} <- System.cmd("bin/dom_extractor",args, into: ""),
      {:ok, extract} <- Jason.decode(extract_json)
    do
      extract
    else
      {:error, error} -> raise "Could not parse JSON from dom_extractor\n\n#{error}"
      {error_in_cmd, 1} -> raise "Error running dom_extractor\n\n#{error_in_cmd}"
      error_in_cmd -> raise "Could not run dom_extractor\n\n#{inspect error_in_cmd}"
    end

  # remove the temp file
  File.rm!(tmp_html_file_path)
  File.rm!(tmp_json_extractor_definition_file_path)

  result
end
