extends KinematicBody2D

export var starting_health = 100
var health

var move_speed = 150
export (NodePath) var patrol_path = ""
var patrol_points
var patrol_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	health = starting_health
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 2:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	var velocity = (target - position).normalized() * move_speed
	global_rotation = velocity.angle()
	velocity = move_and_slide(velocity)
	pass
