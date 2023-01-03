--[[

	The MIT License (MIT)

	Copyright (c) 2023 Lars Norberg

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

--]]
local Addon, ns = ...

local MicroMenu = ns:NewModule("MicroMenu", "LibMoreEvents-1.0", "AceHook-3.0")

local Colors = ns.Colors
local GetFont = ns.API.GetFont
local GetMedia = ns.API.GetMedia

MicroMenu.SpawnButtons = function(self)

	local labels = {
		CharacterMicroButton = CHARACTER_BUTTON,
		SpellbookMicroButton = SPELLBOOK_ABILITIES_BUTTON,
		TalentMicroButton = TALENTS_BUTTON,
		AchievementMicroButton = ACHIEVEMENT_BUTTON,
		QuestLogMicroButton = QUESTLOG_BUTTON,
		GuildMicroButton = LOOKINGFORGUILD,
		LFDMicroButton = DUNGEONS_BUTTON,
		CollectionsMicroButton = COLLECTIONS,
		EJMicroButton = ADVENTURE_JOURNAL or ENCOUNTER_JOURNAL,
		StoreMicroButton = BLIZZARD_STORE,
		MainMenuMicroButton = MAINMENU_BUTTON,
	}

	local buttons = {
		CharacterMicroButton, -- does not work
		SpellbookMicroButton,
		TalentMicroButton,
		AchievementMicroButton,
		QuestLogMicroButton,
		GuildMicroButton,
		LFDMicroButton,
		CollectionsMicroButton,
		EJMicroButton,
		StoreMicroButton,
		MainMenuMicroButton -- does not work
	}

	self.buttons = {}

	local bar = CreateFrame("Frame", ns.Prefix.."MicroMenu", UIParent, "SecureHandlerStateTemplate")
	bar:SetFrameStrata("HIGH")
	bar:Hide()

	local backdrop = CreateFrame("Frame", nil, bar, ns.BackdropTemplate)
	backdrop:SetFrameLevel(bar:GetFrameLevel())
	backdrop:SetBackdrop({
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeSize = 32, edgeFile = GetMedia("border-tooltip"),
		tile = true,
		insets = { left = 8, right = 8, top = 16, bottom = 16 }
	})
	backdrop:SetBackdropColor(.05, .05, .05, .95)

	for i,microButton in next,buttons do

		local button = CreateFrame("Button", nil, bar, "SecureActionButtonTemplate")
		button.ref = microButton

		if (microButton == CharacterMicroButton) then
			button.nocombat = true
			button:SetScript("OnClick", function(self)
				if (InCombatLockdown()) then return end
				ToggleCharacter("PaperDollFrame")
			end)

		elseif (microButton == MainMenuMicroButton) then
			button.nocombat = true
			button:SetScript("OnClick", function(self)
				if (InCombatLockdown()) then return end
				if (not GameMenuFrame:IsShown()) then
					if (not AreAllPanelsDisallowed()) then
						if (SettingsPanel:IsShown()) then
							SettingsPanel:Close()
						end
						CloseMenus()
						CloseAllWindows()
						PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
						ShowUIPanel(GameMenuFrame)
					end
				else
					PlaySound(SOUNDKIT.IG_MAINMENU_QUIT)
					HideUIPanel(GameMenuFrame)
				end
			end)
		else
			button:SetAttribute("type", "macro")
			button:RegisterForClicks("AnyUp","AnyDown")
			button:SetAttribute("click", "macro")
			button:SetAttribute("macrotext", "/click "..microButton:GetName())
			button:SetAttribute("pressAndHoldAction", true)
		end
		button:SetSize(200,30)
		button:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0 + (i-1)*32)

		local backdrop = button:CreateTexture(nil, "ARTWORK")
		backdrop:SetPoint("TOPLEFT", 1,-1)
		backdrop:SetPoint("BOTTOMRIGHT", -1,1)
		backdrop:SetColorTexture(1,1,1,.9)
		button.backdrop = backdrop

		local text = button:CreateFontString(nil, "OVERLAY")
		text:SetFontObject(GetFont(13,true))
		text:SetText(labels[microButton:GetName()])
		text:SetJustifyH("CENTER")
		text:SetJustifyV("MIDDLE")
		text:SetPoint("CENTER")
		button.text = text

		button:SetScript("OnEnter", function(self)
			text:SetTextColor(unpack(Colors.highlight))
			backdrop:SetVertexColor(.25,.25,.25)
		end)

		button:SetScript("OnLeave", function(self)
			if (self:IsEnabled()) then
				text:SetTextColor(unpack(Colors.title))
			else
				text:SetTextColor(unpack(Colors.gray))
			end
			backdrop:SetVertexColor(.1,.1,.1)
		end)

		button:GetScript("OnLeave")(button)

		self.buttons[#self.buttons + 1] = button

	end

	backdrop:SetPoint("RIGHT", self.buttons[1], "RIGHT", 10, 0)
	backdrop:SetPoint("BOTTOM", self.buttons[1], "BOTTOM", 0, -20)
	backdrop:SetPoint("LEFT", self.buttons[1], "LEFT", -10, 0)
	backdrop:SetPoint("TOP", self.buttons[#self.buttons], "TOP", 0, 18)

	local toggle = CreateFrame("CheckButton", ns.Prefix.."MicroMenuToggleButton", UIParent, "SecureHandlerClickTemplate")
	toggle:SetScale(ns.API.GetDefaultElementScale())
	toggle:SetSize(48, 48)
	toggle:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4)
	toggle:RegisterForClicks("AnyUp")
	toggle:SetFrameRef("Bar", bar)

	bar:SetPoint("BOTTOMRIGHT", toggle, "TOPLEFT", 0, 0)
	bar:SetSize(200, 4 + 32*#self.buttons)

	toggle:SetAttribute("_onclick", [[
		local bar = self:GetFrameRef("Bar");
		if (bar:IsShown()) then
			bar:Hide();
		else
			bar:Show();
		end
		bar:UnregisterAutoHide();
		if (bar:IsShown()) then
			bar:RegisterAutoHide(.75);
			bar:AddToAutoHide(self);
		end
	]])

	local texture = toggle:CreateTexture(nil, "ARTWORK", nil, 0)
	texture:SetSize(96, 96)
	texture:SetPoint("CENTER", 0, 0)
	texture:SetTexture(GetMedia("config_button"))
	texture:SetVertexColor(Colors.ui[1], Colors.ui[2], Colors.ui[3])

	RegisterStateDriver(toggle, "visibility", "[petbattle]hide;show")
end

MicroMenu.UpdateButtons = function(self)
	if (InCombatLockdown()) then return end
	for i,button in next,self.buttons do
		if (button.nocombat) then
			if (self.incombat) then
				button:Disable()
				button:GetScript("OnLeave")(button)
			else
				button:Enable()
				if (button:IsMouseOver()) then
					button:GetScript("OnEnter")(button)
				else
					button:GetScript("OnLeave")(button)
				end
			end
		end
	end
end

MicroMenu.OnEvent = function(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		self.incombat = nil
	elseif (event == "PLAYER_REGEN_DISABLED") then
		self.incombat = true
	elseif (event == "PLAYER_REGEN_ENABLED") then
		if (InCombatLockdown()) then return end
		self.incombat = nil
	end
	self:UpdateButtons()
end

MicroMenu.OnInitialize = function(self)
end

MicroMenu.OnEnable = function(self)
	self:SpawnButtons()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
end
