extends Node
class_name State

var parent: Player
var input : Node #Init in statemachine

func enter(): pass
func exit(): pass
func process_input(input: Node) -> State: return null
func process_physics(delta: float) -> State: return null
func process_frame(delta: float) -> State: return null
