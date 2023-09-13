extends CanvasLayer

const WORST_ENDING = """Well, this is certainly an achievement.
You have reached the conclusion of your journey with
the lowest score possible.

Not once did you deviate from the path for a rose;
your steps through each maze were uncoordinated and
lethargic. At every corner, you appear to have put in
the least possible effort while still claiming victory.

Congratulations. We would have more to say, but
we're unwilling to put more effort into this
than you apparently did."""

const NORMAL_ENDING = """You have toiled through each hazardous labyrinth,
and escaped with your life; and more importantly,
your beloved.

'Tis a noble victory you have won, but somehow, it seems
lacking. Could not your step have been quicker; could
you have not met your darling with a rose? Truly, love
is not such stuff that can be measured by one's
accomplishments...

Nonetheless, your journey's end has been hard-won.
May you go forth, hats humourously askance, and only be
at risk of being roasted alive when you desire such
for the sake of entertainment."""

const ALL_PARS_ENDING = """You have toiled through each hazardous labyrinth,
and escaped with your life; and more importantly,
your beloved.

'Tis a noble victory you have won, but somehow, it seems
lacking. The scent of barely-avoided fire hangs heavy in
your nostrils; could you have not met your darling with
a rose? Truly, love is not such stuff that can be
measured by one's accomplishments...

Nonetheless, your journey's end has been hard-won.
May you go forth, hats humourously askance, and only be
at risk of being roasted alive when you desire such
for the sake of entertainment."""

const ALL_ROSES_ENDING = """You have toiled through each hazardous labyrinth,
and escaped with your life; and more importantly,
your beloved.

'Tis a noble victory you have won, but somehow, it seems
lacking. Could not your step have been quicker? Was your
love not so strong as to hasten your flight into your
lover's arms? Truly, love is not such stuff that can be
measured by one's accomplishments...

Nonetheless, your journey's end has been hard-won.
May you go forth, hats humourously askance, and only be
at risk of being roasted alive when you desire such
for the sake of entertainment."""

const BEST_ENDING = """You did it. You outfoxed every hazard, and conquered
every challenge. By your unceasing efforts, you have
gained the highest possible result, and the strength
of both your loves has been proven beyond refute by
your willingness to subject each other to wanton
arbitrary peril.

Sadly, we cannot show you a picture of the two of you
staring wistfully into each others' eyes, as our budget
does not allow for it. Please take us at our word when
we say that the love that has bloomed today will last
forever, and is in no way the result of adrenaline from
surviving some ill-advised courtship ritual.

But who can say what our lovestruck heroes will do now?
What new quests will they undertake; over what once-
insurmountable odds will they triumph, strengthened as
they are, hands locked in sweaty, slightly-charred
comradeship?

None can say. But at the very least, we can be sure that
the game you have just played stands you in better stead
for finding longlasting happiness than anything
Richard La Ruina has ever done."""

onready var story = $CenterContainer/VBoxContainer/Story
onready var back = $CenterContainer/VBoxContainer/BackButton

func _ready():
	var total_score = Global.get_total_score()
	if total_score <= Global.MINIMUM_WIN_SCORE:
		story.story = WORST_ENDING
	elif total_score >= Global.BEST_SCORE_POSSIBLE:
		story.story = BEST_ENDING
	else:
		story.story = NORMAL_ENDING
		if Global.got_all_roses():
			story.story = ALL_ROSES_ENDING
		elif Global.got_all_pars():
			story.story = ALL_PARS_ENDING
	back.grab_focus()

func back():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
