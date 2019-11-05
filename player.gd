"""
Player script
"""
extends KinematicBody2D

export (int) var run_speed: int = 100
export (int) var jump_speed: int = -400
export (int) var gravity: int = 1200

var velocity: Vector2 = Vector2()
var jumping: bool = false


func play_animation(animation: String, flip=null) -> void:
	"""
	Play Animation is used to change or flip an animated
	sprite, max possible arguments is 2
	
	animation:
		type: string
		description:
			reference to the animation to play
	flip:
		type: optionally boole
		description:
			flips sprite horizontally if true
	
	returns:
		void
	"""
	if not $Sprite.is_playing():
		$Sprite.play(animation)
	
	if $Sprite.animation != animation:
		$Sprite.animation = animation

	if flip != null:
		if flip:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	

func get_input() -> void:
	"""
	Get Input takes the input from the user in order to control
	the player
	
	returns:
		void
	"""
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed

	if right:
		velocity.x += run_speed
		play_animation('walk', false)

	if left:
		play_animation('walk', true)
		velocity.x -= run_speed
	
	if velocity.x == 0:
		play_animation('idle')


func _physics_process(delta: float) -> void:
	"""
	Physics Process is a standard function used to process physics
	of the game
	
	delta:
		type: float
		description:
			lenght of time to process last freme
	
	returns:
		void
	"""
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	