local FRACTION_PANEL = nil
local FRACTION = {}
local MEMBERS_TAB = nil
local LAST_INVITED_TIME = {}  
local INVITE_COOLDOWN = 60 * 1000 


function getFractionData()
    triggerServerEvent("onGetFractionId", resourceRoot, localPlayer, getTeamName(getPlayerTeam(localPlayer)))
end


function clearPlayerList()
    if getElementChildren(MEMBERS_TAB) then
        for i, child in pairs(getElementChildren(MEMBERS_TAB)) do
            if isElement(child) then
                destroyElement(child)
            end
        end
    end
    displayPlayerList()
end
addEvent("onUpdatePlayerList", true)
addEventHandler("onUpdatePlayerList", resourceRoot, clearPlayerList)
addEventHandler("onReceiveFractionData", resourceRoot, receiveFractionData)

function displayPlayerList()
    if FRACTION_PANEL and isElement(FRACTION_PANEL) then
        local member_x = 10
        local member_y = 40
        local fire_x = 220
        local fire_y = 40
        local member_label = guiCreateLabel(member_x, member_y, 200, 20, "ID: "..getElementID(FRACTION.leader).."   "..getPlayerName(FRACTION.leader), false, MEMBERS_TAB)
        
        for i, player in pairs(FRACTION.members) do
            member_y = member_y + 20 
            local member_label = guiCreateLabel(member_x, member_y, 200, 20, "ID: "..getElementID(player).."   "..getPlayerName(player), false, MEMBERS_TAB)       
            if localPlayer == FRACTION.leader then
                fire_y = fire_y + 20
                local fireButton = guiCreateButton(fire_x, fire_y, 80, 20, "Уволить", false, MEMBERS_TAB)
                addEventHandler("onClientGUIClick", fireButton, function() firePlayer(player) end,false)
            end
        end
    end
end
addEvent("onPlayerList", true)
addEventHandler("onPlayerList", resourceRoot, displayPlayerList)


function DrawFactionPanel()
    local width = 400 
    local height = 300
    if FRACTION_PANEL == nil then       
        FRACTION_PANEL = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Панель Фракции "..FRACTION.name   , true)
        local tab_panel = guiCreateTabPanel(0, 0.1, 1, 0.9, true, FRACTION_PANEL)
        MEMBERS_TAB = guiCreateTab("Список участников", tab_panel)

        if localPlayer == FRACTION.leader then
            local management_tab = guiCreateTab("Управление городом", tab_panel)
            local invite_button = guiCreateButton( 10, 370, 80, 20, "Пригласить", false, MEMBERS_TAB )
            inviteEdit = guiCreateEdit(100, 370, 100, 20, "", false, MEMBERS_TAB)
            addEventHandler("onClientGUIClick", invite_button, invitePlayerFromInput, false)
        end

        local close_button = guiCreateButton(660, 20, 22, 20, "X", false, FRACTION_PANEL)
        addEventHandler("onClientGUIClick", close_button, closeFactionPanel, false)   
        guiSetInputEnabled(true)
    end
end


function openFactionPanel()
    --getFractionData()
    if getPlayerTeam(localPlayer) then
        --clearPlayerList()
        DrawFactionPanel()
        displayPlayerList()
    end
end
bindKey("z", "down", openFactionPanel)


function closeFactionPanel()
    if FRACTION_PANEL and isElement(FRACTION_PANEL) then
        destroyElement(FRACTION_PANEL) 
        FRACTION_PANEL = nil 
        guiSetInputEnabled(false)
    end
end


function receiveFractionData(FRACTION_ID)
    if FRACTION_ID then
        FRACTION = FRACTION_ID
    end
end
addEvent("onReceiveFractionData", true)
addEventHandler("onReceiveFractionData", resourceRoot, receiveFractionData)


function firePlayer(player)
    local fraction_id = getTeamName(FRACTION.team)
    triggerServerEvent("onRemovePlayerFromFraction", root, player, fraction_id)
end




function invitePlayer(invited_player_nick)
    local leader = getPlayerName(localPlayer)
    local team = FRACTION.team
    local message = leader .. " приглашает вас вступить в " .. FRACTION.name

    if type(leader) == "string" and type(team) == "userdata" and type(invited_player_nick) == "string" and type(message) == "string" then  
        triggerServerEvent("onInvitePlayer", localPlayer, leader, team, invited_player_nick, message)
    end
end


function invitePlayerFromInput()
    local invited_player_nick = guiGetText(inviteEdit) 
    
    if invited_player_nick and invited_player_nick ~= "" then
        local player = getPlayerFromName(invited_player_nick)
        local currentTime = getTickCount()

        if not LAST_INVITED_TIME[invited_player_nick] or currentTime - LAST_INVITED_TIME[invited_player_nick] >= INVITE_COOLDOWN then
            invitePlayer(invited_player_nick)
            LAST_INVITED_TIME[invited_player_nick] = currentTime
        else
            outputChatBox("Подождите, прежде чем отправить новое приглашение этому игроку.")
        end
    end
end


function receiveInvite(team, leader, invited_player, message)
    local invite_window = guiCreateWindow(0.3, 0.3, 0.4, 0.2, "Приглашение во фракцию "..getTeamName(team), true)
    local invite_label = guiCreateLabel(0.1, 0.2, 0.8, 0.3, message, true, invite_window)
    local accept_button = guiCreateButton(0.2, 0.6, 0.3, 0.2, "Принять", true, invite_window)
    local decline_button = guiCreateButton(0.5, 0.6, 0.3, 0.2, "Отказаться", true, invite_window)
    guiSetInputEnabled(true)
    addEventHandler("onClientGUIClick", accept_button, function()
        if type(team) == "userdata" and type(leader) == "string" and type(invited_player) == "userdata" then
            triggerServerEvent("onAcceptInvite", localPlayer, team, leader, invited_player) 
            destroyElement(invite_window)
            guiSetInputEnabled(false)
        end
    end, false)
    addEventHandler("onClientGUIClick", decline_button, function()
        destroyElement(invite_window)
        guiSetInputEnabled(false)
    end, false)
end
addEvent("onReceiveInvite", true)
addEventHandler("onReceiveInvite", resourceRoot, receiveInvite)
