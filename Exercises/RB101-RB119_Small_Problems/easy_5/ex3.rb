def after_midnight(string)
  hours = string[0..1].to_i
  minutes = string [3..4].to_i
  minutes + (hours % 24) * 60
end

def before_midnight(string)
  (1440 - after_midnight(string)) % 1440
end


p after_midnight('00:00') == 0
p before_midnight('00:00') == 0
p after_midnight('12:34') == 754
p before_midnight('12:34') == 686
p after_midnight('24:00') == 0
p before_midnight('24:00') == 0