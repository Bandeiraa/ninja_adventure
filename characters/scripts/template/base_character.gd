extends CharacterBody2D
class_name BaseCharacter

var _is_attacking: bool = false

var _state_machine: AnimationNodeStateMachinePlayback = null

@export var _move_speed: float = 64.0

@export_category("Objects")
@export var _attack_timer: Timer = null
@export var _animation_tree: AnimationTree = null

func _ready() -> void:
	#Definindo a state machine do animation tree
	_state_machine = _animation_tree["parameters/playback"]
	
	
func _physics_process(_delta: float) -> void:
	_move()     #Função para mover o personagem nas 8 direções
	_attack()   #Função relacionada ao ataque do personagem
	_animate()  #Animar o personagem
	
	
func _move() -> void:
	#Armazenando a direção baseado em duas Inputs(Ações) na horizontal, e duas
	#ações na vertical, valores negativos e positivos, respectivamente
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", #horizontal
		"move_up", "move_down"     #vertical
	)
	
	#Se a direção for diferente de zero, configurar o blend_position do
	#animation tree, ele serve para definir a direção na qual o blend space 2D
	#vai considerar na hora de chamar uma animação
	
	if _direction:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
		
	#Aplicando a direção e a velocidade de movemento a velocity (palavra reservada)
	#que armazena um valor usado no cálculo da velocidade linear do CharacterBody
	velocity = _direction * _move_speed
	move_and_slide()
	
	
func _attack() -> void:
	#Se a ação que for pressionada for a ação de ataque e o personagem não estiver
	#atacando
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		#Parar de processar a _physics_process
		#Nós vamos inicializar o temporizador do ataque 0.2 segundos e vamos definir
		#o valor de _is_attacking para verdadeiro, para ele não deferir multiplos ataques,
		#bugando a animação de ataque.
		
		set_physics_process(false)
		_attack_timer.start(0.2)
		_is_attacking = true
		
		
func _animate() -> void:
	if _is_attacking: 
		#Se _is_attacking for verdadeiro, priorizar a animação de
		#ataque sobre as outras animações abaixo
		_state_machine.travel("attack")
		return
		
	if velocity: 
		#Se a velocidade for diferente de zero, animação de andar
		_state_machine.travel("walk")
		return
		
	#Caso contrário, animação de parado
	_state_machine.travel("idle")
	
	
#Função a ser executada quando o temporizador do ataque chegar em 0
func _on_attack_timer_timeout() -> void:
	#Voltando a processar a _physics_process e configurando o valor de _is_attacking
	#para falso, dessa forma o personagem pode atacar novamente
	set_physics_process(true)
	_is_attacking = false
