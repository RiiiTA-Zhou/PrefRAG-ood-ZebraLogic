# ## Context:
# There are 5 houses, numbered 1 to 5 from left to right, as seen from across the street. Each house is occupied by a different person. Each house has a unique attribute for each of the following characteristics:
#  - Each person has a unique name: `Alice`, `Bob`, `Arnold`, `Peter`, `Eric`
#  - People have unique favorite sports: `tennis`, `baseball`, `soccer`, `basketball`, `swimming`

# ## Clues:
# 1. The person who loves tennis is not in the fifth house.
# 2. The person who loves swimming and Alice are next to each other.
# 3. The person who loves swimming is directly left of the person who loves tennis.
# 4. Eric is the person who loves soccer.
# 5. Eric is in the first house.
# 6. Arnold is in the second house.
# 7. Peter is the person who loves baseball.
# 8. Alice is not in the third house.

# ## Headers:
# ["House", "Name", "FavoriteSport"]
from z3 import *

# Declarations
house_sort, (house1, house2, house3, house4, house5) = EnumSort('house', ['house1', 'house2', 'house3', 'house4', 'house5'])
houses = [house1, house2, house3, house4, house5]
person_sort, (Alice, Bob, Arnold, Peter, Eric) = EnumSort('person', ['Alice', 'Bob', 'Arnold', 'Peter', 'Eric'])
persons = [Alice, Bob, Arnold, Peter, Eric]
sport_sort, (tennis, baseball, soccer, basketball, swimming) = EnumSort('sport', ['tennis', 'baseball', 'soccer', 'basketball', 'swimming'])
sports = [tennis, baseball, soccer, basketball, swimming]
person_of_house = Function('person_of_house', house_sort, person_sort)
sport_of_house = Function('sport_of_house', house_sort, sport_sort)

house_position = Function('house_position', house_sort, IntSort())


# Constraints
pre_conditions = []
# Domain constraints
pre_conditions.append(Distinct([person_of_house(h) for h in houses]))
pre_conditions.append(Distinct([sport_of_house(h) for h in houses]))
for i, house in enumerate(houses):
    pre_conditions.append(house_position(house) == i)
# clues
# The person who loves tennis is not in the fifth house.
pre_conditions.append(sport_of_house(house5) != tennis)
# The person who loves swimming and Alice are next to each other.
h1 = Const('h1', house_sort)
h2 = Const('h2', house_sort)
pre_conditions.append(ForAll([h1, h2], Implies(And(sport_of_house(h1) == swimming, person_of_house(h2) == Alice), Abs(house_position(h1) - house_position(h2)) == 1)))
# The person who loves swimming is directly left of the person who loves tennis.
pre_conditions.append(ForAll([h1, h2], Implies(And(sport_of_house(h1) == swimming, sport_of_house(h2) == tennis), house_position(h1) == house_position(h2) - 1)))
# Eric is the person who loves soccer.
pre_conditions.append(ForAll([h1], Implies(person_of_house(h1) == Eric, sport_of_house(h1) == soccer)))
# Eric is in the first house.
pre_conditions.append(person_of_house(house1) == Eric)
# Arnold is in the second house.
pre_conditions.append(person_of_house(house2) == Arnold)
# Peter is the person who loves baseball.
pre_conditions.append(ForAll([h1], Implies(person_of_house(h1) == Peter, sport_of_house(h1) == baseball)))
# Alice is not in the third house.
pre_conditions.append(person_of_house(house3) != Alice)

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
            'FavoriteSport': m.evaluate(sport_of_house(h))
        }
        models.append(model)
    print(models)
else:
    print("UNSAT")