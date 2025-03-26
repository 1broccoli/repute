local addonName, addon = ...
Repute = CreateFrame("Frame", nil, UIParent), {}

local playerName = UnitName("player")
local server = GetRealmName()
local profileKey = playerName .. "-" .. server
local gender = UnitSex("player")
local level = UnitLevel("player")
local _, playerClass = UnitClass("player")
local playerFaction = UnitFactionGroup("player")
local race = UnitRace("player")

local foundFactions = 0
local repFrame = DEFAULT_CHAT_FRAME

local rewardItemCache = {}

-- Ensure factionStandingColours is initialized
if not Repute.factionStandingColours then
    Repute.factionStandingColours = {
        [1] = "|cffff0000", -- Hated
        [2] = "|cffff0000", -- Hostile
        [3] = "|cffff0000", -- Unfriendly
        [4] = "|cffffff00", -- Neutral
        [5] = "|cff00ff00", -- Friendly
        [6] = "|cff00ff00", -- Honored
        [7] = "|cff00ff00", -- Revered
        [8] = "|cff00ff00", -- Exalted
    }
end

Repute:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        Repute:initiate()
    elseif event == "MODIFIER_STATE_CHANGED" then
        local button, state = ...
        if button == "LALT" or button == "RALT" then
            local link = select(2, GameTooltip:GetItem())
            if link then
                local id = tonumber(string.match(link, "item:(%d*)"))
                if Repute.repitems[id] then
                    GameTooltip:ClearLines()
                    GameTooltip:SetHyperlink(link)
                end
            end
        end
        if button == "LCTRL" or button == "RCTRL" and state == 1 then
            local link = select(2, GameTooltip:GetItem())
            if link then
                local id = tonumber(string.match(link, "item:(%d*)"))
                if Repute.repitems[id] then
                    if showRewardTooltip.rewardList and showRewardTooltip.rewardMax > 1 then
                        showRewardTooltip.rewardShowing = showRewardTooltip.rewardShowing + 1
                        if showRewardTooltip.rewardShowing > showRewardTooltip.rewardMax then showRewardTooltip.rewardShowing = 1 end
                        
                        GetItemInfo(showRewardTooltip.rewardList[showRewardTooltip.rewardShowing])
                        rewardItemCache[showRewardTooltip.rewardList[showRewardTooltip.rewardShowing]] = true
                        
                        showRewardTooltip:SetHyperlink("item:"..showRewardTooltip.rewardList[showRewardTooltip.rewardShowing])
                        showRewardTooltip:AddDoubleLine("Press CTRL to cycle rewards", showRewardTooltip.rewardShowing.."/"..showRewardTooltip.rewardMax)
                        showRewardTooltip:Show()
                    end
                end
            end
        end
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        local itemID, success = ...
        if success then
            if rewardItemCache[itemID] then
                C_Timer.After(0.1, function()
                    local link = select(2, GameTooltip:GetItem())
                    if link then
                        local id = tonumber(string.match(link, "item:(%d*)"))
                        if Repute.repitems[id] then
                            if showRewardTooltip.rewardList and showRewardTooltip.rewardMax > 1 then
                                local needsCycleText = true
                                for i = 1, showRewardTooltip:NumLines() do
                                    if string.find(_G["showRewardTooltipTextLeft"..i]:GetText(), "Press CTRL to cycle rewards") then needsCycleText = false end
                                end
                                if needsCycleText then
                                    showRewardTooltip:AddDoubleLine("Press CTRL to cycle rewards", showRewardTooltip.rewardShowing.."/"..showRewardTooltip.rewardMax)
                                    showRewardTooltip:Show()
                                end
                            end
                        end
                    end
                end)
            end
        end
    elseif event == "PLAYER_LEVEL_UP" then
        level = ...
        Repute_Data[profileKey].profile.level = level
    elseif event == "QUEST_TURNED_IN" then
        local questID = ...
        if Repute_Data[profileKey].quests[questID] == false then Repute_Data[profileKey].quests[questID] = true end
    elseif event == "LEARNED_SPELL_IN_TAB" then
        local spellID = ...
        if Repute_Data[profileKey].classbooks[spellID] == false then Repute_Data[profileKey].classbooks[spellID] = true end
    end
