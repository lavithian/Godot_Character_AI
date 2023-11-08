extends Area3D

var velocity = Vector3.ZERO
var speed : float = 30.0

func initialize_velocity1(direction): 
	direction.y = 0
	var rotated_direction = direction.rotated(Vector3.UP, deg_to_rad(90));
	velocity = rotated_direction.normalized() * speed


func _physics_process(delta):
	var motion = velocity * delta
	translate(motion)
	
	if global_transform.origin.y < - 50 || global_transform.origin.x < -50 || global_transform.origin.y >  50 || global_transform.origin.x > 50  :
		queue_free()
