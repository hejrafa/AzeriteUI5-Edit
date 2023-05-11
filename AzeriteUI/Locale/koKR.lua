local Addon, ns = ...

local L = LibStub("AceLocale-3.0"):NewLocale(Addon, "koKR")
if (not L) then return end

L["Create"] = "만들기"
L["Copy"] = "복사"
L["Delete"] = "삭제"
L["Save"] = "저장"
L["Apply"] = "적용"
L["Cancel"] = "취소"
L["Hide"] = "숨기기"
L["Layout:"] = "구성:"
L["Name the New Layout"] = "신규 레이아웃의 이름을 정하세요"
L["HUD Edit Mode"] = "HUD 편집 모드"

L["Click the button below to reset the currently selected EditMode preset to positions matching the default AzeriteUI layout."] = true
L["Reset EditMode Layout"] = true
L["Click the button below to create an EditMode preset named 'Azerite'."] = true
L["Create EditMode Layout"] = true

L["<Left-Click and drag to move>"] = true
L["<MouseWheel to change scale>"] = true
L["<Ctrl and Right-Click to undo last change>"] = true
L["<Shift-Click to reset to default>"] = true

L["Welcome to %s"] = true
L["Congratulations, you are now running AzeriteUI for Retail!|n|nTo create or reset an editmode layout named 'Azerite' and switch to it, click the '|cffffd200%s|r' button. To hide this window for now, click the '|cffffd200%s|r' button. To cancel this tutorial, click the '|cffffd200%s|r' button."] = true
L["You are now running AzeriteUI for %s!|n|nTo set the game's general interface scale to AzeriteUI defaults and position the chat frames to match, click the '|cffffd200%s|r' button. To hide this window for now, click the '|cffffd200%s|r' button. To cancel this tutorial and handle interface scaling yourself, click the '|cffffd200%s|r' button."] = true

L["You can now enter a new battleground, right-click the eye icon on the minimap to enter or leave!"] = true