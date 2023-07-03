global function TitanDebug_AddModSettings

void function TitanDebug_AddModSettings()
{
	ModSettings_AddModTitle( "Titan Debug" )
	ModSettings_AddModCategory( "Global" )
	ModSettings_AddEnumSetting( "titan_debug_base", "Base Setting", [ "Off", "On", "Recommended" ] )

	ModSettings_AddModCategory( "General" )
	ModSettings_AddEnumSetting( "titan_debug_doom_skip_fix", "Fix Doom Skip (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_ai_dodge_friendly", "Fix AI dodging friendly AoE (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_melee_single_hit", "Fix melee double hit (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_termination_fix_suite", "Fix termination-related bugs (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_wave_no_spawn_despawn", "Fix wave despawn on spawn (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_wave_no_block_despawn", "Fix wave despawn on shields (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_wave_single_hit", "Fix wave double hit (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_beam_single_hit", "Fix Laser/Siphon double hit (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_particle_projectile_damage", "Fix projectile damage to Particle (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Ion" )
	ModSettings_AddEnumSetting( "titan_debug_ion_embark_energy", "Ion retains energy on embark (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_split_shot_damage", "Fix Split Shot ADS damage bug (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_entangled_aegis_split_shot", "Fix Entangled Aegis split shots (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_vortex_carry_effects", "Vortex keeps projectile effects (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_vortex_railgun_one_charge", "Fix Vortex Railgun base damage (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_vortex_amplifier_projectiles", "Vortex Amp affects projectiles (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_vortex_no_catch_friendly", "Vortex can't catch ally hitscans (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_vortex_tether_damage", "Vortex Tethers are not invincible (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_laser_shot_need_energy", "Laser Shot needs energy to fire (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Legion" )
	ModSettings_AddEnumSetting( "titan_debug_power_shot_unlock_disembark", "Fix Powershot lock disembark (Rec: On)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Monarch" )
	ModSettings_AddEnumSetting( "titan_debug_energy_transfer_hit_detection", "Fix Energy Transfer hit detection (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_rearm_no_instant", "Fix Rearm instant use bug (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_survival_undoom_fix", "Fix health on doom + undoom. (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Northstar" )
	ModSettings_AddEnumSetting( "titan_debug_vtol_hover_no_jamming", "Fix slow Flight Core after Hover (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_flight_core_no_railgun", "Fix Flight Core giving Railgun (Rec: On)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Ronin" )
	ModSettings_AddEnumSetting( "titan_debug_phase_force_rodeo_off", "Phase forces enemy pilots off (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Scorch" )
	ModSettings_AddEnumSetting( "titan_debug_thermite_tick_rate", "Fix thermite tick rate (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_canister_half_block", "Canisters only get half blocked (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_canister_single_ignite", "Canisters only ignite once (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_canister_no_expiration_damage", "Fix canister expiration damage (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_canister_no_double_tick", "Fix canister ticking faster (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_flame_core_spread", "Fix Flame Core spread (Rec: On)", [ "Off", "On", "Use Base Setting" ] )

	ModSettings_AddModCategory( "Tone" )
	ModSettings_AddEnumSetting( "titan_debug_salvo_core_no_despawn", "Fix Salvo Core despawning (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_tracker_rockets_fix_notification", "Fix Tracker victim notifications (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_tracker_rockets_disembark_clear_locks", "Tracker locks clear on embark (Rec: Off)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_tracker_rockets_no_orbital", "Tracker Rockets die after miss (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
	ModSettings_AddEnumSetting( "titan_debug_sonar_pulse_fix_melee_lock", "Fix Sonar Pulse cancel cooldown (Rec: On)", [ "Off", "On", "Use Base Setting" ] )
}