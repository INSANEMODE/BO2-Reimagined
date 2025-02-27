#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init_wallbuy_fx()
{
	if (getDvar("mapname") == "zm_buried" || getDvar("mapname") == "zm_prison")
	{
		level._uses_sticky_grenades = 1;
		level.disable_fx_zmb_wall_buy_semtex = 0;
	}

	if (!is_false(level._uses_default_wallbuy_fx))
	{
		level._effect["870mcs_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_870mcs");
		level._effect["vector_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_ak74u");
		level._effect["beretta93r_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_berreta93r");
		level._effect["bowie_knife_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_bowie");
		level._effect["claymore_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_claymore");
		level._effect["saritch_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m14");
		level._effect["sig556_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m16");
		level._effect["insas_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_mp5k");
		level._effect["ballista_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_olympia");
	}

	if (!is_false(level._uses_sticky_grenades))
	{
		if (!is_true(level.disable_fx_zmb_wall_buy_semtex))
		{
			grenade = "sticky_grenade_zm";

			if (getDvar("mapname") == "zm_buried")
			{
				grenade = "frag_grenade_zm";
			}

			level._effect[grenade + "_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_semtex");
		}
	}

	if (!is_false(level._uses_taser_knuckles))
		level._effect["tazer_knuckles_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_taseknuck");

	if (isdefined(level.buildable_wallbuy_weapons))
		level._effect["dynamic_wallbuy_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_question");
}

entityspawned(localclientnum)
{
	if (!isdefined(self.type))
	{
		return;
	}

	if (self.type == "player")
		self thread playerspawned(localclientnum);

	if (self.type == "missile")
	{
		switch (self.weapon)
		{
			case "sticky_grenade_zm":
				self thread clientscripts\mp\_sticky_grenade::spawned(localclientnum);
				break;

			case "titus6_explosive_dart_zm":
			case "titus6_explosive_dart_upgraded_zm":
				self thread scripts\zm\reimagined\_explosive_dart::spawned(localclientnum);
				break;
		}
	}
}