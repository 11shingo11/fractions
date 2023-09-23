local SPAWN_X, SPAWN_Y, SPAWN_Z = 1959.55, -1714.46, 17
ID = 1
local PREV_ID = false

function joinHandler()
	spawnPlayer( source, SPAWN_X, SPAWN_Y, SPAWN_Z )
	fadeCamera( source, true )
	setCameraTarget( source, source )   
	appointPlayerId()
end
addEventHandler("onPlayerJoin", root, joinHandler)


function appointPlayerId()
	setElementData(source, "player", source)
	if PREV_ID ~= false then
		setElementID(source, PREV_ID)
		PREV_ID = false
	else
		setElementID(source, ID)
	end
	setElementData(source, "faction_id", nil)--а надо ли оно мне
	
	triggerClientEvent( source, "onPlayerIdDraw", source, source, getElementID(source) )
	ID = ID + 1
end


function playerQuit()
	PREV_ID = getElementID(source)
	
	setElementData(source, "faction_id", nil)
	setElementData(source, "player", nil)
end 
addEventHandler ( "onPlayerQuit", root, playerQuit )