global function ServerCallback_YouArePilot
global function ServerCallback_AnnouncePilot

void function ServerCallback_YouArePilot()
{
	AnnouncementData a = Announcement_Create( "You are the Pilot" )
	Announcement_SetSubText( a, "Grunts are many, you're alone." )
	Announcement_SetTitleColor( a, <1,0,0> )
	Announcement_SetPurge( a, true )
	Announcement_SetPriority( a, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), a )
}

void function ServerCallback_AnnouncePilot( int pilotHandle )
{
	entity player = GetEntityFromEncodedEHandle( pilotHandle )

	AnnouncementData a = Announcement_Create( Localize( "%s1 is the Pilot.", player.GetPlayerName() ) )
	Announcement_SetSubText( a, "Win from them at all cost" )
	Announcement_SetTitleColor( a, <1,0,0> )
	Announcement_SetPurge( a, true )
	Announcement_SetPriority( a, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), a )
}