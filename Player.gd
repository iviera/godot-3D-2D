extends CharacterBody3D

const SPEED = 8.0 
const JUMP_VELOCITY = 5.0

@onready var anim: AnimationPlayer = %AnimationPlayer2

# Variable para bloquear el movimiento o el cambio de animaciones mientras ataca
var esta_atacando = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Detectar clic de ataque
	if Input.is_action_just_pressed("atacar") and not esta_atacando:
		atacar()

	# Solo permitimos caminar/saltar si no estamos en mitad de un ataque
	# (Opcional: puedes quitar el "and not esta_atacando" si quieres que ataque mientras corre)
	if not esta_atacando:
		procesar_movimiento(delta)
	
	move_and_slide()
	global_position.z = 0

func procesar_movimiento(delta: float) -> void:
	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.z = 0
	
	if direction:
		velocity.x = direction * SPEED
		if anim.current_animation != "AnimPack3/FastRun":
			anim.play("AnimPack3/FastRun")
		
		$character.rotation.y = PI/2 if direction > 0 else -PI/2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if anim.current_animation != "AnimPack3/Idle":
			anim.play("AnimPack3/Idle")

func atacar():
	esta_atacando = true
	# El guerrero se detiene para golpear
	velocity.x = 0 
	
	anim.play("AnimPack3/Attack1")
	
	await anim.animation_finished
	esta_atacando = false
