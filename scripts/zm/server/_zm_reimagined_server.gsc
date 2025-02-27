#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	precache_shaders();
	set_dvars();

	level thread on_player_connect();
	level thread server_message_watcher();
	level thread intermission_message();

	level thread random_map_rotation();
	level thread map_vote();

	level thread server_restart();

	if (is_gametype_active("zgrief"))
	{
		level thread connect_timeout_changes();
		level thread afk_kick_watcher();
	}
}

precache_shaders()
{
	precacheshader("menu_zm_popup");
	precacheshader("menu_zm_transit_zclassic_transit");
	precacheshader("menu_zm_highrise_zclassic_rooftop");
	precacheshader("menu_zm_prison_zclassic_prison");
	precacheshader("menu_zm_buried_zclassic_processing");
	precacheshader("menu_zm_tomb_zclassic_tomb");
	precacheshader("menu_zm_transit_zsurvival_transit");
	precacheshader("menu_zm_transit_zsurvival_farm");
	precacheshader("menu_zm_transit_zsurvival_town");
	precacheshader("menu_zm_nuked_zsurvival_nuked");
	precacheshader("menu_zm_transit_zencounter_diner");
	precacheshader("menu_zm_prison_zencounter_cellblock");
	precacheshader("menu_zm_buried_zencounter_street");
	precacheshader("menu_zm_map_transit_blit_power");
}

set_dvars()
{
	if (getDvar("changelog_link") == "")
	{
		setDvar("changelog_link", "github.com/Jbleezy/BO2-Reimagined");
	}

	if (getDvar("discord_link") == "")
	{
		setDvar("discord_link", "dsc.gg/Jbleezy");
	}

	if (getDvar("donate_link") == "")
	{
		setDvar("donate_link", "ko-fi.com/Jbleezy");
	}

	setDvar("sv_sayName", "");
}

on_player_connect()
{
	while (1)
	{
		level waittill("connected", player);

		player thread wait_and_show_connect_message();
	}
}

wait_and_show_connect_message()
{
	self endon("disconnect");

	flag_wait("initial_players_connected");

	server_message("changelog", self, 1);
}

server_message_watcher()
{
	while (1)
	{
		level waittill("say", message, player, hidden);

		if (!hidden)
		{
			continue;
		}

		server_message(toLower(message), player);
	}
}

server_message(message_str, player, tell = 0)
{
	message_array = strTok(message_str, " ");
	message = message_array[0];

	text = "";

	if (message == "changelog")
	{
		text = "Changelog: " + getDvar("changelog_link");
	}
	else if (message == "discord")
	{
		text = "Discord: " + getDvar("discord_link");
	}
	else if (message == "donate")
	{
		text = "Donate: " + getDvar("donate_link");
	}
	else if (message == "stat")
	{
		if (isdefined(level.server_stat_message_func))
		{
			[[level.server_stat_message_func]](message_str, player);
		}

		return;
	}
	else
	{
		return;
	}

	if (isDefined(player) && tell)
	{
		player tell(text);
	}
	else
	{
		say(text);
	}
}

intermission_message()
{
	level waittill("intermission");

	server_message("discord");
	server_message("donate");
}

random_map_rotation()
{
	initial_map = 0;

	if (getDvar("sv_mapRotationRandom") == "")
	{
		initial_map = 1;
		setDvar("sv_mapRotationRandom", 1);
	}

	if (!initial_map && getDvar("sv_mapRotationCurrent") != "")
	{
		return;
	}

	string = getDvar("sv_mapRotation");
	array = rotation_string_to_array(string);

	if (array.size < 2)
	{
		return;
	}

	// randomize maps
	array = array_randomize(array);

	// make sure current map isn't first
	// except for initially since map hasn't been played
	if (!initial_map)
	{
		location = get_location_from_rotation(array[0]);
		map = get_map_from_rotation(array[0]);

		if (level.scr_zm_map_start_location == location && level.script == map)
		{
			num = randomIntRange(1, array.size);
			array = array_swap(array, 0, num);
		}
	}

	string = rotation_array_to_string(array);

	setDvar("sv_mapRotation", string);
	setDvar("sv_mapRotationCurrent", string);

	// make initial map random
	if (initial_map)
	{
		exitLevel(0);
	}
}

