local KEY 
local PLAYER 
local PLAYER_ID_TEXT = ""
CURRENT_PLAYER_ID_TEXT = ""
function setPlayerId( thePlayer, player_id )
    KEY = player_id
    PLAYER = thePlayer
end
addEvent( "onPlayerIdDraw", true )
addEventHandler( "onPlayerIdDraw", root, setPlayerId )


function drawLocalPlayerId()
    local screen_width, screen_height = guiGetScreenSize()
    dxDrawText( tostring(KEY), 10, 10, screen_width, screen_height, tocolor(255, 255, 255, 255), 1, "pricedown" )
end
addEventHandler( "onClientRender", root, drawLocalPlayerId )

 -- Таблица для хранения ID игроков

function drawOtherPlayersId()
    local players = getElementsByType( "player" )
    for _, thePlayer in pairs( players ) do
        if thePlayer ~= localPlayer then
            if type( thePlayer ) == "userdata" then
                triggerServerEvent( "onRequestPlayersId", source, thePlayer )
            end
            local player_x, player_y, player_z = getElementPosition( thePlayer )
            local screen_x, screen_y = getScreenFromWorldPosition( player_x, player_y, player_z + 1 )
            if screen_x and screen_y then
                dxDrawText( PLAYER_ID_TEXT, screen_x - 10, screen_y - 30, screen_width, screen_height, tocolor(255, 255, 255, 255), 1, "pricedown" )
            end
        end
    end
end
addEventHandler( "onClientRender", root, drawOtherPlayersId )

function receivePlayerId(player_id)
    PLAYER_ID_TEXT = player_id  -- Сохраняем ID игрока в таблице
end
addEvent("onReceivePlayerId", true)
addEventHandler("onReceivePlayerId", root, receivePlayerId)


