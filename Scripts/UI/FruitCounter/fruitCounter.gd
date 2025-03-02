extends Label

@onready var player = get_node(^"../../../Player")
@onready var playerFruitCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x += 140
	position.y += 110

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	playerFruitCount = str(player.fruitCount)
	$".".text = playerFruitCount + "/1"
