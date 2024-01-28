extends Node3D
@onready var lp_hands = $player/neck/head/SpringArm3D/HandV2/LP_hands
@onready var animation_player = $player/neck/head/SpringArm3D/HandV2/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("IDLE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
