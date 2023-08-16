# Titan Debug

**Server Only**

Adds a number of titan bug and exploit fixes via ConVars for server owners to use.

Bug fixes do not include those that are already considered intended game behavior (e.g. Siphon slowing more than it should, Enhanced Payload spawning clusters slower and lasting shorter than it should).

## Using the Mod

All bug fixes are handled by ConVars. There are two types of settings: `titan_debug_base`, and the rest.

`titan_debug_base` is the base for all other settings. It can be set to one of three values:

- 0: Off.
- 1: On.
- 2: Use recommended debug options. (Default)

By default, other settings follow `titan_debug_base`. If set to a specific value, however, they will override `titan_debug_base`. Their values are:

- 0: Off.
- 1: On.
- 2: Follows whatever `titan_debug_base` is set to. (Default)

This system exists to minimize the number of ConVars you need to set if you want a specific debug setup. For instance, to fix only Splitter Rifle's split shot bug and leave everything else normal, you could place
```
+titan_debug_base 0
+titan_debug_split_shot_damage 1
```
into your (server) config or launch args.

ConVar settings are applied at match start, so changes made in-game won't apply until the match is restarted. Details about what bug(s) each ConVar fixes are listed in the `mod.json`.

### Mod Settings

Additionally, for players using a local server (i.e. no dedicated server), the mod settings integration can be used instead. However, the descriptiveness of each setting is rather limited due to the space given.

### Reporting Bugs

If you find any crashes/bugs, you can contact me on the Northstar discord @dinorush.

## Recommended Debug List

These are the debug options enabled with the recommended settings. They focus on eliminating the meaner bugs and exploits that benefit very unhealthy gameplay as well as minor bugs that are annoying and hard to control or unintuitive.

- `titan_debug_doom_skip_fix`: Fixes an infrequent case where Doom state can be skipped, killing the titan instantly.
- `titan_debug_termination_fix_suite`: Tone Prime termination doesn't set mag to 10; Laser Shots don't cost Ion energy during terminations; Ion Prime termination doesn't get a free core if the victim disconnects; Vortex cannot catch rockets from Tone Prime and Northstar Prime terminations.
- `titan_debug_ion_embark_energy`: Preserves Ion's energy between disembarks and embarks instead of giving full energy.
- `titan_debug_split_shot_damage`: Fixes Splitter Rifle firing split shots without the correct damage reduction.
- `titan_debug_entangled_aegis_split_shot`: When Aegis ranks are on, corrects the energy generated by Entangled Energy Splitter Rifle split shots instead of using unsplit values.
- `titan_debug_vortex_tether_damage`: Fixes Tether Traps reflected by Vortex becoming invincible.
- `titan_debug_flight_core_no_railgun`: Fixes activating Flight Cores back-to-back (when using high core gain) not giving the Flight Core rocket weapon.
- `titan_debug_thermite_tick_rate`: Fixes thermite occasionally dealing damage at a lower rate than normal. (Mainly an issue on Northstar servers)
- `titan_debug_canister_half_block`: Limits defensives to only block half of Gas Canisters when ignited so they cannot despawn the entire trap.
- `titan_debug_canister_single_ignite`: Fixes Gas Canisters getting ignited multiple times when lit in certain ways.
- `titan_debug_canister_no_expiration_damage`: Fixes Gas Canister expiration damage ignoring Tempered Plating and dealing more damage than it should.
- `titan_debug_flame_core_spread`: Fixes Flame Core wave becoming narrower if the user looks up or down.
- `titan_debug_tracker_rockets_fix_notification`: Fixes the Tracker Rockets locked notification on victims not disappearing when it should.
- `titan_debug_tracker_rockets_no_orbital`: Limits Tracker Rocket lifetime to 7s to prevent them from flying into the sky and retracking their target.
- `titan_debug_sonar_pulse_fix_melee_lock`: Fixes Sonar Pulse suffering an invisible 15s cooldown if melee canceled.
- `titan_debug_power_shot_unlock_disembark`: Fixes Power Shot preventing the player from disembarking if they died or a round ended mid-charge.
- `titan_debug_energy_transfer_hit_detection`: Adds lag compensation for Energy Transfer hits on friendly titans.

## Changelog

### 1.1.1

- Fixed github link on package
- Changed debugging error message to be clearer

### 1.1

- Added Mod Settings support