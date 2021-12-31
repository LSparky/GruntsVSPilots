global function GamemodeGVP_Init

void function GamemodeGVP_Init()
{
	SetSpawnpointGamemodeOverride( TEAM_DEATHMATCH )

	SetShouldUseRoundWinningKillReplay( true )
	SetLoadoutGracePeriodEnabled( false ) // prevent modifying loadouts with grace period
	SetWeaponDropsEnabled( false )
	Riff_ForceTitanAvailability( eTitanAvailability.Never )
	Riff_ForceBoostAvailability( eBoostAvailability.Disabled )
	ClassicMP_ForceDisableEpilogue( true )

	AddCallback_OnClientConnected( GVPInitPlayer )
	AddCallback_OnPlayerKilled( GVPOnPlayerKilled )
	AddCallback_GameStateEnter( eGameState.Playing, SelectFirstPilot )	
}

void function GVPInitPlayer( entity player )
{
	SetTeam( player, GVP_TEAM_GRUNTS )
}

void function SelectFirstPilot()
{
	thread SelectFirstPilotDelayed()
}

void function SelectFirstPilotDelayed()
{
	wait 10.0 + RandomFloat( 5.0 )

	array<entity> players = GetPlayerArray()
	entity pilot = players[ RandomInt( players.len() ) ]

	if (pilot != null || IsAlive(pilot))
		MakePlayerPilot( pilot )

	foreach ( entity otherPlayer in GetPlayerArray() )
			if ( pilot != otherPlayer )
				Remote_CallFunction_NonReplay( otherPlayer, "ServerCallback_AnnouncePilot", pilot.GetEncodedEHandle() )

	thread UpdateGruntLoadout()
}

void function UpdateGruntLoadout()
{
	foreach (entity player in GetPlayerArray())
	{
		if (player.GetTeam() != GVP_TEAM_GRUNTS || !IsAlive(player) || player == null)
			continue;

		player.SetPlayerSettingsWithMods( player.GetPlayerSettings(), [ "disable_wallrun", "disable_doublejump" ] )
	}
}

void function MakePlayerPilot(entity player)
{
	if (player == null)
		return;

	SetTeam( player, GVP_TEAM_PILOT )
	player.SetPlayerGameStat( PGS_ASSAULT_SCORE, 0 ) // reset kills
	Remote_CallFunction_NonReplay( player, "ServerCallback_YouArePilot" )
}

void function GVPOnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !victim.IsPlayer() || GetGameState() != eGameState.Playing )
		return
	
	if ( attacker.IsPlayer() )
    {
		// increase kills by 1
		attacker.SetPlayerGameStat( PGS_ASSAULT_SCORE, attacker.GetPlayerGameStat( PGS_ASSAULT_SCORE ) + 1 )
    }
}