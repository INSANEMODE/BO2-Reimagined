#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

makegrenadedudanddestroy()
{
	self endon( "death" );

	self notify( "grenade_dud" );
	self makegrenadedud();

	if ( isDefined( self ) )
	{
		self delete();
	}
}