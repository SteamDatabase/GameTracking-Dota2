LinkLuaModifier( "modifier_mount_penguin", "modifiers/gameplay/mounts/modifier_mount_penguin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mount_ogreseal", "modifiers/gameplay/mounts/modifier_mount_ogreseal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mount_snowball", "modifiers/gameplay/mounts/modifier_mount_snowball", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mount_frosttoad", "modifiers/gameplay/mounts/modifier_mount_frosttoad", LUA_MODIFIER_MOTION_NONE )

function CWinter2022:SetMountChoices()
    self.tMountChoices = {}
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer ~= nil then
			local nPlayerTeam = PlayerResource:GetTeam( nPlayerID )
			if nPlayerTeam == DOTA_TEAM_GOODGUYS or nPlayerTeam == DOTA_TEAM_BADGUYS then
                self.tMountChoices[nPlayerID] = _G.WINTER2022_MOUNT_CHOICES
			end
		end
	end

    for nPlayerID,rgChoices in pairs( self.tMountChoices ) do
        CustomNetTables:SetTableValue( "mount_choices", tostring(nPlayerID), rgChoices )
        local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
    end
	self:GetTeamAnnouncer( DOTA_TEAM_GOODGUYS ):OnSelectMount()
	self:GetTeamAnnouncer( DOTA_TEAM_BADGUYS ):OnSelectMount()
end

function CWinter2022:OnMountChoice( userId, event )
	local nPlayerID = event["PlayerID"]
    local sChoice = event["Choice"]
    local rgChoices = self.tMountChoices[nPlayerID]
    if rgChoices ~= nil and TableContainsValue( rgChoices, sChoice ) then
        self.tMountChoices[nPlayerID] = nil
        CustomNetTables:SetTableValue( "mount_choices", tostring(nPlayerID), {} )
        local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
        self:GrantMount( nPlayerID, hHero, sChoice )
        self:GetTeamAnnouncer( hHero:GetTeamNumber() ):OnMountSelected( hHero, sChoice )

        if hHero:GetUnitName() == "npc_dota_hero_lich" and sChoice == "frosttoad" then
            EmitSoundOnLocationForAllies(hHero:GetOrigin(), "lich_lich_ability_frosttoad_01", hHero )
        end
    end
end

function CWinter2022:GrantMount( nPlayerID, hHero, sChoice )
    if not IsServer() then return end

    hHero:RemoveModifierByName( "modifier_hero_selecting_mount" )
    hHero:AddNewModifier( hHero, nil, "modifier_mount_" .. sChoice, {} )
    hHero:GetOwnerEntity().mount_choice = sChoice -- for meepo

	local mount_index = -1
	for i,hBuffName in pairs( _G.WINTER2022_MOUNT_CHOICES ) do

		if hBuffName == sChoice then
			mount_index = i
            break
        end
	end

	self.SignOutTable["stats"]["player_stats"][nPlayerID]["mount_index"] = mount_index

	FireGameEvent( "dota_combat_event_message", {
        player_id = nPlayerID,
        teamnumber = PlayerResource:GetTeam( nPlayerID ),
        locstring_value = "#DOTA_HUD_mount_" .. sChoice,
        message = "#DOTA_HUD_mount_select_Toast"
    } )
end

function CWinter2022:Dev_ResetMounts()
    -- remove modifiers
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
        local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
        if hHero ~= nil then
            for _,hBuffName in pairs( _G.WINTER2022_MOUNT_CHOICES ) do
                hHero:RemoveModifierByName("modifier_mount_" .. hBuffName)
            end
        end
    end

    self:SetMountChoices()
end
