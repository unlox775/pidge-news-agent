def function(report, last_reported) do
  last_reported = if last_reported, do: last_reported, else: %{}
  previous_report = last_reported.last_report

  %{}
  |> Map.put(:last_report_date, Date.to_iso8601(Date.utc_today()))
  |> Map.put(:last_report, report)
  |> Map.put(:previous_reports, Map.put(
    Map.get(last_reported, :previous_reports, %{}),
    previous_report.last_report_date,
    previous_report
    ))

end
