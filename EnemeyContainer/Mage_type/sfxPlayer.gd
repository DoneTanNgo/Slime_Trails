extends AudioStreamPlayer2D

func sfx_play(sfx):
	if(Stats.sfx_on):
		stream = load(sfx)
		if(stream):
			play()
