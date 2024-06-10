macroScript RC_MS_SelectSegment
	ButtonText:"Select RailClone Segment"
	category:"RailClone"
	(
	global RC_SelectorItems
	global RC_SelectorNames
	on IsVisible return (if isRailClone != undefined then (isRailClone $) else false)
	on Execute do 
		( 
		RC_SelectorItems = #()
		RC_SelectorNames = #()
		for i = 1 to $.sobjnode.count do
			(
			if $.sobjnode[i] != undefined then 
				(
				append RC_SelectorItems $.sobjnode[i]
				append RC_SelectorNames $.sname[i]
				)
			)
		RC_ShowMenuSelector()
		)
	)	
