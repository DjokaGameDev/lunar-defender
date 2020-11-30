extends Line2D

export (float, 0.5, 3.0) var spread_angle := 1.2
export (int, 1, 36) var segments := 12
export var damage = 20.0

var bouncing_number = 0
var point_end := Vector2.ZERO
var current_target = null

var bounce_this_step = 2

onready var sparks := $Particles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	pass # Replace with function body.


func create(start: Vector2, target) -> void:
	current_target = target
	$BouncingDetection.global_position = target.global_position

	sparks.global_position = target.global_position
	sparks.global_rotation = (target.global_position - start).angle() - 3.14
	sparks.visible = true
		
	point_end = target.global_position

	var _points := []
	var _start := start
	var _end := point_end
	var _segment_length := _start.distance_to(_end) / segments

	_points.append(_start)

	var _current := _start

	for _segment in range(segments):
		# Face the end point and extend towards it
		# Rotate a random amount to get next point
		var _rotation := rand_range(-spread_angle / 2, spread_angle / 2)
		var _new := _current + (_current.direction_to(_end) * _segment_length).rotated(_rotation)
		_points.append(_new)
		_current = _new

	_points.append(_end)
	points = _points
	
	target.modify_health(-damage)
	
	pass

func bounce():
	if bouncing_number > 0:
		var thunder = null
		var ThunderClass = load("res://actor/Swarm/ThunderSwarm/ThunderBolt.tscn")
		
		var current_bounce = 0
		var overlapping_areas = $BouncingDetection.get_overlapping_bodies()
		for area in overlapping_areas:
			if area != current_target and current_bounce < bounce_this_step:
				thunder = ThunderClass.instance()
				thunder.bouncing_number = bouncing_number - 1
				thunder.damage = damage * 6.0 / 10.0
				get_parent().add_child(thunder)
				thunder.create($BouncingDetection.global_position, area)
				current_bounce = current_bounce + 1
			
	pass
