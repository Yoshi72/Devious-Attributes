Scriptname dattHighPrideEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto
Int Property PlayerLevel Auto Hidden
Float Property ModdedAmount Auto Hidden
dattConfigMenu Property Config Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	PlayerLevel = PlayerRef.GetLevel()

	ModdedAmount = (GetMagnitude() / 100.0) * (PlayerLevel * Config.PrideEffectMagnitude)
	PlayerRef.ModAV("Health", ModdedAmount)

	RegisterForModEvent("Datt_PrideEffectEnd", "OnDispel")
EndEvent

Event OnDispel()
	Dispel()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	PlayerRef.ModAV("Health", -1 * ModdedAmount)
EndEvent
