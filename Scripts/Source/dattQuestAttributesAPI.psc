Scriptname dattQuestAttributesAPI Extends dattQuestAttributesBase

; A quick check if the attributes are 
Bool Function InitCheck(Actor target_actor)
	If (target_actor.GetFactionRank(Config.InitVersionAttributeFaction) < Config.CurrentVersionAttributeFaction)
		Return False
	Else
		Return True
	EndIf
EndFunction

; Initializes Attributes to default values for given Actor.
;If value no value for current_version is passed, it will initializes all attributes (a complete wipe). Otherwise, it will only do for new values (update).
Function InitAttributes(Actor target_actor, int current_version = 0)
	If target_actor == None
		Warning("InitAttributes() cannot initialize attributes for actor \"None\".")
		Return
	Endif
	If current_version < 1
		; ===== Base Attributes ==== ;
		;SetAttributeByFaction(target_actor, Config.WillpowerAttributeFaction, Config.WillpowerAttributeDefault)
		target_actor.SetFactionRank(Config.WillpowerAttributeFaction, Config.WillpowerAttributeDefault)
		; StorageUtil.SetIntValue(target_actor, Config.WillpowerAttributeName, Config.WillpowerAttributeDefault)
		; StorageUtil.SetIntValue(target_actor, Config.WillpowerAttributeName, Config.WillpowerAttributeDefault)
		
		; ===== Fetish Attributes ==== ;
		;SetAttributeByFaction(target_actor, Config.NymphomaniaAttributeFaction, Config.NymphomaniaAttributeDefault)
		target_actor.SetFactionRank(Config.NymphomaniaAttributeFaction, Config.NymphomaniaAttributeDefault)
		; StorageUtil.SetIntValue(target_actor, Config.NymphomaniaAttributeName, Config.NymphomaniaAttributeDefault)
		; StorageUtil.SetIntValue(target_actor, Config.NymphomaniaAttributeName, Config.NymphomaniaAttributeDefault)
		
		; ===== Fetish Attributes ==== ;
		; Not needed
		
		; ===== Misc Attributes ==== ;
		;SetAttributeByFaction(target_actor, Config.SlaveAbusivenessStateAttributeFaction, 0)
		target_actor.SetFactionRank(Config.SlaveAbusivenessStateAttributeFaction, 0)
		; StorageUtil.SetIntValue(target_actor, Config.SlaveAbusivenessStateAttributeName, 0)
	EndIf
	target_actor.SetFactionRank(Config.SlaveAbusivenessStateAttributeFaction, Config.CurrentVersionAttributeFaction)
EndFunction



; ==============================
; API Functions
; ==============================

; Set the specified attribute to the passed value.
Int Function SetAttributeByName(Actor target_actor, String attribute_name, Int attribute_value, Int on_error_value = 0)
	Return ChangeAttributeByName(target_actor, attribute_name, attribute_value, false, on_error_value)
	NotifyOfChange()
EndFunction

Int Function SetAttributeByFaction(Actor target_actor, Faction target_attribute_faction, Int attribute_value, Int on_error_value = 0)
	Return ChangeAttributeByFaction(target_actor, target_attribute_faction, attribute_value, false, on_error_value)
	NotifyOfChange()
EndFunction

; Modifies the specified attribute by the passed value.
Int Function ModAttributeByName(Actor target_actor, String attribute_string, Int attribute_value, Int on_error_value = 0)
	Return ChangeAttributeByName(target_actor, attribute_string, attribute_value, true, on_error_value)
	NotifyOfChange()
EndFunction

Int Function ModAttributeByFaction(Actor target_actor, Faction target_attribute_faction, Int attribute_value, Int on_error_value = 0)
	Return ChangeAttributeByFaction(target_actor, target_attribute_faction, attribute_value, true, on_error_value)
	NotifyOfChange()
EndFunction



Int Function ChangeAttributeByName(Actor target_actor, String target_attribute_name, Int attribute_value, bool is_modify_mode = false, Int on_error_value = 0)
	Return ChangeAttribute(target_actor, GetFactionByName(target_attribute_name), target_attribute_name, attribute_value, is_modify_mode, on_error_value)
EndFunction

Int Function ChangeAttributeByFaction(Actor target_actor, Faction target_attribute_faction, Int attribute_value, bool is_modify_mode = false, Int on_error_value = 0)
	Return ChangeAttribute(target_actor, target_attribute_faction, GetNameByFaction(target_attribute_faction), attribute_value, is_modify_mode, on_error_value)
EndFunction

