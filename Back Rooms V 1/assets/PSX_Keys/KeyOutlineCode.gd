extends Node3D

# Declare variables for key_scene, key_racing, and key_outline
var key_scene
var key_racing
var key_outline

func _ready():
	# Initialize the key_scene variable with the root of the scene tree
	key_scene = $"."
	# Initialize the key_racing variable with the "key_racing" node
	key_racing = $key_racing
	# Attempt to initialize the key_outline variable with the "keyOutline" node under "key_racing"
	key_outline = $key_racing/keyOutline

	# Check if key_outline is a valid node
	if key_outline != null:
		# Print a debug message if key_outline is valid
		print("key_outline node found:", key_outline)
		# Connect the `mouse_entered` and `mouse_exited` signals of the keyOutline mesh
		key_outline.connect("mouse_entered", self, "_on_key_outline_mouse_entered")
		key_outline.connect("mouse_exited", self, "_on_key_outline_mouse_exited")
	else:
		# Print an error message if key_outline is not valid
		print("key_outline node not found or is null")

# Called when the mouse enters the keyOutline mesh.
func _on_key_outline_mouse_entered():
	print("Hover on keyOutline")  # Debug message to check if the signal is received
	key_outline.visible = true  # Set the visibility of the keyOutline mesh to true

# Called when the mouse exits the keyOutline mesh.
func _on_key_outline_mouse_exited():
	print("Hover off keyOutline")  # Debug message to check if the signal is received
	key_outline.visible = false  # Set the visibility of the keyOutline mesh to false
