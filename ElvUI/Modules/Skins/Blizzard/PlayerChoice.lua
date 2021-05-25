local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local _G = _G
local select = select
local hooksecurefunc = hooksecurefunc
local IsInJailersTower = IsInJailersTower

local function StyleText(text)
	if text.IsSkinned then return end
	text:SetTextColor(1, 1, 1)
	text.SetTextColor = E.noop
	text.IsSkinned = true
end

local function HandleFirstOptionButton(button)
	if not button then return end

	button:StripTextures(true)
	S:HandleButton(button)
end

local function HandleSecondOptionButton(button)
	if not button then return end

	S:HandleButton(button)
end

local function HandleJailerOptionButton(button)
	if not button or button.IsSkinned then return end

	button:StripTextures(true)
	button:SetTemplate()

	button:HookScript('OnEnter', S.SetModifiedBackdrop)
	button:HookScript('OnLeave', S.SetOriginalBackdrop)

	button.IsSkinned = true
end

function S:Blizzard_PlayerChoiceUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.playerChoice) then return end

	local frame = _G.PlayerChoiceFrame
	hooksecurefunc(frame, 'Update', function()
		if not frame.IsSkinned then
			frame.BlackBackground:SetAlpha(0)
			frame.Background:SetAlpha(0)
			frame.NineSlice:SetAlpha(0)
			frame.BorderFrame.Header:SetAlpha(0)

			frame:SetTemplate('Transparent')

			frame.Title:DisableDrawLayer('BACKGROUND')
			frame.Title.Text:SetTextColor(1, .8, 0)

			S:HandleCloseButton(frame.CloseButton)
			frame.CloseButton.Border:SetAlpha(0)

			frame.IsSkinned = true
		end

		for i = 1, frame:GetNumOptions() do
			local option = frame.Options[i]
			if E.private.skins.parchmentRemoverEnable then
				option.Header.Text:SetTextColor(1, .8, 0)
				option.OptionText:SetTextColor(1, 1, 1)

				option.Background:SetAlpha(0)
				option.Header.Ribbon:SetAlpha(0)
			end

			-- for some reason the buttons are different. W T F
			if IsInJailersTower() then
				if option.OptionButtonsContainer.button1 then
					HandleJailerOptionButton(option.OptionButtonsContainer.button1)
				end
				if option.OptionButtonsContainer.button2 then
					HandleJailerOptionButton(option.OptionButtonsContainer.button2)
				end
			else
				if option.OptionButtonsContainer.button1 then
					HandleFirstOptionButton(option.OptionButtonsContainer.button1)
				end
				if option.OptionButtonsContainer.button2 then
					HandleSecondOptionButton(option.OptionButtonsContainer.button2)
				end
			end

			for x = 1, option.WidgetContainer:GetNumChildren() do
				local child = select(x, option.WidgetContainer:GetChildren())
				if child then
					local text = child.Text
					if text and E.private.skins.parchmentRemoverEnable then
						text:SetTextColor(1, 1, 1)
					end

					local spell = child.Spell
					if spell then
						if not spell.isSkinned then
							spell.Border:SetTexture('')
							spell.IconMask:Hide()

							S:HandleIcon(spell.Icon)

							spell.isSkinned = true
						end

						if E.private.skins.parchmentRemoverEnable then
							spell.Text:SetTextColor(1, 1, 1)
						end
					end

					for j = 1, child:GetNumChildren() do
						local child2 = select(j, child:GetChildren())
						if child2 then
							if child2.Text then StyleText(child2.Text) end
							if child2.LeadingText then StyleText(child2.LeadingText) end
							if child2.Icon and not child2.Icon.isSkinned then
								S:HandleIcon(child2.Icon)

								child2.Icon.isSkinned = true
							end
						end
					end
				end
			end
		end
	end)

	hooksecurefunc(frame, 'SetupRewards', function(rewards)
		if E.private.skins.parchmentRemoverEnable then
			for i = 1, rewards.numActiveOptions do
				local optionFrameRewards = rewards.Options[i].RewardsFrame.Rewards
				for button in optionFrameRewards.ItemRewardsPool:EnumerateActive() do
					if not button.IsSkinned then
						button.Name:SetTextColor(.9, .8, .5)
						button.IconBorder:SetAlpha(0)

						button.IsSkinned = true
					end
				end
			end
		end
		--[[
			optionFrameRewards.CurrencyRewardsPool
			optionFrameRewards.ReputationRewardsPool
		]]
	end)
end

S:AddCallbackForAddon('Blizzard_PlayerChoiceUI')
