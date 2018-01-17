# Active-Replay

A Ruby ORM tool used to turn simple SQL queries and results into Ruby objects and instances of classes. 

# Features 

* Class inheritance of the `SQLiteObject` base class to have access to all of the functionality. 
```
class Pokemon < SQLObject

 (#...)
 
end 
```
* Save and update rows in the database 
```
Pokemon.save({id: 1, name: "pikachu", type: "electric" trainer_id: 1})

# Checks the database if a pokemon with the id of 1 exists. 
# If it does, it updates the row. If it doesn't, it inserts the row. 
```
* Make SQL queries with basic "WHERE" clauses 

```
Pokemon.where({type: "electric"})
```
* Make basic associations 
```
class Pokemon < SQLObject 
   belongs_to :trainer
   # if the foreign keys and class name are all uniform, you do not need to specify anything other than the class it belongs to
   has_one_through :gym, :trainer, :gym
end 

class Trainer < SQLObject
   belongs_to :gym
   has_many :pokemon
end 

class Gym < SQLObject 
  has_many :trainers 
  has_many_through :pokemon, :trainers, :pokemon
end 
```
