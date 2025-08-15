extends Control
@export
var maxNotches : int = 3
@export 
var notchProgress : int = 1
@export
var notchWidth : int = 2
@export
var notchLineColor : Color = Color.BLACK
@export
var progressColor : Color = Color.ORANGE

@onready
var border := $Border

var _barPosition
var _barWidth
var _notchLength

func loadTempProgressAndColor(_notchProgress : int, _maxNotches : int, _progressColor : Color) -> void:
	notchProgress = _notchProgress
	maxNotches = _maxNotches
	progressColor = _progressColor
	_notchLength = border.size.x / maxNotches
	queue_redraw()
	
func loadTempProgress(_notchProgress : int, _maxNotches : int) -> void:
	notchProgress = _notchProgress
	maxNotches = _maxNotches
	_notchLength = border.size.x / maxNotches

func _ready() -> void:
	var borderTheme : StyleBoxFlat = border.get_theme_stylebox("panel","StyleBoxFlat")
	_barPosition = border.position + Vector2(borderTheme.border_width_left,borderTheme.border_width_top)
	_barWidth = border.size.y - borderTheme.border_width_top - borderTheme.border_width_bottom
	_notchLength = border.size.x / maxNotches

func _draw() -> void:
	draw_rect(Rect2(_barPosition, Vector2(_notchLength * notchProgress, _barWidth)), progressColor, true)
	for i in range(1,maxNotches):
		draw_line(_barPosition + Vector2(_notchLength * i, 0), _barPosition + Vector2(_notchLength * i, _barWidth), notchLineColor, notchWidth)
