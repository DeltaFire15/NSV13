/obj/structure/overmap/onMouseDrag(src_object, over_object, src_location, over_location, params, mob/M)
	// Handle pilots dragging their mouse
	if(M == pilot)
		if(move_by_mouse && can_move() && !pilot.incapacitated())
			desired_angle = getMouseAngle(params, M)

	// If we're the pilot but not the gunner, don't update gunner-specific information
	if(!LAZYFIND(gauss_gunners, M) && M != gunner)
		return

	// Handle gunners dragging their mouse
	if(LAZYFIND(gauss_gunners, M)) // Anyone with overmap_gunning should also be in gauss_gunners
		var/datum/component/overmap_gunning/user_gun = M.GetComponent(/datum/component/overmap_gunning)
		user_gun.onMouseDrag(src_object, over_object, src_location, over_location, params, M)
		return TRUE
	if(aiming)
		aiming_target = over_object
		aiming_params = params
		if(target_lock)
			lastangle = get_angle(src, get_turf(over_object))
		else if (fire_mode == FIRE_MODE_BROADSIDE)
			if((overmap_angle(src, over_location) - angle) <= 180)
				lastangle = (src.angle + 90)
			else
				lastangle = (src.angle + 270)
		else
			lastangle = getMouseAngle(params, M)
		draw_beam()
	else
		autofire_target = over_object

/obj/structure/overmap/proc/onMouseDown(object, location, params, mob/M)
	if(istype(object, /atom/movable/screen) && !istype(object, /atom/movable/screen/click_catcher))
		return
	if((object in M.contents) || (object == M))
		return
	var/datum/component/overmap_gunning/user_gun = M.GetComponent(/datum/component/overmap_gunning)
	if(user_gun)
		user_gun?.onMouseDown(object)
		return TRUE
	if(M != gunner)
		return
	if((fire_mode == FIRE_MODE_MAC || fire_mode == FIRE_MODE_BLUE_LASER || fire_mode == FIRE_MODE_HYBRID_RAIL))
		aiming_target = object
		aiming_params = params
		if(target_lock)
			lastangle = get_angle(src, get_turf(object))
		else
			lastangle = getMouseAngle(params, M)
		start_aiming(params, M)
	else if(fire_mode == FIRE_MODE_BROADSIDE) //If the weapon fires from the sides, we want the aiming laser to lock to the sides
		aiming_target = object
		aiming_params = params
		if((overmap_angle(src, location) - angle) <= 180)
			lastangle = (src.angle + 90)
		else
			lastangle = (src.angle + 270)
		start_aiming(params, M)
	else
		autofire_target = object

/obj/structure/overmap/proc/onMouseUp(object, location, params, mob/M)
	if(istype(object, /atom/movable/screen) && !istype(object, /atom/movable/screen/click_catcher))
		return
	var/datum/component/overmap_gunning/user_gun = M.GetComponent(/datum/component/overmap_gunning)
	if(user_gun)
		user_gun?.onMouseUp(object)
		return TRUE
	if(M != gunner)
		return
	autofire_target = null
	lastangle = get_angle(src, get_turf(object))
	stop_aiming()
	if(fire_mode == FIRE_MODE_MAC || fire_mode == FIRE_MODE_BLUE_LASER || fire_mode == FIRE_MODE_HYBRID_RAIL || FIRE_MODE_BROADSIDE)
		fire_weapon(object)
	if(fire_mode == FIRE_MODE_BROADSIDE)
		if((overmap_angle(src, location) - angle) <= 180)
			lastangle = (src.angle + 90)
		else
			lastangle = (src.angle + 270)
	QDEL_LIST(current_tracers)

/obj/structure/overmap
	var/next_beam = 0

/obj/structure/overmap/proc/draw_beam(force_update = FALSE)
	var/diff = abs(aiming_lastangle - lastangle)
	check_user()
	if(diff < AIMING_BEAM_ANGLE_CHANGE_THRESHOLD || world.time < next_beam && !force_update)
		return
	next_beam = world.time + 0.05 SECONDS
	aiming_lastangle = lastangle
	var/obj/item/projectile/beam/overmap/aiming_beam/P = new
	P.gun = src
	P.color = "#99ff99"
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(aiming_target)
	if(!istype(targloc) || !istype(curloc))
		return
	P.preparePixelProjectile(targloc, src, aiming_params, 0)
	P.layer = BULLET_HOLE_LAYER
	P.fire(lastangle)

/obj/structure/overmap/proc/check_user(automatic_cleanup = TRUE)
	if(!istype(gunner) || gunner.incapacitated())
		if(automatic_cleanup)
			stop_aiming()
		return FALSE
	return TRUE

/obj/structure/overmap/proc/start_aiming(params, mob/M)
	aiming = TRUE
	draw_beam(TRUE)

/obj/structure/overmap/proc/stop_aiming()
	aiming = FALSE
	QDEL_LIST(current_tracers)

/obj/structure/overmap/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/item/projectile/beam/overmap/aiming_beam))
		var/obj/item/projectile/beam/overmap/aiming_beam/AB = mover
		if(src == AB.gun)
			return TRUE
	return ..()


/obj/item/projectile/beam/overmap/aiming_beam
	name = "aiming beam"
	icon = null
	hitsound = null
	hitsound_wall = null
	damage = 0				//Handled manually.
	nodamage = TRUE
	damage_type = BURN
	flag = "energy"
	range = 150
	jitter = 10
	var/obj/structure/overmap/gun
	icon_state = ""
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/aiming
	reflectable = REFLECT_FAKEPROJECTILE
	hitscan_light_range = 0
	hitscan_light_intensity = 0
	hitscan_light_color_override = "#99ff99"
	var/constant_tracer = TRUE

/obj/item/projectile/beam/overmap/aiming_beam/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE, highlander)
	set waitfor = FALSE
	if(isnull(highlander))
		highlander = constant_tracer
	if(highlander && istype(gun))
		var/list/obj/item/projectile/beam/overmap/aiming_beam/new_tracers = list()
		for(var/datum/point/p in beam_segments)
			// I don't know why these "dead zones" appear and override the normal lines, but there is a pattern, so I'm gonna use it
			if((p.x != 273) && (p.x != 7889) && (p.y != 273) && (p.y != 7889))
				new_tracers += generate_tracer_between_points(p, beam_segments[p], tracer_type, color, 0, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
		if(new_tracers.len)
			QDEL_LIST(gun.current_tracers)
			gun.current_tracers += new_tracers
	else
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	if(cleanup)
		QDEL_LIST(beam_segments)
		beam_segments = null
		QDEL_NULL(beam_index)
