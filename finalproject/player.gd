extends CharacterBody2D

@export var speed := 250.0
@export var jump_force := -450.0
@export var gravity := 1200.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

func _physics_process(delta):

	handle_gravity(delta)
	handle_jump()
	handle_movement()

	move_and_slide()

	#update_animation()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func handle_movement():
	var direction = Input.get_axis("move_left", "move_right")

	velocity.x = direction * speed

	if direction != 0:
		sprite.flip_h = direction < 0
#
#func update_animation():
#
	#if not is_on_floor():
		#animation.play("jump")
#
	#elif velocity.x != 0:
		#animation.play("run")
#
	#else:
		#animation.play("idle")
