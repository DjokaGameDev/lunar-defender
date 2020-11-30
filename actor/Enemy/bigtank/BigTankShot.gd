extends Sprite

var motion = Vector2(5,0)
var target = Vector2(0,0)

var ExplosionClass = preload("res://actor/Enemy/bigtank/BigTankShotExplosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#global_rotation = 0
	translate(motion)
	if global_position.distance_to(target) < 5:
		var explosion = ExplosionClass.instance()
		explosion.global_position = global_position
		get_tree().get_root().get_node_or_null("BattleField/GroundObject").add_child(explosion)
		queue_free()
		pass
	pass
