FRACTIONS = { city_mayor = {
    team = nil,
    name = "Мэрия Города",
    leader = nil, 
    members = {}
} }


function createTeamsOnStart()
    for i, fraction in pairs( FRACTIONS ) do
        fraction.team = i
    end
end
addEventHandler( "onResourceStart", resourceRoot, createTeamsOnStart )


function sendDataToAllPlayersInFraction( team, fraction_id ) 
    players = getElementsByType( "player" )
    for _, player in pairs( players ) do 
        if getElementData( player, "fraction_id" ) == team then
            triggerClientEvent( player, "onReceiveFractionData", resourceRoot, fraction_id )
            triggerClientEvent( player, "onUpdatePlayerList", resourceRoot )
        end
    end
end


function setPlayerFractionLeader( player, fraction_id )
    local fraction = fraction_id
    if fraction.leader == nil then
        setElementData( player, "fraction_id", fraction.team )
        fraction.leader = player
        table.insert( fraction.members, player )
    else

    end 
end


function setPlayerFraction( player, fraction_id )
    local fraction = fraction_id   

    if fraction then
        if fraction.leader == player then
            
        elseif getElementData( player, "fraction_id" ) ~= nil then
            
        else           
            setElementData( player, "fraction_id", fraction.team )
            table.insert( fraction.members, player )
            sendDataToAllPlayersInFraction( fraction.team, fraction )
        end
    else
        
    end
end


function removePlayerFromFraction( player, fraction_id )
    if type( fraction_id ) == "string" then
        fraction_id = getFractionId( player, fraction_id )
    end

    local fraction = fraction_id

    if fraction then
        if fraction.leader == player then 
            setElementData( player, "faction_id", nil )
            fraction.leader = nil
            fraction.members.player = nil
        elseif getElementData( player, "fraction_id" ) ~= getElementData( fraction.leader, "fraction_id" ) then 

        elseif getPlayerTeam( player ) == nil then

        else
            local player_index = nil
            for i, member in pairs( fraction.members ) do
                if member == player then
                    player_index = i
                break
                end
            end

            if player_index then
                table.remove( fraction.members, player_index )
            -- Дополнительные действия, если нужны
            end
            setElementData( player, "fraction_id", nil )
            sendDataToAllPlayersInFraction( fraction_id.team, fraction_id )

        end
    else

    end
end
addEvent( "onRemovePlayerFromFraction", true )
addEventHandler( "onRemovePlayerFromFraction", root, removePlayerFromFraction )


function sendMessageToFraction( player, fraction_id, msg )
    outputChatBox( fraction_id.name..": "..getPlayerName(player).." says: "..msg )
end


function getFractionId( player, fraction_id )
    for i, fraction in pairs( FRACTIONS ) do
        local f = FRACTIONS
        if tostring( i ) == fraction_id then
            FRACTION_ID = f[i]
        end
    end    
    return FRACTION_ID
end
addEvent( "onGetFractionId", true )
addEventHandler( "onGetFractionId", root, getFractionId )


function handleCommand( source, command, ... )
    ARGS = {...}
    PLAYER_ID = ARGS[1]
    FRACTION_ID = ARGS[2]
    local player = getElementByID( PLAYER_ID )

    if FRACTION_ID ~= nil then
        FRACTION_ID = getFractionId( source, FRACTION_ID )
    end

    if command == "set_player_fraction_leader" then
        if FRACTION_ID.leader == nil then
            setPlayerFractionLeader( player, FRACTION_ID )
            triggerClientEvent( player, "onReceiveFractionData", resourceRoot, FRACTION_ID )
        elseif FRACTION_ID.leader == player then

        else 

        end
    elseif command == "set_player_fraction" then
        local fraction_id = getFractionId( source, getElementData( source, "fraction_id" ) )
        if fraction_id.leader == source and ARGS[2] ~= nil then
            setPlayerFraction( player, FRACTION_ID )
            sendDataToAllPlayersInFraction( FRACTION_ID.team, FRACTION_ID )
        elseif fraction_id and fraction_id.leader == source and ARGS[2] == nil then
            removePlayerFromFraction( player, fraction_id.team )
            sendDataToAllPlayersInFraction( fraction_id.team, fraction_id ) 
         end
    elseif command == "/f" then
        local player = source
        local fraction_id = getFractionId( source, getElementData( source, "fraction_id" ) )
        sendMessageToFraction( source, fraction_id, ARGS[1] )
    else

    end
    
end
addCommandHandler( "set_player_fraction_leader", handleCommand )
addCommandHandler( "set_player_fraction", handleCommand )
addCommandHandler( "/f", handleCommand )



function onAcceptInvite( team, leader, invited_player )
    local fraction_id = team
    setPlayerFraction( invited_player, fraction_id )
end 
addEvent( "onAcceptInvite", true )
addEventHandler( "onAcceptInvite", root, onAcceptInvite )


function onInvitePlayer( leader, team, invited_player, message )
    if invited_player then
        triggerClientEvent( invited_player, "onReceiveInvite", resourceRoot, team, leader, invited_player, message )
    end
end
addEvent("onInvitePlayer", true )
addEventHandler( "onInvitePlayer", root, onInvitePlayer )

