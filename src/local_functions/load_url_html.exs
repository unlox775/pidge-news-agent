def function(url) do
  # if the URL has any double-quotes or dollar signs then URL encode them
  url =
    url
    |> String.replace("\"", "%22")
    |> String.replace("$", "%24")

  # Run the bin/html_to_markdown command-line script in a shell.
  #   pipe in html using bash, and return the result
  {html, 0} = System.cmd("bin/get_url_html_post_js_render", [url], into: "")
end
