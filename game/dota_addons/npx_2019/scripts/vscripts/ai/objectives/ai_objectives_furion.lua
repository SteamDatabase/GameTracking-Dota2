
-----------------------------------------------------------------------------------------------------

if CObjectivesFurionBot == nil then
	CObjectivesFurionBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CObjectivesFurionBot:constructor( me )
	self.me = me
end

function CObjectivesFurionBot:BotThink()

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ObjectivesFurionThink", ObjectivesFurionThink, 0.1 )

		thisEntity.Bot = CObjectivesFurionBot( thisEntity )
	end
end

function ObjectivesFurionThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


