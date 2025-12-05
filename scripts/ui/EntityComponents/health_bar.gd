class_name HealthBar
extends ProgressBar

var parent_node #CharacterBody2D
@export var health_component : HealthComponent = null
var max_Health := 1
var min_Health := 0

# get parent node e.g.:'player', and set the health_component and ists values
#note instaciate does not work, simply copy the node from the component scene to add
func _ready():
	parent_node = get_parent()
	health_component = parent_node.health_component
	max_Health = health_component.maxHealth
	min_Health = health_component.minHealth
	
func _process(_delta):
	self.value = clamp(health_component.curHealth * 100 / health_component.maxHealth, 0, 100)
	if health_component.curHealth == max_Health:
		self.visible = false
		if health_component.curHealth == min_Health:
			self.visible = false
	else:
		self.visible = true
	
