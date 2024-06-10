macroScript FP_MS_SelectCustomObject
	ButtonText:"Select Forest Custom Object"
	category:"Forest Pack"
	(
	global FP_SelectorItems
	global FP_SelectorNames
	on IsVisible return (if isForestPack != undefined then (isForestPack $) else false)
	on Execute do 
		( 
		FP_SelectorItems = #()
		FP_SelectorNames = #()
		for i = 1 to $.cobjlist.count do
			(
			if $.cobjlist[i] != undefined then 
				(
				append FP_SelectorItems $.cobjlist[i]
				append FP_SelectorNames $.namelist[i]
				)
			)
		FP_ShowMenuSelector()
		)
	)
