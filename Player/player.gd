extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var isCrouch =false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("mCrouch"):
		isCrouch =!isCrouch
	
	if isCrouch:
		SPEED =2.0
	else:
		SPEED =5.0
	
	if isCrouch && $CollisionShape3D.shape.height >0.25:
		var crouchHeight =lerp($CollisionShape3D.shape.height, 0.25, 0.25)
		$CollisionShape3D.shape.height =crouchHeight
		
	if !isCrouch && $CollisionShape3D.shape.height >0.25:
		var crouchHeight =lerp($CollisionShape3D.shape.height, 2.0, 0.2)
		$CollisionShape3D.shape.height =crouchHeight
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("mJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if isCrouch:
			isCrouch =false

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("mLeft", "mRight", "mForward", "mBack")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