Int Function ChangeAttribute(Actor target_actor, Faction target_attribute_faction, String target_attribute_name, Int attribute_value, bool is_modify_mode = false, Int on_error_value = 0)
	If target_actor == None
		Error("ChangeAttribute() was passed an empty target_actor.")
		Return on_error_value
	ElseIf target_attribute_faction == None
		Error("ChangeAttribute() was passed an empty target_attribute_faction.")
	EndIf
	
	If IsCalculatedAttributeByFaction(target_attribute_faction)
		Warning("ChangeAttribute() calculated attributes shouldn't be set manually...")
		Return on_error_value
	EndIf
	
	If !CheckAttributeMatch(target_attribute_faction, target_attribute_name)
		Error("ChangeAttribute() faction and attribute name either do not match, or are not a known attribute.")
		Return on_error_value
	EndIf
	
	
	
	Log("ChangeAttribute() for actor = " + target_actor.GetBaseObject();/.GetName()/; +", target_attribute_name = " + target_attribute_name + ", value = " + attribute_value + ", is_modify_mode = " + is_modify_mode)
	If !InitCheck(target_actor)
		Log("ChangeAttribute() actor's attribute init version is not up to date... Init the new attributes.")
		InitAttributes(target_actor, target_actor.GetFactionRank(Config.InitVersionAttributeFaction))
	EndIf
	
	Int m_old_attribute_value = target_actor.GetFactionRank(target_attribute_faction)
	Int m_max_attribute_value = GetMaxAttributeValueByFaction(target_attribute_faction, target_actor)
	Int m_min_attribute_value = GetMinAttributeValueByFaction(target_attribute_faction, target_actor)
	
	; If in modify mode, add current actor value to attribute_value.
	If is_modify_mode
		attribute_value += m_old_attribute_value
	EndIf
	
	If m_max_attribute_value == m_min_attribute_value
		Error("ChangeAttribute() min and max value for that attribute are the same! Aborting change.")
		Return on_error_value
	EndIf
	
	; Attribute Value Limitation checks
	If attribute_value > m_max_attribute_value
		; Don't go higher than the max value for that attribute.
		attribute_value = m_max_attribute_value
		Log("ChangeAttribute() passed value of " + attribute_value + " is higher than max (" + m_max_attribute_value + "). Use max value instead...")
	ElseIf attribute_value < m_min_attribute_value
		; Don't go lower than the min value for that attribute.
		attribute_value = m_min_attribute_value
		Log("ChangeAttribute() passed value of " + attribute_value + " is lower than min (" + m_min_attribute_value + "). Use min value instead...")
	EndIf
	
	; Only do changes if the new value is different than the old one.
	If attribute_value != m_old_attribute_value
		target_actor.SetFactionRank(target_attribute_faction, attribute_value)
		; ===== StorageUtil Function ===== ;
		; StorageUtil.SetIntValue(target_actor, target_attribute_name, attribute_value)
		
		; If the attribute is not Soul State, set attribute state as well.
		HasChangesQueued = target_actor
		
		; ===== Legacy State calculations =====
		; Currently not in use
		
		;RecalculateAttributes(target_actor, target_attribute_faction)
	Else
		Log("ChangeAttribute()")
	EndIf
	Return attribute_value
EndFunction




Int Function GetAttributeByName(Actor target_actor, String target_attribute_name, bool set_defaults_on_missing = true, Int on_error_value = 0)
	Return GetAttribute(target_actor, GetFactionByName(target_attribute_name), target_attribute_name, set_defaults_on_missing, on_error_value)
EndFunction

Int Function GetAttributeByFaction(Actor target_actor, Faction target_attribute_faction, bool set_defaults_on_missing = true, Int on_error_value = 0)
	Return GetAttribute(target_actor, target_attribute_faction, GetNameByFaction(target_attribute_faction), set_defaults_on_missing, on_error_value)
EndFunction


