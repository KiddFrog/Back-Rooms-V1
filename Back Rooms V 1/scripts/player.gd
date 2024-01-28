extends CharacterBody3D

# Player nodes

@onready var standingCollisionShape = $standing_collision_shape
@onready var crouchingCollisionShape = $crouching_collision_shape
@onready var rayCast3D = $RayCast3D
@onready var neck = $neck
@onready var head = $neck/head
@onready var eyes = $neck/head/eyes
@onready var camera3D = $neck/head/eyes/Camera3D
@onready var hand = $neck/head/eyes/SpringArm3D/hand
@onready var spring_arm_3d = $neck/head/eyes/Camera3D/SpringArm3D
@onready var animation_player = $neck/head/SpringArm3D/HandV2/AnimationPlayer
@onready var key = $"../stage/CSGBox3D/CSGBox3D/WorldEnvironment/Key"




# Player speed variables
var currentSpeed = 5.0
@export var walkingSpeed = 5.0
@export var sprintingSpeed = 8.0
@export var crouchingSpeed = 3.0
@export var jumpVelocity = 4.5

# Headbobbing variables
const headBobbingSprintingSpeed = 22.0
const headBobbingWalkingSpeed = 14.0
const headBobbingCrouchingSpeed = 10.0
const headBobbingCrouchingIntensity = 0.05
const headBobbingWalkingIntensity = 0.01
const headBobbingSprintingIntensity = 0.02
var headBobbingVector = Vector2.ZERO
var headBobbingIndex = 0.0
var headBobbingCurrentIntensity = 0.0

# States
var walking = false
var sprinting = false
var crouching = false
var freeLooking = false
var sliding = false

# Player mouse and movement variables
var lerpSpeed = 10.0
const mouseSensitivity = .05
var direction = Vector3.ZERO
var crouchingDepth = -0.5
var freeLookTiltAmount = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		# Connect the mouse button input event to the _on_input_event method
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		if freeLooking:
			neck.rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
			head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-45), deg_to_rad(89))
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		## Check if the left mouse button was pressed
		#if event.pressed:
					## Play the "POINT" animation in the HandV2 AnimationPlayer
			## USE THIS LATER if animation_player.has_animation("POINT"):
			#print("Mouse clicked")
			#animation_player.play("POINT")


func _physics_process(delta):

	
	
	
	var inputDir = Input.get_vector("left", "right", "forward", "backwards")

	if Input.is_action_pressed("crouch"):
		currentSpeed = crouchingSpeed
		head.position.y = lerp(head.position.y, crouchingDepth, delta * lerpSpeed)
		standingCollisionShape.disabled = true
		crouchingCollisionShape.disabled = false
		walking = false
		sprinting = false
		crouching = true
	elif !rayCast3D.is_colliding():
		head.position.y = lerp(head.position.y, 0.0, delta * lerpSpeed)
		standingCollisionShape.disabled = false
		crouchingCollisionShape.disabled = true
		if Input.is_action_pressed("sprint"):
			currentSpeed = sprintingSpeed
			walking = false
			sprinting = true
			crouching = false
		else:
			currentSpeed = walkingSpeed
			walking = true
			sprinting = false
			crouching = false
		if Input.is_action_pressed("free_look"):
			freeLooking = true
			camera3D.rotation.z = -deg_to_rad(neck.rotation.y * freeLookTiltAmount)
		else:
			freeLooking = false
			camera3D.rotation.z = lerp(camera3D.rotation.z, 0.0, delta * lerpSpeed)
			neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerpSpeed)

	if sprinting:
		headBobbingCurrentIntensity = headBobbingSprintingIntensity
		headBobbingIndex += headBobbingSprintingSpeed * delta
	elif walking:
		headBobbingCurrentIntensity = headBobbingWalkingIntensity
		headBobbingIndex += headBobbingWalkingSpeed * delta
	elif crouching:
		headBobbingCurrentIntensity = headBobbingCrouchingIntensity
		headBobbingIndex += headBobbingCrouchingSpeed * delta
		
	if is_on_floor() && inputDir != Vector2.ZERO:
		headBobbingVector.y = sin(headBobbingIndex)
		headBobbingVector.x = sin(headBobbingIndex / 2) + 0.5
		eyes.position.y = lerp(eyes.position.y, headBobbingVector.y * (headBobbingCurrentIntensity / 2.0), delta * lerpSpeed)
		eyes.position.x = lerp(eyes.position.x, headBobbingVector.x * headBobbingCurrentIntensity, delta * lerpSpeed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerpSpeed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerpSpeed)

	
	if !is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = jumpVelocity

	direction = lerp(direction, (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized(), delta * lerpSpeed)

	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)




	move_and_slide()
