#include maps\mp\zm_highrise;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zm_highrise_gamemodes;
#include maps\mp\zm_highrise_sq;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_highrise_fx;
#include maps\mp\zm_highrise_ffotd;
#include maps\mp\zm_highrise_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_highrise_amb;
#include maps\mp\zm_highrise_elevators;
#include maps\mp\zombies\_load;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_highrise_classic;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_weap_slipgun;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zm_highrise_achievement;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_highrise_distance_tracking;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;
#include character\c_highrise_player_farmgirl;
#include character\c_highrise_player_oldman;
#include character\c_highrise_player_engineer;
#include character\c_highrise_player_reporter;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_chugabud;

zclassic_preinit()
{
	setdvar("player_sliding_velocity_cap", 80.0);
	setdvar("player_sliding_wishspeed", 800.0);
	registerclientfield("scriptmover", "clientfield_escape_pod_tell_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_sparks_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_impact_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_light_fx", 5000, 1, "int");
	registerclientfield("actor", "clientfield_whos_who_clone_glow_shader", 5000, 1, "int");
	registerclientfield("toplayer", "clientfield_whos_who_audio", 5000, 1, "int");
	registerclientfield("toplayer", "clientfield_whos_who_filter", 5000, 1, "int");
	level.whos_who_client_setup = 1;
	maps\mp\zm_highrise_sq::sq_highrise_clientfield_init();
	precachemodel("p6_zm_keycard");
	precachemodel("p6_zm_hr_keycard");
	precachemodel("fxanim_zom_highrise_trample_gen_mod");
	level.banking_map = "zm_transit";
	level.weapon_locker_map = "zm_transit";
	level thread maps\mp\zombies\_zm_banking::init();
	survival_init();

	if (!(isdefined(level.banking_update_enabled) && level.banking_update_enabled))
		return;

	weapon_locker = spawnstruct();
	weapon_locker.origin = (2107, 98, 1150);
	weapon_locker.angles = vectorscale((0, 1, 0), 60.0);
	weapon_locker.targetname = "weapons_locker";
	deposit_spot = spawnstruct();
	deposit_spot.origin = (2247, 553, 1326);
	deposit_spot.angles = vectorscale((0, 1, 0), 60.0);
	deposit_spot.script_length = 16;
	deposit_spot.targetname = "bank_deposit";
	withdraw_spot = spawnstruct();
	withdraw_spot.origin = (2280, 611, 1330);
	withdraw_spot.angles = vectorscale((0, 1, 0), 60.0);
	withdraw_spot.script_length = 16;
	withdraw_spot.targetname = "bank_withdraw";
	level thread maps\mp\zombies\_zm_weapon_locker::main();
	weapon_locker thread maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerwatch();
	level thread maps\mp\zombies\_zm_banking::main();
	deposit_spot thread maps\mp\zombies\_zm_banking::bank_deposit_unitrigger();
	withdraw_spot thread maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger();
}

is_magic_box_in_inverted_building()
{
	b_is_in_inverted_building = 0;
	a_boxes_in_inverted_building = array("start_chest", "orange_level3_chest");
	str_location = level.chests[level.chest_index].script_noteworthy;
	assert(isdefined(str_location), "is_magic_box_in_inverted_building() can't find magic box location");

	for (i = 0; i < a_boxes_in_inverted_building.size; i++)
	{
		if (a_boxes_in_inverted_building[i] == str_location)
			b_is_in_inverted_building = 1;
	}

	return b_is_in_inverted_building;
}