extends Area3D

@onready var hand_v_2 = $"../../../../../../player/neck/head/SpringArm3D/HandV2"
@onready var animation_player = $"../../../../../../player/neck/head/SpringArm3D/HandV2/AnimationPlayer"
@onready var lp_hands = $"../../../../../../player/neck/head/SpringArm3D/HandV2/LP_hands"
@onready var collision_shape_3d = $CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready():
	# Create a Callable object for the _on_mouse_entered method
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Connect the mouse_entered signal to the Callable object
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	input_event.connect(_on_input_event)

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		on_mouse_click()

func _on_area_3d_mouse_entered():
	print("I am the Mouse, I have entered!")

# This function will be called when the mouse enters the Area3D node
func _on_mouse_entered():
	print ("I'm in the correct area!")
	# Add code later to add text for the player to read

func on_mouse_click():
	#Play the "GRAB" animation in the HandV2 AnimationPlayer
	print("I clicked")
	if animation_player.has_animation("GRAB"):
		animation_player.play("GRAB")
	else:
		print("No GRAB animation found.")
		
func _on_mouse_exited():
	print("I've exited the building")


