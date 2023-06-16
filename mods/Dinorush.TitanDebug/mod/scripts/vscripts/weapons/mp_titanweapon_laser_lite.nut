global function MpTitanWeaponLaserLite_Init

global function OnWeaponAttemptOffhandSwitch_titanweapon_laser_lite
global function OnWeaponPrimaryAttack_titanweapon_laser_lite

#if SERVER
global function OnWeaponNPCPrimaryAttack_titanweapon_laser_lite
#endif

void function MpTitanWeaponLaserLite_Init()
{
	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_laser_lite, LaserLite_DamagedTarget )
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_laser_lite( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	int curCost = weapon.GetWeaponCurrentEnergyCost()
	bool canUse = owner.CanUseSharedEnergy( curCost )

	#if CLIENT
		if ( !canUse )
			FlashEnergyNeeded_Bar( curCost )
	#endif
	return canUse
}

var function OnWeaponPrimaryAttack_titanweapon_laser_lite( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if SERVER
	if ( TitanDebug_GetSetting( "titan_debug_laser_shot_need_energy" ) && !weaponOwner.ContextAction_IsBusy() && !OnWeaponAttemptOffhandSwitch_titanweapon_laser_lite( weapon ) )
        return 0

	table weaponDotS = expect table( weapon.s )
	weaponDotS.entitiesHit <- []
	#endif

	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif

	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 1, DF_GIB | DF_EXPLOSION )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	weapon.SetWeaponChargeFractionForced(1.0)
	return 1
}
#if SERVER
var function OnWeaponNPCPrimaryAttack_titanweapon_laser_lite( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanweapon_laser_lite( weapon, attackParams )
}

void function LaserLite_DamagedTarget( entity target, var damageInfo )
{
	entity weapon = DamageInfo_GetWeapon( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( attacker == target )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}

	if ( TitanDebug_GetSetting( "titan_debug_beam_single_hit" ) )
	{
		if ( !IsValid( weapon ) )
			weapon = DamageInfo_GetInflictor( damageInfo )

		if ( !IsValid( weapon ) )
			return

		if ( "entitiesHit" in weapon.s )
		{
			table weaponDotS = expect table( weapon.s )
			array entitiesHit = expect array( weaponDotS.entitiesHit )
			if ( !entitiesHit.contains( target ) )
				entitiesHit.append( target )
			else
			{
				DamageInfo_SetDamage( damageInfo, 0 )
				return
			}
		}
	}
}

#endif