map_vote()
{
	level waittill("intermission");

	level.zombie_vars["map_vote_active"] = 0;
	array = array_randomize(rotation_string_to_array(getDvar("sv_mapRotation")));

	if (array.size >= 3)
	{
		level.zombie_vars["map_vote_active"] = 1;
	}

	level.zombie_vars["obj_vote_active"] = 0;
	obj_array = [];

	if (is_gametype_active("zgrief"))
	{
		obj_array = array_randomize(strTok(getDvar("ui_gametype_obj"), " "));

		if (obj_array.size >= 3)
		{
			level.zombie_vars["obj_vote_active"] = 1;
			arrayRemoveValue(obj_array, level.scr_zm_ui_gametype_obj);
		}
	}

	if (!level.zombie_vars["map_vote_active"] && !level.zombie_vars["obj_vote_active"])
	{
		return;
	}

	time = level.zombie_vars["zombie_intermission_time"];

	maps = [];
	exclude = [];

	for (i = 0; i < 3; i++)
	{
		maps[i] = [];
	}

	gametype = getSubStr(level.scr_zm_ui_gametype, 1, level.scr_zm_ui_gametype.size);

	maps[1]["rotation_string"] = "exec zm_" + gametype + "_" + level.scr_zm_map_start_location + ".cfg map " + level.script;
	maps[1]["map_name"] = level.script;
	maps[1]["loc_name"] = level.scr_zm_map_start_location;
	maps[1]["gametype_name"] = level.scr_zm_ui_gametype;

	if (level.zombie_vars["obj_vote_active"])
	{
		maps[1]["obj_name"] = level.scr_zm_ui_gametype_obj;
	}

	exclude[exclude.size] = maps[1]["loc_name"];

	rotation = undefined;

	foreach (rotation in array)
	{
		if (!isInArray(exclude, get_location_from_rotation(rotation)))
		{
			break;
		}
	}

	maps[0]["rotation_string"] = rotation;
	maps[0]["map_name"] = get_map_from_rotation(rotation);
	maps[0]["loc_name"] = get_location_from_rotation(rotation);
	maps[0]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (level.zombie_vars["obj_vote_active"])
	{
		maps[0]["obj_name"] = obj_array[0];
	}

	exclude[exclude.size] = maps[0]["loc_name"];

	rotation = undefined;

	foreach (rotation in array)
	{
		if (!isInArray(exclude, get_location_from_rotation(rotation)))
		{
			break;
		}
	}

	maps[2]["rotation_string"] = rotation;
	maps[2]["map_name"] = get_map_from_rotation(rotation);
	maps[2]["loc_name"] = get_location_from_rotation(rotation);
	maps[2]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (level.zombie_vars["obj_vote_active"])
	{
		maps[2]["obj_name"] = obj_array[1];
	}

	y = -102.5;

	level.zombie_vars["vote_timer_hud"] = create_map_vote_timer_hud(0, y, time);

	y += 12.5;

	level.zombie_vars["vote_input_hud"] = create_map_vote_input_hud(0, y);

	y = 70;

	if (is_gametype_active("zgrief"))
	{
		y = 150;
	}

	og_y = y;

	level.zombie_vars["map_image_hud"] = [];
	level.zombie_vars["map_image_hud"][0] = create_map_image_hud(get_image_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y);
	level.zombie_vars["map_image_hud"][1] = create_map_image_hud(get_image_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y);
	level.zombie_vars["map_image_hud"][2] = create_map_image_hud(get_image_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y);

	level.zombie_vars["map_name_hud"] = [];
	level.zombie_vars["map_name_hud"][0] = create_map_name_hud(get_name_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y);
	level.zombie_vars["map_name_hud"][1] = create_map_name_hud(get_name_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y);
	level.zombie_vars["map_name_hud"][2] = create_map_name_hud(get_name_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y);

	y += 20;

	level.zombie_vars["map_vote_count_hud"] = [];
	level.zombie_vars["map_vote_count_hud"][0] = create_map_vote_count_hud(-200, y);
	level.zombie_vars["map_vote_count_hud"][1] = create_map_vote_count_hud(0, y);
	level.zombie_vars["map_vote_count_hud"][2] = create_map_vote_count_hud(200, y);

	level.zombie_vars["map_votes"] = [];
	level.zombie_vars["map_votes"][0] = 0;
	level.zombie_vars["map_votes"][1] = 0;
	level.zombie_vars["map_votes"][2] = 0;

	level.zombie_vars["obj_name_hud"] = [];
	level.zombie_vars["obj_vote_count_hud"] = [];
	level.zombie_vars["obj_votes"] = [];

	if (level.zombie_vars["obj_vote_active"])
	{
		y = 207;

		level.zombie_vars["obj_name_hud"][0] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[0]["obj_name"]), -200, y);
		level.zombie_vars["obj_name_hud"][1] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[1]["obj_name"]), 0, y);
		level.zombie_vars["obj_name_hud"][2] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[2]["obj_name"]), 200, y);

		y += 20;

		level.zombie_vars["obj_vote_count_hud"][0] = create_map_vote_count_hud(-200, y);
		level.zombie_vars["obj_vote_count_hud"][1] = create_map_vote_count_hud(0, y);
		level.zombie_vars["obj_vote_count_hud"][2] = create_map_vote_count_hud(200, y);

		level.zombie_vars["obj_votes"][0] = 0;
		level.zombie_vars["obj_votes"][1] = 0;
		level.zombie_vars["obj_votes"][2] = 0;
	}

	array_thread(get_players(), ::player_choose_map, og_y);

	wait time;

	level notify("stop_vote");

	players = get_players();

	index = get_map_winner();

	for (i = 0; i < 3; i++)
	{
		if (i != index)
		{
			level.zombie_vars["map_image_hud"][i].alpha = 0;
			level.zombie_vars["map_name_hud"][i].alpha = 0;
			level.zombie_vars["map_vote_count_hud"][i].alpha = 0;
		}
	}

	if (index != 1)
	{
		level.zombie_vars["map_image_hud"][index] moveOverTime(0.5);
		level.zombie_vars["map_name_hud"][index] moveOverTime(0.5);
		level.zombie_vars["map_vote_count_hud"][index] moveOverTime(0.5);

		level.zombie_vars["map_image_hud"][index].x = 0;
		level.zombie_vars["map_name_hud"][index].x = 0;
		level.zombie_vars["map_vote_count_hud"][index].x = 0;
	}

	foreach (player in players)
	{
		if (!isdefined(player.map_select))
		{
			continue;
		}

		for (i = 0; i < 3; i++)
		{
			if (i != index)
			{
				player.map_select.hud[i].alpha = 0;
			}
			else
			{
				player.map_select.hud[i].color = (1, 1, 1);
			}
		}

		if (index != 1)
		{
			player.map_select.hud[index] moveOverTime(0.5);
			player.map_select.hud[index].x = 0;
		}
	}

	setDvar("sv_mapRotationCurrent", maps[index]["rotation_string"]);

	if (level.zombie_vars["obj_vote_active"])
	{
		index = get_obj_winner();

		for (i = 0; i < 3; i++)
		{
			if (i != index)
			{
				level.zombie_vars["obj_name_hud"][i].alpha = 0;
				level.zombie_vars["obj_vote_count_hud"][i].alpha = 0;
			}
		}

		if (index != 1)
		{
			level.zombie_vars["obj_name_hud"][index] moveOverTime(0.5);
			level.zombie_vars["obj_vote_count_hud"][index] moveOverTime(0.5);

			level.zombie_vars["obj_name_hud"][index].x = 0;
			level.zombie_vars["obj_vote_count_hud"][index].x = 0;
		}

		foreach (player in players)
		{
			if (!isdefined(player.obj_select))
			{
				continue;
			}

			for (i = 0; i < 3; i++)
			{
				if (i != index)
				{
					player.obj_select.hud[i].alpha = 0;
				}
				else
				{
					player.obj_select.hud[i].color = (1, 1, 1);
				}
			}

			if (index != 1)
			{
				player.obj_select.hud[index] moveOverTime(0.5);
				player.obj_select.hud[index].x = 0;
			}
		}

		setDvar("ui_gametype_obj_cur", maps[index]["obj_name"]);

		level thread wait_and_setclientdvarall(1.5, "ui_gametype_obj", getDvar("ui_gametype_obj_cur"));
	}

	level.zombie_vars["vote_input_hud"].alpha = 0;
	level.zombie_vars["vote_timer_hud"].alpha = 0;
}