end)

function Repute:initiate()
    local defaultData = {
        profileKeys = {},
    }
    if Repute_Data == nil then
        Repute_Data = {
            global = defaultData
        }
    end
    if Repute_Data.global == nil then
        Repute_Data.global = defaultData
    end
    for option, default in pairs(defaultData) do
        if Repute_Data.global[option] == nil then Repute_Data.global[option] = default end
    end
    if Repute_Data.global.profileKeys[profileKey] == nil then Repute_Data.global.profileKeys[profileKey] = true end
    if Repute_Data[profileKey] == nil then Repute_Data[profileKey] = {} end
    if Repute_Data[profileKey].factions == nil then Repute_Data[profileKey].factions = {} end
    Repute_Data[profileKey].profile = {
        name = playerName,
        server = server,
        gender = gender,
        level = level,
        class = playerClass,
        faction = playerFaction,
    }
    
    Repute:getAllFactions(true)
    if Repute_Data[profileKey].quests == nil then Repute_Data[profileKey].quests = {} end
    if not Repute.repitems then Repute.repitems = {} end
    for k, v in pairs(Repute.repitems) do
        if v.quest and not v.repeatable then
            local questID
            if type(v.quest) == 'table' then
                if v.quest[playerClass] then
                    if v.quest[playerClass] == true then
                        questID = v.quest.questID
                    else
                        questID = v.quest[playerClass].questID
                    end
                end
            else
                questID = v.quest
            end
            if questID then
                Repute_Data[profileKey].quests[questID] = IsQuestFlaggedCompleted(questID)
            end
        end
    end
    
    if Repute_Data[profileKey].classbooks == nil then Repute_Data[profileKey].classbooks = {} end
    if not Repute.classbooks then Repute.classbooks = {} end
    for k, v in pairs(Repute.classbooks) do
        if v[playerClass] then
            Repute_Data[profileKey].classbooks[v[playerClass]] = IsSpellKnown(v[playerClass])
        end
    end
end

SLASH_Repute1 = "/Repute"
function SlashCmdList.Repute(msg)
    for i, v in pairs(Repute_Data[profileKey].quests) do
        print(i, v)
    end
end

local function getRepString(repValue, profile)
    local repString = { str = "|cffffd100-" }
    local standingID
    local standingLabel
    local dispValue = repValue
    local progress
    if repValue then
        if repValue < -6000 then
            standingID = 1
            dispValue = repValue + 42000
        elseif repValue < -3000 then
            standingID = 2
            dispValue = repValue + 6000
        elseif repValue < 0 then
            dispValue = repValue + 3000
            standingID = 3
        elseif repValue < 3000 then
            standingID = 4
        elseif repValue < 9000 then
            standingID = 5
            dispValue = repValue - 3000
        elseif repValue < 21000 then
            standingID = 6
            dispValue = repValue - 9000
        elseif repValue < 42000 then
            standingID = 7
            dispValue = repValue - 21000
        elseif repValue >= 42000 then
            standingID = 8
            progress = ""
        end
        standingLabel = Repute.factionStandingColours[standingID] .. GetText("FACTION_STANDING_LABEL"..standingID, profile.gender)
        if standingID ~= 8 then
            progress = " " .. math.floor(dispValue / 100) / 10 .. "k /" .. Repute.factionStandingMax[standingID] / 1000 .. "k"
        end
        repString = {
            str = standingLabel .. progress,
            l = standingLabel,
            n = progress,
            s = standingID,
        }
    end
    return repString
end

local showRewardTooltip = CreateFrame("GameTooltip", "showRewardTooltip", GameTooltip, "GameTooltipTemplate")

