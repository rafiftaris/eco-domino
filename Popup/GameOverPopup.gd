extends PopupDialog



# Called when the node enters the scene tree for the first time.
func _ready():
	$OvertimeNumber.set_visible(false)
	$OvertimeText.set_visible(false)

func show_score(scores):
	var total = scores.score - scores.penalty
	set_visible(true)
	$ScoreNumber.set_text(str(scores.score))
	$PenaltyNumber.set_text(str(scores.penalty*-1))
	$TotalNumber.set_text(str(max(total,0)))
