/obj/structure/lattice/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering and cable placement."
	icon = 'icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk"
	number_of_rods = 2
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	flags_1 = PREVENT_CLICK_UNDER_1//NSV make it so prevent_click_under doesn't need density
	//Negates the effect of space and openspace.
	//Shouldn't be placed above anything else.
	FASTDMM_PROP(\
		pipe_astar_cost = -98.5\
	)

/obj/structure/lattice/catwalk/over
	layer = CATWALK_LAYER
	plane = GAME_PLANE


/obj/structure/lattice/catwalk/deconstruction_hints(mob/user)
	to_chat(user, "<span class='notice'>The supporting rods look like they could be <b>sliced</b>.</span>")

/obj/structure/lattice/attackby(obj/item/C, mob/user, params)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	if(C.tool_behaviour == TOOL_WELDER)
		if(!C.tool_start_check(user, amount=0))
			return FALSE
		balloon_alert(user, "You start slicing through the outer plating..")
		if(C.use_tool(src, user, 25, volume=100))
			balloon_alert(user, "You slice [src].")
			deconstruct()
			return TRUE

/obj/structure/lattice/catwalk/ratvar_act()
	new /obj/structure/lattice/catwalk/clockwork(loc)

/obj/structure/lattice/catwalk/Move()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()

/obj/structure/lattice/catwalk/deconstruct()
	var/turf/T = loc
	if(!istype(src, /obj/structure/lattice/catwalk/over)) // NSV13 - don't cut cables if the catwalk goes *over* the cables
		for(var/obj/structure/cable/C in T)
			C.deconstruct()
	..()

// NSV13 - allow cable laying on open plated catwalk
/obj/structure/lattice/catwalk/proc/can_lay_cable()
	return FALSE
