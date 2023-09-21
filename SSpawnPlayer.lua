local SPAWN_X, SPAWN_Y, SPAWN_Z = 1959.55, -1714.46, 17
local PLAYER_IDS = {}
ID = 1


function joinHandler()
	spawnPlayer( source, SPAWN_X, SPAWN_Y, SPAWN_Z )
	fadeCamera( source, true )
	setCameraTarget( source, source )   
	
end
addEventHandler("onPlayerJoin", root, joinHandler)


function appointPlayerId()
	PLAYER_IDS[source] = ID
	triggerClientEvent( source, "onPlayerIdDraw", source, source, ID )
	ID = ID + 1
end
addEventHandler( "onPlayerJoin", root, appointPlayerId )


function getPlayerIdFromList( thePlayer )
	if type( thePlayer ) == "userdata" then
		for player, player_id in pairs( PLAYER_IDS ) do
			if player ~= thePlayer and thePlayer ~= nil then --player~=nil 
				triggerClientEvent( thePlayer, "onReceivePlayerId", client, player_id )
			end
		end
	end
end
addEvent("onRequestPlayersId", true)
addEventHandler("onRequestPlayersId", root, getPlayerIdFromList)


function getPlayerFromPlayersIdList(id)
	for player, player_id in pairs( PLAYER_IDS ) do 		
		if id == tostring(player_id) then
			this_player = player
		end	
	end	
	return this_player
end


function playerQuit()
	if #PLAYER_IDS > 1 then
		table.remove( PLAYER_IDS, source )
	end
end 
addEventHandler ( "onPlayerQuit", root, playerQuit )