Scriptname dattPeriodicEventsHelper Extends Form Hidden

Function SetTrauma(string traumaName, Actor akActor, Faction fTraumaFaction, int traumaLevel) global
	If traumaLevel != 0 && traumaLevel != 10 && traumaLevel != 20 && traumaLevel != 30 &&  traumaLevel != 40 &&  traumaLevel != 50
		Debug.MessageBox("SetTrauma() for traumaName = " + traumaName +", received invalid trauma level (must be 10-50), traumaLevel=" + traumaLevel)
		Return
	EndIf

	akActor.AddToFaction(fTraumaFaction)
	string lastUpdateEntryKey = "_datt_last_" + traumaName +"_trauma_update_time"
	float currentTime = Utility.GetCurrentGameTime()
	StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)
	akActor.SetFactionRank(fTraumaFaction, traumaLevel)
EndFunction

Function ModTrauma(string traumaName, Actor akActor, Faction fTraumaFaction, int traumaLevel) global
	akActor.AddToFaction(fTraumaFaction)
	string lastUpdateEntryKey = "_datt_last_" + traumaName +"_trauma_update_time"
	float currentTime = Utility.GetCurrentGameTime()
	StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)
	akActor.ModFactionRank(fTraumaFaction, traumaLevel)

	int currentTraumaLevel = akActor.GetFactionRank(fTraumaFaction)

	;precaution
	If currentTraumaLevel > 50
		akActor.SetFactionRank(fTraumaFaction, 50)
	EndIf
EndFunction

int Function AdjustTrauma(string traumaName, Actor akActor, Faction fTraumaFaction) global
	akActor.AddToFaction(fTraumaFaction)
	string lastUpdateEntryKey = "_datt_last_" + traumaName +"_trauma_update_time"
	float currentTime = Utility.GetCurrentGameTime()

	int traumaLevel = akActor.GetFactionRank(fTraumaFaction)

	If traumaLevel <= 0 ;we are at the minimum, nothing to do
		akActor.SetFactionRank(fTraumaFaction, 0)

		;set the last update entry anyway
		StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)
		return 0
	ElseIf traumaLevel > 50
		akActor.SetFactionRank(fTraumaFaction, 50)

		;set the last update entry anyway
		StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)

	;precaution, should never come to this
	ElseIf traumaLevel != 0 && traumaLevel != 10 && traumaLevel != 20 && traumaLevel != 30 &&  traumaLevel != 40 &&  traumaLevel != 50
		Debug.MessageBox("AdjustTrauma() for traumaName = " + traumaName +", received invalid trauma level (must be 10-50), traumaLevel=" + traumaLevel + ", setting it to 0")
		akActor.SetFactionRank(fTraumaFaction, 0)
		StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)
		return 0
	EndIf

	float lastUpdateTime = StorageUtil.GetFloatValue(akActor as Form, lastUpdateEntryKey)	
	If lastUpdateTime == 0.0
		akActor.ModFactionRank(fTraumaFaction, -10)
	Else
		float stageDecreaseTime = StorageUtil.GetFloatValue(None, "_datt_traumaStageDecreaseTime", 12.0)
		float hoursPassed = Math.abs(lastUpdateTime - currentTime) * 24.0
		If hoursPassed >= stageDecreaseTime
			MiscUtil.PrintConsole("[Datt] Adjust trauma for " + akActor.GetBaseObject().GetName() + ", hoursPassed = " + hoursPassed + ", will adjust trauma level by " + (-10 * ((hoursPassed / stageDecreaseTime) as int)))
			akActor.ModFactionRank(fTraumaFaction, -10 * ((hoursPassed / stageDecreaseTime) as int))
		EndIf
	EndIf
	
	StorageUtil.SetFloatValue(akActor as Form, lastUpdateEntryKey, currentTime)
	return akActor.GetFactionRank(fTraumaFaction)
EndFunction