wait_and_setclientdvarall(time, dvar, value)
{
	wait time;

	scripts\zm\_zm_reimagined::setclientdvarall(dvar, value);
}

create_map_image_hud(image, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = -1;
	hud.foreground = 1;
	hud.alpha = 1;
	hud setShader(image, 180, 95);

	return hud;
}

create_map_name_hud(name, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.8;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = 1;
	hud.foreground = 1;
	hud.alpha = 1;
	hud setText(name);

	return hud;
}

create_map_gametype_hud(name, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = 1;
	hud.foreground = 1;
	hud.alpha = 1;
	hud setText(name);

	return hud;
}

create_map_vote_count_hud(x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = 1;
	hud.foreground = 1;
	hud.alpha = 1;
	hud setValue(0);

	return hud;
}

create_map_vote_input_hud(x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.foreground = 1;
	hud.alpha = 1;
	hud setText(&"ZOMBIE_VOTE_HOWTO");

	return hud;
}

create_map_vote_timer_hud(x, y, time)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.foreground = 1;
	hud.alpha = 1;
	hud.label = &"ZOMBIE_HUD_VOTE_TIME";
	hud setTimer(time);

	return hud;
}

create_map_select_hud(x, y)
{
	hud = newClientHudElem(self);
	hud.x = x;
	hud.y = y + 2.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.foreground = 1;
	hud.alpha = 1;
	hud setShader("menu_zm_popup", 180, 95);

	return hud;
}

