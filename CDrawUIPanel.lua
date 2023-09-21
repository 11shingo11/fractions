local FRACTION_PANEL = nil
DATA = {}
MEMBERS_TAB = nil


function clearPlayerList()
    for i, child in ipairs(getElementChildren(MEMBERS_TAB)) do
        if isElement(child) then
            destroyElement(child)
        end
    end
end


function displayPlayerList()
    if FRACTION_PANEL and isElement(FRACTION_PANEL) then
        clearPlayerList(MEMBERS_TAB)
        local member_x = 10
        local member_y = 40
        local fire_x = 220
        local fire_y = 40
        for i, player_data in pairs(DATA) do
            local member_label = guiCreateLabel(member_x, member_y, 200, 20, player_data.player_nick, false, MEMBERS_TAB)
            member_y = member_y + 20         
            if localPlayer == DATA[1].leader then
                local fireButton = guiCreateButton(fire_x, fire_y, 80, 20, "Уволить", false, MEMBERS_TAB)
                fire_y = fire_y + 20
                addEventHandler("onClientGUIClick", fireButton, function() firePlayer(player_data) end,false)
            end
        end
    end
end
addEvent("onPlayerList", true)
addEventHandler("onPlayerList", resourceRoot, displayPlayerList)


function openFactionPanel()
    local width = 400 
    local height = 300
    if FRACTION_PANEL == nil then
        FRACTION_PANEL = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Панель Фракции "..DATA[1].team_name, true)
        local tab_panel = guiCreateTabPanel(0, 0.1, 1, 0.9, true, FRACTION_PANEL)
        MEMBERS_TAB = guiCreateTab("Список участников", tab_panel)

 -- тут надо сделать перебор по массиву данных что бы понять кто из игроков лидер фракции
        if localPlayer == DATA[1].leader then
            local management_tab = guiCreateTab("Управление городом", tab_panel)
        end
        local close_button = guiCreateButton(660, 20, 22, 20, "X", false, FRACTION_PANEL)
        local refresh_button = guiCreateButton(600, 20, 22, 20, "R", false, FRACTION_PANEL)
        

        displayPlayerList()
        local invite_button = guiCreateButton( 10, 370, 80, 20, "Пригласить", false, MEMBERS_TAB )
        inviteEdit = guiCreateEdit(100, 370, 100, 20, "", false, MEMBERS_TAB)

        addEventHandler("onClientGUIClick", close_button, closeFactionPanel, false)
        addEventHandler("onClientGUIClick", refresh_button, updateFactionMembersList, false)
        addEventHandler("onClientGUIClick", invite_button, invitePlayerFromInput, false)

        guiSetInputEnabled(true)
    end

end
bindKey("z", "down", openFactionPanel)


function updateFactionMembersList()     
    triggerServerEvent("onGuiRequestInfo", root, localPlayer)
end
addEvent("onUpdatePlayerList", true)
addEventHandler("onUpdatePlayerList", resourceRoot, updateFactionMembersList)
bindKey("z", "down", updateFactionMembersList)



function closeFactionPanel()
    if FRACTION_PANEL and isElement(FRACTION_PANEL) then
        destroyElement(FRACTION_PANEL) 
        FRACTION_PANEL = nil 
        guiSetInputEnabled(false)
    end
    updateFactionMembersList()
end


function receivePlayerData(playerDATA)
    if playerDATA then
        DATA = playerDATA
    end
    
end
addEvent("onReceivePlayerData", true)
addEventHandler("onReceivePlayerData", resourceRoot, receivePlayerData)


function firePlayer(player_data)
    local player = getPlayerFromNick(player_data.player_nick)
    local fraction_id = player_data.team_name
    triggerServerEvent("onRemovePlayerFromFraction", root, player, fraction_id)
end




function invitePlayer(invited_player_nick)
    local playerName = getPlayerName(localPlayer)
    local message = playerName .. " приглашает вас вступить в " .. DATA[1].team_name 
    triggerServerEvent("onInvitePlayer", localPlayer,playerName, invited_player_nick, message)
end


function invitePlayerFromInput()
    local invited_player_nick = guiGetText(inviteEdit) 
    if invited_player_nick and invited_player_nick ~= "" then
        invitePlayer(invited_player_nick)
    end
end


function receiveInvite(inviting_player_nick, message)
    local invite_window = guiCreateWindow(0.3, 0.3, 0.4, 0.2, "Приглашение во фракцию", true)
    local invite_label = guiCreateLabel(0.1, 0.2, 0.8, 0.3, message, true, invite_window)
    local accept_button = guiCreateButton(0.2, 0.6, 0.3, 0.2, "Принять", true, invite_window)
    local decline_button = guiCreateButton(0.5, 0.6, 0.3, 0.2, "Отказаться", true, invite_window)
    guiSetInputEnabled(true)
    addEventHandler("onClientGUIClick", accept_button, function()
        triggerServerEvent("onAcceptInvite", localPlayer, inviting_player_nick) 
        destroyElement(invite_window)
        guiSetInputEnabled(false) 
    end, false)
    addEventHandler("onClientGUIClick", decline_button, function()
        destroyElement(invite_window)
        guiSetInputEnabled(false)
    end, false)
end
addEvent("onReceiveInvite", true)
addEventHandler("onReceiveInvite", resourceRoot, receiveInvite)
