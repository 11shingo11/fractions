local KEY 
local PLAYER 


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


function drawOtherPlayersId()
    local players = getElementsByType( "player" )
    for _, thePlayer in pairs( players ) do
        if thePlayer ~= localPlayer then
            local player_id = getElementID(thePlayer)
            local player_x, player_y, player_z = getElementPosition( thePlayer )
            local screen_x, screen_y = getScreenFromWorldPosition( player_x, player_y, player_z + 1 )
            if screen_x and screen_y then
                dxDrawText( player_id, screen_x - 10, screen_y - 30, screen_width, screen_height, tocolor(255, 255, 255, 255), 1, "pricedown" )
            end
        end
    end
end
addEventHandler( "onClientRender", root, drawOtherPlayersId )



