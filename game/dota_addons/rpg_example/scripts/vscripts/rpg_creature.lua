ai = require( "ai/ai_roamer_creature" )
function Spawn( entityKeyValues )
    ai.Init( thisEntity )

    local nGoldReward = 0
    if RandomFloat( 0, 1 ) > 0.75 then
        nGoldReward = thisEntity:GetGoldBounty()
    end
    thisEntity:SetMinimumGoldBounty( nGoldReward )
    thisEntity:SetMaximumGoldBounty( nGoldReward )
end
