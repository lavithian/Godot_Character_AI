extends Node3D

const SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var test

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapssed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding() :
		var format_string = "Ray ID: %s."
		print (format_string % ray.get_collider().name)
		if (ray.get_collider() && ray.get_collider().name == "Enemy") :
			print ("Wahoo!")
			ray.get_collider().health -= 10
		#ray.get_collider().health = 50
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	pass

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
