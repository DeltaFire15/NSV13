/*
The file for the space weather basetype.
*/

/datum/space_weather
	var/name = "Space Weather Basetype"	//What's this weather called? Should be available for players to see via the Starmap console (maybe requiring a upgrade first)
	var/desc = "This weather shouldn't exist. Tell god about this."	//This description is shown to a player ship which enters a system with an active weather condition.
	var/longrange_hidden = FALSE	//If this is true, this weather will not show up on sensors.
	var/shortrange_hidden = FALSE	//If this is true, this weather will not cause a message on system entering.
	var/datum/star_system/attached_system				//Which system does this belong to? Generally, weather should always have a system.
	var/cycle_interval = -1			//How many actual ticks inbetween each 'tick' of the on_cycle effect? -1 is never.
	var/creation_time				//When was this created
	var/duration					//creation_time + time until end
	var/default_duration			//How long does this weather last by default if no args are submitted for time
	var/permanent = FALSE			//If true: Will stay unless replaced by another weather.

/*
Creation of new weather.
Args:
system_target = the sytem that'll be influenced. Must be provided.
time = How long this will last. Optional, if not provided will use default_duration.
is_permanent = Will it end without being replaced? Optional, overrides base permanent if used.
Will override already present weather conditions, assuming nobody will try creating one in a system with active weather unless they want it replaced.
*/
/datum/space_weather/New(datum/star_system/system_target, time , is_permanent = -1)
	. = ..()
	if(!system_target)
		return INITIALIZE_HINT_QDEL	//We don't want phantom weather vibing in nullspace with no references.
	if(system_target.current_weather)
		system_target.current_weather.end()
	if(is_permanent != -1)
		permanent = is_permanent
	attached_system = system_target
	system_target.current_weather = src
	creation_time = world.time
	if(!permanent)
		addtimer(CALLBACK(src, .proc/end), (time? time : default_duration))
	begin()

/*
Does something repeatedly over the course of the weather, with an internal of cycle_interval ticks.
*/
/datum/space_weather/proc/on_cycle()
	addtimer(CALLBACK(src, .proc/on_cycle), cycle_interval)	//Assumption: on_cycle cycle gets started by begin(), which checks for cycle_interval being -1, so this case can be ignored.
	return TRUE

/*
Does something when a ship arrives in the system. Usually just calls its initial effect.
*/
/datum/space_weather/proc/on_arrive(obj/structure/overmap/target)
	return initial_effect(target)

/*
Does something when the weather starts, or something is being affected by the weather for the first time
*/
/datum/space_weather/proc/initial_effect(obj/structure/overmap/target)
	return TRUE

/*
Does something when a ship exits a system affected by this. By default, just calls the final effect
*/
/datum/space_weather/proc/on_exit(obj/structure/overmap/target)
	return final_effect(target)
/*
Does something when the weather ends, or something is no longer being affected by the weather.
*/
/datum/space_weather/proc/final_effect(obj/structure/overmap/target)
	return TRUE

/*
Does something when the weather begins, usually calling the initial effects and initiating the cycle effect cycle.
*/
/datum/space_weather/proc/begin()
	for(var/obj/structure/overmap/OM in attached_system.system_contents)
		initial_effect()
	if(cycle_interval)
		addtimer(CALLBACK(src, .proc/on_cycle), cycle_interval)
/*
Does something when the weather ends, usually calling the final effect and then qdeling the weather.
*/
/datum/space_weather/proc/end()
	for(var/obj/structure/overmap/OM in attached_system.system_contents)
		final_effect(OM)
	attached_system.current_weather = null
	qdel(src)
