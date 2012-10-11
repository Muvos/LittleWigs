
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Taran Zhu", 877, 686)
mod:RegisterEnableMob(56884)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Hatred will consume and conquer all!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {115002, {107087, "FLASHSHAKE"}, 107356}
end

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "GrippingHatred", 115002)
	self:Log("SPELL_AURA_APPLIED", "HazeOfHate", 107087)
	self:Log("SPELL_AURA_APPLIED", "RisingHateStart", 107356)
	self:Log("SPELL_AURA_REMOVED", "RisingHateStop", 107356)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, _, _, _, spellId)
	if spellId == 125920 and unitId == "boss1" then -- Kneel
		self:Win()
	end
end

function mod:GrippingHatred(_, spellId, _, _, spellName)
	self:Message(115002, spellName, "Urgent", spellId, "Alert")
end

function mod:HazeOfHate(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(107087, CL["you"]:format(spellName), "Personal", spellId, "Info")
		self:FlashShake(107087)
	end
end

function mod:RisingHateStart(_, spellId, _, _, spellName)
	self:Message(107356, CL["cast"]:format(spellName), "Important", spellId, "Alert")
	self:Bar(107356, CL["cast"]:format(spellName), 5, spellId)
	self:Bar(107356, "~"..spellName, 16.5, spellId) -- 16-19
end

function mod:RisingHateStop(_, spellId, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, CL["cast"]:format(spellName))
end

