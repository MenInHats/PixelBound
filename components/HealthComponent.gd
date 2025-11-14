extends Resource

class_name HealthComponent

signal entity_died
signal health_changed(new_health)
signal health_healed(new_health)

@export var maxHealth := 100 
@export var curHealth := 10

func setHealthToMax() -> int:
	curHealth = clamp(curHealth, 0, maxHealth) #clamp allows for the setting of a custom health that doesent exceed the max health and is not below 0 health
	print("Player Health:", curHealth)
	return curHealth

func damageCalculation(recievedDamage: int) -> int:
	curHealth = max(curHealth - recievedDamage, 0) #max ensures curHealth does not go below 0 
	if curHealth <= 0:
		emit_signal("entity_died")
	int(curHealth)
	return curHealth

func healingCalculation(recievedHealth: int):
	curHealth = min(curHealth + recievedHealth, maxHealth) #min ensures curHealth does not go above the maxHealth
	emit_signal("health_healed", curHealth)

func killEntity():
	curHealth = 0
	emit_signal("health_changed", curHealth)
	emit_signal("entity_died")
	
func resetEntityHealth():
	curHealth = maxHealth
	emit_signal("health_healed", curHealth)

func isEntityDead() -> bool: #fuction to check if entity (self) is dead
	return curHealth <= 0
