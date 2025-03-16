import json
from typing import DefaultDict


with open("query_results/driver_races.csv", "r") as f:
    rows = f.read().replace('"', '').split("\n")[1:-1]
driver_races = {
    row.split(",")[0]: row.split(",")[1:]
    for row in rows
}
print(len(driver_races.keys()))

grouped_by_num_races = DefaultDict(dict)
for driver, races in driver_races.items():
    grouped_by_num_races[len(races)][int(driver)] = [int(race) for race in races]
grouped_by_num_races_ordered = dict()
for key in sorted(grouped_by_num_races.keys(), reverse=True):
    grouped_by_num_races_ordered[key] = grouped_by_num_races[key]

# print(json.dumps(grouped_by_num_races_ordered, indent=4))

unique_drivers = dict()
subsets = DefaultDict(list)
for frequency, driver_races in grouped_by_num_races_ordered.items():
    for driver, races in driver_races.items():
        subset_parent = None
        for previous_driver, pd_races in unique_drivers.items():
            if set(races).issubset(set(pd_races)):
                subset_parent = previous_driver
                break
        if subset_parent:
            subsets[subset_parent].append(driver)
        else:
            unique_drivers[driver] = races

print(len(unique_drivers.keys()))

races = DefaultDict(set)
for driver, driver_races in unique_drivers.items():
    for race in driver_races:
        races[race].add(driver)

# def get_driver_combinations(drivers_so_far, remaining_races, smallest_size_set=1000):
#     for d in races[remaining_races[0]]:
#         resultant_set = set(remaining_races) - set(unique_drivers[d])
#         if len(resultant_set) == 0:
#             yield drivers_so_far + [d]
#         elif len(drivers_so_far) + 1 >= smallest_size_set:
#             break
#         else:
#             yield from get_driver_combinations(drivers_so_far + [d], list(resultant_set))

# all_race_ids = list(races.keys())
# driver_sets = set()
# c = 0
# for driver_set in get_driver_combinations([], all_race_ids):
#     driver_sets.add("-".join([str(d) for d in sorted(driver_set)]))
#     c += 1
#     if c % 1000 == 0:
#         print(c)

# find the unmatched race with fewest options
# of the drivers who raced that race find the one who would cover the most remaining races

# remaining_race_ids = set(races.keys())
# drivers_included = set()
# while len(remaining_race_ids) > 0:
#     first_unmatched_race = min(remaining_race_ids)
#     drivers_in_race = races[first_unmatched_race]
#     new_driver = 0
#     new_driver_races = set()

#     # select the driver from the race who would tick off most new races
#     for driver in drivers_in_race:
#         driver_races = remaining_race_ids.intersection(set(unique_drivers[driver]))
#         if len(driver_races) > len(new_driver_races):
#             new_driver = driver
#             new_driver_races = driver_races
    
#     # add the selected driver
#     drivers_included.add(new_driver)
#     remaining_race_ids.difference_update(new_driver_races)

#   [1, 24, 38, 82, 276, 340, 454, 539, 629, 685, 762, 763]


remaining_race_ids = set(races.keys())
drivers_included = set()
while len(remaining_race_ids) > 0:
    new_driver = 0
    new_driver_races = set()

    # select the driver from the race who would tick off most new races
    for driver, driver_races in unique_drivers.items():
        driver_races = remaining_race_ids.intersection(set(driver_races))
        if len(driver_races) > len(new_driver_races):
            new_driver = driver
            new_driver_races = driver_races
    
    # add the selected driver
    drivers_included.add(new_driver)
    remaining_race_ids.difference_update(new_driver_races)

print(sorted(list(drivers_included)))
    

with open("unique_drivers.csv", "w+") as f:
    for race in sorted(races.keys()):
        drivers = races[race]
        f.write(f"{race},")
        for driver in sorted(unique_drivers.keys()):
            f.write("1," if driver in drivers else ",")
        f.write("\n")


print()

for i in [1, 5, 17, 38, 48, 50, 71, 94, 102, 115, 126]:
    print(sorted(unique_drivers.keys())[i-1])

print()


for i in [118, 123, 125, 127]:
    print(sorted(unique_drivers.keys())[i-1])