local function addRepToToolTip(self, id)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon,
        itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(id)
    
    local item = Repute.repitems[id]
    local factionID = item.faction
    if type(factionID) == 'table' then factionID = item.faction[playerFaction] end
    if itemMinLevel == nil then itemMinLevel = 0 end
    if item.level then itemMinLevel = item.level end
    local requiredStanding = ""
    if item.requires then
        local limit = ""
        if item.limit then limit = " to " .. Repute.factionStandingColours[item.limit] .. GetText("FACTION_STANDING_LABEL"..item.limit, gender).."\124r\n" end
        requiredStanding = "Requires "..Repute.factionStandingColours[item.requires] .. GetText("FACTION_STANDING_LABEL"..item.requires, gender).."\124r"..limit.."\n"
    end
    
    if factionID then
        local factionName, _, factionStanding, barMin, barMax, value = GetFactionInfoByID(factionID)
        local multiplier = 1
        if race == "Human" then multiplier = 1.1 end
        local token = ""
        if item.token then token = " + " .. Repute.repitems[item.token].rep * multiplier end
        local stack = ""
        if item.stack then stack = " (per " .. item.stack .. ")" end
        local itemrep = ""
        if item.rep then itemrep = item.rep * multiplier end
        local repIncrease = ""
        if itemrep or token then repIncrease = ": ".. itemrep .. token .. stack end
        local factionHeader = "|cffffd100" .. factionName .. repIncrease
        local factionStandingtext = "|cffffd100Faction not encountered yet"
        if Repute_Data[profileKey].factions[factionID] then
            local reputationString = getRepString(Repute_Data[profileKey].factions[factionID], Repute_Data[profileKey].profile)
            factionStandingtext = reputationString.str
        end
        if _G[self:GetName().."TextLeft2"]:GetText() then
            _G[self:GetName().."TextLeft2"]:SetText(factionHeader.."\124r\n"..factionStandingtext.."\124r\n"..requiredStanding.._G[self:GetName().."TextLeft2"]:GetText())
        else
            self:AddLine(factionHeader.."\124r\n"..factionStandingtext.."\124r\n"..requiredStanding)
        end
    end

    local itemRewards = item.reward
    local classRewards = false
    local soulbound = false
    local startsquest = false
    for i = 1, self:NumLines() do
        if string.find(_G[self:GetName().."TextLeft"..i]:GetText(), ITEM_SOULBOUND) then soulbound = true end
        if string.find(_G[self:GetName().."TextLeft"..i]:GetText(), ITEM_STARTS_QUEST) then startsquest = i end
    end
    
    if item.quest then
        local questID
        if type(item.quest) == 'table' then
            classRewards = true
            if item.quest[playerClass] then
                if item.quest[playerClass] == true then
                    questID = item.questID
                    itemRewards = item.reward
                else
                    questID = item.quest[playerClass].questID
                    itemRewards = item.quest[playerClass].reward
                end
            end
        else
            questID = item.quest
        end
        if questID then
            local questStatus = "Incomplete"
            if item.repeatable then
                questStatus = "Repeatable"
            elseif Repute_Data[profileKey].quests[questID] then
                questStatus = "Completed"
            end
            if startsquest then
                _G[self:GetName().."TextLeft"..startsquest]:SetText(_G[self:GetName().."TextLeft"..startsquest]:GetText().. " (" .. questStatus .. ")")
            elseif _G[self:GetName().."TextLeft3"]:GetText() then
                _G[self:GetName().."TextLeft3"]:SetText(_G[self:GetName().."TextLeft3"]:GetText().." ("..questStatus..")")
            end
        end
    end
    
    for key, show in pairs(Repute_Data.global.profileKeys) do
        if true then
            local k = Repute_Data[key]
            if k.profile and server == k.profile.server and not item[k.profile.faction] then
                local reputationString = getRepString(k.factions[factionID], k.profile)
                local color = RAID_CLASS_COLORS[k.profile.class]
                local level = ""
                if k.profile.level < itemMinLevel then level = "|cff808080 ("..k.profile.level..")" end
                
                local rewardForThisClass = true
                if classRewards and not item.quest[k.profile.class] then rewardForThisClass = false end
                
                local complete = ""
                local questForThisAlt = false
                local thisQuestId
                if classRewards then
                    if item.quest[k.profile.class] then
                        if item.quest[k.profile.class] == true then
                            thisQuestId = item.questID
                        else
                            thisQuestId = item.quest[k.profile.class].questID
                        end
                    end
                else
                    thisQuestId = item.quest
                end
                if thisQuestId and not item.repeatable then
                    questForThisAlt = true
                    complete = "|cff808080 (Incomplete)"
                    if k.quests[thisQuestId] then complete = "|cffffffff (Complete)" end
                    if k.quests[thisQuestId] == nil then complete = "|cff808080 (Unknown)" end
                end
                
                if factionID then
                    if (k.profile.level >= itemMinLevel and (rewardForThisClass or questForThisAlt)) or IsAltKeyDown() then
                        self:AddDoubleLine(k.profile.name..level..complete, reputationString.str, color.r, color.g, color.b)
                    end
                end
            end
        end
    end

    if Repute.repitemsets[id] then
        self:AddLine(" ")
        self:AddLine("Set:")
        for i, v in ipairs(Repute.repitemsets[id]) do
            local thisItemLink = select(2, GetItemInfo(Repute.repitemsets[id][i]))
            local note = ""
            if Repute.repitemsets[id].note then note = Repute.repitemsets[id].note[i] end
            
            local countBags = GetItemCount(Repute.repitemsets[id][i])
            local countTotal = GetItemCount(Repute.repitemsets[id][i], true)
            local bankText = ""
            if countTotal - countBags ~= 0 then bankText = "(".. (countTotal - countBags) .. " in bank) " end
            self:AddDoubleLine(thisItemLink.." "..note, bankText .. countTotal)
        end
    end
    
    if item.note then
        self:AddLine("* ".. item.note)
    end

    self:Show()
    
    showRewardTooltip.rewardList = nil
        
    if itemRewards then
        showRewardTooltip.rewardList = itemRewards
        showRewardTooltip.rewardShowing = showRewardTooltip.rewardShowing or 1
        showRewardTooltip.rewardMax = table.getn(itemRewards)
        
        if showRewardTooltip.rewardShowing > showRewardTooltip.rewardMax then showRewardTooltip.rewardShowing = 1 end
        
        GetItemInfo(itemRewards[showRewardTooltip.rewardShowing])
        rewardItemCache[itemRewards[showRewardTooltip.rewardShowing]] = true
        
        showRewardTooltip:SetOwner(GameTooltip, "ANCHOR_NONE")
        showRewardTooltip:SetHyperlink("item:"..itemRewards[showRewardTooltip.rewardShowing])
        if showRewardTooltip.rewardMax > 1 then
            showRewardTooltip:AddDoubleLine("Press CTRL to cycle rewards", showRewardTooltip.rewardShowing.."/"..showRewardTooltip.rewardMax)
        end
        
        local screenW = GetScreenWidth() or 0
        local ttW = showRewardTooltip:GetWidth() or 0
        local ttR = self:GetRight() or 0
        if screenW - ttR < ttW then
            showRewardTooltip:ClearAllPoints()
            showRewardTooltip:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT", 0, 0)
        else
            showRewardTooltip:ClearAllPoints()
            showRewardTooltip:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT", 0, 0)
        end
        showRewardTooltip:Show()
    end
