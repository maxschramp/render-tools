macroScript RC_MS_SelectBaseObject
	ButtonText:"Select RailClone Base Object"
	category:"RailClone"
	(
	global RC_SelectorItems
	global RC_SelectorNames
	on IsVisible return (if isRailClone != undefined then (isRailClone $) else false)
	on Execute do 
		( 
		RC_SelectorItems = #()
		RC_SelectorNames = #()
		for i = 1 to $.banode.count do
			(
			if $.banode[i] != undefined then 
				(
				append RC_SelectorItems $.banode[i]
				append RC_SelectorNames $.baname[i]
				)
			)
		RC_ShowMenuSelector()
		)
	)
