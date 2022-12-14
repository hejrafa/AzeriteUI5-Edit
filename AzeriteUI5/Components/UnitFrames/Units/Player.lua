--[[

	The MIT License (MIT)

	Copyright (c) 2022 Lars Norberg

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
local oUF = ns.oUF

local PlayerMod = ns:NewModule("PlayerFrame", "LibMoreEvents-1.0")

local defaults = { profile = ns:Merge({
	enabled = true
}, ns.UnitFrame.defaults) }

local style = function(self, unit)

end

PlayerMod.OnInitialize = function(self)
	self.db = ns.db:RegisterNamespace("PlayerFrame", defaults)
	self:SetEnabledState(self.db.profile.enabled)

	oUF:DisableBlizzard("player")
	oUF:RegisterStyle(ns.Prefix.."Player", style)

	-- Disable Player Alternate Power Bar
	PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_SHOW")
	PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_HIDE")
	PlayerPowerBarAlt:UnregisterEvent("PLAYER_ENTERING_WORLD")

end

PlayerMod.OnEnable = function(self)
	if (ns.UnitFrames.Player) then
		ns.UnitFrames.Player:Enable()
	else
		oUF:SetActiveStyle(ns.Prefix.."Player")
		ns.UnitFrames.Player = oUF:Spawn("player", ns.Prefix.."UnitFramePlayer")
	end
end

PlayerMod.OnDisable = function(self)
	if (ns.UnitFrames.Player) then
		ns.UnitFrames.Player:Disable()
	end
end
