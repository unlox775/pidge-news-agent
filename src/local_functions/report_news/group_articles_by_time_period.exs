def function(db) {
  # 1. Last month:
  current_date = Date.utc_today()
  first_of_current_month = Date.new(current_date.year, current_date.month, 1)
  last_day_of_last_month = Date.add(first_of_current_month, -1)
  last_month = to_year_month(last_day_of_last_month)

  # 2. List of the 11 months before last_month:
  last_year_months = Enum.map(0..10, fn num ->
    Date.add(first_of_current_month, ((num+1) * -30) - 15)
    |> to_year_month()
  end)
  |> Enum.reverse()
  |> tl()  # removing the current month

  # 3. Last 7 days:
  last_week_days = Enum.map(1..7, fn days_behind ->
    Date.add(current_date, -days_behind)
  end)
  |> Enum.map(&(Date.to_iso8601(&1)))

  %{}
  |> Map.put(:last_week, compile_last_week(db, last_week_days))
  |> Map.put(:last_month, compile_last_month(db, last_month))
  |> Map.put(:months, compile_last_year(db, last_year_months))
end

# Helper function to get the YYYY-MM format
defp to_year_month(date) do
  year = date.year
  month = date.month
  "#{year}-#{String.pad_leading(Integer.to_string(month), 2, "0")}"
end}

def compile_last_week(db, last_week_days) do
  last_week_days
  |> Enum.map(fn day ->
    db.by_date[day]
  end)
  |> List.flatten()
end

def compile_last_month(db, last_month) do
  # loop through db.by_date keys, and if they are in last_month, add them to the list
  db.by_date
  |> Map.keys()
  |> Enum.filter(fn date ->
    # if the first YYYY-MM of the date is the same as last_month, keep it
    String.slice(date, 0, 7) == last_month
  end)
  |> Enum.map(fn date ->
    db.by_date[date]
  end)
  |> List.flatten()
end

def compile_last_year(db, last_year_months) do
  last_year_months
  |> Enum.reduce(%{}, fn month, acc ->
    acc
    |> Map.put(month, compile_last_month(db, month))
  end
end
