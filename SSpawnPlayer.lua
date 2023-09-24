local SPAWN_X, SPAWN_Y, SPAWN_Z = 1959.55, -1714.46, 17
ID = 1
local PREV_ID = false
local PREV_IDS = {}

function joinHandler()
	spawnPlayer( source, SPAWN_X, SPAWN_Y, SPAWN_Z )
	fadeCamera( source, true )
	setCameraTarget( source, source )  
	appointPlayerId()
end
addEventHandler("onPlayerJoin", root, joinHandler)


function appointPlayerId()
	setElementData(source, "player", source)
	if table.maxn(PREV_IDS) ~= 0 then
		tryToGetIdFromPrevIds()
		setElementID(source, PREV_ID)
	else
		setElementID(source, ID)
		ID = ID + 1
	end
	setElementData(source, "faction_id", nil)--а надо ли оно мне
	
	triggerClientEvent( source, "onPlayerIdDraw", source, source, getElementID(source) )
end


function playerQuit()
	table.insert(PREV_IDS, getElementID(source))
	setElementData(source, "faction_id", nil)
	setElementData(source, "player", nil)
end 
addEventHandler ( "onPlayerQuit", root, playerQuit )


function tryToGetIdFromPrevIds()
	for _, ID in pairs(PREV_IDS) do
		if ID ~= nil then
			outputChatBox(ID)
			PREV_ID = ID
			table.remove(PREV_IDS, _)
			break
		end
	end
end