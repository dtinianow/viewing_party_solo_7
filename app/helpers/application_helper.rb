module ApplicationHelper
  def format_minutes(minutes)
    hours = minutes / 60
    mins = minutes % 60
    format('%d hr and %d min', hours, mins)
  end
end
