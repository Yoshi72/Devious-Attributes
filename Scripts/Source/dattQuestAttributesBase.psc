Scriptname dattQuestAttributesBase Extends dattQuestBase Hidden
; This script contains some basic functions in order to handle attributes.


; ==============================
; Get Attribute Functions
; ==============================

; Returns the corresponding faction for the attribute name
Faction Function GetFactionByName(String attribute_name)
	; ===== Base Attributes ===== ;
	If attribute_name == Config.WillpowerAttributeName
		Return Config.WillpowerAttributeFaction
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_name == Config.NymphomaniaAttributeName
		Return Config.NymphomaniaAttributeFaction
	; ===== Calculated Attributes ===== ;
	ElseIf attribute_name == Config.SubmissivenessAttributeName
		Return Config.SubmissivenessAttributeFaction
	; ===== Misc Attributes ===== ;
	ElseIf attribute_name == Config.SlaveAbusivenessStateAttributeName
		Return Config.SlaveAbusivenessStateAttributeFaction
	Else
		Warning("GetFactionByName() could not find attribute faction for " + attribute_name + ".")
		Return None
	EndIf
EndFunction

; Returns the corresponding faction for the attributeID
String Function GetNameByFaction(Faction attribute_faction)
	; ===== Base Attributes ===== ;
	If attribute_faction == Config.WillpowerAttributeFaction
		Return Config.WillpowerAttributeName
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_faction == Config.NymphomaniaAttributeFaction
		Return Config.NymphomaniaAttributeName
	; ===== Calculated Attributes ===== ;
	ElseIf attribute_faction == Config.SubmissivenessAttributeFaction
		Return Config.SubmissivenessAttributeName
	; ===== Misc Attributes ===== ;
	ElseIf attribute_faction == Config.SlaveAbusivenessStateAttributeFaction
		Return Config.SlaveAbusivenessStateAttributeName
	Else
		;Warning("GetNameByFaction() could not find attribute faction for attribute_faction = " + attribute_faction + ".")
		Return None
	EndIf
EndFunction



; A simple check if the faction and attribute name are matching.
Bool Function CheckAttributeMatch(Faction attribute_faction, String attribute_name)
	; ===== Base Attributes ===== ;
	If (attribute_faction == Config.WillpowerAttributeFaction && attribute_name == Config.WillpowerAttributeName)
		Return True
	; ===== Fetish Attributes ===== ;
	ElseIf (attribute_faction == Config.NymphomaniaAttributeFaction && attribute_name == Config.NymphomaniaAttributeName)
		Return True
	; ===== Fetish Attributes ===== ;
	ElseIf (attribute_faction == Config.SubmissivenessAttributeFaction && attribute_name == Config.SubmissivenessAttributeName)
		Return True
	; ===== Misc Attributes ===== ;
	ElseIf (attribute_faction == Config.SlaveAbusivenessStateAttributeFaction && attribute_name == Config.SlaveAbusivenessStateAttributeName)
		Return True
	Else
		Return False
	EndIf
Endfunction



Bool Function IsCalculatedAttribute(Faction attribute_faction)
	If attribute_faction == Config.SubmissivenessAttributeFaction
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function IsMiscAttribute(Faction attribute_faction)
	If attribute_faction == Config.SlaveAbusivenessStateAttributeFaction
		Return True
	Else
		Return False
	EndIf
EndFunction

Int Function GetMaxAttributeValueByName(String attribute_name, Actor target_actor = None)
	Int attribute_value_max = 0
	; ===== Base Attributes ===== ;
	If attribute_name == Config.WillpowerAttributeName
		attribute_value_max = Config.MaxBaseAttributeValue
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_name == Config.NymphomaniaAttributeName
		attribute_value_max = Config.MaxFetishAttributeValue
	; ===== Misc Attributes ===== ;
	ElseIf attribute_name == Config.SlaveAbusivenessStateAttributeName
		attribute_value_max = 2
	Else
		Return attribute_value_max
	EndIf
EndFunction

Int Function GetMaxAttributeValueByFaction(Faction attribute_faction, Actor target_actor = None)
	Int attribute_value_max = 0
	; ===== Base Attributes ===== ;
	If attribute_faction == Config.WillpowerAttributeFaction
		attribute_value_max = Config.MaxBaseAttributeValue
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_faction == Config.NymphomaniaAttributeFaction
		attribute_value_max = Config.MaxFetishAttributeValue
	; ===== Misc Attributes ===== ;
	ElseIf attribute_faction == Config.SlaveAbusivenessStateAttributeFaction
		attribute_value_max = 2
	Else
		Return attribute_value_max
	EndIf
EndFunction

Int Function GetMinAttributeValueByName(String attribute_name, Actor target_actor = None)
	Int attribute_value_max = 0
	; ===== Base Attributes ===== ;
	If attribute_name == Config.WillpowerAttributeName
		attribute_value_max = Config.MinBaseAttributeValue
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_name == Config.NymphomaniaAttributeName
		attribute_value_max = Config.MinFetishAttributeValue
	; ===== Misc Attributes ===== ;
	ElseIf attribute_name == Config.SlaveAbusivenessStateAttributeName
		attribute_value_max = -2
	Else
		Return attribute_value_max
	EndIf
EndFunction

Int Function GetMinAttributeValueByFaction(Faction attribute_faction, Actor target_actor = None)
	Int attribute_value_max = 0
	; ===== Base Attributes ===== ;
	If attribute_faction == Config.WillpowerAttributeFaction
		attribute_value_max = Config.MinBaseAttributeValue
	; ===== Fetish Attributes ===== ;
	ElseIf attribute_faction == Config.NymphomaniaAttributeFaction
		attribute_value_max = Config.MinFetishAttributeValue
	; ===== Misc Attributes ===== ;
	ElseIf attribute_faction == Config.SlaveAbusivenessStateAttributeFaction
		attribute_value_max = -2
	Else
		Return attribute_value_max
	EndIf
EndFunction

Function NotifyOfChange(Actor target_actor, String target_attribute_name, Int attribute_value)
	; Placeholder
EndFunction
