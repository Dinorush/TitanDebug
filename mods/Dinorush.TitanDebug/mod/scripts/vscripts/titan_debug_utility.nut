untyped

global function TitanDebug_Init
global function TitanDebug_GetSetting
global function TitanDebug_WaveShouldHit
global function TitanDebug_WaitBuffer

struct {
	table< string, bool > debugSettings = {
		titan_debug_doom_skip_fix = true,
		titan_debug_ai_dodge_friendly = false,
		titan_debug_melee_single_hit = false,
		titan_debug_termination_fix_suite = true,
		titan_debug_wave_no_spawn_despawn = false,
		titan_debug_wave_no_block_despawn = false,
		titan_debug_wave_single_hit = false,
		titan_debug_beam_single_hit = false,
		titan_debug_particle_projectile_damage = false,

		titan_debug_ion_embark_energy = true,
		titan_debug_split_shot_damage = true,
		titan_debug_entangled_aegis_split_shot = true,
		titan_debug_vortex_carry_effects = false,
		titan_debug_vortex_railgun_one_charge = false,
		titan_debug_vortex_amplifier_projectiles = false,
		titan_debug_vortex_no_catch_friendly = false,
		titan_debug_vortex_tether_damage = true,
		titan_debug_laser_shot_need_energy = false,

		titan_debug_vtol_hover_no_jamming = false,
		titan_debug_flight_core_no_railgun = true,

		titan_debug_thermite_tick_rate = true,
		titan_debug_canister_half_block = true,
		titan_debug_canister_single_ignite = true,
		titan_debug_canister_no_expiration_damage = true,
		titan_debug_canister_no_double_tick = false,
		titan_debug_flame_core_spread = true,

		titan_debug_phase_force_rodeo_off = false,

		titan_debug_salvo_core_no_despawn = false,
		titan_debug_tracker_rockets_fix_notification = true,
		titan_debug_tracker_rockets_disembark_clear_locks = false,
		titan_debug_tracker_rockets_no_orbital = true,
		titan_debug_sonar_pulse_fix_melee_lock = true,

		titan_debug_power_shot_unlock_disembark = true,

		titan_debug_energy_transfer_hit_detection = true,
		titan_debug_rearm_no_instant = false,
		titan_debug_survival_undoom_fix = false,
	}

	bool settingsInit = false
} file

void function TitanDebug_Init()
{
	TitanDebug_SettingsInit()

	// The synced melee chooser for titans isn't created unless it's in an actual match
	if ( TitanDebug_GetSetting( "titan_debug_termination_fix_suite" ) )
	{
		try
		{
			AddSyncedMeleeServerCallback( GetSyncedMeleeChooser( "titan", "titan" ), TitanDebug_FixTerminationBugs )
		}
		catch( error )
		{
			print("FAILED TO ADD CALLBACK")
		}
	}

	if ( TitanDebug_GetSetting( "titan_debug_ion_embark_energy" ) )
		AddSoulTransferFunc( TitanDebug_TransferSharedEnergy )

	// Can't do Wave Single Hit fix via callbacks here since we need to stop the other callbacks from running if they shouldn't hit
}

void function TitanDebug_SettingsInit() {
	foreach ( key, _ in file.debugSettings ) {
		int val = GetConVarInt( key )
		if ( val == 2 )
			val = GetConVarInt( "titan_debug_base" )

		if ( val != 2 )
			file.debugSettings[key] = bool( val )
	}

	file.settingsInit = true
}

bool function TitanDebug_GetSetting( string setting ) {
	if ( !file.settingsInit )
		TitanDebug_SettingsInit()

	return file.debugSettings[setting]
}

void function LTSRebalance_AddPassive( string name )
{
	if ( name in ePassives )
		return

	table passives = expect table( getconsttable()["ePassives"] )
	passives[name] <- passives.len() // ePassives starts at 0
}

