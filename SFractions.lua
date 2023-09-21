FRACTIONS = {city_mayor = {
    team = nil,
    name = "Мэрия Города",
    leader = nil, 
    members = {}
}}


function createTeamsOnStart()
    for i, fraction in pairs(FRACTIONS) do
        fraction.team = createTeam(i, 0, 255, 0)
    end
end
addEventHandler("onResourceStart", resourceRoot, createTeamsOnStart)


function setPlayerFractionLeader(player, fraction_id)
    local fraction = fraction_id
    if fraction then
        setPlayerTeam(player, fraction.team)
        local player_team = getPlayerTeam(player)
        fraction.leader = player
    else

    end 
end

function getPlayerData(player_id)
    data = {}  
    local player = player_id
    if player ~= false then
        if type(getPlayerTeam(player)) ~= "boolean" then
            local players = getPlayersInTeam(getPlayerTeam(player))
            for i, playerInTeam in pairs(players) do 
                local player_data = {}
                local fraction_id = getFractionId(getTeamName(getPlayerTeam(playerInTeam)))
                if playerInTeam == fraction_id.leader then
                    player_data.leader = playerInTeam
                else 
                    player_data.leader = nil
                end
                player_data.player = playerInTeam
                player_data.team = getPlayerTeam(playerInTeam)
                player_data.team_name = getTeamName(getPlayerTeam(playerInTeam))
                player_data.player_nick = getPlayerName(playerInTeam)
                player_data.player_id = player_id
                table.insert(data, player_data)        
            end
        else 
            local player_data = {}
            player_data.player = player
            player_data.team = nil
            player_data.team_name = nil
            player_data.player_nick = getPlayerName(player)
            player_data.player_id = player_id
            table.insert(data, player_data)
        end
        triggerClientEvent(player, "onReceivePlayerData", resourceRoot, data)
    end
end
addEvent("onGuiRequestInfo", true)
addEventHandler("onGuiRequestInfo", root, getPlayerData)

function setPlayerFraction(player, fraction_id)
    local fraction = fraction_id   
    if fraction then
        if fraction.leader == player then 
        elseif getPlayerTeam(player) ~= false then
        else
            setPlayerTeam(player, fraction.team)
            fraction.members.player = player
            --getPlayerData(player)
            triggerClientEvent(player, "onUpdatePlayerList", resourceRoot)
            triggerClientEvent({fraction.leader, player},"onPlayerList",resourceRoot)
        end
    else
    end
end


function removePlayerFromFraction(player, fraction_id)
    if type(fraction_id) == "string" then
        fraction_id = getFractionId(fraction_id)
    end
    local fraction = fraction_id
    if fraction then
        if fraction.leader == player then 
        elseif getPlayerTeam(player) ~= getPlayerTeam(fraction.leader) then 
        elseif getPlayerTeam(player) == nil then
        else
            fraction.members.player = nil
            setPlayerTeam(player, nil)
            getPlayerData(fraction.leader)
            triggerClientEvent({fraction.leader, player},"onPlayerList",resourceRoot)
        end

    else

    end
end
addEvent("onRemovePlayerFromFraction", true)
addEventHandler("onRemovePlayerFromFraction", root, removePlayerFromFraction)


function sendMessageToFraction(player, fraction_id, msg)
    outputChatBox(fraction_id.name..": "..getPlayerName(player).." says: "..msg, getPlayerTeam(player))
end


function getFractionId(fraction_id)
    for i, fraction in pairs(FRACTIONS) do
        local f = FRACTIONS
        if tostring(i) == fraction_id then
            FRACTION_ID = f[i]
        end
    end
    return FRACTION_ID
end



function handleCommand(source, command, ...)
    ARGS = {...}
    PLAYER_ID = ARGS[1]
    FRACTION_ID = ARGS[2]
    local player = getPlayerFromPlayersIdList(PLAYER_ID)
    if FRACTION_ID ~= nil then
        FRACTION_ID = getFractionId(FRACTION_ID)
    end
    if command == "set_player_fraction_leader" then
        setPlayerFractionLeader(player, FRACTION_ID)
        getPlayerData(player)
    elseif command == "set_player_fraction" then
        if FRACTION_ID.leader == source then
            setPlayerFraction(player, FRACTION_ID)
            getPlayerData(player)
        else 
        end
    elseif command == "remove_player_from_fraction" then
        local fraction_id = getFractionId(getTeamName(getPlayerTeam(source)))
        if fraction_id and fraction_id.leader == source and ARGS[2] == nil then
            removePlayerFromFraction(player, fraction_id)
        else 
        end
    elseif command == "/f" then
        local player = source
        local fraction_id = getFractionId(getTeamName(getPlayerTeam(source)))
        sendMessageToFraction(source,fraction_id,ARGS[1])
    else
        -- Обработка неизвестной команды.
    end
    
end
addCommandHandler("set_player_fraction_leader", handleCommand)
addCommandHandler("set_player_fraction", handleCommand)
addCommandHandler("remove_player_from_fraction", handleCommand)
addCommandHandler("/f", handleCommand)


-- нет проверки данных с клиента
function onAcceptInvite(invitingPlayerNick)
    local invitingPlayer = getPlayerFromName(invitingPlayerNick)
    local fraction_id = getFractionId("city_mayor")
    if invitingPlayer then
        setPlayerFraction(invitingPlayer, fraction_id)
        setPlayerTeam(source, getPlayerTeam(invitingPlayer))
    end
end
addEvent("onAcceptInvite", true)
addEventHandler("onAcceptInvite", root, onAcceptInvite)

-- нет проверки данных с клиента
function onInvitePlayer(invitingPlayerNick, invitedPlayerNick, message)
    local invitedPlayer = getPlayerFromName(invitedPlayerNick)
    if invitedPlayer then
        triggerClientEvent(invitedPlayer, "onReceiveInvite", resourceRoot, invitingPlayerNick, message)
    end
end
addEvent("onInvitePlayer", true)
addEventHandler("onInvitePlayer", root, onInvitePlayer)
