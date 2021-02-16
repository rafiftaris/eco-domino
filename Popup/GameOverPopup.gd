extends PopupDialog



# Called when the node enters the scene tree for the first time.
func _ready():
	$OvertimeNumber.set_visible(false)
	$OvertimeText.set_visible(false)

func show_score(scores, is_time_penalty):
	var total = scores.score - scores.penalty
	set_visible(true)
	$ScoreNumber.set_text(str(scores.score))
	$PenaltyNumber.set_text(str(scores.penalty*-1))
	if is_time_penalty:
		$OvertimeNumber.set_text(str(Global.time_penalty*-1))
		$OvertimeNumber.set_visible(true)
		$OvertimeText.set_visible(true)
		total -= Global.time_penalty
	$TotalNumber.set_text(str(total))
