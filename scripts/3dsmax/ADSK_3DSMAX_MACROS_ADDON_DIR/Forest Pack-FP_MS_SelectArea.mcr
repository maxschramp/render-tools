macroScript FP_MS_SelectArea
	ButtonText:"Select Forest Area"
	category:"Forest Pack"
	(
	global FP_SelectorItems
	global FP_SelectorNames
	on IsVisible return (if isForestPack != undefined then (isForestPack $) else false)
	on Execute do 
		( 
		FP_SelectorItems = #()
		FP_SelectorNames = #()
		for i = 1 to $.arnodelist.count do
			(
			if $.arnodelist[i] != undefined then 
				(
				append FP_SelectorItems $.arnodelist[i]
				append FP_SelectorNames $.arnamelist[i]
				)
			)
		FP_ShowMenuSelector()
		)
	)