create_obj_select_hud(x, y)
{
	hud = newClientHudElem(self);
	hud.x = x;
	hud.y = y + 2.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.foreground = 1;
	hud.alpha = 1;
	hud setShader("menu_zm_popup", 180, 40);

	return hud;
}

player_choose_map(y)
{
	self endon("disconnect");

	self.map_select = spawnStruct();
	self.map_select.ind = 1;
	self.map_select.selected = 0;
	self.map_select.name = "map";
	self.map_select.hud = [];
	self.map_select.hud[0] = self create_map_select_hud(-200, y);
	self.map_select.hud[1] = self create_map_select_hud(0, y);
	self.map_select.hud[2] = self create_map_select_hud(200, y);
	self.map_select.hud[self.map_select.ind].color = (1, 1, 0);

	if (level.zombie_vars["obj_vote_active"])
	{
		self.obj_select = spawnStruct();
		self.obj_select.ind = 1;
		self.obj_select.selected = 0;
		self.obj_select.name = "obj";
		self.obj_select.hud = [];
		self.obj_select.hud[0] = self create_obj_select_hud(-200, y + 65);
		self.obj_select.hud[1] = self create_obj_select_hud(0, y + 65);
		self.obj_select.hud[2] = self create_obj_select_hud(200, y + 65);
	}

	self notifyonplayercommand("left", "+speed_throw");
	self notifyonplayercommand("left", "+moveleft");
	self notifyonplayercommand("right", "+attack");
	self notifyonplayercommand("right", "+moveright");
	self notifyonplayercommand("select", "+usereload");
	self notifyonplayercommand("select", "+activate");
	self notifyonplayercommand("select", "+gostand");

	self thread left_watcher();
	self thread right_watcher();
	self thread select_watcher();

	level waittill("stop_vote");

	self.map_select.hud destroy();

	if (isdefined(self.obj_select))
	{
		self.obj_select.hud destroy();
	}
}

left_watcher()
{
	level endon("stop_vote");
	self endon("disconnect");

	while (1)
	{
		self waittill("left");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		prev_ind = select.ind;

		select.ind--;

		if (select.ind < 0)
		{
			select.ind = 2;
		}

		select.hud[prev_ind].color = (1, 1, 1);
		select.hud[select.ind].color = (1, 1, 0);
	}
}

