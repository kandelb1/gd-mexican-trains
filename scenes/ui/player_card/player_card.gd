extends PanelContainer
class_name PlayerCard


@onready var player_label: Label = $%PlayerLabel
@onready var hand_label: Label = $%HandSizeLabel

var player: PlayerResource

func _ready():
  set_player_name(player.name)
  set_hand_size(player.hand.get_hand_length())
  player.hand_changed.connect(on_player_change)


func on_player_change():
  set_hand_size(player.hand.get_hand_length())


func set_player_name(name: String):
  player_label.text = name


func set_hand_size(num: int):
  hand_label.text = str(num)