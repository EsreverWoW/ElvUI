local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')
local AB = E:GetModule('ActionBars')

local type, pairs, select, tonumber = type, pairs, select, tonumber
local lower, wipe, next, print = strlower, wipe, next, print

local EnableAddOn = EnableAddOn
local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local DisableAddOn = DisableAddOn
local ReloadUI = ReloadUI
local SetCVar = SetCVar
-- GLOBALS: ElvUIGrid, ElvDB

function E:Grid(msg)
	msg = msg and tonumber(msg)
	if type(msg) == 'number' and (msg <= 256 and msg >= 4) then
		E.db.gridSize = msg
		E:Grid_Show()
	elseif ElvUIGrid and ElvUIGrid:IsShown() then
		E:Grid_Hide()
	else
		E:Grid_Show()
	end
end

local AddOns = {
	ElvUI = true,
	ElvUI_Options = true,
	ElvUI_Libraries = true,
	ElvUI_CPU = true -- debug tool located at https://github.com/Resike/ElvUI_CPU
}

function E:LuaError(msg)
	local switch = lower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if not AddOns[name] and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				ElvDB.DisabledAddOns[name] = i
			end
		end

		SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == '0' then
		if switch == 'off' then
			SetCVar('scriptProfile', 0)
			SetCVar('scriptErrors', 0)
			E:Print('Lua errors off.')

			if E:IsAddOnEnabled('ElvUI_CPU') then
				DisableAddOn('ElvUI_CPU')
			end
		end

		if next(ElvDB.DisabledAddOns) then
			for name in pairs(ElvDB.DisabledAddOns) do
				EnableAddOn(name, E.myname)
			end

			wipe(ElvDB.DisabledAddOns)
			ReloadUI()
		end
	else
		E:Print('/edebug on - /edebug off')
	end
end

function E:DisplayCommands()
	print(L["EHELP_COMMANDS"])
end

