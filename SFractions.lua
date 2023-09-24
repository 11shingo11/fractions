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


function setPlayerFraction(player, fraction_id)
    local fraction = fraction_id   
    if fraction then
        if fraction.leader == player then

        elseif getPlayerTeam(player) ~= false then

        else
            setPlayerTeam(player, fraction.team)
            fraction.members.player = player
            for _, player in pairs(getPlayersInTeam(FRACTION_ID.team)) do
                triggerClientEvent(player, "onReceiveFractionData", resourceRoot, FRACTION_ID)
                triggerClientEvent(player, "onUpdatePlayerList", resourceRoot)
            end
        end
    else
        
    end
end


function removePlayerFromFraction(player, fraction_id)
    if type(fraction_id) == "string" then
        fraction_id = getFractionId(player, fraction_id)
    end

    local fraction = fraction_id

    if fraction then
        if fraction.leader == player then 
            setPlayerTeam(player, nil)
            fraction.leader = nil
        elseif getPlayerTeam(player) ~= getPlayerTeam(fraction.leader) then 

        elseif getPlayerTeam(player) == nil then

        else
            fraction.members.player = nil
            setPlayerTeam(player, nil)
            for _, player in pairs(getPlayersInTeam(FRACTION_ID.team)) do
                triggerClientEvent(player, "onReceiveFractionData", resourceRoot, FRACTION_ID)
                triggerClientEvent(player, "onUpdatePlayerList", resourceRoot)
            end
        end
    else

    end
end
addEvent("onRemovePlayerFromFraction", true)
addEventHandler("onRemovePlayerFromFraction", root, removePlayerFromFraction)


function sendMessageToFraction(player, fraction_id, msg)
    outputChatBox(fraction_id.name..": "..getPlayerName(player).." says: "..msg, getPlayerTeam(player))
end


function getFractionId(player, fraction_id)
    for i, fraction in pairs(FRACTIONS) do
        local f = FRACTIONS
        if tostring(i) == fraction_id then
            FRACTION_ID = f[i]
        end
    end    
    return FRACTION_ID
end
addEvent("onGetFractionId", true)
addEventHandler("onGetFractionId", root, getFractionId)


function handleCommand(source, command, ...)
    ARGS = {...}
    PLAYER_ID = ARGS[1]
    FRACTION_ID = ARGS[2]
    local player = getElementByID(PLAYER_ID)

    if FRACTION_ID ~= nil then
        FRACTION_ID = getFractionId(player, FRACTION_ID)
    end

    if command == "set_player_fraction_leader" then
        if FRACTION_ID.leader == nil then
            setPlayerFractionLeader(player, FRACTION_ID)
            triggerClientEvent(player, "onReceiveFractionData", resourceRoot, FRACTION_ID)
        elseif FRACTION_ID.leader == player then

        else 

        end
    elseif command == "set_player_fraction" then
         if FRACTION_ID.leader == source then
             setPlayerFraction(player, FRACTION_ID)
             triggerClientEvent({player,getPlayersInTeam(FRACTION_ID.team)}, "onReceiveFractionData", resourceRoot, FRACTION_ID)
             triggerClientEvent({player,getPlayersInTeam(FRACTION_ID.team)}, "onUpdatePlayerList", resourceRoot)
         else 
         end
    elseif command == "remove_player_from_fraction" then
        local fraction_id = getFractionId(source, getTeamName(getPlayerTeam(source)))
        if fraction_id and fraction_id.leader == source and ARGS[2] == nil then
            removePlayerFromFraction(player, fraction_id)
            triggerClientEvent({player,getPlayersInTeam(FRACTION_ID.team)}, "onReceiveFractionData", resourceRoot, FRACTION_ID)
            triggerClientEvent({player,getPlayersInTeam(FRACTION_ID.team)}, "onUpdatePlayerList", resourceRoot)
        else 
        end
    elseif command == "/f" then
        local player = source
        local fraction_id = getFractionId(source, getTeamName(getPlayerTeam(source)))
        sendMessageToFraction(source,fraction_id,ARGS[1])
    else

    end
    
end
addCommandHandler("set_player_fraction_leader", handleCommand)
addCommandHandler("set_player_fraction", handleCommand)
addCommandHandler("remove_player_from_fraction", handleCommand)
addCommandHandler("/f", handleCommand)



function onAcceptInvite(team, leader, invited_player)
    if type(team) == "userdata" and type(leader) == "string" and type(invited_player) == "userdata" then
        local fraction_id = getFractionId(leader, getTeamName(team))
        setPlayerFraction(invited_player, fraction_id)
        setPlayerTeam(invited_player, team)
    end
end
addEvent("onAcceptInvite", true)
addEventHandler("onAcceptInvite", root, onAcceptInvite)


function onInvitePlayer(leader, team, invited_player_nick, message)
    if type(leader) == "string" and type(team) == "userdata" and type(invited_player_nick) == "string" and type(message) == "string" then       
        local invited_player = getPlayerFromName(invited_player_nick)
        if invited_player then
            triggerClientEvent(invited_player, "onReceiveInvite", resourceRoot, team, leader, invited_player, message)
        end
    end
end
addEvent("onInvitePlayer", true)
addEventHandler("onInvitePlayer", root, onInvitePlayer)