end

local function addClassBookToToolTip(self, id)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon,
        itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(id)
    
    for key, show in pairs(Repute_Data.global.profileKeys) do
        if key ~= profileKey then
            local k = Repute_Data[key]
            if k.profile and server == k.profile.server then
                if Repute.classbooks[id][k.profile.class] then
                    local color = RAID_CLASS_COLORS[k.profile.class]
                    local isLearned = "|cff808080Unknown"
                    
                    local level = ""
                    if k.profile.level < itemMinLevel then level = "|cff808080 ("..k.profile.level..")" end
                    
                    if k.classbooks then
                        if k.classbooks[Repute.classbooks[id][k.profile.class]] == true then isLearned = "Learned"
                        elseif k.classbooks[Repute.classbooks[id][k.profile.class]] == false then isLearned = "Can learn" end
                    end
                    self:AddDoubleLine(k.profile.name .. level, isLearned, color.r, color.g, color.b)
                end
            end
        end
    end
end

local function addRepToToolTip(self, id)
    -- Define the function to add reputation information to the tooltip
    local factionName, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(id)
    if factionName then
        local factionStandingtext = Repute.factionStandingColours[standingID] .. GetText("FACTION_STANDING_LABEL"..standingID, gender)
        local repString = factionName .. " ("..factionStandingtext .. " " .. barValue - barMin .. " /" .. barMax - barMin .. "|r)"
        self:AddLine(repString, 1, 1, 1)
    end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(self, link)
    local id = tonumber(string.match(link, "item:(%d*)"))
    if id then
        if Repute.repitems[id] then
            if Repute.repitems[id][playerFaction] then id = Repute.repitems[id][playerFaction] end
            addRepToToolTip(self, id)
        elseif Repute.classbooks[id] then
            addClassBookToToolTip(self, id)
        end
    end
