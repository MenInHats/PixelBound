extends Resource

class_name HealthComponent

@export var maxHealth := 100 
@export var curHealth := 10
@export var minHealth := 0
var entityIsDead

func damage_calculation(recievedDamage: int) -> int:
	curHealth = max(curHealth - recievedDamage, 0) #max ensures curHealth does not go below 0 
	int(curHealth)
	return curHealth

func healing_calculation(recievedHealth: int):
	curHealth = min(curHealth + recievedHealth, maxHealth) #min ensures curHealth does not go above the maxHealth
	return curHealth
	
func reset_entity_health():
	curHealth = maxHealth
	return curHealth

func is_entity_dead(entity_health) -> bool: #fuction to check if entity (self) is dead
	return entity_health <= 0