; Returns the current value for the given attribute.
; Returns 0 if there is an error.
; If actor is not part of the faction, it either returns 0 or add him to the faction and return default values
Int Function GetAttribute(Actor target_actor, Faction target_attribute_faction, String target_attribute_name, bool set_defaults_on_missing = true, Int on_error_value = 0)
	If target_actor == None
		Error("GetAttribute() was passed an empty target_actor.")
		Return on_error_value
	ElseIf target_attribute_faction == None
		Error("GetAttribute() was passed an empty target_aattribute.")
	EndIf
	
	If !CheckAttributeMatch(target_attribute_faction, target_attribute_name)
		Error("GetAttribute() faction and attribute name either do not match, or are not a known attribute.")
		Return on_error_value
	EndIf
	
	If !InitCheck(target_actor)
		Log("GetAttribute() actor's attribute init version is not up to date... Init the new attributes.")
		If set_defaults_on_missing
			InitAttributes(target_actor, target_actor.GetFactionRank(Config.InitVersionAttributeFaction))
		Else
			return on_error_value
		EndIf
	EndIf
	
	Int m_max_attribute_value = GetMaxAttributeValueByFaction(target_attribute_faction, target_actor)
	Int m_min_attribute_value = GetMinAttributeValueByFaction(target_attribute_faction, target_actor)
	
	If m_max_attribute_value == m_min_attribute_value
		Error("GetAttribute() min and max value for that attribute are the same! Aborting...")
		Return on_error_value
	EndIf
	
	; Change attribute value if it somehow does exceed the min/max limits and fire events for statchanges
	Int m_attribute_value = target_actor.GetFactionRank(target_attribute_faction)
	Int m_attribute_value_new = dattUtility.LimitValueInt(m_attribute_value, m_min_attribute_value, m_max_attribute_value)
	If m_attribute_value != m_attribute_value_new
		Warning("GetAttribute() current value of " + m_attribute_value + " for attribute \"" + target_attribute_name + "\" for actor \"" + target_actor.GetBaseObject();/.GetName()/; + "\" is exceeding the limit of " + m_attribute_value_new + ". This should not have happened! Calling ChangeAttribute()...")
		ChangeAttribute(target_actor, target_attribute_faction, GetNameByFaction(target_attribute_faction), m_attribute_value_new, false)
		NotifyOfChangeManual(target_actor)
		return m_attribute_value_new
	Else
		Return m_attribute_value
	EndIf
EndFunction

Int Function GetAttributeStateByName(Actor target_actor, String target_attribute_name, bool set_defaults_on_missing = true, Int on_error_value = 0)
	Return GetAttributeState(GetAttribute(target_actor, GetFactionByName(target_attribute_name), target_attribute_name, set_defaults_on_missing, on_error_value))
EndFunction

Int Function GetAttributeStateByFaction(Actor target_actor, Faction target_attribute_faction, bool set_defaults_on_missing = true, Int on_error_value = 0)
	Return GetAttributeState(GetAttribute(target_actor, target_attribute_faction, GetNameByFaction(target_attribute_faction), set_defaults_on_missing, on_error_value))
EndFunction



; Set all attributes to defaults.
Function SetDefaults(Actor target_actor)
	If target_actor == None
		Error("SetDefaults() was passed a form parameter, that was empty or not an actor. Aborting change...")
		Return
	EndIf
	; ===== Base Attributes ===== ;
	ChangeAttribute(target_actor, Config.WillpowerAttributeFaction, Config.WillpowerAttributeName, Config.MaxBaseAttributeValue, false)
	
	; ===== Fetish Attributes ===== ;
	ChangeAttribute(target_actor, Config.NymphomaniaAttributeFaction, Config.NymphomaniaAttributeName, Config.NymphomaniaAttributeDefault, false)
	
	; ===== Misc Attributes ===== ;
	ChangeAttribute(target_actor, Config.SlaveAbusivenessStateAttributeFaction, Config.SlaveAbusivenessStateAttributeName, 0, false)
	
	NotifyOfChange()
EndFunction



Function ActorVictim(Form[] victim_actor_form, String[] victim_tags, Int[] victim_magnitudes, Int victim_magnitude, Form[] master_actor_form, String[] master_tags, Int[] master_magnitudes, Int master_magnitude)
	If victim_actor_form.Length <= 0 || victim_actor_form[1] as Actor != None
		Warning("ActorVictim() victim_actor_form is empty or it's first element is not an actor. Aborting...")
		Return
	EndIf
	If victim_tags.Length != victim_magnitudes.Length
		Warning("ActorVictim() array size of victim_tags and victim_magnitudes mismatch. Aborting...")
		Return
	EndIf
	If victim_tags.Length <= 0
		Warning("ActorVictim() victim_tags is empty. Aborting...")
		Return
	EndIf
	
	If master_actor_form.Length > 0
		If master_tags.Length != master_magnitudes.Length
			Warning("ActorVictim() array size of master_tags and master_magnitudes mismatch. Aborting...")
			Return
		EndIf
	EndIf
	
	Int m_current_actor_index = 0
	While m_current_actor_index < victim_actor_form.Length
		ActorAttributeCalculation(victim_actor_form[0] as Actor, victim_tags, victim_magnitudes, victim_magnitude, master_actor_form)
	EndWhile
	
	m_current_actor_index = 0
	While m_current_actor_index < master_actor_form.Length
		ActorAttributeCalculation(master_actor_form[0] as Actor, master_tags, master_magnitudes, master_magnitude, victim_actor_form)
	EndWhile
EndFunction

Function ActorAttributeCalculation(Actor victim_actor, String[] victim_tags, Int[] victim_magnitudes, Int magnitude, Form[] master_actor_form)
	If !victim_actor
		Error("ActorVictimProcess() victim_actor is empty or not an actor. Aborting...")
		Return
	EndIf
	
	; Do Stuff
EndFunction
