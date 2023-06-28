	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_GridPacker
Global floater_AssemblyTool
try (if floater_GridPacker.dialogBar then (cui.UnRegisterDialogBar floater_GridPacker); closeRolloutFloater floater_GridPacker) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Grid Packer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "GridPacker_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,475])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("tmr_GP_prgrsFade", "btn_GP_DockLeft", "btn_GP_DockFloat", "btn_GP_DockRight")
	-------------------------------------------------------------------------------------------------------------------
	----=GridPacker==============================================================================================
rollout rollout_GP_ "Grid Packer"
(
local yp1 = #(25, 43, 158, 177, 196, 223, 303, 364, 409)
local CountStr = "0         "
local SizeStr = " 0             "
local DockX = 181; local DockW = 13
button btn_GP_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_GP_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_GP_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_GP_DockLeft pressed do (ATfn_.DockFloaterSide floater_GridPacker iniFile "left")
on btn_GP_DockRight pressed do (ATfn_.DockFloaterSide floater_GridPacker iniFile "right")
on btn_GP_DockFloat pressed do (ATfn_.DockFloaterFloat floater_GridPacker iniFile fl0W fl0H)
	-------
button btn_GP_RefreshInfo "Refresh" pos:[4,yp1[1]-24] width:70 height:21 tooltip:" Refresh Info "
radiobuttons rdbtn_GP_ObjectsGroups "" labels:#("Objects Only","Objects And Groups") pos:[1,yp1[1]] columns:2 offsets:#([0,0],[-17,0]) default:1 tooltip:" Process Objects Only \n or Objects and Groups "

groupBox grp_GP_Info "Info" pos:[2,yp1[2]+0] width:(fl0W-16) height:109
label lbl_GP_ObjectsAndGroupsLabel "Count:" pos:[33,yp1[2]+13] tooltip:" Objects And Groups Count "
label lbl_GP_ObjectsAndGroupsCount CountStr pos:[69,yp1[2]+13] tooltip:lbl_GP_ObjectsAndGroupsLabel.tooltip
button btn_GP_GroupsCount "Groups:" pos:[115,yp1[2]+11] width:45 height:18 enabled:false border:true tooltip:"        Lmb - Select Groups \n Ctrl+Lmb - Open Groups \n        Rmb - Close Groups "
label lbl_GP_GroupsCount CountStr pos:[161,yp1[2]+13] enabled:false tooltip:" Groups Only Count "
groupBox grp_GP_ObjSize "Sizes" pos:[9,yp1[2]+27] width:(fl0W-30) height:59
label lbl_GP_ObjMaximumSizeLabel "Maximum:" pos:[48,yp1[2]+38] tooltip:" Maximum Object Size by XY Axis "
label lbl_GP_ObjMaximumSizeCount SizeStr pos:[102,yp1[2]+38] tooltip:lbl_GP_ObjMaximumSizeLabel.tooltip
label lbl_GP_ObjAverageSizeLabel "Average:" pos:[51,yp1[2]+52] tooltip:" Average Object Size by XY Axis "
label lbl_GP_ObjAverageSizeCount SizeStr pos:[102,yp1[2]+52] tooltip:lbl_GP_ObjAverageSizeLabel.tooltip
label lbl_GP_ObjMinimumSizeLabel "Minimum:" pos:[52,yp1[2]+66] tooltip:" Minimum Object Size by XY Axis "
label lbl_GP_ObjMinimumSizeCount SizeStr pos:[102,yp1[2]+66] tooltip:lbl_GP_ObjMinimumSizeLabel.tooltip
button btn_GP_ElementsCount "Get Elements Count:" pos:[10,yp1[2]+88] width:110 height:18 border:true
label lbl_GP_ElementsCount CountStr pos:[126,yp1[2]+90] tooltip:" Elements Count "

checkButton chbtn_GP_CopyObjects pos:[4,yp1[3]] width:14 height:14 highlightColor:colCHBX tooltip:" Copy Packaged Objects "
label lbl_GP_CopyObjects "Copy Objects" pos:[22,yp1[3]] tooltip:chbtn_GP_CopyObjects.tooltip
checkButton chbtn_GP_AddToLayer pos:[114,yp1[3]] width:14 height:14 highlightColor:colCHBX tooltip:" Add To Layer \"GridPacker\" "
label lbl_GP_AddToLayer "Add To Layer" pos:[132,yp1[3]] tooltip:chbtn_GP_AddToLayer.tooltip

checkButton chbtn_GP_PivotCenter pos:[4,yp1[4]] width:14 height:14 highlightColor:colCHBX tooltip:" Pivot in the Center of the Object "
label lbl_GP_PivotCenter "Pivot to Center" pos:[22,yp1[4]] tooltip:chbtn_GP_PivotCenter.tooltip
checkButton chbtn_GP_PivotZmin pos:[114,yp1[4]] width:14 height:14 highlightColor:colCHBX tooltip:" Pivot to the Minimum \n of the Object Z Axis "
label lbl_GP_PivotZmin "Pivot to Z Min" pos:[132,yp1[4]] tooltip:chbtn_GP_PivotZmin.tooltip

checkButton chbtn_GP_CreateGrid pos:[4,yp1[5]] width:14 height:14 highlightColor:colCHBX tooltip:" Grid Creation Toggle "
label lbl_GP_CreateGrid "Create Grid" pos:[22,yp1[5]] tooltip:chbtn_GP_CreateGrid.tooltip
colorpicker color_GP_GridColor "" pos:[80,yp1[5]-1] width:22 height:18 color:[255,156,0] modal:false tooltip:" Set Grid Color "
checkButton chbtn_GP_ObjAverageSize pos:[114,yp1[5]] width:14 height:14 enabled:true highlightColor:colCHBX tooltip:" Resize Objects By Average Size "
label lbl_GP_POGobjAverageSize "Average Size" pos:[132,yp1[5]] tooltip:chbtn_GP_ObjAverageSize.tooltip

groupBox grp_GP_CellCount "Cell Count" pos:[2,yp1[6]-6] width:(fl0W-16) height:84
spinner spnr_GP_CellCountX "X:" pos:[55,yp1[6]+9] width:43 range:[1,999,1] type:#integer scale:1 toolTip:" Grid Cells Count By X "
spinner spnr_GP_CellCountY "Y:" pos:[113,yp1[6]+9] width:43 range:[1,999,1] type:#integer scale:1 toolTip:" Grid Cells Count By Y "
button btn_GP_CellCountCalcByX "Calculate By X" pos:[8,yp1[6]+28] width:94 height:21 tooltip:" Calculate Cells Count By X "
button btn_GP_CellCountCalcByY "Calculate By Y" pos:[106,yp1[6]+28] width:94 height:21 tooltip:" Calculate Cells Count By Y "
button btn_GP_CellCountCalcProp "Calculate Cells Proportionally" pos:[8,yp1[6]+52] width:(fl0W-28) height:21 tooltip:" Calculate Cells Count Proportionally "

groupBox grp_GP_CellSize "Cell Size" pos:[2,yp1[7]] width:(fl0W-16) height:59
spinner spnr_GP_CellSize pos:[55,yp1[7]+13] width:144 range:[0,9999999,1] enabled:true type:#worldunits toolTip:" Grid Cell Size "
button btn_GP_CellSizeByMax "Get Maximum" pos:[8,yp1[7]+32] width:94 height:21 border:true tooltip:" Get Objects Maximum Size "
button btn_GP_CellSizeByAverage "Get Average" pos:[106,yp1[7]+32] width:94 height:21 border:true tooltip:" Get Objects Average Size "

groupBox grp_GP_SortBySize "Sort By Size" pos:[2,yp1[8]] width:(fl0W-16) height:39
radiobuttons rdbtn_GP_SortBySize "" labels:#("Decrease","Increase") pos:[20,yp1[8]+16] columns:2 offsets:#([0,0],[15,0]) default:1 tooltip:" Pack Objects By Size Order "

button btn_GP_PackObjects "Pack" pos:[5,yp1[9]] width:(fl0W-20) height:37 tooltip:" Pack Objects On Grid "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetPolyElementsCount poly =
(
local GlobInt = (dotNetClass "Autodesk.Max.GlobalInterface").Instance
local INode  = GlobInt.COREInterface14.GetINodeByHandle poly.INode.handle asdotnetobject:true
local IObj   = INode.evalworldstate (currenttime as integer) true asdotnetobject:true
local MNMesh = IObj.obj.mesh
(GlobInt.MNFaceElement.Create MNMesh).Count
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetInput =
(
Input = if rdbtn_GP_ObjectsGroups.state == 1 \
	then (#((ATfn_.GetGeometry selection), #()))
	else (ATfn_.GetNHH selection false)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetInfo =
(
local Input = fn_GetInput()
local InArr = (ATfn_.GetGeometry Input[1]) + Input[2]
local GroupsArr = Input[2]
local ObjectsSizesArr = (ATfn_.GetMinMax InArr)[5]
lbl_GP_ObjectsAndGroupsCount.text = lbl_GP_GroupsCount.text = CountStr
lbl_GP_ObjMaximumSizeCount.text = lbl_GP_ObjAverageSizeCount.text = lbl_GP_ObjMinimumSizeCount.text = SizeStr
if InArr.count > 0
then
	(
	lbl_GP_ObjectsAndGroupsCount.text = InArr.count as string
	lbl_GP_GroupsCount.text = GroupsArr.count as string
	local XYsizeArr = #()
	for os in ObjectsSizesArr do (append XYsizeArr os[1]; append XYsizeArr os[2])
	local XYsizeMax = amax XYsizeArr; lbl_GP_ObjMaximumSizeCount.text = XYsizeMax as string
	local XYsizeMin = amin XYsizeArr; lbl_GP_ObjMinimumSizeCount.text = XYsizeMin as string
	lbl_GP_ObjAverageSizeCount.text = (XYsizeMin + (XYsizeMax - XYsizeMin)/2) as string
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByXYAreaDecrease o1 o2 =
(
local oMinMax = ATfn_.GetMinMax #(o1, o2)
local Area1 = (oMinMax[2][1][1] - oMinMax[1][1][1]) * (oMinMax[2][1][2] - oMinMax[1][1][2])
local Area2 = (oMinMax[2][2][1] - oMinMax[1][2][1]) * (oMinMax[2][2][2] - oMinMax[1][2][2])
case of
	(
	(Area1 > Area2): -1
	(Area1 < Area2): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByXYAreaIncrease o1 o2 =
(
local oMinMax = ATfn_.GetMinMax #(o1, o2)
local Area1 = (oMinMax[2][1][1] - oMinMax[1][1][1]) * (oMinMax[2][1][2] - oMinMax[1][1][2])
local Area2 = (oMinMax[2][2][1] - oMinMax[1][2][1]) * (oMinMax[2][2][2] - oMinMax[1][2][2])
case of
	(
	(Area1 > Area2): 1
	(Area1 < Area2): -1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_PlaceOnGrid CountX CountY CSize GPos oArr =
(
local FitState = true
local CellCount = CountX * CountY
local CellCenterPosArr = #()
for cY=1 to CountY do
	(
	for cX=1 to CountX do
		(
		local posX = GPos[1]-(CountX*CSize/2) + (CSize/2) + CSize*(cX-1)
		local posY = GPos[2]+(CountY*CSize/2) - (CSize/2) - CSize*(cY-1)
		local posZ = GPos[3]
		append CellCenterPosArr [posX,posY,posZ]
		)
	)
local PackCount = if oArr.count < CellCount then oArr.count else CellCount
for n=1 to PackCount do (oArr[n].pos = [CellCenterPosArr[n][1], CellCenterPosArr[n][2], (CellCenterPosArr[n][3] + oArr[n].pos.Z)])
if PackCount < oArr.count then
	(
	messageBox " Objects Count Exceeds Cells Count.\n\n Objects That Do Not Fit Are Selected." title:" Grid Packer" beep:false
	clearSelection()
	local NotFit = for n=PackCount+1 to oArr.count collect oArr[n]
	select NotFit
	FitState = false
	)
return FitState
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Warning1 = (messageBox "Geometry Objects are not Selected." title:" Grid Packer" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_PackObjects pressed do with undo on
(
local Input = fn_GetInput()
local InArr = (ATfn_.GetGeometry Input[1]) + Input[2]
local GroupsArr = Input[2]
local Count = InArr.count
if Count != 0 then
(
local CurrentTaskMode = getCommandPanelTaskMode()
setCommandPanelTaskMode #create
if chbtn_GP_CopyObjects.checked then
	(
	local CopyArr = #()
	maxOps.cloneNodes InArr clonetype:#copy newNodes:&tempArr
	CopyArr = if rdbtn_GP_ObjectsGroups.state == 1 then (ATfn_.DetachFromGroups tempArr) else tempArr
	Input = ATfn_.GetNHH CopyArr false
	InArr = Input[1] + Input[2]
	GroupsArr = Input[2]
	)
if rdbtn_GP_ObjectsGroups.state == 1 then (InArr = (ATfn_.DetachFromGroups InArr))
if rdbtn_GP_SortBySize.state == 1
	then (qsort InArr fn_compareByXYAreaDecrease)
	else (qsort InArr fn_compareByXYAreaIncrease)
local MinMaxAArr = ATfn_.GetMinMax InArr
local ObjectsSizesArr = MinMaxAArr[5]
local ObjectsMinMax = #(MinMaxAArr[1], MinMaxAArr[2])
local CellCountX = spnr_GP_CellCountX.value
local CellCountY = spnr_GP_CellCountY.value
local CellSizeXY = spnr_GP_CellSize.value
local LocalPivotPositions = for n=1 to Count collect (InArr[n].pivot - ObjectsMinMax[1][n])
for n=1 to Count do (InArr[n].pivot = ObjectsMinMax[1][n] + (ObjectsMinMax[2][n] - ObjectsMinMax[1][n])/2)
if chbtn_GP_PivotZmin.checked then (for n=1 to Count do (InArr[n].pivot.Z = ObjectsMinMax[1][n][3]))
if chbtn_GP_ObjAverageSize.checked then
	(
	local AverageSize = lbl_GP_ObjAverageSizeCount.text as number
	for n=1 to Count do
		(
		local scaleVal = AverageSize/(amax ObjectsSizesArr[n][1] ObjectsSizesArr[n][2])
		in coordsys local scale InArr[n] [scaleVal, scaleVal, scaleVal]
		)
	)
local PackGrid
if chbtn_GP_CreateGrid.checked then
	(
	local ccX = if CellCountX == 0 then 1 else CellCountX
	local ccY = if CellCountY == 0 then 1 else CellCountY
	local NewName = uniqueName "GridPackerGrid_"
	gridPlane = Plane widthsegs:ccX lengthsegs:ccY width:(CellSizeXY*ccX) length:(CellSizeXY*ccY)
	ConvertTo gridPlane Editable_Poly
	setEdgeSelection gridPlane (gridPlane.edges as bitarray)
	gridPlane.EditablePoly.createShape NewName off gridPlane
	delete gridPlane
	PackGrid = getNodeByName NewName
	PackGrid.wirecolor = color_GP_GridColor.color
	PackGrid.render_renderable = false
	PackGrid.render_displayRenderMesh = false
	layermanager.newLayerFromName "GridPackerGrids"
	local GridLayer = LayerManager.getlayerfromname "GridPackerGrids"
	GridLayer.addNode PackGrid
	)
local FitState = fn_PlaceOnGrid CellCountX CellCountY CellSizeXY [0,0,0] InArr
if (chbtn_GP_PivotCenter.checked or chbtn_GP_PivotZmin.checked) then (InArr.position.Z = 0)
layermanager.newLayerFromName "GridPacker"
local GridPackerLayer = LayerManager.getlayerfromname "GridPacker"
if FitState do (select InArr; if chbtn_GP_CreateGrid.checked then (selectMore PackGrid))
local NewObjectsMinMax = ATfn_.GetMinMax InArr
if not (chbtn_GP_PivotCenter.checked and chbtn_GP_PivotZmin.checked)
then (for n=1 to Count do (InArr[n].pivot = NewObjectsMinMax[1][n] + LocalPivotPositions[n]))
else (if not chbtn_GP_PivotCenter.checked then (for n=1 to Count do (InArr[n].pivot = NewObjectsMinMax[1][n] + LocalPivotPositions[n]; InArr[n].pivot.Z = NewObjectsMinMax[1][n][3])))
fn_GetInfo()
redrawViews()
setCommandPanelTaskMode CurrentTaskMode
) else (fn_Warning1())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_CellSizeByMax pressed do
(
local OMSC = lbl_GP_ObjMaximumSizeCount.text as number
if OMSC != undefined then (spnr_GP_CellSize.value = OMSC) else (fn_Warning1())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_CellSizeByAverage pressed do
(
local OMSC = lbl_GP_ObjAverageSizeCount.text as number
if OMSC != undefined then (spnr_GP_CellSize.value = OMSC) else (fn_Warning1())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_CellCountCalcByY pressed do
(
local InArr = if rdbtn_GP_ObjectsGroups.state == 1 then (ATfn_.GetGeometry selection) else (ATfn_.GetNHH selection true)
spnr_GP_CellCountX.value = ceil (InArr.count/(spnr_GP_CellCountY.value as float))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_CellCountCalcByX pressed do
(
local InArr = if rdbtn_GP_ObjectsGroups.state == 1 then (ATfn_.GetGeometry selection) else (ATfn_.GetNHH selection true)
spnr_GP_CellCountY.value = ceil (InArr.count/(spnr_GP_CellCountX.value as float))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_CellCountCalcProp pressed do
(
local InArr = if rdbtn_GP_ObjectsGroups.state == 1 then (ATfn_.GetGeometry selection) else (ATfn_.GetNHH selection true)
spnr_GP_CellCountX.value = spnr_GP_CellCountY.value = ceil (sqrt InArr.count)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_ElementsCount pressed do
(
local CurrentTaskMode = getCommandPanelTaskMode()
setCommandPanelTaskMode #create
local InArr = ATfn_.GetGeometry (selection as array) VRProxy:false 
-- local InArr = ATfn_.GetGeometry (selection as array)
local ElementsCount = 0
for objct in InArr do
	(
	addModifier objct (Edit_Poly ())
	ElementsCount += fn_GetPolyElementsCount objct
	deleteModifier objct 1
	)
lbl_GP_ElementsCount.text = ElementsCount as string
SetFocus rollout_GP_
setCommandPanelTaskMode CurrentTaskMode
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_GroupsCount pressed do
(
if keyboard.controlPressed
then (ATfn_.SelectInGroups selection)
else
	(
	local GroupsArr = (ATfn_.GetNHH selection false)[2]
	if GroupsArr.count != 0 then (undo on; select GroupsArr)
	)
redrawViews()
)
	-------------
on btn_GP_GroupsCount rightclick do (max group close; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_GP_ObjectsGroups changed state do (fn_GetInfo(); btn_GP_GroupsCount.enabled = lbl_GP_GroupsCount.enabled = (rdbtn_GP_ObjectsGroups.state == 2))
	-------------------------------------------------------------------------------------------------------------------
on btn_GP_RefreshInfo pressed do (fn_GetInfo())
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_GP_ open do
	(
	fn_GetInfo()
	callbacks.addScript  #selectionSetChanged "floater_GridPacker.rollouts[1].fn_GetInfo()" id:#GridPacker
	callbacks.addScript  #sceneUndo "floater_GridPacker.rollouts[1].fn_GetInfo()" id:#GridPacker
	callbacks.addScript  #sceneRedo "floater_GridPacker.rollouts[1].fn_GetInfo()" id:#GridPacker
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_GridPacker.checked = true)catch()
	)
on rollout_GP_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_GridPacker.checked = false)catch()
	ATfn_.SaveFloaterINI floater_GridPacker iniFile ExcludedControls
	callbacks.removeScripts id:#GridPacker
	floater_GridPacker = undefined
	)
)
	----==============================================================================================================
floater_GridPacker = ATfn_.CreateFloater floater_GridPacker iniFile fl0W fl0H floaterTitle #(rollout_GP_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_GridPacker iniFile ExcludedControls)
	)
)