local BLIZZARD_ADDONS = {
	'Blizzard_AchievementUI',
	'Blizzard_AdventureMap',
	'Blizzard_AlliedRacesUI',
	'Blizzard_AnimaDiversionUI',
	'Blizzard_APIDocumentation',
	'Blizzard_APIDocumentationGenerated',
	'Blizzard_ArchaeologyUI',
	'Blizzard_ArdenwealdGardening',
	'Blizzard_ArtifactUI',
	'Blizzard_AuctionHouseShared',
	'Blizzard_AuctionHouseUI',
	'Blizzard_AuthChallengeUI',
	'Blizzard_AzeriteEssenceUI',
	'Blizzard_AzeriteRespecUI',
	'Blizzard_AzeriteUI',
	'Blizzard_BarbershopUI',
	'Blizzard_BattlefieldMap',
	'Blizzard_BehavioralMessaging',
	'Blizzard_BlackMarketUI',
	'Blizzard_BoostTutorial',
	'Blizzard_Calendar',
	'Blizzard_ChallengesUI',
	'Blizzard_Channels',
	'Blizzard_CharacterCreate',
	'Blizzard_CharacterCustomize',
	'Blizzard_ChromieTimeUI',
	'Blizzard_ClassTalentUI',
	'Blizzard_ClassTrial',
	'Blizzard_ClickBindingUI',
	'Blizzard_ClientSavedVariables',
	'Blizzard_Collections',
	'Blizzard_CombatLog',
	'Blizzard_CombatText',
	'Blizzard_Commentator',
	'Blizzard_Communities',
	'Blizzard_CompactRaidFrames',
	'Blizzard_Console',
	'Blizzard_Contribution',
	'Blizzard_CovenantCallings',
	'Blizzard_CovenantPreviewUI',
	'Blizzard_CovenantRenown',
	'Blizzard_CovenantSanctum',
	'Blizzard_CovenantToasts',
	'Blizzard_CUFProfiles',
	'Blizzard_DeathRecap',
	'Blizzard_DebugTools',
	'Blizzard_Deprecated',
	'Blizzard_EncounterJournal',
	'Blizzard_EventTrace',
	'Blizzard_ExpansionLandingPage',
	'Blizzard_FlightMap',
	'Blizzard_FrameEffects',
	'Blizzard_GarrisonTemplates',
	'Blizzard_GarrisonUI',
	'Blizzard_GenericTraitUI',
	'Blizzard_GMChatUI',
	'Blizzard_GuildBankUI',
	'Blizzard_GuildControlUI',
	'Blizzard_GuildUI',
	'Blizzard_HybridMinimap',
	'Blizzard_InspectUI',
	'Blizzard_IslandsPartyPoseUI',
	'Blizzard_IslandsQueueUI',
	'Blizzard_ItemInteractionUI',
	'Blizzard_ItemSocketingUI',
	'Blizzard_ItemUpgradeUI',
	'Blizzard_Kiosk',
	'Blizzard_LandingSoulbinds',
	'Blizzard_MacroUI',
	'Blizzard_MajorFactions',
	'Blizzard_MapCanvas',
	'Blizzard_MawBuffs',
	'Blizzard_MoneyReceipt',
	'Blizzard_MovePad',
	'Blizzard_NamePlates',
	'Blizzard_NewPlayerExperience',
	'Blizzard_NewPlayerExperienceGuide',
	'Blizzard_ObjectiveTracker',
	'Blizzard_ObliterumUI',
	'Blizzard_OrderHallUI',
	'Blizzard_PartyPoseUI',
	'Blizzard_PetBattleUI',
	'Blizzard_PlayerChoice',
	'Blizzard_Professions',
	'Blizzard_ProfessionsCrafterOrders',
	'Blizzard_ProfessionsCustomerOrders',
	'Blizzard_ProfessionsTemplates',
	'Blizzard_PTRFeedback',
	'Blizzard_PTRFeedbackGlue',
	'Blizzard_PVPMatch',
	'Blizzard_PVPUI',
	'Blizzard_QuestNavigation',
	'Blizzard_RaidUI',
	'Blizzard_RuneforgeUI',
	'Blizzard_ScrappingMachineUI',
	'Blizzard_SecureTransferUI',
	'Blizzard_SharedMapDataProviders',
	'Blizzard_SharedTalentUI',
	'Blizzard_SocialUI',
	'Blizzard_Soulbinds',
	'Blizzard_StoreUI',
	'Blizzard_SubscriptionInterstitialUI',
	'Blizzard_TalentUI',
	'Blizzard_TimeManager',
	'Blizzard_TokenUI',
	'Blizzard_TorghastLevelPicker',
	'Blizzard_TrainerUI',
	'Blizzard_TutorialManager',
	'Blizzard_Tutorials',
	'Blizzard_UIFrameManager',
	'Blizzard_UIWidgets',
	'Blizzard_VoidStorageUI',
	'Blizzard_WarfrontsPartyPoseUI',
	'Blizzard_WeeklyRewards',
	'Blizzard_WorldMap',
	'Blizzard_WowTokenUI'
}

function E:EnableBlizzardAddOns()
	for _, addon in pairs(BLIZZARD_ADDONS) do
		local reason = select(5, GetAddOnInfo(addon))
		if reason == 'DISABLED' then
			EnableAddOn(addon)
			E:Print('The following addon was re-enabled:', addon)
		end
	end
end

function E:DBConvertProfile()
	E.db.dbConverted = nil
	E:DBConversions()
	ReloadUI()
end

function E:LoadCommands()
	if E.private.actionbar.enable then
		self:RegisterChatCommand('kb', AB.ActivateBindMode)
	end

	self:RegisterChatCommand('ec', 'ToggleOptions')
	self:RegisterChatCommand('elvui', 'ToggleOptions')

	self:RegisterChatCommand('bgstats', DT.ToggleBattleStats)

	self:RegisterChatCommand('moveui', 'ToggleMoveMode')
	self:RegisterChatCommand('resetui', 'ResetUI')

	self:RegisterChatCommand('emove', 'ToggleMoveMode')
	self:RegisterChatCommand('ereset', 'ResetUI')
	self:RegisterChatCommand('edebug', 'LuaError')

	self:RegisterChatCommand('ehelp', 'DisplayCommands')
	self:RegisterChatCommand('ecommands', 'DisplayCommands')
	self:RegisterChatCommand('eblizzard', 'EnableBlizzardAddOns')
	self:RegisterChatCommand('estatus', 'ShowStatusReport')
	self:RegisterChatCommand('efixdb', 'DBConvertProfile')
	self:RegisterChatCommand('egrid', 'Grid')
end