// Fixes Tone Prime getting ammo set to 10 on termination, Ion Prime getting free laser core if the target disconnects, and Ion spending energy for termination Laser Shots
void function TitanDebug_FixTerminationBugs( SyncedMeleeChooser actions, SyncedMelee action, entity player, entity target ) {
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	target.EndSignal( "OnDestroy" )

	entity weapon = player.GetMainWeapons().len() > 0 ? player.GetMainWeapons()[0] : null
	table startTable = {
		startWeapon = weapon
		startTime = Time()
		startAmmo = ( IsValid( weapon ) ? weapon.GetWeaponPrimaryClipCount() : 0 )
		startEnergy = player.GetSharedEnergyCount()
	}

	OnThreadEnd(
		function() : ( player, startTable )
		{
			if ( IsValid( player ) )
			{
				// Band-aid fix to fix Tone Prime ammo refill bug
				if( IsValid( startTable.startWeapon ) )
				{
					float ammoRegenRate = expect float( startTable.startWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate ) )
					int expectedAmmo = int( startTable.startAmmo + ammoRegenRate * ( Time() - startTable.startTime ) )
					int newAmmo = minint( startTable.startWeapon.GetWeaponPrimaryClipCountMax(), expectedAmmo )
					startTable.startWeapon.SetWeaponPrimaryClipCount( newAmmo )
				}

				// Additional band-aid fix for Ion using energy for Laser Shot in terminations
				float energyRegenRate = player.GetSharedEnergyRegenRate()
				int expectedEnergy = int ( startTable.startEnergy + energyRegenRate * ( Time() - startTable.startTime ) )
				int newEnergy = minint( player.GetSharedEnergyTotal(), expectedEnergy )
				player.TakeSharedEnergy( player.GetSharedEnergyCount() )
				player.AddSharedEnergy( newEnergy )
			}

			if ( player.IsTitan() ) // Fix case where enemy leaves game during Ion prime termination
			{
				entity weapon = player.GetMainWeapons().len() > 0 ? player.GetMainWeapons()[0] : null
				if( IsValid( weapon ) )
					player.SetActiveWeaponByName( weapon.GetWeaponClassName() )
			}
		}
	)

	player.WaitSignal( "SyncedMeleeComplete" )
}

// Fix Ion getting full energy from disembark -> embark
// We need to thread the shared energy transfer since the energy is set after transfer callbacks
void function TitanDebug_TransferSharedEnergy( entity soul, entity destEnt, entity srcEnt )
{
	if ( IsValid( srcEnt ) )
    	thread TransferSharedEnergy_Think( destEnt, srcEnt )
}

void function TransferSharedEnergy_Think( entity destEnt, entity srcEnt )
{
	int energy = srcEnt.GetSharedEnergyCount()
	WaitEndFrame()
	if ( IsValid ( destEnt ) )
	{
		destEnt.TakeSharedEnergy( destEnt.GetSharedEnergyCount() )
    	destEnt.AddSharedEnergy( energy )
	}
}

bool function TitanDebug_WaveShouldHit( entity ent, var damageInfo )
{
	if ( !TitanDebug_GetSetting( "titan_debug_wave_single_hit" ) )
		return true

	entity inflictor = DamageInfo_GetInflictor( damageInfo )
    if( ent.IsTitan() && IsValid ( ent.GetTitanSoul() ) )
    {
		if ( !( "soulsHit" in inflictor.s ) )
			inflictor.s.soulsHit <- []

        entity soul = ent.GetTitanSoul()
        if ( !inflictor.s.soulsHit.contains( soul ) )
            inflictor.s.soulsHit.append( soul )
        else
        {
            DamageInfo_SetDamage( damageInfo, 0 )
            return false
        }
    }

	return true
}

entity function TitanDebug_DamageInfo_GetWeapon( var damageInfo, entity defaultWeapon = null )
{
	entity ent = DamageInfo_GetWeapon( damageInfo )
	
	if ( !IsValid( ent ) )
		ent = DamageInfo_GetInflictor( damageInfo )
	
	if ( !IsValid( ent ) || ent.IsPlayer() || ent.IsNPC() )
		ent = defaultWeapon

	return ent
}

float function TitanDebug_WaitBuffer( float waitTime, float tickBuffer, string settingCheck = "" )
{
	// If setting isn't on, just do normal behavior
	if ( settingCheck.len() > 0 && !TitanDebug_GetSetting( settingCheck ) )
	{
		wait waitTime
		return tickBuffer
	}

	// If the time we wait is 0, simply return immediately without waiting (otherwise it must wait for next tick)
	float timeToWait = waitTime - tickBuffer
	if ( timeToWait <= 0 )
		return tickBuffer - waitTime
	
	float startTime = Time()
	wait timeToWait
	return Time() - startTime - waitTime + tickBuffer
}