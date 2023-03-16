#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\zombies\_zm_equip_springpad;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

precache()
{
	precachemodel( "collision_wall_128x128x10_standard" );
	precachemodel( "collision_wall_256x256x10_standard" );
	precachemodel( "collision_wall_512x512x10_standard" );
	precachemodel( "zm_collision_buried_street_grief" );
	precachemodel( "p6_zm_bu_buildable_bench_tarp" );

	trig = spawn( "script_model", (1288, 1485, 59) );
	trig.angles = (0, 0, 0);
	trig.script_angles = (0, 70, 0);
	trig.targetname = "headchopper_buildable_trigger";
	trig.target = "buildable_headchopper";

	ent = spawn( "script_model", (1271.89, 1495.38, 77.78) );
	ent.angles = (61.5365, 340.343, 0.216167);
	ent.targetname = "buildable_headchopper";
	ent.target = "headchopper_bench";
	ent setmodel( "t6_wpn_zmb_chopper" );

	level.chalk_buildable_pieces_hide = 1;
	griefbuildables = array( "chalk", "turbine", "springpad_zm", "subwoofer_zm", "headchopper_zm" );
	maps\mp\zm_buried_buildables::include_buildables( griefbuildables );
	maps\mp\zm_buried_buildables::init_buildables( griefbuildables );
	maps\mp\zombies\_zm_equip_turbine::init();
	maps\mp\zombies\_zm_equip_turbine::init_animtree();
	maps\mp\zombies\_zm_equip_springpad::init( &"ZM_BURIED_EQ_SP_PHS", &"ZM_BURIED_EQ_SP_HTS" );
	maps\mp\zombies\_zm_equip_subwoofer::init( &"ZM_BURIED_EQ_SW_PHS", &"ZM_BURIED_EQ_SW_HTS" );
    maps\mp\zombies\_zm_equip_headchopper::init( &"ZM_BURIED_EQ_HC_PHS", &"ZM_BURIED_EQ_HC_HTS" );
}

street_treasure_chest_init()
{
	start_chest = getstruct( "start_chest", "script_noteworthy" );
	court_chest = getstruct( "courtroom_chest1", "script_noteworthy" );
	jail_chest = getstruct( "jail_chest1", "script_noteworthy" );
	gun_chest = getstruct( "gunshop_chest", "script_noteworthy" );
	setdvar( "disableLookAtEntityLogic", 1 );
	level.chests = [];
	level.chests[ level.chests.size ] = start_chest;
	level.chests[ level.chests.size ] = court_chest;
	level.chests[ level.chests.size ] = jail_chest;
	level.chests[ level.chests.size ] = gun_chest;

	chest_names = array("start_chest", "courtroom_chest1", "jail_chest1", "gunshop_chest");
	chest_name = random(chest_names);
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( chest_name );
}

main()
{
	level.buildables_built[ "pap" ] = 1;
	level.equipment_team_pick_up = 1;
	level.zones["zone_mansion"].is_enabled = 0;
	level thread maps\mp\zombies\_zm_buildables::think_buildables();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects( "street" );
	street_treasure_chest_init();
	deleteslothbarricades();

	disable_tunnels();

	powerswitchstate( 1 );
	level.enemy_location_override_func = ::enemy_location_override;
	spawnmapcollision( "zm_collision_buried_street_grief" );
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	builddynamicwallbuys();
	buildbuildables();
	turnperkon( "revive" );
	turnperkon( "doubletap" );
	turnperkon( "marathon" );
	turnperkon( "juggernog" );
	turnperkon( "sleight" );
	turnperkon( "additionalprimaryweapon" );
	turnperkon( "Pack_A_Punch" );
}

enemy_location_override( zombie, enemy )
{
	location = enemy.origin;
	if ( isDefined( self.reroute ) && self.reroute )
	{
		if ( isDefined( self.reroute_origin ) )
		{
			location = self.reroute_origin;
		}
	}
	return location;
}

builddynamicwallbuys()
{
	builddynamicwallbuy( "morgue", "pdw57_zm" );
	builddynamicwallbuy( "church", "svu_zm" );
	builddynamicwallbuy( "mansion", "an94_zm" );

    level notify("dynamicwallbuysbuilt");
}