right_watcher()
{
	level endon("stop_vote");
	self endon("disconnect");

	while (1)
	{
		self waittill("right");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		prev_ind = select.ind;

		select.ind++;

		if (select.ind > 2)
		{
			select.ind = 0;
		}

		select.hud[prev_ind].color = (1, 1, 1);
		select.hud[select.ind].color = (1, 1, 0);
	}
}

select_watcher()
{
	level endon("stop_vote");
	self endon("disconnect");

	while (1)
	{
		self waittill("select");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		if (!select.selected)
		{
			select.selected = 1;
			select.hud[select.ind].color = (0, 1, 0);

			if (select.name == "map")
			{
				level.zombie_vars["map_votes"][select.ind]++;
				level.zombie_vars["map_vote_count_hud"][select.ind] setValue(level.zombie_vars["map_votes"][select.ind]);

				if (isdefined(self.obj_select))
				{
					self.obj_select.hud[self.obj_select.ind].color = (1, 1, 0);
				}
			}
			else
			{
				level.zombie_vars["obj_votes"][select.ind]++;
				level.zombie_vars["obj_vote_count_hud"][select.ind] setValue(level.zombie_vars["obj_votes"][select.ind]);
			}
		}
	}
}

get_player_select()
{
	if (self.map_select.selected)
	{
		if (isdefined(self.obj_select))
		{
			if (self.obj_select.selected)
			{
				return undefined;
			}

			return self.obj_select;
		}

		return undefined;
	}

	return self.map_select;
}

get_map_winner()
{
	// if no one voted, stay on current map
	if (level.zombie_vars["map_votes"][0] == 0 && level.zombie_vars["map_votes"][1] == 0 && level.zombie_vars["map_votes"][2] == 0)
	{
		return 1;
	}

	winner = array(0);

	for (i = 1; i < 3; i++)
	{
		if (level.zombie_vars["map_votes"][i] == level.zombie_vars["map_votes"][winner[0]])
		{
			winner[winner.size] = i;
		}
		else if (level.zombie_vars["map_votes"][i] > level.zombie_vars["map_votes"][winner[0]])
		{
			winner = array(i);
		}
	}

	return random(winner);
}

get_obj_winner()
{
	// if no one voted, stay on current obj
	if (level.zombie_vars["obj_votes"][0] == 0 && level.zombie_vars["obj_votes"][1] == 0 && level.zombie_vars["obj_votes"][2] == 0)
	{
		return 1;
	}

	winner = array(0);

	for (i = 1; i < 3; i++)
	{
		if (level.zombie_vars["obj_votes"][i] == level.zombie_vars["obj_votes"][winner[0]])
		{
			winner[winner.size] = i;
		}
		else if (level.zombie_vars["obj_votes"][i] > level.zombie_vars["obj_votes"][winner[0]])
		{
			winner = array(i);
		}
	}

	return random(winner);
}

get_name_for_loc(map, location, gametype)
{
	if (location == "transit")
	{
		if (gametype == "zclassic")
		{
			return &"ZMUI_CLASSIC_TRANSIT";
		}
		else
		{
			return &"ZMUI_TRANSIT_STARTLOC";
		}
	}
	else if (location == "farm")
	{
		return &"ZMUI_FARM";
	}
	else if (location == "town")
	{
		return &"ZMUI_TOWN";
	}
	else if (location == "diner")
	{
		return &"ZMUI_DINER";
	}
	else if (location == "power")
	{
		return &"ZMUI_POWER";
	}
	else if (location == "tunnel")
	{
		return &"ZMUI_TUNNEL";
	}
	else if (location == "cornfield")
	{
		return &"ZMUI_CORNFIELD";
	}
	else if (location == "nuked")
	{
		return &"ZMUI_NUKED_STARTLOC";
	}
	else if (location == "rooftop")
	{
		return &"ZMUI_CLASSIC_ROOFTOP";
	}
	else if (location == "prison")
	{
		return &"ZMUI_CLASSIC_PRISON";
	}
	else if (location == "cellblock")
	{
		return &"ZMUI_CELLBLOCK";
	}
	else if (location == "docks")
	{
		return &"ZMUI_DOCKS";
	}
	else if (location == "processing")
	{
		return &"ZMUI_CLASSIC_BURIED";
	}
	else if (location == "street")
	{
		return &"ZMUI_STREET_LOC";
	}
	else if (location == "maze")
	{
		return &"ZMUI_MAZE";
	}
	else if (location == "tomb")
	{
		return &"ZMUI_CLASSIC_TOMB";
	}

	return "";
}

