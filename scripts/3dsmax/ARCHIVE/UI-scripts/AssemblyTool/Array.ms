	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_Array
Global floater_AssemblyTool
try (if floater_Array.dialogBar then (cui.UnRegisterDialogBar floater_Array); closeRolloutFloater floater_Array) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Array"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Array_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,535])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_ARR_DockLeft", "btn_ARR_DockFloat", "btn_ARR_DockRight",
	"chbtn_ARR_Preview", "chbtn_ARR_EditOrigin", "mlbx_ARR_Input")
	-------------------------------------------------------------------------------------------------------------------
local inArr = #()
local inList = #()
local xyzArr = #()
local flatArr = #()
local xyzRot = #()
local xyzScl = #()
local origPos = [0, 0, 0]
local CountButDown
local origPoint
local curSel = #()
local LastProcessed = #()
	----=Array==============================================================================================
rollout rollout_ARR_ "Array"
(
local yp1 = #(24, 149, 171, 192, 259, 359, 480)
local DockX = 181; local DockW = 13
button btn_ARR_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_ARR_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_ARR_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_ARR_DockLeft pressed do (ATfn_.DockFloaterSide floater_Array iniFile "left")
on btn_ARR_DockRight pressed do (ATfn_.DockFloaterSide floater_Array iniFile "right")
on btn_ARR_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Array iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_ARR_SelectedOrList "" labels:#("Selected","List") pos:[2,yp1[1]-20] columns:2 offsets:#([0,0],[5,0]) default:2 tooltip:" Array With Selected Scene Objects \n Or Array With Objects In List "
button btn_ARR_AddObjInput "+" width:22 height:21 pos:[0,yp1[1]] images:ATIcons[1] tooltip:" Add Objects To Input "
button btn_ARR_RemoveObjInput "-" width:22 height:21 pos:[26,yp1[1]] images:ATIcons[2] tooltip:" Remove Objects From Input "
button btn_ARR_RemoveAllObjInput "_" width:22 height:21 pos:[52,yp1[1]] images:ATIcons[3] tooltip:" Remove All Input Objects From List "
button btn_ARR_SelectAllInput "All" width:22 height:21 pos:[78,yp1[1]] images:ATIcons[4] tooltip:" Select All Input Objects "
multilistBox mlbx_ARR_Input items:#() width:(fl0W-16) height:7 pos:[2,yp1[1]+22] selection:1 tooltip:" Input Objects "
	
radiobuttons rdbtn_ARR_CopyOrInstance "" labels:#("Copy","Instance") pos:[5,yp1[2]] columns:2 offsets:#([0,0],[-7,0]) default:2 tooltip:" Copy Or Instance Array Objects "

checkButton chbtn_ARR_PivotToCenterZMin "" pos:[5,yp1[3]] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Set Pivot To Objects Center And Z Minimum "
label lbl_ARR_PivotToCenterZMin "Pivot To Center Z Minimum" pos:[23,yp1[3]] toolTip:chbtn_ARR_PivotToCenterZMin.toolTip

GroupBox grp_ARR_OriginPoint "Origin Point:" pos:[2,yp1[4]] width:(fl0W-16) height:65
spinner spnr_ARR_OriginByX "X" pos:[15,yp1[4]+18] width:55 range:[-999999,999999,0.] type:#float scale:.1 toolTip:" Origin Point By X Axis "
spinner spnr_ARR_OriginByY "Y" pos:[80,yp1[4]+18] width:55 range:[-999999,999999,0.] type:#float scale:.1 toolTip:" Origin Point By Y Axis "
spinner spnr_ARR_OriginByZ "Z" pos:[145,yp1[4]+18] width:55 range:[-999999,999999,0.] type:#float scale:.1 toolTip:" Origin Point By Z Axis "
button btn_ARR_PlaceOrigin "Place Origin" pos:[7,yp1[4]+38] width:95 height:21 toolTip:" Place Origin Point "
checkButton chbtn_ARR_EditOrigin "Edit Origin" pos:[105,yp1[4]+38] width:95 height:21 highlightColor:colCHBX toolTip:" Edit Origin Point "

local PTogX = 5
checkButton chbtn_ARR_ArrayByXTogg "X" pos:[PTogX-2,yp1[5]+15] width:18 height:18 highlightColor:[204,64,64] checked:true tooltip:" Array By X Toggle "
checkButton chbtn_ARR_ArrayByYTogg "Y" pos:[PTogX-2,yp1[5]+34] width:18 height:18 highlightColor:[63,164,63] checked:true tooltip:" Array By Y Toggle "
checkButton chbtn_ARR_ArrayByZTogg "Z" pos:[PTogX-2,yp1[5]+53] width:18 height:18 highlightColor:[70,114,255] checked:true tooltip:" Array By Z Toggle "
local SpWdp1 = 45; local cntX = PTogX+22
label lbl_ARR_Count "Count" pos:[cntX+8,yp1[5]]
spinner spnr_ARR_CountByX pos:[cntX,yp1[5]+16] width:SpWdp1 range:[1,99,1] type:#integer scale:1 toolTip:" Count By X "
spinner spnr_ARR_CountByY pos:[cntX,yp1[5]+35] width:SpWdp1 range:[1,99,1] type:#integer scale:1 toolTip:" Count By Y "
spinner spnr_ARR_CountByZ pos:[cntX,yp1[5]+54] width:SpWdp1 range:[1,99,1] type:#integer scale:1 toolTip:" Count By Z "
label lbl_ARR_CountByAll1 "]" pos:[cntX+54,yp1[5]+22]
spinner spnr_ARR_CountByXYZ pos:[cntX+47,yp1[5]+35] width:16 range:[-999999,999999,0] type:#integer scale:1 toolTip:" Count By XYZ "
label lbl_ARR_CountByAll2 "]" pos:[cntX+54,yp1[5]+49]
button btn_ARR_ResetCountSpiners "Reset" pos:[cntX+2,yp1[5]+73] width:41 height:21 toolTip:" Reset Count Spiners Value "
local SpWdp2 = 90; local shftX = cntX+70; local Pscale = .1
label lbl_ARR_Shift "Spacing" pos:[shftX+29,yp1[5]]
spinner spnr_ARR_ShiftByX pos:[shftX,yp1[5]+16] width:SpWdp2 range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Spacing By X "
spinner spnr_ARR_ShiftByY pos:[shftX,yp1[5]+35] width:SpWdp2 range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Spacing By Y "
spinner spnr_ARR_ShiftByZ pos:[shftX,yp1[5]+54] width:SpWdp2 range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Spacing By Z "
label lbl_ARR_ShiftByAll1 "]" pos:[shftX+99,yp1[5]+22]
spinner spnr_ARR_ShiftByXYZ pos:[shftX+92,yp1[5]+35] width:16 range:[-999999,999999,0] type:#float scale:Pscale toolTip:"  Spacing By XYZ "
label lbl_ARR_ShiftByAll2 "]" pos:[shftX+99,yp1[5]+49]
button btn_ARR_ResetShiftSpiners "Reset" pos:[122,yp1[5]+73] width:45 height:21 toolTip:" Reset Spacing Spiners Value "

checkButton chbtn_ARR_Preview "Preview" pos:[2,yp1[6]] width:100 height:37 highlightColor:colCHBX toolTip:" Activate Preview "
button btn_ARR_Randomize "Randomize" pos:[105,yp1[6]] width:101 height:37 enabled:false

checkButton chbtn_ARR_SelectResult "" pos:[4,yp1[6]+42] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Select Result Array When Apply "
label lbl_ARR_SelectResult "Select Result Array When Apply" pos:[22,yp1[6]+42] toolTip:chbtn_ARR_SelectResult.toolTip

checkButton chbtn_ARR_SetWireColorState pos:[4,yp1[6]+60] width:14 height:14 highlightColor:colCHBX tooltip:" Set Uniform Wire Color To Processed Objects "
label lbl_ARR_SetWireColorState "Set Uniform Wire Color To Processed" pos:[22,yp1[6]+60]

button btn_ARR_Apply "Apply" pos:[2,yp1[6]+78] width:204 height:37 enabled:true

button btn_ARR_SelLastProcessed "Select Last Created Array" pos:[1,yp1[7]] width:(fl0W-15) height:23
	---local-----------------------------------------------------------------------------------------------------------
local xCount = if chbtn_ARR_ArrayByXTogg.checked then spnr_ARR_CountByX.value else 1
local yCount = if chbtn_ARR_ArrayByYTogg.checked then spnr_ARR_CountByY.value else 1
local zCount = if chbtn_ARR_ArrayByZTogg.checked then spnr_ARR_CountByZ.value else 1
	---local-----------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_DefineInArr RebuildMode:false =
(
local state = true
if rdbtn_ARR_SelectedOrList.state == 1
then
	(
	if RebuildMode
	then (inArr = for o in inArr where isValidNode o collect o)
	else (inArr = ATfn_.GetNHH (selection as array) true)
	if inArr.count == 0 do
		(
		ATfn_.messageNS()
		state = false
		)
	)
else
	(
	inList = for o in inList where isValidNode o collect o
	mlbx_ARR_Input.items = for o in inList collect o.name
	inArr = deepCopy inList
	if inArr.count == 0 do
		(
		messageBox "List Is Empty. Add Objects To List." title:" Assembly Tool" beep:false
		state = false
		)
	)
if not state do chbtn_ARR_Preview.checked = false
return state
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_FlattenXYZArray =
(
flatArr = #()
for x=1 to xyzArr.count do
	(
	for y=1 to xyzArr[1].count do
		(
		for o in xyzArr[x][y] where isValidObj o do append flatArr o
		)
	)
return flatArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CopyObj =
(
local newObj = ATfn_.CopyObject inArr[random 1 inArr.count] IInstance:(rdbtn_ARR_CopyOrInstance.state == 2)
if chbtn_ARR_PivotToCenterZMin.checked do (ATfn_.SetPivot #(newObj) 0 0 1 true)
return newObj
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_freeArr FreeInput:true =
(
if FreeInput do
	(
	free inArr
	rdbtn_ARR_SelectedOrList.enabled = true
	btn_ARR_Randomize.enabled = false
	chbtn_ARR_Preview.checked = false
	)
free xyzArr
free flatArr
free xyzRot
free xyzScl
gc()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_DeleteXYZArrObjects =
(
for x=1 to xyzArr.count do
	(
	for y=1 to xyzArr[1].count do
		(
		delete (for o in xyzArr[x][y] where isValidObj o collect o)
		)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CancelPreview =
(
fn_DeleteXYZArrObjects()
fn_freeArr()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_xyzCount =
(
max create mode
xCount = if chbtn_ARR_ArrayByXTogg.checked then spnr_ARR_CountByX.value else 1
yCount = if chbtn_ARR_ArrayByYTogg.checked then spnr_ARR_CountByY.value else 1
zCount = if chbtn_ARR_ArrayByZTogg.checked then spnr_ARR_CountByZ.value else 1
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_PosArr xShift yShift zShift =
(
fn_xyzCount()
for x=1 to xCount do
	(
	for y=1 to yCount do
		(
		for z=1 to zCount do
			(
			xyzArr[x][y][z].pos = origPos + [xShift * (x-1), yShift * (y-1), zShift * (z-1)]
			)
		)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetCountButDown =
(
fn_xyzCount()
CountButDown = [xCount, yCount, zCount]
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_xyzArrRebuild =
(
if not chbtn_ARR_Preview.checked do return false
if not (fn_DefineInArr RebuildMode:true) do (fn_CancelPreview(); return false)
fn_xyzCount()
if xCount != CountButDown[1] do
	(
	if xCount < CountButDown[1]
	then
		(
		for x=CountButDown[1] to (xCount + 1) by -1 do
			(
			for y=xyzArr[x].count to 1 by -1 do (delete xyzArr[x][y])
			deleteItem xyzArr x
			)
		)
	else
		(
		for x=(CountButDown[1] + 1) to xCount do
			(
			local xArr = #()
			for y=1 to yCount do
				(
				local yArr = #()
				for z=1 to zCount do
					(
					append yArr (fn_CopyObj())
					)
				append xArr yArr
				)
			append xyzArr xArr
			)
		)
	)
if yCount != CountButDown[2] do
	(
	if yCount < CountButDown[2]
	then
		(
		for xArr in xyzArr do
			(
			for y=xArr.count to (yCount + 1) by -1 do
				(
				delete xArr[y]
				deleteItem xArr y
				)
			)
		)
	else
		(
		for xArr in xyzArr do
			(
			for y=(CountButDown[2] + 1) to yCount do
				(
				local yArr = #()
				for z=1 to zCount do (append yArr (fn_CopyObj()))
				append xArr yArr
				)
			)
		)
	)
if zCount != CountButDown[3] do
	(
	if zCount < CountButDown[3]
	then
		(
		for xArr in xyzArr do
			(
			for yArr in xArr do
				(
				for z=yArr.count to (zCount + 1) by -1 do
					(
					delete yArr[z]
					deleteItem yArr z
					)
				)
			)
		)
	else
		(
		for xArr in xyzArr do
			(
			for yArr in xArr do
				(
				for z=(CountButDown[3] + 1) to zCount do
					(
					append yArr (fn_CopyObj())
					)
				)
			)
		)
	)
	
-- 	format "%\n" xyzArr
if xCount > CountButDown[1] or yCount > CountButDown[2] or zCount > CountButDown[3] do
	(fn_PosArr spnr_ARR_ShiftByX.value spnr_ARR_ShiftByY.value spnr_ARR_ShiftByZ.value)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_xyzArrCreate =
(
fn_xyzCount()
dimArr = #(xCount, yCount, zCount)
local xsh = spnr_ARR_ShiftByX.value; local ysh = spnr_ARR_ShiftByY.value; local zsh = spnr_ARR_ShiftByZ.value
for x=1 to xCount do
	(
	local xArr = #()
	local xRot = #()
	local xScl = #()
	for y=1 to yCount do
		(
		local yArr = #()
		local yRot = #()
		local yScl = #()
		for z=1 to zCount do
			(
			local newObj = fn_CopyObj()
			append yArr newObj
			append yRot [newObj.rotation.controller[1].value, newObj.rotation.controller[2].value, newObj.rotation.controller[3].value]
			append yScl newObj.scale
			)
		append xArr yArr
		append xRot yRot
		append xScl yScl
		)
	append xyzArr xArr
	append xyzRot xRot
	append xyzScl xScl
	)
fn_PosArr xsh ysh zsh
btn_ARR_Randomize.enabled = true
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_xyzArrReCreate =
(
if chbtn_ARR_Preview.checked do
	(
	if not (fn_DefineInArr RebuildMode:true) do (fn_CancelPreview(); return false)
	fn_DeleteXYZArrObjects()
	fn_freeArr FreeInput:false
	fn_xyzArrCreate()
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_OrigToSpiners =
(
spnr_ARR_OriginByX.value = origPos.x
spnr_ARR_OriginByY.value = origPos.y
spnr_ARR_OriginByZ.value = origPos.z
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_EndEditOrigin =
(
callbacks.removeScripts id:#ATcallbacks_ARR_
if isValidNode origPoint do
	(
	if chbtn_ARR_Preview.checked do
		(
		fn_FlattenXYZArray()
		if flatArr.count > 0 do flatArr.position += origPoint.pos - origPos
		)
	origPos = origPoint.pos
	fn_OrigToSpiners()
	delete origPoint
	)
select curSel
chbtn_ARR_EditOrigin.checked = false
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_PlaceOrigin pressed do with undo off
(
curSel = selection as array
origPoint = Point cross:true Box:false constantscreensize:true isSelected:true pos:origPos name:"OriginPointHelper"
local storeOrig = origPos
	-----fn----------------------------------------------
FN fn_mouseTrackObject msg ir obj faceNum shift ctrl alt =
(
if msg == #freeMove
then
	(
	if ir != undefined
	then
		(
		origPoint.pos = ir.pos
		)
	else
		(
		origPoint.pos = mapScreenToCP mouse.pos
		)
	return #continue
	)
if msg == #mousePoint
then
	(
	origPos = origPoint.pos
	delete origPoint
	return #end
	)
if msg == #mouseMove
then 
	(
	origPos = origPoint.pos
	delete origPoint
	return #end
	)
if msg == #mouseAbort
then 
	(
	delete origPoint
	return #end
	)
)
	-----fn---------------------------------------
local OnGeometry = for objct in geometry where not objct.isHidden collect objct
mouseTrack on:OnGeometry trackCallBack:fn_mouseTrackObject
if chbtn_ARR_Preview.checked do
	(
	fn_FlattenXYZArray()
	flatArr.position += origPos - storeOrig
	)
fn_OrigToSpiners()
select curSel
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ARR_EditOrigin changed state do with undo off
(
if state
then
	(
	curSel = selection as array
	origPoint = Point cross:true Box:false constantscreensize:true isSelected:true pos:origPos name:"OriginPointHelper"
	callbacks.addScript #selectionSetChanged "floater_Array.rollouts[1].fn_EndEditOrigin()" id:#ATcallbacks_ARR_
	)
else
	(
	fn_EndEditOrigin()
	)
)
	-------------------------------------------------------------------------------------------------------------------
local flatArrbutDownPos = #()
on spnr_ARR_OriginByX buttonDown do
(
if chbtn_ARR_Preview.checked do
	(
	fn_FlattenXYZArray()
	flatArrbutDownPos = for o in flatArr collect o.pos
	)
)
on spnr_ARR_OriginByX changed val do with undo off
(
if chbtn_ARR_Preview.checked do
	(
	for n=1 to flatArr.count do flatArr[n].pos.x = flatArrbutDownPos[n].x + val - origPos.x
	)
)
on spnr_ARR_OriginByX buttonUp do origPos.x = spnr_ARR_OriginByX.value
	-------------------------------------------------------------------
on spnr_ARR_OriginByY buttonDown do
(
if chbtn_ARR_Preview.checked do
	(
	fn_FlattenXYZArray()
	flatArrbutDownPos = for o in flatArr collect o.pos
	)
)
on spnr_ARR_OriginByY changed val do with undo off
(
if chbtn_ARR_Preview.checked do
	(
	for n=1 to flatArr.count do flatArr[n].pos.y = flatArrbutDownPos[n].y + val - origPos.y
	)
)
on spnr_ARR_OriginByY buttonUp do origPos.y = spnr_ARR_OriginByY.value
	-------------------------------------------------------------------
on spnr_ARR_OriginByZ buttonDown do
(
if chbtn_ARR_Preview.checked do
	(
	fn_FlattenXYZArray()
	flatArrbutDownPos = for o in flatArr collect o.pos
	)
)
on spnr_ARR_OriginByZ changed val do with undo off
(
if chbtn_ARR_Preview.checked do
	(
	for n=1 to flatArr.count do flatArr[n].pos.z = flatArrbutDownPos[n].z + val - origPos.z
	)
)
on spnr_ARR_OriginByZ buttonUp do origPos.z = spnr_ARR_OriginByZ.value
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_Apply pressed do with undo off
(
if chbtn_ARR_Preview.checked
then
	(
	chbtn_ARR_Preview.checked = btn_ARR_Randomize.enabled = false
	)
else
	(
	if not fn_DefineInArr() do return false
	fn_xyzArrCreate()
	)
fn_FlattenXYZArray()
if chbtn_ARR_SelectResult.checked do (select flatArr)
LastProcessed = deepCopy flatArr
if chbtn_ARR_SetWireColorState.checked do ((ATfn_.GetArrayByHeads flatArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor())
fn_freeArr()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ARR_PivotToCenterZMin changed state do with undo off (fn_xyzArrReCreate())
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_Randomize pressed do with undo off (fn_xyzArrReCreate())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ARR_Preview changed state do with undo off
(
if state
then
	(
-- 	local startTime= timeStamp()
	if chbtn_ARR_EditOrigin.checked do (fn_EndEditOrigin())
	if not fn_DefineInArr() do return false
	rdbtn_ARR_SelectedOrList.enabled = false
	fn_xyzArrCreate()
-- 	format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - startTime)).ToString()) ".")[1]
	)
else
	(
	fn_CancelPreview()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_CountByX buttonDown do fn_GetCountButDown()
on spnr_ARR_CountByX buttonUp do fn_xyzArrRebuild()
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_CountByY buttonDown do fn_GetCountButDown()
on spnr_ARR_CountByY buttonUp do fn_xyzArrRebuild()
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_CountByZ buttonDown do fn_GetCountButDown()
on spnr_ARR_CountByZ buttonUp do fn_xyzArrRebuild()
	-------------------------------------------------------------------------------------------------------------------
local CountCtrlArr = #(spnr_ARR_CountByX, spnr_ARR_CountByY, spnr_ARR_CountByZ)
on spnr_ARR_CountByXYZ buttonDown do (fn_GetCountButDown())
on spnr_ARR_CountByXYZ changed val do
(
for n=1 to 3 do
	(
	CountCtrlArr[n].value = CountButDown[n] + val
	if CountCtrlArr[n].value < 1 do CountCtrlArr[n].value = 1
	)
)
on spnr_ARR_CountByXYZ buttonUp do
(
spnr_ARR_CountByXYZ.value = 0.
fn_xyzArrRebuild()
)
	----------------------------------------------------
on btn_ARR_ResetCountSpiners pressed do
(
fn_GetCountButDown()
CountCtrlArr.value = 1
fn_xyzArrRebuild()
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_ShiftByX changed val do
(
if not chbtn_ARR_Preview.checked do return false
fn_PosArr val spnr_ARR_ShiftByY.value spnr_ARR_ShiftByZ.value
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_ShiftByY changed val do
(
if not chbtn_ARR_Preview.checked do return false
fn_PosArr spnr_ARR_ShiftByX.value val spnr_ARR_ShiftByZ.value
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_ARR_ShiftByZ changed val do
(
if not chbtn_ARR_Preview.checked do return false
fn_PosArr spnr_ARR_ShiftByX.value spnr_ARR_ShiftByY.value val
)
	-------------------------------------------------------------------------------------------------------------------
local ShiftButDown
local ShiftCtrlArr = #(spnr_ARR_ShiftByX, spnr_ARR_ShiftByY, spnr_ARR_ShiftByZ)
on spnr_ARR_ShiftByXYZ buttonDown do
(
ShiftButDown = [spnr_ARR_ShiftByX.value, spnr_ARR_ShiftByY.value, spnr_ARR_ShiftByZ.value]
)
on spnr_ARR_ShiftByXYZ changed val do
(
for n=1 to 3 do
	(
	ShiftCtrlArr[n].value = ShiftButDown[n] + val
	)
if not chbtn_ARR_Preview.checked do return false
fn_PosArr spnr_ARR_ShiftByX.value spnr_ARR_ShiftByY.value spnr_ARR_ShiftByZ.value
)
on spnr_ARR_ShiftByXYZ buttonUp do
(
spnr_ARR_ShiftByXYZ.value = 0.
)
	----------------------------------------------------
on btn_ARR_ResetShiftSpiners pressed do
(
ShiftCtrlArr.value = 0
if not chbtn_ARR_Preview.checked do return false
fn_PosArr spnr_ARR_ShiftByX.value spnr_ARR_ShiftByY.value spnr_ARR_ShiftByZ.value
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ARR_ArrayByXTogg changed state do with undo off
(
if not chbtn_ARR_ArrayByYTogg.checked and not chbtn_ARR_ArrayByZTogg.checked
then
	(
	chbtn_ARR_ArrayByXTogg.checked = true
	)
else
	(
	fn_GetCountButDown()
	if state
	then (CountButDown[1] = 1)
	else (CountButDown[1] = spnr_ARR_CountByX.value)
	fn_xyzArrRebuild()
	)
)
	----------------------------------------------------
on chbtn_ARR_ArrayByYTogg changed state do with undo off
(
if not chbtn_ARR_ArrayByXTogg.checked and not chbtn_ARR_ArrayByZTogg.checked
then
	(
	chbtn_ARR_ArrayByYTogg.checked = true
	)
else
	(
	fn_GetCountButDown()
	if state
	then (CountButDown[2] = 1)
	else (CountButDown[2] = spnr_ARR_CountByY.value)
	fn_xyzArrRebuild()
	)
)
	----------------------------------------------------
on chbtn_ARR_ArrayByZTogg changed state do with undo off
(
if not chbtn_ARR_ArrayByXTogg.checked and not chbtn_ARR_ArrayByYTogg.checked
then
	(
	chbtn_ARR_ArrayByZTogg.checked = true
	)
else
	(
	fn_GetCountButDown()
	if state
	then (CountButDown[3] = 1)
	else (CountButDown[3] = spnr_ARR_CountByZ.value)
	fn_xyzArrRebuild()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_ARR_Input selectionEnd do with undo off 
(
clearSelection()
-- local items = mlbx_ARR_Input.items
-- select (for s in mlbx_ARR_Input.selection where isValidNode (GetNodeByName items[s]) collect (GetNodeByName items[s]))
select (for s in mlbx_ARR_Input.selection where isValidNode inList[s] collect inList[s])
forceCompleteRedraw()
)
on mlbx_ARR_Input rightclick do with undo off (mlbx_ARR_Input.selection = #{})
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_AddObjInput pressed do with undo off
(
inList = ATfn_.ArraysSum (ATfn_.ValidateArray inList) (ATfn_.ArraysDifference (ATfn_.GetNHH (selection as array) true) (fn_FlattenXYZArray()))
mlbx_ARR_Input.items = (for o in inList collect o.name)
if chbtn_ARR_Preview.checked do
	(
	fn_DefineInArr()
	fn_xyzArrReCreate()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_RemoveObjInput pressed do with undo off
(
inList = ATfn_.ArraysDifference (ATfn_.ValidateArray inList) (ATfn_.GetNHH (selection as array) true)
-- inList = ATfn_.ArraysDifference inList (for s in mlbx_ARR_Input.selection where isValidNode inList[s] collect inList[s])
mlbx_ARR_Input.items = (for o in inList collect o.name)
if chbtn_ARR_Preview.checked do
	(
	if fn_DefineInArr()
	then (fn_xyzArrReCreate())
	else (fn_CancelPreview())
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_RemoveAllObjInput pressed do with undo off
(
if chbtn_ARR_Preview.checked do fn_CancelPreview()
inArr = #()
inList = #()
mlbx_ARR_Input.items = #()
mlbx_ARR_Input.selection = #{}
)
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_SelectAllInput pressed do with undo on
(
if rdbtn_ARR_SelectedOrList.state == 1
then
	(
	if chbtn_ARR_Preview.checked
	then
		(
		clearSelection()
		select (ATfn_.ValidateArray inArr)
		redrawviews()
		)
	)
else
	(
	clearSelection()
	inList = ATfn_.ValidateArray inList
	mlbx_ARR_Input.items = (for o in inList collect o.name)
	select inList
	redrawviews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_ARR_SelectedOrList changed state do
((for cntr in rollout_ARR_.controls where (matchPattern cntr.name pattern:"*Input") and not (matchPattern cntr.name pattern:"btn_ARR_SelectAllInput") collect cntr).enabled = (state == 2))
	-------------------------------------------------------------------------------------------------------------------
on btn_ARR_SelLastProcessed pressed do with undo on (select (ATfn_.ValidateArray LastProcessed))
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_ARR_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_Array.checked = true)catch()
	)
on rollout_ARR_ close do
	(
	if chbtn_ARR_Preview.checked do
		(
		)
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_Array.checked = false)catch()
	ATfn_.SaveFloaterINI floater_Array iniFile ExcludedControls
	fn_CancelPreview()
	floater_Array = undefined
	)
)
	----==============================================================================================================
floater_Array = ATfn_.CreateFloater floater_Array iniFile fl0W fl0H floaterTitle #(rollout_ARR_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_Array iniFile ExcludedControls)
	origPos = [floater_Array.rollouts[1].spnr_ARR_OriginByX.value, floater_Array.rollouts[1].spnr_ARR_OriginByY.value, floater_Array.rollouts[1].spnr_ARR_OriginByZ.value]
	floater_Array.rollouts[1].rdbtn_ARR_SelectedOrList.enabled = true
	)
)