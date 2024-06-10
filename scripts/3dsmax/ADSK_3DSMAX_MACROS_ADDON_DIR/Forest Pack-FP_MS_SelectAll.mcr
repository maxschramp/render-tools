macroScript FP_MS_SelectAll
	ButtonText:"Select all Forest dependences"
	category:"Forest Pack"
	(
	on IsVisible return (if isForestPack != undefined then (isForestPack $) else false)
	on Execute do 
		( 
		local list = #()
		append list $
		FP_AddSelectionItems list $.cobjlist
		FP_AddSelectionItems list $.arnodelist
		FP_AddSelectionItems list $.surflist
		FP_AddSelectionItems list $.distpathnodes
		FP_AddSelectionItems list $.distrefnodes
		FP_AddSelectionItems list $.distpflownodes
		FP_AddSelectionItems list $.efpainode
		if $.lookat != undefined then append list $.lookat
		if $.light != undefined then append list $.light
		try(select list) catch()
		)
	)
