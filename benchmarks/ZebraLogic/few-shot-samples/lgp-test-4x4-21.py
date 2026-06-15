# ##Context:
# There are 4 houses, numbered 1 to 4 from left to right, as seen from across the street. Each house is occupied by a different person. Each house has a unique attribute for each of the following characteristics:
#  - Each person has a unique name: `Eric`, `Peter`, `Alice`, `Arnold`
#  - People own unique car models: `tesla model 3`, `honda civic`, `toyota camry`, `ford f150`
#  - Each person has a unique birthday month: `jan`, `april`, `sept`, `feb`
#  - Each person has a unique hobby: `painting`, `cooking`, `gardening`, `photography`

# ## Clues:
# 1. The person whose birthday is in January is not in the second house.
# 2. The photography enthusiast is somewhere to the left of Eric.
# 3. The photography enthusiast is somewhere to the left of Peter.
# 4. The person who owns a Honda Civic is directly left of the person who owns a Tesla Model 3.
# 5. There is one house between the person who owns a Tesla Model 3 and the person who enjoys gardening.
# 6. The person who owns a Tesla Model 3 is Arnold.
# 7. The person whose birthday is in February is the person who loves cooking.
# 8. The person who owns a Toyota Camry is Peter.
# 9. The person whose birthday is in April is Arnold.
# 10. Alice is the photography enthusiast.
# 11. Peter is the person whose birthday is in January.

# ## Headers:
# ["House", "Name", "CarModel", "Birthday", "Hobby"]

from z3 import *

# Declarations
house_sort, (house1, house2, house3, house4) = EnumSort('house', ['house1', 'house2', 'house3', 'house4'])
houses = [house1, house2, house3, house4]
person_sort, (Eric, Peter, Alice, Arnold) = EnumSort('person', ['Eric', 'Peter', 'Alice', 'Arnold'])
persons = [Eric, Peter, Alice, Arnold]
car_model_sort, (tesla_model_3, honda_civic, toyota_camry, ford_f150) = EnumSort('car_model', ['tesla_model_3', 'honda_civic', 'toyota_camry', 'ford_f150'])
car_models = [tesla_model_3, honda_civic, toyota_camry, ford_f150]
birthday_sort, (jan, april, sept, feb) = EnumSort('birthday', ['jan', 'april', 'sept', 'feb'])
birthdays = [jan, april, sept, feb]
hobby_sort, (painting, cooking, gardening, photography) = EnumSort('hobby', ['painting', 'cooking', 'gardening', 'photography'])
hobbies = [painting, cooking, gardening, photography]
person_of_house = Function('person_of_house', house_sort, person_sort)
car_model_of_house = Function('car_model_of_house', house_sort, car_model_sort)
birthday_of_house = Function('birthday_of_house', house_sort, birthday_sort)
hobby_of_house = Function('hobby_of_house', house_sort, hobby_sort)
house_position = Function('house_position', house_sort, IntSort())

# Constraints
pre_conditions = []
# Domain constraints
pre_conditions.append(Distinct([person_of_house(h) for h in houses]))
pre_conditions.append(Distinct([car_model_of_house(h) for h in houses]))
pre_conditions.append(Distinct([birthday_of_house(h) for h in houses]))
pre_conditions.append(Distinct([hobby_of_house(h) for h in houses]))
for i, house in enumerate(houses):
    pre_conditions.append(house_position(house) == i)
# clues
# The person whose birthday is in January is not in the second house.
pre_conditions.append(birthday_of_house(house2) != jan)
# The photography enthusiast is somewhere to the left of Eric.
h1 = Const('h1', house_sort)
h2 = Const('h2', house_sort)
pre_conditions.append(ForAll([h1, h2], Implies(And(hobby_of_house(h1) == photography, person_of_house(h2) == Eric), house_position(h1) < house_position(h2))))
# The photography enthusiast is somewhere to the left of Peter.
pre_conditions.append(ForAll([h1, h2], Implies(And(hobby_of_house(h1) == photography, person_of_house(h2) == Peter), house_position(h1) < house_position(h2))))
# The person who owns a Honda Civic is directly left of the person who owns a Tesla Model 3.
pre_conditions.append(ForAll([h1, h2], Implies(And(car_model_of_house(h1) == honda_civic, car_model_of_house(h2) == tesla_model_3), house_position(h1) == house_position(h2) - 1)))
# There is one house between the person who owns a Tesla Model 3 and the person who enjoys gardening.
pre_conditions.append(ForAll([h1, h2], Implies(And(car_model_of_house(h1) == tesla_model_3, hobby_of_house(h2) == gardening), Abs(house_position(h1) - house_position(h2)) == 2)))
# The person who owns a Tesla Model 3 is Arnold.
pre_conditions.append(ForAll([h1], Implies(car_model_of_house(h1) == tesla_model_3, person_of_house(h1) == Arnold)))
# The person whose birthday is in February is the person who loves cooking.
pre_conditions.append(ForAll([h1], Implies(birthday_of_house(h1) == feb, hobby_of_house(h1) == cooking)))
# The person who owns a Toyota Camry is Peter.
pre_conditions.append(ForAll([h1], Implies(car_model_of_house(h1) == toyota_camry, person_of_house(h1) == Peter)))
# The person whose birthday is in April is Arnold.
pre_conditions.append(ForAll([h1], Implies(birthday_of_house(h1) == april, person_of_house(h1) == Arnold)))
# Alice is the photography enthusiast.
pre_conditions.append(ForAll([h1], Implies(person_of_house(h1) == Alice, hobby_of_house(h1) == photography)))
# Peter is the person whose birthday is in January.
pre_conditions.append(ForAll([h1], Implies(person_of_house(h1) == Peter, birthday_of_house(h1) == jan)))

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
            'CarModel': m.evaluate(car_model_of_house(h)),
            'Birthday': m.evaluate(birthday_of_house(h)),
            'Hobby': m.evaluate(hobby_of_house(h))
        }
        models.append(model)
    print(models)
else:
    print("UNSAT")