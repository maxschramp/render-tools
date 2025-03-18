macroScript InstantlyAutoEdges category:"#render-tools" tooltip: "Auto Edges"
(
	mapped fn setVisibilityEdges objs threshold = (
		edgeList = #{1..(objs.numFaces * 3)}
		meshop.autoEdge objs edgeList threshold type:#SetClear
	)
	mapped fn getDeputyInstances objSet filtSet = (
		InstanceMgr.GetInstances objSet &instArray
		appendIfUnique filtSet instArray[1]
	)
	mapped fn numEdgesSum objs &outValue = (
		outValue += objs.numFaces * 3
	)
	-- filt to get meshes
	local meshSet = for i in geometry where i.isSelected and \
		classOf i.baseObject == Editable_mesh collect i
	clearListener()
	actionMan.executeAction 0 "40472" -- open Listener
	if meshSet.count == 0 then (
		format "No Mesh in selection!\n" -- feedback
	)
	else (
		local numEdges = 0 ; numEdgesSum meshSet &numEdges
		format "Total Objects:\t%\nTotal Edges:\t%\n" meshSet.count numEdges
		local filtSet = #() -- kick out instances (to speed up)
		getDeputyInstances meshSet filtSet
		if autosave.Enable do autosave.resettimer() -- reset AS timer (just for safe)
		local thrVal = 5 -- set default threshold value
		if keyboard.controlPressed do ( -- get input threshold val if CTRL pressed
			input = getKBValue prompt:"Enter valid threshold (from 0 to 180):"
			if classOf input == Integer or classOf input == Float do (
				if input >= 0 and input <= 180 do thrVal = input
			)
		)
		-- //> start
		setWaitCursor()
		local timeStart = timestamp()
		with undo off (setVisibilityEdges filtSet thrVal)
		local timeEnd = timestamp()
		setArrowCursor()
		-- end <//
		redrawviews()
		format "\nTotal Time:\t\t% sec.\n" ((timeEnd - timeStart)/1000.0)
	)
)
