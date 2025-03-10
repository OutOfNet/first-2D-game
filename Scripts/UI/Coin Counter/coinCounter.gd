extends Label

@onready var player = get_node(^"../../../Player")
@onready var playerCoinCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x += 60
	position.y += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	playerCoinCount = str(player.coinCount)
	$".".text = playerCoinCount
