extends Area2D
class_name PlayerAttackArea

@onready
var attackSprite := $"Attack Sprites"

func base_attack() -> void:
	attackSprite.stop()
	attackSprite.play("slash")

func rotate_sprite_left(toLeft : bool) -> void:
	attackSprite.flip_h = toLeft
