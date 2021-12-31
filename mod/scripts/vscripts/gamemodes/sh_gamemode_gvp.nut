global function Sh_GamemodeGVP_Init

global const string GAMEMODE_GVP = "gvp"
global const int GVP_TEAM_PILOT = TEAM_MILITIA
global const int GVP_TEAM_GRUNTS = TEAM_IMC

void function Sh_GamemodeGVP_Init()
{
	// create custom gamemode
	AddCallback_OnCustomGamemodesInit( CreateGamemodeGVP )
	AddCallback_OnRegisteringCustomNetworkVars( GVPRegisterNetworkVars )
}

void function CreateGamemodeGVP()
{
	GameMode_Create( GAMEMODE_GVP )
	GameMode_SetName( GAMEMODE_GVP, "Grunts VS Pilot" )
	GameMode_SetDesc( GAMEMODE_GVP, "Grunts versus a single Pilot, who will win." )
	GameMode_SetGameModeAnnouncement( GAMEMODE_GVP, "ffa_modeDesc" )
	GameMode_SetDefaultTimeLimits( GAMEMODE_GVP, 10, 0.0 )
		GameMode_AddScoreboardColumnData( GAMEMODE_GVP, "#SCOREBOARD_SCORE", PGS_ASSAULT_SCORE, 2 )
	GameMode_AddScoreboardColumnData( GAMEMODE_GVP, "#SCOREBOARD_PILOT_KILLS", PGS_PILOT_KILLS, 2 )
	GameMode_SetColor( GAMEMODE_GVP, [147, 204, 57, 255] )
	
	AddPrivateMatchMode( GAMEMODE_GVP ) // add to private lobby modes

	GameMode_SetDefaultScoreLimits( GAMEMODE_GVP, 25, 0 )
	
	#if SERVER
		GameMode_AddServerInit( GAMEMODE_GVP, GamemodeGVP_Init )
		GameMode_SetPilotSpawnpointsRatingFunc( GAMEMODE_GVP, RateSpawnpoints_Generic )
		GameMode_SetTitanSpawnpointsRatingFunc( GAMEMODE_GVP, RateSpawnpoints_Generic )
	#endif
	#if !UI
		GameMode_SetScoreCompareFunc( GAMEMODE_GVP, CompareAssaultScore )
	#endif
}

void function GVPRegisterNetworkVars()
{
	if ( GAMETYPE != GAMEMODE_GVP )
		return

	Remote_RegisterFunction( "ServerCallback_YouArePilot" )
	Remote_RegisterFunction( "ServerCallback_AnnouncePilot" )
}