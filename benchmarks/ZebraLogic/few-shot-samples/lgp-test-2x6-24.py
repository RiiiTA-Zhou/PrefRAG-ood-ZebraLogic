# ## Context:
# There are 2 houses, numbered 1 to 2 from left to right, as seen from across the street. Each house is occupied by a different person. Each house has a unique attribute for each of the following characteristics:
#  - Each person has a unique name: `Eric`, `Arnold`
#  - Each person has a unique type of pet: `cat`, `dog`
#  - The people are of nationalities: `dane`, `brit`
#  - Each person has an occupation: `doctor`, `engineer`
#  - People have unique favorite sports: `soccer`, `basketball`
#  - Everyone has a unique favorite cigar: `prince`, `pall mall`
 
# ## Clues:
# 1. The person who has a cat and the Prince smoker are next to each other.
# 2. Eric is directly left of the person who owns a dog.
# 3. The Dane is not in the second house.
# 4. Arnold is the person who is a doctor.
# 5. The person who loves basketball is not in the second house.

# ## Headers:
# ["House", "Name", "Pet", "Nationality", "Occupation", "FavoriteSport", "Cigar"]

from z3 import *

# Declarations
house_sort, (house1, house2) = EnumSort('house', ['house1', 'house2'])
houses = [house1, house2]
person_sort, (Eric, Arnold) = EnumSort('person', ['Eric', 'Arnold'])
persons = [Eric, Arnold]
pet_sort, (cat, dog) = EnumSort('pet', ['cat', 'dog'])
pets = [cat, dog]
nationality_sort, (dane, brit) = EnumSort('nationality', ['dane', 'brit'])
nationalities = [dane, brit]
occupation_sort, (doctor, engineer) = EnumSort('occupation', ['doctor', 'engineer'])
occupations = [doctor, engineer]
sport_sort, (soccer, basketball) = EnumSort('sport', ['soccer', 'basketball'])
sports = [soccer, basketball]
cigar_sort, (prince, pall_mall) = EnumSort('cigar', ['prince', 'pall_mall'])
cigars = [prince, pall_mall]
person_of_house = Function('person_of_house', house_sort, person_sort)
pet_of_house = Function('pet_of_house', house_sort, pet_sort)
nationality_of_house = Function('nationality_of_house', house_sort, nationality_sort)
occupation_of_house = Function('occupation_of_house', house_sort, occupation_sort)
sport_of_house = Function('sport_of_house', house_sort, sport_sort)
cigar_of_house = Function('cigar_of_house', house_sort, cigar_sort)

# Constraints
pre_conditions = []
# Domain constraints
pre_conditions.append(Distinct([person_of_house(h) for h in houses]))
pre_conditions.append(Distinct([pet_of_house(h) for h in houses]))
pre_conditions.append(Distinct([nationality_of_house(h) for h in houses]))
pre_conditions.append(Distinct([occupation_of_house(h) for h in houses]))
pre_conditions.append(Distinct([sport_of_house(h) for h in houses]))
pre_conditions.append(Distinct([cigar_of_house(h) for h in houses]))
# clues
# The person who has a cat and the Prince smoker are next to each other.
h1 = Const('h1', house_sort)
h2 = Const('h2', house_sort)
pre_conditions.append(ForAll([h1, h2], Implies(And(pet_of_house(h1) == cat, cigar_of_house(h2) == prince), h1 != h2)))
# Eric is directly left of the person who owns a dog.
pre_conditions.append(person_of_house(house1) == Eric)
pre_conditions.append(pet_of_house(house2) == dog)
# The Dane is not in the second house.
h = Const('h', house_sort)
pre_conditions.append(ForAll([h], Implies(nationality_of_house(h) == dane, h != house2)))
# Arnold is the person who is a doctor.
h = Const('h', house_sort)
pre_conditions.append(ForAll([h], Implies(person_of_house(h) == Arnold, occupation_of_house(h) == doctor)))
# The person who loves basketball is not in the second house.
h = Const('h', house_sort)
pre_conditions.append(ForAll([h], Implies(sport_of_house(h) == basketball, h != house2)))

# Solve
s = Solver()
s.add(pre_conditions)
if s.check() == sat:
    m = s.model()
    models = []
    for num, h in enumerate(houses):
        model = {
            'House': str(num + 1),
            'Name': m.evaluate(person_of_house(h)),
            'Pet': m.evaluate(pet_of_house(h)),
            'Nationality': m.evaluate(nationality_of_house(h)),
            'Occupation': m.evaluate(occupation_of_house(h)),
            'FavoriteSport': m.evaluate(sport_of_house(h)),
            'Cigar': m.evaluate(cigar_of_house(h))
        }
        models.append(model)

    print(models)
else:
    print("UNSAT")