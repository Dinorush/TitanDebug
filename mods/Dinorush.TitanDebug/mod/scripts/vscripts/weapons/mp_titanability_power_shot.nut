global function OnWeaponPrimaryAttack_power_shot
global function MpTitanAbilityPowerShot_Init
global function PowerShotCleanup
#if SERVER
global function OnWeaponNpcPrimaryAttack_power_shot
#endif

void function MpTitanAbilityPowerShot_Init()
{
	#if SERVER
	AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_predator_cannon, PowerShot_DamagedEntity )
	RegisterSignal( "PowerShotCleanup" )
	#endif
}

var function OnWeaponPrimaryAttack_power_shot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.ContextAction_IsActive() || ( weaponOwner.IsPlayer() && weaponOwner.PlayerMelee_GetState() != PLAYER_MELEE_STATE_NONE ) )
		return 0

	array<entity> weapons = GetPrimaryWeapons( weaponOwner )
	entity primaryWeapon = weapons[0]
	if ( !IsValid( primaryWeapon ) || primaryWeapon.IsReloading() || weaponOwner.e.ammoSwapPlaying == true )
		return 0

	if ( primaryWeapon.HasMod( "LongRangePowerShot" ) || primaryWeapon.HasMod( "CloseRangePowerShot" ) )
		return 0

	int rounds = primaryWeapon.GetWeaponPrimaryClipCount()
	if ( rounds == 0 )
		return 0
	//	primaryWeapon.SetWeaponPrimaryClipCount( 1 )

	int milestone = primaryWeapon.GetReloadMilestoneIndex()
	if ( milestone != 0 )
		return 0

	if ( weaponOwner.IsPlayer() )
	{
		weaponOwner.SetTitanDisembarkEnabled( false )
		primaryWeapon.SetForcedADS()
		weaponOwner.SetMeleeDisabled()
		PlayerUsedOffhand( weaponOwner, weapon )
		#if SERVER
		if ( TitanDebug_GetSetting( "titan_debug_power_shot_unlock_disembark" ) )
			thread TitanDebug_ClearPowerShotLimits( weaponOwner, weapon )
		else
			thread MonitorEjectStatus( weaponOwner )
		#endif
	}

	if ( primaryWeapon.HasMod( "LongRangeAmmo" ) )
	{
		array<string> mods = primaryWeapon.GetMods()
		mods.fastremovebyvalue( "LongRangeAmmo" )
		mods.append( "LongRangePowerShot" )
		if ( mods.contains( "fd_longrange_helper" ) )
			mods.append( "fd_LongRangePowerShot" )
		if ( weapon.HasMod( "pas_legion_chargeshot" ) )
			mods.append( "pas_LongRangePowerShot" )
		primaryWeapon.SetMods( mods )
	}
	else
	{
		array<string> mods = primaryWeapon.GetMods()
		mods.append( "CloseRangePowerShot" )
		if ( mods.contains( "fd_closerange_helper" ) )
			mods.append( "fd_CloseRangePowerShot" )
		if ( weapon.HasMod( "pas_legion_chargeshot" ) )
			mods.append( "pas_CloseRangePowerShot" )
		primaryWeapon.SetMods( mods )
	}

	#if SERVER
	// This setting breaks shotgun blast pellets only hitting once per target. Fix in damage callback.
	if ( TitanDebug_GetSetting( "titan_debug_vortex_no_catch_friendly" ) )
	{
		table weaponDotS = expect table( weapon.s )
		if ( "powerShotTargets" in weapon.s )
		{
			array powerShotTargets = expect array( weaponDotS.powerShotTargets )
			powerShotTargets.clear()
		}
		else
			weaponDotS.powerShotTargets <- []
	}
	#endif

	return weapon.GetAmmoPerShot()
}

#if SERVER
void function TitanDebug_ClearPowerShotLimits( entity weaponOwner, entity weapon )
{
    OnThreadEnd(
    function() : ( weaponOwner, weapon )
        {
            if ( IsValid( weaponOwner ) )
            {
				if ( !IsValid( weapon ) || !weapon.e.gunShieldActive )
            		weaponOwner.ClearMeleeDisabled()
                weaponOwner.SetTitanDisembarkEnabled( true )
            }
        }
    )
	weaponOwner.EndSignal( "PowerShotCleanup" )
    weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.WaitSignal( "TitanEjectionStarted" )
}

