(
Global floater_Painter
Global floater_AssemblyTool
try (if floater_Painter.dialogBar then (cui.UnRegisterDialogBar floater_Painter); closeRolloutFloater floater_Painter) catch()
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Painter"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Painter_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,545])[2]
-- local fl0P = ATfn_.GetINI 0 iniFile floaterTitle "LastPosition" [50,50]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
	----=Object Paint======================================================================================================================
local PaintWithArr = #()
local PaintWithSelArr = #()
local PaintOnArr = #()
local SceneObjects = #()
local HidedOnPaint = #()
rollout rollout_OP_ "Painter"
(
local DockX = 181; local DockW = 13
button btn_OP_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_OP_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_OP_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_OP_DockLeft pressed do (ATfn_.DockFloaterSide floater_Painter iniFile "left")
on btn_OP_DockRight pressed do (ATfn_.DockFloaterSide floater_Painter iniFile "right")
on btn_OP_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Painter iniFile fl0W fl0H)
	-------
local yp1 = #(34, 176, 302, 322, 347, 341, 413, 365, 458, 478)
label lbl_OP_lblPaintWith "With :" pos:[2,yp1[1]-32] tooltip:" Paint With Objects "
radiobuttons rdbtn_OP_SelectedOrList "" labels:#("Selected","List") pos:[38,yp1[1]-32] columns:2 offsets:#([0,0],[5,0]) default:(OBJPaintGetSetting 39) tooltip:" Paint With Selected Scene Objects \n Or Paint With Objects In List "
radiobuttons rdbtn_OP_PaintWithAllOrSelected "" labels:#("All","Sel") pos:[3,yp1[1]-16] default:(ATfn_.GetINI 0 iniFile rollout_OP_.title "rdbtn_OP_PaintWithAllOrSelected" 1) offsets:#([0,0],[-1,0]) enabled:(OBJPaintGetSetting 39 == 2) columns:2 tooltip:" Paint With All Or Selected List Objects "
radiobuttons rdbtn_OP_PaintWithRandomOrOrder "" labels:#("Order","Random") pos:[95,yp1[1]-16] default:(ATfn_.GetINI 0 iniFile rollout_OP_.title "rdbtn_OP_PaintWithRandomOrOrder" 1) offsets:#([0,0],[-6,0]) enabled:(OBJPaintGetSetting 39 == 2) columns:2 tooltip:" Paint Randomly Or In List Order "
button btn_OP_PaintWithAddObj "+" width:22 height:21 pos:[0,yp1[1]] images:ATIcons[1] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Add To List "
button btn_OP_PaintWithRemoveObj "-" width:22 height:21 pos:[23,yp1[1]] images:ATIcons[2] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Remove From List "
button btn_OP_PaintWithRemoveAllObj "_" width:22 height:21 pos:[46,yp1[1]] images:ATIcons[3] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Remove All From List "
button btn_OP_PaintWithSelect "Sel" width:22 height:21 pos:[69,yp1[1]] images:ATIcons[4] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Select All List Objects "
button btn_OP_PaintWithSortAlphabet "A-Z" width:22 height:21 pos:[92,yp1[1]] images:ATIcons[27] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Sort List Alphabetically "
button btn_OP_PaintWithSortBySize "Sz" width:22 height:21 pos:[115,yp1[1]] images:ATIcons[22] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Sort List By Objects Size "
button btn_OP_PaintWithSortReverse "R" width:22 height:21 pos:[138,yp1[1]] images:ATIcons[28] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Reverse List Order "
button btn_OP_PaintWithUp "Up" width:22 height:21 pos:[161,yp1[1]] images:ATIcons[23] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Lmb - Move Selected In List Up \n Rmb - Move Selected In List Top "
button btn_OP_PaintWithDown "Dn" width:22 height:21 pos:[185,yp1[1]] images:ATIcons[24] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Lmb - Move Selected In List Down \n Rmb - Move Selected In List Bottom "
multilistBox mlbx_OP_PaintWithList items:(ATfn_.GetINI 0 iniFile rollout_OP_.title "mlbx_OP_PaintWithListItems" #()) \
	selection:(ATfn_.GetINI 0 iniFile rollout_OP_.title "mlbx_OP_PaintWithListSelection" #{}) width:(fl0W-16) height:7 pos:[2,yp1[1]+22] enabled:(OBJPaintGetSetting 39 == 2) tooltip:" Paint With Objects "

label lbl_OP_PaintOn "On :" pos:[2,yp1[2]-16] tooltip:" Paint On Objects "
local GridSceneSelectedDefault = case (OBJPaintGetSetting 18) of (1: 1; 2: 3; 3: 2)
radiobuttons rdbtn_OP_GridSceneSelected "" labels:#("Grid","Scene","Selected") pos:[30,yp1[2]-16] columns:3 offsets:#([0,0],[-9,0],[-8,0]) default:GridSceneSelectedDefault tooltip:" Paint On Grid, Scene \n Or Selected (List) Objects "
button btn_OP_POnAddObj "+" width:22 height:21 pos:[0,yp1[2]] images:ATIcons[1] enabled:(OBJPaintGetSetting 18 == 2) tooltip:" Add To List "
button btn_OP_POnRemoveObj "-" width:22 height:21 pos:[26,yp1[2]] images:ATIcons[2] enabled:(OBJPaintGetSetting 18 == 2) tooltip:" Remove From List "
button btn_OP_POnRemoveAllObj "_" width:22 height:21 pos:[52,yp1[2]] images:ATIcons[3] enabled:(OBJPaintGetSetting 18 == 2) tooltip:" Remove All From List "
button btn_OP_POnSelect "Sel" width:22 height:21 pos:[78,yp1[2]] images:ATIcons[4] enabled:(OBJPaintGetSetting 18 == 2) tooltip:" Select All List Objects "
multilistBox mlbx_OP_POnList items:(ATfn_.GetINI 0 iniFile rollout_OP_.title "mlbx_OP_POnListItems" #()) \
	selection:(ATfn_.GetINI 0 iniFile rollout_OP_.title "mlbx_OP_POnListSelection" #{}) width:(fl0W-16) height:7 pos:[2,yp1[2]+22] enabled:(OBJPaintGetSetting 18 == 2) tooltip:" Paint On Objects "

checkButton chbtn_OP_PaintOnPainted "" pos:[108,yp1[3]] width:14 height:14 checked:(OBJPaintGetSetting 20) highlightColor:colCHBX
label lbl_OP_PaintOnPainted "Paint On Painted" pos:[126,yp1[3]]
spinner spnr_OP_Offset "Offset:" pos:[14,yp1[3]] width:88 range:[0,999999,(OBJPaintGetSetting 19)] type:#float
spinner spnr_OP_Spacing "Spacing:" pos:[10,yp1[4]] width:112 range:[(units.decodeValue "1cm"),999999,(OBJPaintGetSetting 1)] type:#float
button btn_OP_GetMaxSize "<]" pos:[122,yp1[4]] width:16 height:16 tooltip:" Get Spacing By Biggest Object In Selection "
checkButton chbtn_OP_FollowStroke "Follow" pos:[148,yp1[4]-4] width:28 height:25 images:ATIcons[29] checked:(OBJPaintGetSetting 13) highlightColor:colCHBX tooltip:" Follow Stroke "
checkButton chbtn_OP_AlignToNormal "Align" pos:[179,yp1[4]-4] width:28 height:25 images:ATIcons[21] checked:(OBJPaintGetSetting 17) highlightColor:colCHBX tooltip:" Align To Normal "

checkButton chbtn_OP_AlignX "X" pos:[100,yp1[5]] width:18 height:18 checked:(OBJPaintGetSetting 14 == 1) highlightColor:[204,64,64] tooltip:" Uses Paint Object's X Axis For Alignment "
checkButton chbtn_OP_AlignY "Y" pos:[127,yp1[5]] width:18 height:18 checked:(OBJPaintGetSetting 14 == 2) highlightColor:[63,164,63] tooltip:" Uses Paint Object's Y Axis For Alignment "
checkButton chbtn_OP_AlignZ "Z" pos:[154,yp1[5]] width:18 height:18 checked:(OBJPaintGetSetting 14 == 3) highlightColor:[70,114,255] tooltip:" Uses Paint Object's Z Axis For Alignment "
checkButton chbtn_OP_FlipAxis "Flip" pos:[181,yp1[5]] width:26 height:18 checked:(OBJPaintGetSetting 15) highlightColor:colCHBX tooltip:" Reverses Alignment Asis "

groupBox grp_OP_Position "Position" pos:[0,yp1[6]] width:93 height:70
local RMinX = 9
spinner spnr_OP_PositionX "X:" pos:[RMinX,yp1[6]+15] width:80 range:[-999999,999999,(OBJPaintGetSetting 2).X] type:#float enabled:true toolTip:" Random X Position "
spinner spnr_OP_PositionY "Y:" pos:[RMinX,yp1[6]+32] width:80 range:[-999999,999999,(OBJPaintGetSetting 2).Y] type:#float enabled:true toolTip:" Random Y Position "
spinner spnr_OP_PositionZ "Z:" pos:[RMinX,yp1[6]+49] width:80 range:[-999999,999999,(OBJPaintGetSetting 2).Z] type:#float enabled:true toolTip:" Random Z Position "

groupBox grp_OP_Rotation "Rotation" pos:[0,yp1[7]] width:93 height:40
checkButton chbtn_OP_RandomRotationX "X" pos:[6,yp1[7]+15] width:22 height:21 checked:(OBJPaintGetSetting 9) highlightColor:[204,64,64] tooltip:" Lmb - Random Rotation By X Toggle \n Rmb - Random Seed By X "
checkButton chbtn_OP_RandomRotationY "Y" pos:[35,yp1[7]+15] width:22 height:21 checked:(OBJPaintGetSetting 10) highlightColor:[63,164,63] tooltip:" Lmb - Random Rotation By Y Toggle \n Rmb - Random Seed By Y "
checkButton chbtn_OP_RandomRotationZ "Z" pos:[64,yp1[7]+15] width:22 height:21 checked:(OBJPaintGetSetting 11) highlightColor:[70,114,255] tooltip:" Lmb - Random Rotation By Z Toggle \n Rmb - Random Seed By Z "

groupBox grp_OP_Scale "Scale" pos:[96,yp1[8]] width:111 height:88
local SMinX = 123; local SMaxX = SMinX+42; local SY = 18
checkButton chbtn_OP_ScaleEven "Even" pos:[SMinX+10,yp1[8]+10] width:22 height:21 images:ATIcons[30] checked:(OBJPaintGetSetting 27 == 1) highlightColor:colCHBX tooltip:" Same Scaling To All Painted Objects "
checkButton chbtn_OP_ScaleRandom "Random" pos:[SMinX+33,yp1[8]+10] width:22 height:21 images:ATIcons[31] checked:(OBJPaintGetSetting 27 == 2) highlightColor:colCHBX tooltip:" Random Scaling To Each Painted Object \n Rmb - Random Seed "
checkButton chbtn_OP_ScaleRamp "Ramp" pos:[SMinX+56,yp1[8]+10] width:22 height:21 images:ATIcons[32] checked:(OBJPaintGetSetting 27 == 3) highlightColor:colCHBX tooltip:" Scaling Factor Increase Or Decrease \n Throughout The Stroke "
checkButton chbtn_OP_ScaleLock "[" pos:[SMinX-23,yp1[8]+15+SY] width:12 height:50 checked:(OBJPaintGetSetting 28) highlightColor:colCHBX tooltip:" Lock Scale Toggle "
spinner spnr_OP_ScaleXMin "X:" pos:[SMinX,yp1[8]+15+SY] width:42 range:[0,9999,(OBJPaintGetSetting 21)] type:#integer scale:1 enabled:true toolTip:" Random X Scale Minimum "
spinner spnr_OP_ScaleYMin "Y:" pos:[SMinX,yp1[8]+32+SY] width:42 range:[0,9999,(OBJPaintGetSetting 22)] type:#integer scale:1 enabled:true toolTip:" Random Y Scale Minimum "
spinner spnr_OP_ScaleZMin "Z:" pos:[SMinX,yp1[8]+49+SY] width:42 range:[0,9999,(OBJPaintGetSetting 23)] type:#integer scale:1 enabled:true toolTip:" Random Z Scale Minimum "
local ScaleMinCntrls = #(spnr_OP_ScaleXMin,spnr_OP_ScaleYMin,spnr_OP_ScaleZMin)
spinner spnr_OP_ScaleXMax pos:[SMaxX,yp1[8]+15+SY] width:38 range:[0,9999,(OBJPaintGetSetting 24)] type:#integer scale:1 enabled:(OBJPaintGetSetting 27 != 1) toolTip:" Random X Scale Maximum "
spinner spnr_OP_ScaleYMax pos:[SMaxX,yp1[8]+32+SY] width:38 range:[0,9999,(OBJPaintGetSetting 25)] type:#integer scale:1 enabled:(OBJPaintGetSetting 27 != 1) toolTip:" Random Y Scale Maximum "
spinner spnr_OP_ScaleZMax pos:[SMaxX,yp1[8]+49+SY] width:38 range:[0,9999,(OBJPaintGetSetting 26)] type:#integer scale:1 enabled:(OBJPaintGetSetting 27 != 1) toolTip:" Random Z Scale Maximum "
local ScaleMaxCntrls = #(spnr_OP_ScaleXMax,spnr_OP_ScaleYMax,spnr_OP_ScaleZMax)

checkButton chbtn_OP_SetWireColorState pos:[4,yp1[9]] width:14 height:14 highlightColor:colCHBX tooltip:" Set Rundom Wire Color To Processed Objects "
label lbl_OP_SetWireColorState "Set Rundom Wire Color To Processed" pos:[22,yp1[9]]

checkButton chbtn_OP_PaintObjects "Paint" pos:[0,yp1[10]] width:(fl0W-13) height:37 checked:(OBJPaintGetSetting 50) highlightColor:colCHBX tooltip:" Start Paint Objects "
timer tmr_OP_CheckPaintObjects interval:100 active:(OBJPaintGetSetting 50)
on tmr_OP_CheckPaintObjects tick do
(
if not (OBJPaintGetSetting 50) do
	(
	tmr_OP_CheckPaintObjects.active = false
	chbtn_OP_PaintObjects.checked = false
	resumeEditing()
	clearUndoBuffer()
	local newArr = ATfn_.ArraysDifference (Objects as array) SceneObjects
	if newArr.count > 0 do
		(
		select newArr
		if chbtn_OP_SetWireColorState.checked do (newArr.wirecolor = ATfn_.RandomColor())
		)
	HidedOnPaint.isHidden = true
	resetPivot PaintWithArr; resetPivot PaintWithSelArr; resetPivot selection
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_VerifyItems =
(
PaintWithArr = ATfn_.VerifyControlItems mlbx_OP_PaintWithList
PaintOnArr = ATfn_.VerifyControlItems mlbx_OP_POnList
)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_InitializeList listcntrl arr = (listcntrl.items = (for o in arr collect o.name))
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_ValidateArr arr = (for o in arr where isValidNode o collect o)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_ObjectPaintSetDefaultSettings =
(
local settingsdir = getdir #plugcfg_ln + ("\\PolyTools\\ObjectPaint\\Settings\\")
local settingsfilename = settingsdir + "Default.txt"
if not (doesFileExist settingsfilename) do (createfile settingsfilename)
if (doesFileExist settingsfilename) and (getFileAttribute settingsfilename #readOnly) do (setFileAttribute settingsfilename #readOnly false)
local settingsfile = openFile settingsfilename mode:"w+"
if settingsfile != undefined do
	(
	format "#(" to:settingsfile
	for i = 1 to 37 do
		(
		curset = (OBJPaintGetSetting i) as string
		format curset to:settingsfile
		if i < 37 do format "," to:settingsfile
		)
	format ")" to:settingsfile
	close settingsfile
	)
)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_cntrlEnable rollout_ pat st = (for c in rollout_.controls where (matchPattern c.name pattern:pat) do c.enabled = st)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OP_GridSceneSelected changed state do with undo off
(
case state of
	(
	1: (OBJPaintSetSetting 18 1; fn_cntrlEnable rollout_OP_ "*_POn*" false)
	2: (OBJPaintSetSetting 18 3; fn_cntrlEnable rollout_OP_ "*_POn*" false)
	3: (OBJPaintSetSetting 18 2; fn_cntrlEnable rollout_OP_ "*_POn*" true)
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OP_SelectedOrList changed state do with undo off
(
case state of
	(
	1: (OBJPaintSetSetting 39 1; fn_cntrlEnable rollout_OP_ "*_PaintWith*" false)
	2: (OBJPaintSetSetting 39 2; fn_cntrlEnable rollout_OP_ "*_PaintWith*" true)
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OP_PaintWithAllOrSelected changed state do with undo off
(
if chbtn_OP_PaintObjects.checked do
	(
	local SetState = true
	local PaintWithListSel = mlbx_OP_PaintWithList.selection as array
	case state of
		(
		1:
			(
			ObjectPaint.Nodes = PaintWithArr
			ObjectPaint.NodeNames = for objct in PaintWithArr collect objct.name
			)
		2: 
			(
			if PaintWithListSel.count != 0
			then
				(
				ObjectPaint.Nodes = for so in PaintWithListSel collect PaintWithArr[so]
				ObjectPaint.NodeNames = for objct in ObjectPaint.Nodes collect objct.name
				)
			else (messagebox "Select Objects In List." title:" Painter"; SetState = false)
			)
		)
	if SetState do (PolyBOBJPaintSetup ObjectPaint.Nodes 1)
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OP_PaintWithRandomOrOrder changed state do with undo off
(
if chbtn_OP_PaintObjects.checked do
	(
	case state of
		(
		1: (OBJPaintSetSetting 16 false; OBJPaintSetSetting 38 true)
		2: (OBJPaintSetSetting 16 true; OBJPaintSetSetting 38 true)
		)
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on mlbx_OP_PaintWithList selectionEnd do with undo off
(
local PaintWithListSel = mlbx_OP_PaintWithList.selection as array
if chbtn_OP_PaintObjects.checked
then
	(
	ObjectPaint.Nodes = for so in PaintWithListSel collect PaintWithArr[so]
	ObjectPaint.NodeNames = for objct in ObjectPaint.Nodes collect objct.name
	PolyBOBJPaintSetup ObjectPaint.Nodes 1
-- 	PolyBOBJInterActiveUpdate()
	)
else (select (for so in PaintWithListSel collect PaintWithArr[so]))
redrawviews()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithSelect pressed do with undo on (clearSelection(); select PaintWithArr; redrawviews())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithRemoveAllObj pressed do with undo off (PaintWithArr = #(); mlbx_OP_PaintWithList.items = #())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithRemoveObj pressed do with undo off
(
-- for objct in selection where (findItem PaintWithArr objct != 0) do (deleteItem PaintWithArr (findItem PaintWithArr objct))
-- fn_InitializeList mlbx_OP_PaintWithList PaintWithArr
-- mlbx_OP_PaintWithList.selection = #{}
PaintWithArr = ATfn_.RemoveListBoxObjects (ATfn_.GetNHH (selection as array) true) mlbx_OP_PaintWithList PaintWithArr
mlbx_OP_PaintWithList.selection = #{}
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithAddObj pressed do with undo off
(
local selArr = ATfn_.GetNHH (selection as array) true
if (ATfn_.CheckEmpty selArr) do
	(
	PaintWithArr = ATfn_.AddListBoxObjects selArr mlbx_OP_PaintWithList PaintWithArr
	PaintOnArr = ATfn_.RemoveListBoxObjects selArr mlbx_OP_POnList PaintOnArr
	mlbx_OP_PaintWithList.selection = mlbx_OP_POnList.selection = #{}
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithDown pressed do with undo off (ATfn_.MoveInListDown mlbx_OP_PaintWithList PaintWithArr false)
on btn_OP_PaintWithDown rightclick do with undo off (ATfn_.MoveInListDown mlbx_OP_PaintWithList PaintWithArr true)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithUp pressed do with undo off (ATfn_.MoveInListUp mlbx_OP_PaintWithList PaintWithArr false)
on btn_OP_PaintWithUp rightclick do with undo off (ATfn_.MoveInListUp mlbx_OP_PaintWithList PaintWithArr true)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithSortAlphabet pressed do with undo off
(
local SelNames = for nn in (mlbx_OP_PaintWithList.selection as array) collect mlbx_OP_PaintWithList.items[nn]
qsort PaintWithArr ATfn_.CompareNames
fn_InitializeList mlbx_OP_PaintWithList PaintWithArr
mlbx_OP_PaintWithList.selection = for sn in SelNames collect findItem mlbx_OP_PaintWithList.items sn
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithSortBySize pressed do with undo off
(
local SelNames = for nn in (mlbx_OP_PaintWithList.selection as array) collect mlbx_OP_PaintWithList.items[nn]
qsort PaintWithArr ATfn_.CompareBySizeDecrease
fn_InitializeList mlbx_OP_PaintWithList PaintWithArr
mlbx_OP_PaintWithList.selection = for sn in SelNames collect findItem mlbx_OP_PaintWithList.items sn
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_PaintWithSortReverse pressed do with undo off
(
local SelNames = for nn in (mlbx_OP_PaintWithList.selection as array) collect mlbx_OP_PaintWithList.items[nn]
PaintWithArr = for i=PaintWithArr.count to 1 by -1 collect PaintWithArr[i]
fn_InitializeList mlbx_OP_PaintWithList PaintWithArr
mlbx_OP_PaintWithList.selection = for sn in SelNames collect findItem mlbx_OP_PaintWithList.items sn
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on mlbx_OP_POnList selectionEnd do with undo off
(
local PaintOnListSel = mlbx_OP_POnList.selection as array
select (for so in PaintOnListSel collect PaintOnArr[so])
-- if chbtn_OP_PaintObjects.checked and (OBJPaintGetSetting 18 == 2) do
-- 	(
-- 	select (for so in PaintOnListSel collect PaintOnArr[so])
-- 	)
redrawviews()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_POnSelect pressed do with undo on (clearSelection(); select PaintOnArr; redrawviews())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_POnRemoveAllObj pressed do with undo off (PaintOnArr = #(); mlbx_OP_POnList.items = #())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_POnRemoveObj pressed do with undo off
(
PaintOnArr = ATfn_.RemoveListBoxObjects (ATfn_.GetNHH (selection as array) true) mlbx_OP_POnList PaintOnArr
mlbx_OP_POnList.selection = #{}
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_POnAddObj pressed do with undo off
(
local selArr = ATfn_.GetNHH (selection as array) true
if (ATfn_.CheckEmpty selArr) do
	(
	PaintOnArr = ATfn_.AddListBoxObjects selArr mlbx_OP_POnList PaintOnArr
	PaintWithArr = ATfn_.RemoveListBoxObjects selArr mlbx_OP_PaintWithList PaintWithArr
	mlbx_OP_PaintWithList.selection = mlbx_OP_POnList.selection = #{}
	)
)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_setScaleVal v1 v2 v3 val CntrlsArr = (OBJPaintSetSetting v1 val; if (OBJPaintGetSetting 28) do (OBJPaintSetSetting v2 val; OBJPaintSetSetting v3 val; CntrlsArr.value = val))
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleZMax changed val do
(
case (OBJPaintGetSetting 27) of
	(
	2: (fn_setScaleVal 26 24 25 val ScaleMaxCntrls; if val < (OBJPaintGetSetting 23) do (fn_setScaleVal 23 21 22 val ScaleMinCntrls))
	3: (fn_setScaleVal 34 32 33 val ScaleMaxCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleYMax changed val do
(
case (OBJPaintGetSetting 27) of
	(
	2: (fn_setScaleVal 25 26 24 val ScaleMaxCntrls; if val < (OBJPaintGetSetting 22) do (fn_setScaleVal 22 23 21 val ScaleMinCntrls))
	3: (fn_setScaleVal 33 34 32 val ScaleMaxCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleXMax changed val do
(
case (OBJPaintGetSetting 27) of
	(
	2: (fn_setScaleVal 24 25 26 val ScaleMaxCntrls; if val < (OBJPaintGetSetting 21) do (fn_setScaleVal 21 22 23 val ScaleMinCntrls))
	3: (fn_setScaleVal 32 33 34 val ScaleMaxCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleZMin changed val do
(
case (OBJPaintGetSetting 27) of
	(
	1: (fn_setScaleVal 8 6 7 val ScaleMinCntrls)
	2: (fn_setScaleVal 23 21 22 val ScaleMinCntrls; if val > (OBJPaintGetSetting 26) do (fn_setScaleVal 26 24 25 val ScaleMaxCntrls))
	3: (fn_setScaleVal 31 29 30 val ScaleMinCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleYMin changed val do
(
case (OBJPaintGetSetting 27) of
	(
	1: (fn_setScaleVal 7 8 6 val ScaleMinCntrls)
	2: (fn_setScaleVal 22 23 21 val ScaleMinCntrls; if val > (OBJPaintGetSetting 25) do (fn_setScaleVal 25 26 24 val ScaleMaxCntrls))
	3: (fn_setScaleVal 30 31 29 val ScaleMinCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_ScaleXMin changed val do
(
case (OBJPaintGetSetting 27) of
	(
	1: (fn_setScaleVal 6 7 8 val ScaleMinCntrls)
	2: (fn_setScaleVal 21 22 23 val ScaleMinCntrls; if val > (OBJPaintGetSetting 24) do (fn_setScaleVal 24 25 26 val ScaleMaxCntrls))
	3: (fn_setScaleVal 29 30 31 val ScaleMinCntrls)
	)
PolyBOBJInterActiveUpdate()
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_ScaleRamp changed state do
(
OBJPaintSetSetting 27 3; PolyBOBJInterActiveUpdate()
ScaleMaxCntrls.enabled = true
chbtn_OP_ScaleRamp.checked = true; chbtn_OP_ScaleEven.checked = chbtn_OP_ScaleRandom.checked = false
spnr_OP_ScaleXMin.value = OBJPaintGetSetting 29; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 30; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 31
spnr_OP_ScaleXMax.value = OBJPaintGetSetting 32; spnr_OP_ScaleYMax.value = OBJPaintGetSetting 33; spnr_OP_ScaleZMax.value = OBJPaintGetSetting 34
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_ScaleRandom changed state do
(
OBJPaintSetSetting 27 2; PolyBOBJInterActiveUpdate()
ScaleMaxCntrls.enabled = true
chbtn_OP_ScaleRandom.checked = true; chbtn_OP_ScaleEven.checked = chbtn_OP_ScaleRamp.checked = false
spnr_OP_ScaleXMin.value = OBJPaintGetSetting 21; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 22; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 23
spnr_OP_ScaleXMax.value = OBJPaintGetSetting 24; spnr_OP_ScaleYMax.value = OBJPaintGetSetting 25; spnr_OP_ScaleZMax.value = OBJPaintGetSetting 26
)
on chbtn_OP_ScaleRandom rightclick do (OBJPaintSetSetting 27 2; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_ScaleEven changed state do
(
OBJPaintSetSetting 27 1; PolyBOBJInterActiveUpdate()
ScaleMaxCntrls.enabled = false
chbtn_OP_ScaleEven.checked = true; chbtn_OP_ScaleRandom.checked = chbtn_OP_ScaleRamp.checked = false
spnr_OP_ScaleXMin.value = OBJPaintGetSetting 6; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 7; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 8
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_ScaleLock changed state do (OBJPaintSetSetting 28 state; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_PositionX changed val do (local curScatter = OBJPaintGetSetting 2; curScatter.x = val; OBJPaintSetSetting 2 curScatter; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_PositionY changed val do (local curScatter = OBJPaintGetSetting 2; curScatter.y = val; OBJPaintSetSetting 2 curScatter; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_PositionZ changed val do (local curScatter = OBJPaintGetSetting 2; curScatter.z = val; OBJPaintSetSetting 2 curScatter; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_RandomRotationX changed state do (OBJPaintSetSetting 9 state; PolyBOBJInterActiveUpdate())
on chbtn_OP_RandomRotationX rightclick do (if chbtn_OP_RandomRotationX.checked do (OBJPaintSetSetting 9 true; PolyBOBJInterActiveUpdate()))
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_RandomRotationY changed state do (OBJPaintSetSetting 10 state; PolyBOBJInterActiveUpdate())
on chbtn_OP_RandomRotationY rightclick do (if chbtn_OP_RandomRotationY.checked do (OBJPaintSetSetting 10 true; PolyBOBJInterActiveUpdate()))
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_RandomRotationZ changed state do (OBJPaintSetSetting 11 state; PolyBOBJInterActiveUpdate())
on chbtn_OP_RandomRotationZ rightclick do (if chbtn_OP_RandomRotationZ.checked do (OBJPaintSetSetting 11 true; PolyBOBJInterActiveUpdate()))
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_AlignX changed state do (OBJPaintSetSetting 14 1; PolyBOBJInterActiveUpdate(); chbtn_OP_AlignY.checked = chbtn_OP_AlignZ.checked = false; chbtn_OP_AlignX.checked = true)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_AlignY changed state do (OBJPaintSetSetting 14 2; PolyBOBJInterActiveUpdate(); chbtn_OP_AlignX.checked = chbtn_OP_AlignZ.checked = false; chbtn_OP_AlignY.checked = true)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_AlignZ changed state do (OBJPaintSetSetting 14 3; PolyBOBJInterActiveUpdate(); chbtn_OP_AlignX.checked = chbtn_OP_AlignY.checked = false; chbtn_OP_AlignZ.checked = true)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_FlipAxis changed state do (OBJPaintSetSetting 15 state; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_AlignToNormal changed state do (OBJPaintSetSetting 17 state; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_FollowStroke changed state do (OBJPaintSetSetting 13 state; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_PaintOnPainted changed state do (OBJPaintSetSetting 20 (not OBJPaintGetSetting 20); updateToolbarButtons())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_Offset changed val do (OBJPaintSetSetting 19 val; PolyBOBJInterActiveUpdate())
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OP_GetMaxSize pressed do
(
local inArr = #()
case (OBJPaintGetSetting 39) of
	(
	1: (inArr = ATfn_.GetNHH (selection as array) true)
	2:
		(
		local PaintWithListSel = mlbx_OP_PaintWithList.selection as array
		case (rdbtn_OP_PaintWithAllOrSelected.state) of
			(
			1: (inArr = PaintWithArr)
			2: 
				(
				if PaintWithListSel.count != 0
				then (inArr = for so in PaintWithListSel collect PaintWithArr[so])
				else (messagebox "Select List Objects To Paint With." title:" Painter")
				)
			)
		)
	)
if inArr.count > 0 do
	(
	local SizeArr = #()
	for objct in inArr do (append SizeArr (distance objct.min objct.max))
-- 	local mmArr = ATfn_.GetMinMax inArr
-- 	for n=1 to inArr.count do (append SizeArr (distance mmArr[1][n] mmArr[2][n]))
-- 	local maxSpacing = ceil ((amax SizeArr)/2)
	local maxSpacing = ceil ((amax SizeArr)/1.5)
	spnr_OP_Spacing.value = maxSpacing
	PolyBOBJSpacingChangeStart()
	OBJPaintSetSetting 1 maxSpacing
	PolyBOBJInterActiveUpdate()
	PolyBOBJSpacingChangeEnd()
	)
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on spnr_OP_Spacing buttondown do (PolyBOBJSpacingChangeStart(); ObjectPaint.hasStartedSpacingButtonDown = true)
	------------------------------------------------------------------------
on spnr_OP_Spacing buttonup do (PolyBOBJSpacingChangeEnd(); ObjectPaint.hasStartedSpacingButtonDown = false)
	------------------------------------------------------------------------
on spnr_OP_Spacing changed val do
(
if (not ObjectPaint.hasStartedSpacingButtonDown)
then --value is typed in manually
	(
	PolyBOBJSpacingChangeStart()
	OBJPaintSetSetting 1 val
	PolyBOBJInterActiveUpdate()
	PolyBOBJSpacingChangeEnd()
	)
else (OBJPaintSetSetting 1 val; PolyBOBJInterActiveUpdate())
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OP_PaintObjects changed state do
(
PaintWithSelArr = #()
local PaintWithListSel = mlbx_OP_PaintWithList.selection as array
case (OBJPaintGetSetting 39) of
(
1: (
	PaintWithSelArr = ATfn_.GetNHH (selection as array) true
	if PaintWithSelArr.count == 0 do (chbtn_OP_PaintObjects.checked = false; return messagebox "Select Objects To Paint With." title:" Painter")
	if not (ATfn_.CheckEmpty PaintWithSelArr) do (chbtn_OP_PaintObjects.checked = false; return false)
	)
2: (
	if PaintWithArr.count == 0 do (chbtn_OP_PaintObjects.checked = false; return messagebox "Add List Objects To Paint With." title:" Painter")
	if rdbtn_OP_PaintWithAllOrSelected.state == 2 and PaintWithListSel.count == 0 do (chbtn_OP_PaintObjects.checked = false; return messagebox "Select List Objects To Paint With." title:" Painter")
	)
)
if rdbtn_OP_GridSceneSelected.state == 3 and PaintOnArr.count == 0 do (chbtn_OP_PaintObjects.checked = false; return messagebox "Add List Objects To Paint On." title:" Painter")

HidedOnPaint = for o in PaintWithArr where o.isHidden collect o
HidedOnPaint.isHidden = false

if state
then
(
suspendEditing()
case (OBJPaintGetSetting 39) of
(
1: --Paint with selected objects
	(
	ResetScale PaintWithSelArr
	local Xst = 0; local Yst = 0; local Zst = 0
	case (OBJPaintGetSetting 14) of
		(
		1: Xst = (if (OBJPaintGetSetting 15) then 2 else 1)
		2: Yst = (if (OBJPaintGetSetting 15) then 2 else 1)
		3: Zst = (if (OBJPaintGetSetting 15) then 2 else 1)
		)
	ATfn_.SetPivot PaintWithSelArr Xst Yst Zst true --- Set Pivot
	PolyBOBJPaintSetup PaintWithSelArr 1
	)
2: --Use objects in list
	(
	ResetScale PaintWithArr
	local Xst = 0; local Yst = 0; local Zst = 0
	case (OBJPaintGetSetting 14) of
		(
		1: Xst = (if (OBJPaintGetSetting 15) then 2 else 1)
		2: Yst = (if (OBJPaintGetSetting 15) then 2 else 1)
		3: Zst = (if (OBJPaintGetSetting 15) then 2 else 1)
		)
	ATfn_.SetPivot PaintWithArr Xst Yst Zst true --- Set Pivot
	case (rdbtn_OP_PaintWithAllOrSelected.state) of
		(
		1:
			(
			ObjectPaint.Nodes = PaintWithArr
			ObjectPaint.NodeNames = for objct in PaintWithArr collect objct.name
			)
		2: 
			(
			ObjectPaint.Nodes = for so in PaintWithListSel collect PaintWithArr[so]
			ObjectPaint.NodeNames = for objct in ObjectPaint.Nodes collect objct.name
			)
		)
	case (rdbtn_OP_PaintWithRandomOrOrder.state) of
		(
		1: (OBJPaintSetSetting 16 false; OBJPaintSetSetting 38 true)
		2: (OBJPaintSetSetting 16 true; OBJPaintSetSetting 38 true)
		)
	---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	PolyBOBJPaintSetup ObjectPaint.Nodes 1
	---vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	)
)
if (OBJPaintGetSetting 18 == 2) do
	(
	local PaintOnListSel = mlbx_OP_POnList.selection as array
-- 	undo on
	if PaintOnListSel.count > 0
	then (select (for so in PaintOnListSel collect PaintOnArr[so]))
	else (select PaintOnArr)
	)
	---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SceneObjects = Objects as array
PBStartTrack PolyBOBJPaint --Paint
	---vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
)
else 
	(
	PBEndTrack(); PolyBOBJEndPaint(); resumeEditing()
	clearUndoBuffer()
	local newArr = ATfn_.ArraysDifference (Objects as array) SceneObjects
	if newArr.count > 0 do
		(
		select newArr
		if chbtn_OP_SetWireColorState.checked do (newArr.wirecolor = ATfn_.RandomColor())
		)
	HidedOnPaint.isHidden = true
	resetPivot PaintWithArr; resetPivot PaintWithSelArr; resetPivot selection
	)
tmr_OP_CheckPaintObjects.active = state
)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_OP_ open do
	(
-- 	PaintWithArr = fn_ValidateArr PaintWithArr
	OBJPaintSetSetting 3 0 ---ObjectPaintRotXSpinner
	OBJPaintSetSetting 4 0 ---ObjectPaintRotYSpinner
	OBJPaintSetSetting 5 0 ---ObjectPaintRotZSpinner
	case (OBJPaintGetSetting 27) of
		(
		1: (
			spnr_OP_ScaleXMin.value = OBJPaintGetSetting 6; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 7; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 8
			)
		2: (
			spnr_OP_ScaleXMin.value = OBJPaintGetSetting 21; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 22; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 23
			spnr_OP_ScaleXMax.value = OBJPaintGetSetting 24; spnr_OP_ScaleYMax.value = OBJPaintGetSetting 25; spnr_OP_ScaleZMax.value = OBJPaintGetSetting 26
			)
		3: (
			spnr_OP_ScaleXMin.value = OBJPaintGetSetting 29; spnr_OP_ScaleYMin.value = OBJPaintGetSetting 30; spnr_OP_ScaleZMin.value = OBJPaintGetSetting 31
			spnr_OP_ScaleXMax.value = OBJPaintGetSetting 32; spnr_OP_ScaleYMax.value = OBJPaintGetSetting 33; spnr_OP_ScaleZMax.value = OBJPaintGetSetting 34
			)
		)
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Painter.checked = true)
	callbacks.addScript #nodePostDelete "floater_Painter.rollouts[1].fn_VerifyItems()" id:#ATcallbacks_OP_
	callbacks.addScript #filePostOpenProcess "floater_Painter.rollouts[1].fn_VerifyItems()" id:#ATcallbacks_OP_
	)
on rollout_OP_ close do
	(
	PBEndTrack()
	PolyBOBJEndPaint()
	resumeEditing()
	tmr_OP_CheckPaintObjects.active = false
	fn_ObjectPaintSetDefaultSettings()
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Painter.checked = false)
	setINISetting iniFile rollout_OP_.title "mlbx_OP_PaintWithListItems" (with printAllElements on ((mlbx_OP_PaintWithList.items) as string))
	setINISetting iniFile rollout_OP_.title "mlbx_OP_POnListItems" (with printAllElements on ((mlbx_OP_POnList.items) as string))
	setINISetting iniFile rollout_OP_.title "mlbx_OP_PaintWithListSelection" (with printAllElements on ((mlbx_OP_PaintWithList.selection) as string))
	setINISetting iniFile rollout_OP_.title "mlbx_OP_POnListSelection" (with printAllElements on ((mlbx_OP_POnList.selection) as string))
	setINISetting iniFile rollout_OP_.title "rdbtn_OP_PaintWithAllOrSelected" ((rdbtn_OP_PaintWithAllOrSelected.state) as string)
	setINISetting iniFile rollout_OP_.title "rdbtn_OP_PaintWithRandomOrOrder" ((rdbtn_OP_PaintWithRandomOrOrder.state) as string)
	ATfn_.SaveFloaterPosSize floater_Painter iniFile
	callbacks.removeScripts id:#ATcallbacks_OP_
	floater_Painter = undefined
	)
)
	----================================================================================================================================
floater_Painter = ATfn_.CreateFloater floater_Painter iniFile fl0W fl0H floaterTitle #(rollout_OP_)
on execute do
	(
	if not ATfn_.GetINI 0 ((getFilenamePath (getThisScriptFilename())) + "INI\AssemblyTool_Settings.ini") "Preferences" "TooltipShow" true do
		(for r in floater_Painter.Rollouts do (for c in r.controls do try(c.tooltip = "")catch()))
	floater_Painter.rollouts[1].fn_VerifyItems()
	)
)