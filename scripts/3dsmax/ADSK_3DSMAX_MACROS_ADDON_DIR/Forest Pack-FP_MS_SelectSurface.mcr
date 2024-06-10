macroScript FP_MS_SelectSurface
	ButtonText:"Select Forest Surface"
	category:"Forest Pack"
	(
	global FP_SelectorItems
	global FP_SelectorNames
	on IsVisible return (if isForestPack != undefined then (isForestPack $) else false)
	on Execute do 
		( 
		FP_SelectorItems = #()
		FP_SelectorNames = #()
		for i = 1 to $.surflist.count do
			(
			if $.surflist[i] != undefined then 
				(
				append FP_SelectorItems $.surflist[i]
				append FP_SelectorNames $.surflist[i].name
				)
			)
		FP_ShowMenuSelector()
		)
	)
