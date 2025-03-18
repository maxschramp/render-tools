runStuff()
fn fixProblemsInXrefs =
(
	local nbrXref=xrefs.getXRefFileCount()
	
	local all_problems = #()
	for i = 1 to nbrXref do
	(
		object_with_problem = #()
		x = xrefs.getXRefFile i
		if (not x.disabled) then
		(
			y = x.tree.children
			
			for o in y where classof o == RailClone_Pro do
			(
				append object_with_problem o
			)
			if object_with_problem.count > 0 then
			(
				blob = x as string + "\n"
				for obj in object_with_problem do
				(
					blob = blob + obj.name + "\n"
				)
				append all_problems blob
			)
		)
	)

	if all_problems.count > 0 then
	(
			machin = "Problems in xrefs:\n"
			for problem in all_problems do
			(
				machin = machin +  "\n" + problem
			)
			return machin
	)
	return ""
)

fn fixProblemsInScene =
(
	local nbr_affected_object = 0
	local broken_objects=#()

	for obj in geometry do
	(
		if ((classof obj) == RailClone_Pro) then
		(
			if (obj.rendermode == true) then 
			(
				append broken_objects obj.name
				obj.rendermode = false
				nbr_affected_object = nbr_affected_object + 1
			)
		)
	)

	if nbr_affected_object > 0 then
	(
		blob = "Nbr or railclones fixed in scene:\n" + nbr_affected_object as string
		return blob
	)
	else return ""
)

fn runStuff = 
(
	local prob_xref = fixProblemsInXrefs()
	local prob_scene = fixProblemsInScene()
	if (prob_xref!="" or prob_scene!="") then
	(
		return true
	)
	else return false
)