// should always match function GetMapMaterialName from mapinfoimage.lua
get_image_for_loc(map, location, gametype)
{
	gamemode = get_gamemode_for_gametype(gametype);

	if (location == "power")
	{
		return "menu_zm_map_transit_blit_power";
	}

	if (map == "zm_transit" && gamemode != "zclassic")
	{
		gamemode = "zsurvival";
	}

	if (location == "diner")
	{
		gamemode = "zencounter";
	}

	if (location == "tunnel" || location == "cornfield")
	{
		gamemode = "zsurvival";
		location = "transit";
	}

	if (location == "nuked")
	{
		gamemode = "zsurvival";
	}

	if (location == "cellblock" || location == "docks")
	{
		gamemode = "zencounter";
		location = "cellblock";
	}

	if (location == "street" || location == "maze")
	{
		gamemode = "zencounter";
		location = "street";
	}

	return "menu_" + map + "_" + gamemode + "_" + location;
}

get_gamemode_for_gametype(gametype)
{
	gamemode = "zclassic";

	if (gametype == "zstandard")
	{
		gamemode = "zsurvival";
	}

	if (gametype == "zgrief")
	{
		gamemode = "zencounter";
	}

	return gamemode;
}

rotation_string_to_array(string)
{
	array = [];

	tokens = strTok(string, " ");

	for (i = 0; i < tokens.size; i += 4)
	{
		array[array.size] = tokens[i] + " " + tokens[i+1] + " " + tokens[i+2] + " " + tokens[i+3];
	}

	return array;
}

rotation_array_to_string(array)
{
	string = "";

	for (i = 0; i < array.size; i++)
	{
		string += array[i];

		if (i < (array.size - 1))
		{
			string += " ";
		}
	}

	return string;
}

get_gametype_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	location = tokens[1]; // zm_gametype_location.cfg
	location = strTok(location, ".");
	location = location[0]; // zm_gametype_location
	location = strTok(location, "_");
	location = location[1]; // gametype

	return location;
}

get_location_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	location = tokens[1]; // zm_gametype_location.cfg
	location = strTok(location, ".");
	location = location[0]; // zm_gametype_location
	location = strTok(location, "_");
	location = location[2]; // location

	return location;
}

get_map_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	map = tokens[3];

	return map;
}

connect_timeout_changes()
{
	setDvar("sv_connectTimeout", 30);

	flag_wait("initial_players_connected");

	setDvar("sv_connectTimeout", 60);
}

afk_kick_watcher()
{
	level endon("end_game");

	flag_wait("initial_blackscreen_passed");

	time_to_kick = 120000;

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			if (player any_button_pressed() || player is_bot())
			{
				player.afk_time = undefined;
				continue;
			}

			if (player.sessionstate == "spectator")
			{
				if (isDefined(player.afk_time))
				{
					player.afk_time += 50;
					continue;
				}
			}

			if (!isDefined(player.afk_time))
			{
				player.afk_time = getTime();
			}

			if ((getTime() - player.afk_time) >= time_to_kick)
			{
				kick(player getEntityNumber());
			}
		}

		wait 0.05;
	}
}

any_button_pressed()
{
	if (self actionslotonebuttonpressed() || self actionslottwobuttonpressed() || self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed() || self attackbuttonpressed() || self fragbuttonpressed() || self inventorybuttonpressed() || self jumpbuttonpressed() || self meleebuttonpressed() || self secondaryoffhandbuttonpressed() || self sprintbuttonpressed() || self stancebuttonpressed() || self throwbuttonpressed() || self usebuttonpressed() || self changeseatbuttonpressed())
	{
		return 1;
	}

	return 0;
}

server_restart()
{
	no_players_time = 0;

	while (1)
	{
		players = get_players();

		if (players.size < 1)
		{
			no_players_time++;
		}
		else
		{
			no_players_time = 0;
		}

		if (no_players_time >= 3600)
		{
			cmdexec("quit");
		}

		wait 1;
	}
}