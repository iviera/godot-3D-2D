extends CharacterBody3D

# En 3D, las unidades son metros. 5.0 a 10.0 es una velocidad normal.
const SPEED = 8.0 
const JUMP_VELOCITY = 5.0

@onready var anim: AnimationPlayer = %AnimationPlayer

func _physics_process(delta: float) -> void:
	# Gravedad estándar
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Forzamos que no haya movimiento en el eje Z (profundidad)
	velocity.z = 0
	
	if direction:
		velocity.x = direction * SPEED
		
		# Animación de correr
		if anim.current_animation != "AnimPack1/FastRun":
			anim.play("AnimPack1/FastRun")
		
		# Rotación suave o instantánea
		$character.rotation.y = PI/2 if direction > 0 else -PI/2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Animación de Idle
		if anim.current_animation != "AnimPack1/Idle":
			anim.play("AnimPack1/Idle")
	
	move_and_slide()
	
	# Truco extra: mantener siempre la Z en 0 por si las colisiones lo empujan
	global_position.z = 0
