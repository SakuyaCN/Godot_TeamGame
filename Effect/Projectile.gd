extends Area2D

onready var ray_cast := $RayCast2D
onready var trail := $Trail
#onready var hitbox := $Hitbox
#onready var animation_player := $AnimationPlayer

var vector := Vector2.ZERO
var start_position := Vector2.ZERO
var max_distance := 0.0
var hurt = 0.0
var scattering = 0.0
var role:Node

func _ready():
	trail.set_as_toplevel(true)
	trail.global_position = Vector2(0, 0)

func shoot(_role,_start_position: Vector2, _vector: Vector2, _max_distance: float,_scattering:float, _hurt: float,is_line) -> void:
	$Sprite.play(is_line)
	role = _role
	start_position = _start_position
	vector = _vector
	max_distance = _max_distance
	hurt = _hurt
	var num = 100 - _scattering
	if num > 0:
		scattering = rand_range(-num/2,num/2)
	global_position = _start_position

func _physics_process(delta: float) -> void:
	if vector == Vector2.ZERO:
		return
	
	# Add to trail before moving project, so we are using the last position
	# from the last frame.
	trail.add_point(global_position)
	while trail.get_point_count() > 3:
		trail.remove_point(0)
	
	var increment = vector * delta
	if scattering > 0.0:
		increment.y = scattering
	ray_cast.cast_to = increment

	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		global_position = ray_cast.get_collision_point()
		vector = Vector2.ZERO
	else:
		global_position += increment
	
	if start_position.distance_to(global_position) >= max_distance:
		queue_free()

func _on_Projectile_body_entered(_body: Node) -> void:
	role.fight_script.doAtk()
	queue_free()