end)

GameTooltip:HookScript("OnTooltipSetItem", function(self)
    local link = select(2, self:GetItem())
    if link then
        local id = tonumber(string.match(link, "item:(%d*)"))
        if id then
            if Repute.repitems[id] then
                if Repute.repitems[id][playerFaction] then id = Repute.repitems[id][playerFaction] end
                addRepToToolTip(self, id)
            elseif Repute.classbooks[id] then
                addClassBookToToolTip(self, id)
            end
        end
    end
end)

local Repute_msg_filter = function(frame, event, message, ...)
    repFrame = frame
    C_Timer.After(0.2, function() Repute:getAllFactions() end)
    return true
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", Repute_msg_filter)

function Repute:createRepString(faction)
    local factionStandingtext = Repute.factionStandingColours[faction.standingID] .. GetText("FACTION_STANDING_LABEL"..faction.standingID, gender)
    local changeString = ""
    if faction.oldValue then
        local positive = "+"
        local change = faction.barValue - faction.oldValue
        if change < 0 then positive = "" end
        changeString = positive .. change
    end
    
    local newmessage = faction.name .. " " .. changeString .. " ("..factionStandingtext .. " " .. faction.barValue - faction.barMin .. " /" .. faction.barMax - faction.barMin .. "|r)"
    getglobal(repFrame:GetName()):AddMessage(newmessage, 0.5, 0.5, 1)
end

function Repute:getAllFactions(initiate)
    if not Repute_Data[profileKey] then
        Repute_Data[profileKey] = { profile = {}, quests = {}, classbooks = {}, factions = {} }
    end
    if not Repute_Data[profileKey].factions then
        Repute_Data[profileKey].factions = {}
    end

    local numFactions = GetNumFactions()
    for factionIndex = 1, numFactions do
        local name, description, standingId, barMin, barMax, earnedValue, atWarWith, canToggleAtWar,
            isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
        if isHeader and isCollapsed then
            ExpandFactionHeader(factionIndex)
            numFactions = GetNumFactions()
        end
            
        if hasRep or not isHeader then
            if initiate then
                Repute_Data[profileKey].factions[factionID] = earnedValue
            else
                local oldValue = Repute_Data[profileKey].factions[factionID]
                if earnedValue ~= oldValue then
                    local faction = {
                        factionID = factionID,
                        name = name,
                        standingID = standingId,
                        barMin = barMin,
                        barMax = barMax,
                        barValue = earnedValue,
                        oldValue = oldValue,
                    }
                    Repute_Data[profileKey].factions[factionID] = earnedValue
                    Repute:createRepString(faction)
                end
            end
        end
    end
end

-- Register Initial Events
Repute:RegisterEvent("PLAYER_LOGIN")
Repute:RegisterEvent("MODIFIER_STATE_CHANGED")
Repute:RegisterEvent("PLAYER_LEVEL_UP")
Repute:RegisterEvent("GET_ITEM_INFO_RECEIVED")
Repute:RegisterEvent("QUEST_TURNED_IN")
Repute:RegisterEvent("LEARNED_SPELL_IN_TAB")
