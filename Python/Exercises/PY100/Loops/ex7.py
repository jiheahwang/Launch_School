cities = ['Istanbul', 'Los Angeles', 'Tokyo', None,
          'Vienna', None, 'London', 'Beijing', None]

for city in cities:
    if city == None:
        continue
    else:
        print(len(city))