builddynamicwallbuy( location, weaponname )
{
	foreach ( stub in level.chalk_builds )
	{
		wallbuy = getstruct( stub.target, "targetname" );

		if ( isDefined( wallbuy.script_location ) && wallbuy.script_location == location )
		{
			spawned_wallbuy = undefined;
			for ( i = 0; i < level._spawned_wallbuys.size; i++ )
			{
				if ( level._spawned_wallbuys[ i ].target == wallbuy.targetname )
				{
					spawned_wallbuy = level._spawned_wallbuys[ i ];
					break;
				}
			}

			if ( !isDefined( spawned_wallbuy ) )
			{
				origin = wallbuy.origin;

				// center wallbuy chalk and model, and adjust wallbuy trigger
				if(weaponname == "pdw57_zm")
				{
					origin += anglesToForward(wallbuy.angles) * 12;
					wallbuy.origin += anglesToForward(wallbuy.angles) * 3;
				}
				else if(weaponname == "svu_zm")
				{
					origin += anglesToForward(wallbuy.angles) * 24;
					wallbuy.origin += anglesToForward(wallbuy.angles) * 15;
				}

				struct = spawnStruct();
				struct.target = wallbuy.targetname;
				level._spawned_wallbuys[level._spawned_wallbuys.size] = struct;

				// move model foreward so it always shows in front of chalk
				model = spawn_weapon_model( weaponname, undefined, origin + anglesToRight(wallbuy.angles) * -0.25, wallbuy.angles );
				model.targetname = struct.target;
				model setmodel( getWeaponModel(weaponname) );
				model useweaponhidetags( weaponname );
				model hide();

				chalk_fx = weaponname + "_fx";
				thread scripts\zm\replaced\utility::playchalkfx( chalk_fx, origin, wallbuy.angles );
			}

			maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy( weaponname, wallbuy.targetname, 1 );
			thread wait_and_remove( stub, stub.buildablezone.pieces[ 0 ] );
		}
	}
}

buildbuildables()
{
	buildbuildable( "headchopper_zm" );
	buildbuildable( "springpad_zm" );
	buildbuildable( "subwoofer_zm" );
	buildbuildable( "turbine" );
}

disable_tunnels()
{
	// stables tunnel entrance
	origin = (-1502, -262, 26);
	angles = ( 0, 90, 5 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin + (0, 60, 0) );
	model.angles = angles;
	model setmodel( "p6_zm_bu_wood_door_bare" );
	model = spawn( "script_model", origin + (0, -60, 0) );
	model.angles = angles;
	model setmodel( "p6_zm_bu_wood_door_bare_right" );

	// stables tunnel exit
	origin = (-22, -1912, 269);
	angles = ( 0, -90, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// saloon tunnel entrance
	origin = (488, -1778, 188);
	angles = ( 0, 0, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// saloon tunnel exit
	origin = (120, -1984, 228);
	angles = ( 0, 45, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel saloon side
	origin = (770, -863, 320);
	angles = ( 0, 180, -35 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel courthouse side
	origin = (349, 579, 240);
	angles = ( 0, 0, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel above general store
	origin = (-123, -801, 326);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );

	// main tunnel above jail
	origin = (-852, 408, 379);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_512x512x10_standard" );

	// main tunnel above stables
	origin = (-713, -313, 287);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );

	// gunsmith debris
	debris_trigs = getentarray( "zombie_debris", "targetname" );
	foreach ( debris_trig in debris_trigs )
	{
		if ( debris_trig.target == "pf728_auto2534" )
		{
			debris_trig delete();
		}
	}

	// zombie spawns
	level.zones["zone_tunnel_gun2saloon"].is_enabled = 0;
	level.zones["zone_tunnel_gun2saloon"].is_spawning_allowed = 0;
	level.zones["zone_tunnel_gun2stables"].is_enabled = 0;
	level.zones["zone_tunnel_gun2stables"].is_spawning_allowed = 0;
	level.zones["zone_tunnel_gun2stables2"].is_enabled = 0;
	level.zones["zone_tunnel_gun2stables2"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_center"].is_enabled = 0;
	level.zones["zone_tunnels_center"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_north"].is_enabled = 0;
	level.zones["zone_tunnels_north"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_north2"].is_enabled = 0;
	level.zones["zone_tunnels_north2"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south"].is_enabled = 0;
	level.zones["zone_tunnels_south"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south2"].is_enabled = 0;
	level.zones["zone_tunnels_south2"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south3"].is_enabled = 0;
	level.zones["zone_tunnels_south3"].is_spawning_allowed = 0;

	foreach ( spawn_location in level.zones["zone_stables"].spawn_locations )
	{
		if ( spawn_location.origin == ( -1551, -611, 36.69 ) )
		{
			spawn_location.is_enabled = false;
		}
	}

	// player spawns
	invalid_zones = array("zone_start", "zone_tunnels_center", "zone_tunnels_north", "zone_tunnels_south");
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	foreach(spawn_point in spawn_points)
	{
		if(isinarray(invalid_zones, spawn_point.script_noteworthy))
		{
			spawn_point.locked = 1;
		}
	}
}