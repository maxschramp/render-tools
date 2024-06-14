macroScript removeIOR buttontext: "Reset Base IOR" toolTip:"Remove Base IOR Map and set to 1.5" category:"#render-tools" (
	if not isGroupHead $ do (
		for mtl in $.material do (
			mtl.baseIor = 1.5
			print("Set Base IOR to 1.5")
			mtl.baseIorTexmap = undefined
			print("Removed Base IOR Texmap")
		)
	)
)