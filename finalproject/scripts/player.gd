extends CharacterBody2D

@export var speed := 250.0
@export var jump_force := -450.0
@export var gravity := 1200.0

# Fly variables
@export var fly_speed := -300.0 
@export var fly_delay := 0.3 # Time in seconds required to hold jump before flying starts
var jump_hold_timer := 0.0
var is_flying := false

# Dash variables
@export var dash_speed := 1000.0
@export var dash_duration := 0.3
@export var dash_cooldown := 1.0 

var is_dashing := false
var can_dash := true
var dash_timer := 0.0
var cooldown_timer := 0.0
var dash_direction := 1.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

func _physics_process(delta):
	# Handle cooldown progression
	if not can_dash:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_dash = true

	if is_dashing:
		handle_dash(delta)
	else:
		handle_jump_and_fly(delta)
		handle_movement()
		handle_dash_input()

	move_and_slide()
	#update_animation()

func handle_jump_and_fly(delta):
	# If jump is being held down
	if Input.is_action_pressed("jump"):
		jump_hold_timer += delta
		
		# Initial tap jump trigger on the exact frame it is pressed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_force

		# Check if the hold duration satisfies the flight requirement
		if jump_hold_timer >= fly_delay:
			is_flying = true
			velocity.y = fly_speed
		else:
			is_flying = false
			handle_gravity(delta)
	else:
		# Reset tracking variables when jump button is completely released
		jump_hold_timer = 0.0
		is_flying = false
		handle_gravity(delta)

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement():
	var direction = Input.get_axis("move_left", "move_right")

	velocity.x = direction * speed

	if direction != 0:
		sprite.flip_h = direction < 0
		dash_direction = direction

func handle_dash_input():
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		is_dashing = true
		can_dash = false
		dash_timer = dash_duration
		cooldown_timer = dash_cooldown
		velocity.y = 0 
		is_flying = false # Cancel flight when starting a dash

func handle_dash(delta):
	dash_timer -= delta
	velocity.x = dash_direction * dash_speed
	
	if dash_timer <= 0:
		is_dashing = false

#func update_animation():
#	if is_dashing:
#		animation.play("dash")
#	elif is_flying:
#		animation.play("fly")
#	elif not is_on_floor():
#		animation.play("jump")
#	elif velocity.x != 0:
#		animation.play("run")
#	else:
#		animation.play("idle")
