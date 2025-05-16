# As seen in the previous exercise, the time of day can be represented as the number of minutes before or after midnight. If the number of minutes is positive, the time is after midnight. If the number of minutes is negative, the time is before midnight.

# Write two methods that each take a time of day in 24 hour format, and return the number of minutes before and after midnight, respectively. Both methods should return a value in the range 0..1439.

# You may not use ruby's Date and Time methods.

# Yes, we know that 24:00 isn't a valid time in 24-hour format. Humor us, though; it makes the problem more interesting.
# Disregard Daylight Savings and Standard Time and other irregularities.

MINUTES_PER_HOUR = 60
HOURS_PER_DAY = 24
MINUTES_PER_DAY = 1440

def after_midnight(string)
  hours = string[0..1].to_i
  minutes = string[3..4].to_i
  hours % HOURS_PER_DAY * MINUTES_PER_HOUR + minutes
end

def before_midnight(string)
  (MINUTES_PER_DAY - after_midnight(string)) % MINUTES_PER_DAY
end


p after_midnight('00:00') == 0
p before_midnight('00:00') == 0
p after_midnight('12:34') == 754
p before_midnight('12:34') == 686
p after_midnight('24:00') == 0
p before_midnight('24:00') == 0
