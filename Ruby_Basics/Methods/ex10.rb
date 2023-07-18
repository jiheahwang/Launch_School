def name(namearray)
  namearray.sample
end

def activity(activityarray)
  activityarray.sample
end

def sentence(name, activity)
  name + " likes " + activity
end

names = ['Dave', 'Sally', 'George', 'Jessica']
activities = ['walking', 'running', 'cycling']

puts sentence(name(names), activity(activities))