void function MonitorEjectStatus( entity weaponOwner )
{
	weaponOwner.EndSignal( "PowerShotCleanup" )

	weaponOwner.WaitSignal( "TitanEjectionStarted" )

	if ( IsValid( weaponOwner ) )
	{
		weaponOwner.ClearMeleeDisabled()
		weaponOwner.SetTitanDisembarkEnabled( true )
	}
}
#endif

void function PowerShotCleanup( entity owner, entity weapon, array<string> modNames, array<string> modsToAdd )
{
	if ( IsValid( owner ) && owner.IsPlayer() )
	{
		#if SERVER
		owner.ClearMeleeDisabled()
		owner.SetTitanDisembarkEnabled( true )
		owner.Signal( "PowerShotCleanup")
		#endif
	}
	if ( IsValid( weapon ) )
	{
		if ( !weapon.e.gunShieldActive && !weapon.HasMod( "SiegeMode" ) )
		{
			while( weapon.GetForcedADS() )
				weapon.ClearForcedADS()
		}

		#if SERVER
		array<string> mods = weapon.GetMods()
		foreach( modName in modNames )
			mods.fastremovebyvalue( modName )
		foreach( mod in modsToAdd )
			mods.append( mod )
		weapon.SetMods( mods )
		#endif
	}
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_power_shot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_power_shot( weapon, attackParams )
}

void function RemoveCloseRangeMod( entity weapon, entity weaponOwner )
{
	if ( !weapon.HasMod( "CloseRangeShot" ) )
		return
	array<string> mods = weapon.GetMods()
	mods.fastremovebyvalue( "CloseRangeShot" )
	weapon.SetMods( mods )
}

void function GiveCloseRangeMod( entity weapon, entity weaponOwner )
{
	if ( weapon.HasMod( "CloseRangeShot" ) )
		return

	array<string> mods = weapon.GetMods()
	mods.append( "CloseRangeShot" )
	weapon.SetMods( mods )
}

void function PowerShot_DamagedEntity( entity victim, var damageInfo )
{
	int scriptDamageType = DamageInfo_GetCustomDamageType( damageInfo )
	if ( scriptDamageType & DF_KNOCK_BACK && !IsHumanSized( victim ) )
	{
		entity attacker = DamageInfo_GetAttacker( damageInfo )

		if ( TitanDebug_GetSetting( "titan_debug_vortex_no_catch_friendly" ) )
			TitanDebug_FixVortexShotgunBlast( attacker, victim, damageInfo )

		float distance = Distance( victim.GetOrigin(), attacker.GetOrigin() )
		vector pushback = Normalize( victim.GetOrigin() - attacker.GetOrigin() )
		pushback *= 500 * 1.0 - StatusEffect_Get( victim, eStatusEffect.pushback_dampen ) * GraphCapped( distance, 0, 1200, 1.0, 0.25 )
		PushPlayerAway( victim, pushback )
	}
}

// If Shotgun Blast hits a Vortex entity that does not absorb the bullets, pellets will stack damage on targets behind it.
// The damageInfo comes in with total damage, not separate instances, so we must manually calculate the correct damage.
// One separate instance can occur for the shot that goes to Vortex though, so we have to account for duplicates.
void function TitanDebug_FixVortexShotgunBlast( entity attacker, entity victim, var damageInfo )
{
	entity weapon = DamageInfo_GetWeapon( damageInfo )
	if ( !IsValid( weapon ) || !DamageInfo_GetDamage( damageInfo ) )
		return

	table weaponDotS = expect table( weapon.s )
	if ( !( "powerShotTargets" in weaponDotS ) )
		weaponDotS.powerShotTargets <- []

	array targets = expect array( weaponDotS.powerShotTargets )
	if ( targets.contains( victim ) )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}
	else
		targets.append( victim )

	float singleDamage = CalcWeaponDamage( attacker, victim, weapon, Distance( attacker.EyePosition(), DamageInfo_GetDamagePosition( damageInfo ) ), 0 )
	if ( IsCriticalHit( attacker, victim, DamageInfo_GetHitBox( damageInfo ), DamageInfo_GetDamage( damageInfo ), DamageInfo_GetDamageType( damageInfo ) ) )
		singleDamage *= weapon.GetWeaponSettingFloat( eWeaponVar.critical_hit_damage_scale )
	DamageInfo_SetDamage( damageInfo, min( DamageInfo_GetDamage( damageInfo ), singleDamage ) )
}
#endif