extends StateEnemy
class_name DeathEnemy

func enter():
	super()
	enemy.animations.play("death")
	## Changing z index should be uneeded, but kept here incase issues arise
	# enemy.z_index = -1
	if enemy.has_node("DamageArea"):
		enemy.get_node("DamageArea").remove_from_group("enemy_attacks")
	if enemy.has_node("Hurtbox"):
		enemy.get_node("Hurtbox").remove_from_group("enemy_attacks")
