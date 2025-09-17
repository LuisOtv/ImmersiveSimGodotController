extends Control

# Text content and UI components
var currentText
@onready var textDisplay: RichTextLabel = $Panel/Text
@onready var displayTimer: Timer = $Timer

# Update text display and start auto-close timer
func updateText():
	textDisplay.text = currentText
	displayTimer.start()

# Handle input to close text box
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel') and visible:
		_closeTextBox()

# Auto-close when timer expires
func _on_timer_timeout() -> void:
	_closeTextBox()

# Close text box and clear content
func _closeTextBox():
	visible = false
	currentText = ''
	updateText()
