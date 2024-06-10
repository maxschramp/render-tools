	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_Randomizer
Global floater_AssemblyTool
try (if floater_Randomizer.dialogBar then (cui.UnRegisterDialogBar floater_Randomizer); closeRolloutFloater floater_Randomizer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Randomizer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Randomizer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,480])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_RZ_DockLeft", "btn_RZ_DockFloat", "btn_RZ_DockRight",
	"chbtn_RZ_Preview")
	-------------------------------------------------------------------------------------------------------------------
	----=Randomizer==============================================================================================
rollout rollout_RZ_ "Randomizer"
(
---free >>    f
local yp1 = #(0, 10, 135, 260, 388, 412)
local DockX = 181; local DockW = 13
button btn_RZ_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_RZ_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_RZ_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_RZ_DockLeft pressed do (ATfn_.DockFloaterSide floater_Randomizer iniFile "left")
on btn_RZ_DockRight pressed do (ATfn_.DockFloaterSide floater_Randomizer iniFile "right")
on btn_RZ_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Randomizer iniFile fl0W fl0H)
	-------
-- button btn_RZ_ReinitializeInput "Reinitialize Input" pos:[0,yp1[1]] width:206 height:23 enbled:false tooltip:" Reinitialize Input Selection "

GroupBox grp_RZ_RandPosition "Position" pos:[2,yp1[2]] width:(fl0W-16) height:123
local SpWdp = 65; local PTogX = 8
checkButton chbtn_RZ_RandPositionXTogg "X" pos:[PTogX,yp1[2]+15] width:18 height:18 highlightColor:[204,64,64] tooltip:" X Position Toggle "
checkButton chbtn_RZ_RandPositionYTogg "Y" pos:[PTogX,yp1[2]+34] width:18 height:18 highlightColor:[63,164,63] tooltip:" Y Position Toggle "
checkButton chbtn_RZ_RandPositionZTogg "Z" pos:[PTogX,yp1[2]+53] width:18 height:18 highlightColor:[70,114,255] tooltip:" Z Position Toggle "
local PMinX = PTogX+22; local Pscale = .1
spinner spnr_RZ_RandPositionXMin pos:[PMinX,yp1[2]+16] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" X Position Minimum "
spinner spnr_RZ_RandPositionYMin pos:[PMinX,yp1[2]+35] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Y Position Minimum "
spinner spnr_RZ_RandPositionZMin pos:[PMinX,yp1[2]+54] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Z Position Minimum "
label lbl_RZ_RandPositionAllMin1 "]" pos:[PMinX+74,yp1[2]+22]
spinner spnr_RZ_RandPositionAllMin pos:[PMinX+67,yp1[2]+35] width:16 range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Position All Minimum "
label lbl_RZ_RandPositionAllMin2 "]" pos:[PMinX+74,yp1[2]+49]
local PMaxX = PMinX+87
spinner spnr_RZ_RandPositionXMax pos:[PMaxX,yp1[2]+16] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" X Position Maximum "
spinner spnr_RZ_RandPositionYMax pos:[PMaxX,yp1[2]+35] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Y Position Maximum "
spinner spnr_RZ_RandPositionZMax pos:[PMaxX,yp1[2]+54] width:SpWdp range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Z Position Maximum "
label lbl_RZ_RandPositionAllMax1 "]" pos:[PMaxX+74,yp1[2]+22]
spinner spnr_RZ_RandPositionAllMax pos:[PMaxX+67,yp1[2]+35] width:16 range:[-999999,999999,0] type:#float scale:Pscale toolTip:" Position All Maximum "
label lbl_RZ_RandPositionAllMax2 "]" pos:[PMaxX+74,yp1[2]+49]
button btn_RZ_RandPositionSeed "Random Seed" pos:[8,yp1[2]+73] width:100 height:21 enbled:false tooltip:" Randomly Move Selected "
button btn_RZ_RandPositionZero "Position To 0" pos:[111,yp1[2]+73] width:89 height:21 tooltip:" Position To 0 By Checked Axis "
button btn_RZ_RandPositionRandSpiners "Randomize Spiners" pos:[8,yp1[2]+97] width:105 height:21 toolTip:" Randomly Position Spiners Value "
button btn_RZ_RandPositionResetSpiners "Reset Spiners" pos:[116,yp1[2]+97] width:85 height:21 toolTip:" Reset Position Spiners Value "

GroupBox grp_RZ_RandRotation "Rotation" pos:[2,yp1[3]] width:(fl0W-16) height:123
local SpWdr = 65; local RTogX = 8
checkButton chbtn_RZ_RandRotationXTogg "X" pos:[RTogX,yp1[3]+15] width:18 height:18 highlightColor:[204,64,64] tooltip:" X Rotation Toggle "
checkButton chbtn_RZ_RandRotationYTogg "Y" pos:[RTogX,yp1[3]+34] width:18 height:18 highlightColor:[63,164,63] tooltip:" Y Rotation Toggle "
checkButton chbtn_RZ_RandRotationZTogg "Z" pos:[RTogX,yp1[3]+53] width:18 height:18 highlightColor:[70,114,255] tooltip:" Z Rotation Toggle "
local RMinX = RTogX+22; local Rscale = .1
spinner spnr_RZ_RandRotationXMin pos:[RMinX,yp1[3]+16] width:SpWdr range:[-360,360,-0] type:#float scale:Rscale toolTip:" X Rotation CCW "
spinner spnr_RZ_RandRotationYMin pos:[RMinX,yp1[3]+35] width:SpWdr range:[-360,360,-0] type:#float scale:Rscale toolTip:" Y Rotation CCW "
spinner spnr_RZ_RandRotationZMin pos:[RMinX,yp1[3]+54] width:SpWdr range:[-360,360,-0] type:#float scale:Rscale toolTip:" Z Rotation CCW "
label lbl_RZ_RandRotationAllMin1 "]" pos:[RMinX+74,yp1[3]+22]
spinner spnr_RZ_RandRotationAllMin pos:[RMinX+67,yp1[3]+35] width:16 range:[-999999,999999,0] type:#float scale:Rscale toolTip:" Rotation All Minimum "
label lbl_RZ_RandRotationAllMin2 "]" pos:[RMinX+74,yp1[3]+49]
local RMaxX = RMinX+87
spinner spnr_RZ_RandRotationXMax pos:[RMaxX,yp1[3]+16] width:SpWdr range:[-360,360,0] type:#float scale:Rscale toolTip:" X Rotation CW "
spinner spnr_RZ_RandRotationYMax pos:[RMaxX,yp1[3]+35] width:SpWdr range:[-360,360,0] type:#float scale:Rscale toolTip:" Y Rotation CW "
spinner spnr_RZ_RandRotationZMax pos:[RMaxX,yp1[3]+54] width:SpWdr range:[-360,360,0] type:#float scale:Rscale toolTip:" Z Rotation CW "
label lbl_RZ_RandRotationAllMax1 "]" pos:[RMaxX+74,yp1[3]+22]
spinner spnr_RZ_RandRotationAllMax pos:[RMaxX+67,yp1[3]+35] width:16 range:[-999999,999999,0] type:#float scale:Rscale toolTip:" Rotation All Maximum "
label lbl_RZ_RandRotationAllMax2 "]" pos:[RMaxX+74,yp1[3]+49]
button btn_RZ_RandRotationSeed "Random Seed" pos:[8,yp1[3]+73] width:100 height:21 enbled:false tooltip:" Randomly Rotate Selected "
button btn_RZ_RandRotationZero "Rotation To 0" pos:[111,yp1[3]+73] width:89 height:21 tooltip:" Align Objects To World Axis "
button btn_RZ_RandRotationRandSpiners "Randomize Spiners" pos:[8,yp1[3]+97] width:105 height:21 toolTip:" Randomly Rotation Spiners Value "
button btn_RZ_RandRotationResetSpiners "Reset Spiners" pos:[116,yp1[3]+97] width:85 height:21 toolTip:" Reset Rotation Spiners Value "

GroupBox grp_RZ_RandScale "Scale" pos:[2,yp1[4]] width:(fl0W-16) height:123
local SpWds = 55; local STogX = 8
checkButton chbtn_RZ_RandScaleXTogg "X" pos:[STogX,yp1[4]+15] width:18 height:18 highlightColor:[204,64,64] tooltip:" X Scale Toggle "
checkButton chbtn_RZ_RandScaleYTogg "Y" pos:[STogX,yp1[4]+34] width:18 height:18 highlightColor:[63,164,63] tooltip:" Y Scale Toggle "
checkButton chbtn_RZ_RandScaleZTogg "Z" pos:[STogX,yp1[4]+53] width:18 height:18 highlightColor:[70,114,255] tooltip:" Z Scale Toggle "
local SMinX = STogX+22; local Sscale = 1
spinner spnr_RZ_RandScaleXMin pos:[SMinX,yp1[4]+16] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleXTogg.state) toolTip:" X Scale Minimum "
spinner spnr_RZ_RandScaleYMin pos:[SMinX,yp1[4]+35] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleYTogg.state) toolTip:" Y Scale Minimum "
spinner spnr_RZ_RandScaleZMin pos:[SMinX,yp1[4]+54] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleZTogg.state) toolTip:" Z Scale Minimum "
label lbl_RZ_RandScaleAllMin1 "]" pos:[SMinX+64,yp1[4]+22]
spinner spnr_RZ_RandScaleAllMin pos:[SMinX+57,yp1[4]+35] width:16 range:[-999999,999999,0] type:#float scale:Sscale toolTip:" All Scales Minimum "
label lbl_RZ_RandScaleAllMin2 "]" pos:[SMinX+64,yp1[4]+49]
local SMaxX = SMinX+77
spinner spnr_RZ_RandScaleXMax pos:[SMaxX,yp1[4]+16] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleXTogg.state) toolTip:" X Scale Maximum "
spinner spnr_RZ_RandScaleYMax pos:[SMaxX,yp1[4]+35] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleYTogg.state) toolTip:" Y Scale Maximum "
spinner spnr_RZ_RandScaleZMax pos:[SMaxX,yp1[4]+54] width:SpWds range:[1,9999,100] type:#float scale:Sscale enabled:(chbtn_RZ_RandScaleZTogg.state) toolTip:" Z Scale Maximum "
label lbl_RZ_RandScaleAllMax1 "]" pos:[SMaxX+64,yp1[4]+22]
spinner spnr_RZ_RandScaleAllMax pos:[SMaxX+57,yp1[4]+35] width:16 range:[-999999,999999,0] type:#float scale:Sscale toolTip:" Scale All Maximum "
label lbl_RZ_RandScaleAllMax2 "]" pos:[SMaxX+64,yp1[4]+49]
checkButton chbtn_RZ_RandScaleLock " ]" pos:[186,yp1[4]+15] width:12 height:56 checked:true highlightColor:colCHBX tooltip:" Lock Scale Toggle "
button btn_RZ_RandScaleSeed "Random Seed" pos:[8,yp1[4]+73] width:100 height:21 enbled:false tooltip:" Randomly Scale Selected "
button btn_RZ_RandScaleZero "Scale To 100" pos:[111,yp1[4]+73] width:89 height:21 tooltip:" Restore Objects Scale "
button btn_RZ_RandScaleRandSpiners "Randomize Spiners" pos:[8,yp1[4]+97] width:105 height:21 toolTip:" Randomly Scale Spiners Value "
button btn_RZ_RandScaleResetSpiners "Reset Spiners" pos:[116,yp1[4]+97] width:85 height:21 toolTip:" Reset Scale Spiners Value "

button btn_RZ_RandomAllSeed "Random Seed All" pos:[0,yp1[5]] width:206 height:21 enabled:false

checkButton chbtn_RZ_Preview "Preview" pos:[0,yp1[6]] width:100 height:37 highlightColor:colCHBX toolTip:" Activate Preview \n Rmb - Reinitialize Input "
button btn_RZ_Apply "Apply" pos:[103,yp1[6]] width:103 height:37 enbled:false
	---local-----------------------------------------------------------------------------------------------------------
local input_arr = #()
local initial_arr = #()
local pos_seed_arr = #()
local rot_seed_arr = #()
local scl_seed_arr = #()
	---Position--------------------------------------------------------------------------------------------------------
local pos_min_arr_x = #()
local pos_max_arr_x = #()
local pos_min_arr_y = #()
local pos_max_arr_y = #()
local pos_min_arr_z = #()
local pos_max_arr_z = #()
	-----fn---Position---X---------------------------------------------------------------------------------------------
FN fn_get_pos_arr_x =
(
pos_min_arr_x = #(); pos_max_arr_x = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionXTogg.checked do
	(
	local range = spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local pos_min_obj_x = input_arr[n].pos.x - range * pos_seed_arr[n].x
		append pos_min_arr_x pos_min_obj_x
		append pos_max_arr_x (pos_min_obj_x + range)
		)
	)
redrawViews()
)
	-----fn---Position---X---------------------------------------------------------------------------------------------
FN fn_set_pos_min_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionXTogg.checked do
	(
	local range = spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.x = pos_max_arr_x[n] - (range * (1 - pos_seed_arr[n].x)))
	)
redrawViews()
)
	-----fn---Position---X---------------------------------------------------------------------------------------------
FN fn_set_pos_max_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionXTogg.checked do
	(
	local range = spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.x = pos_min_arr_x[n] + range * pos_seed_arr[n].x)
	)
redrawViews()
)
	-----fn---Position---Y---------------------------------------------------------------------------------------------
FN fn_get_pos_arr_y =
(
pos_min_arr_y = #(); pos_max_arr_y = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionYTogg.checked do
	(
	local range = spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local pos_min_obj_y = input_arr[n].pos.y - range * pos_seed_arr[n].y
		append pos_min_arr_y pos_min_obj_y
		append pos_max_arr_y (pos_min_obj_y + range)
		)
	)
redrawViews()
)
	-----fn---Position---Y---------------------------------------------------------------------------------------------
FN fn_set_pos_min_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionYTogg.checked do
	(
	local range = spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.y = pos_max_arr_y[n] - (range * (1 - pos_seed_arr[n].y)))
	)
redrawViews()
)
	-----fn---Position---Y---------------------------------------------------------------------------------------------
FN fn_set_pos_max_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionYTogg.checked do
	(
	local range = spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.y = pos_min_arr_y[n] + range * pos_seed_arr[n].y)
	)
redrawViews()
)
	-----fn---Position---Z---------------------------------------------------------------------------------------------
FN fn_get_pos_arr_z =
(
pos_min_arr_z = #(); pos_max_arr_z = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionZTogg.checked do
	(
	local range = spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local pos_min_obj_z = input_arr[n].pos.z - range * pos_seed_arr[n].z
		append pos_min_arr_z pos_min_obj_z
		append pos_max_arr_z (pos_min_obj_z + range)
		)
	)
redrawViews()
)
	-----fn---Position---Z---------------------------------------------------------------------------------------------
FN fn_set_pos_min_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionZTogg.checked do
	(
	local range = spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.z = pos_max_arr_z[n] - (range * (1 - pos_seed_arr[n].z)))
	)
redrawViews()
)
	-----fn---Position---Z---------------------------------------------------------------------------------------------
FN fn_set_pos_max_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandPositionZTogg.checked do
	(
	local range = spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].pos.z = pos_min_arr_z[n] + range * pos_seed_arr[n].z)
	)
redrawViews()
)
	-----fn---Position------------------------------------------------------------------------------------------------
FN fn_set_pos_min =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value
	local range_y = spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value
	local range_z = spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local pos_x = if chbtn_RZ_RandPositionXTogg.checked
						then (pos_max_arr_x[n] - (range_x * (1 - pos_seed_arr[n].x)))
						else (input_arr[n].pos.x)
		local pos_y = if chbtn_RZ_RandPositionYTogg.checked
						then (pos_max_arr_y[n] - (range_y * (1 - pos_seed_arr[n].y)))
						else (input_arr[n].pos.y)
		local pos_z = if chbtn_RZ_RandPositionZTogg.checked
						then (pos_max_arr_z[n] - (range_z * (1 - pos_seed_arr[n].z)))
						else (input_arr[n].pos.z)
		input_arr[n].pos = [pos_x, pos_y, pos_z]
		)
	)
redrawViews()
)
	-----fn---Position------------------------------------------------------------------------------------------------
FN fn_set_pos_max =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value
	local range_y = spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value
	local range_z = spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local pos_x = if chbtn_RZ_RandPositionXTogg.checked
						then (pos_min_arr_x[n] + range_x * pos_seed_arr[n].x)
						else (input_arr[n].pos.x)
		local pos_y = if chbtn_RZ_RandPositionYTogg.checked
						then (pos_min_arr_y[n] + range_y * pos_seed_arr[n].y)
						else (input_arr[n].pos.y)
		local pos_z = if chbtn_RZ_RandPositionZTogg.checked
						then (pos_min_arr_z[n] + range_z * pos_seed_arr[n].z)
						else (input_arr[n].pos.z)
		input_arr[n].pos = [pos_x, pos_y, pos_z]
		)
	)
redrawViews()
)
	---Rotation--------------------------------------------------------------------------------------------------------
local rot_min_arr_x = #()
local rot_max_arr_x = #()
local rot_min_arr_y = #()
local rot_max_arr_y = #()
local rot_min_arr_z = #()
local rot_max_arr_z = #()
	-----fn---Rotation---X---------------------------------------------------------------------------------------------
FN fn_get_rot_arr_x =
(
rot_min_arr_x = #(); rot_max_arr_x = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationXTogg.checked do
	(
	local range = spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local rot_min_obj_x = input_arr[n].rotation.controller[1].value - range * rot_seed_arr[n].x
		append rot_min_arr_x rot_min_obj_x
		append rot_max_arr_x (rot_min_obj_x + range)
		)
	)
redrawViews()
)
	-----fn---Rotation---X---------------------------------------------------------------------------------------------
FN fn_set_rot_min_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationXTogg.checked do
	(
	local range = spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[1].value = rot_max_arr_x[n] - (range * (1 - rot_seed_arr[n].x)))
	)
redrawViews()
)
	-----fn---Rotation---X---------------------------------------------------------------------------------------------
FN fn_set_rot_max_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationXTogg.checked do
	(
	local range = spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[1].value = rot_min_arr_x[n] + range * rot_seed_arr[n].x)
	)
redrawViews()
)
	-----fn---Rotation---Y---------------------------------------------------------------------------------------------
FN fn_get_rot_arr_y =
(
rot_min_arr_y = #(); rot_max_arr_y = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationYTogg.checked do
	(
	local range = spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local rot_min_obj_y = input_arr[n].rotation.controller[2].value - range * rot_seed_arr[n].y
		append rot_min_arr_y rot_min_obj_y
		append rot_max_arr_y (rot_min_obj_y + range)
		)
	)
redrawViews()
)
	-----fn---Rotation---Y---------------------------------------------------------------------------------------------
FN fn_set_rot_min_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationYTogg.checked do
	(
	local range = spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[2].value = rot_max_arr_y[n] - (range * (1 - rot_seed_arr[n].y)))
	)
redrawViews()
)
	-----fn---Rotation---Y---------------------------------------------------------------------------------------------
FN fn_set_rot_max_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationYTogg.checked do
	(
	local range = spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[2].value = rot_min_arr_y[n] + range * rot_seed_arr[n].y)
	)
redrawViews()
)
	-----fn---Rotation---Z---------------------------------------------------------------------------------------------
FN fn_get_rot_arr_z =
(
rot_min_arr_z = #(); rot_max_arr_z = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationZTogg.checked do
	(
	local range = spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local rot_min_obj_z = input_arr[n].rotation.controller[3].value - range * rot_seed_arr[n].z
		append rot_min_arr_z rot_min_obj_z
		append rot_max_arr_z (rot_min_obj_z + range)
		)
	)
redrawViews()
)
	-----fn---Rotation---Z---------------------------------------------------------------------------------------------
FN fn_set_rot_min_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationZTogg.checked do
	(
	local range = spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[3].value = rot_max_arr_z[n] - (range * (1 - rot_seed_arr[n].z)))
	)
redrawViews()
)
	-----fn---Rotation---Z---------------------------------------------------------------------------------------------
FN fn_set_rot_max_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandRotationZTogg.checked do
	(
	local range = spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].rotation.controller[3].value = rot_min_arr_z[n] + range * rot_seed_arr[n].z)
	)
redrawViews()
)
	-----fn---Rotation------------------------------------------------------------------------------------------------
FN fn_set_rot_min =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value
	local range_y = spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value
	local range_z = spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local rot_x = if chbtn_RZ_RandRotationXTogg.checked
						then (rot_max_arr_x[n] - (range_x * (1 - rot_seed_arr[n].x)))
						else (input_arr[n].rotation.controller[1].value)
		local rot_y = if chbtn_RZ_RandRotationYTogg.checked
						then (rot_max_arr_y[n] - (range_y * (1 - rot_seed_arr[n].y)))
						else (input_arr[n].rotation.controller[2].value)
		local rot_z = if chbtn_RZ_RandRotationZTogg.checked
						then (rot_max_arr_z[n] - (range_z * (1 - rot_seed_arr[n].z)))
						else (input_arr[n].rotation.controller[3].value)
		input_arr[n].rotation.controller.value = eulerToQuat (eulerAngles rot_x rot_y rot_z)
		)
	)
redrawViews()
)
	-----fn---Rotation------------------------------------------------------------------------------------------------
FN fn_set_rot_max =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value
	local range_y = spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value
	local range_z = spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local rot_x = if chbtn_RZ_RandRotationXTogg.checked
						then (rot_min_arr_x[n] + range_x * rot_seed_arr[n].x)
						else (input_arr[n].rotation.controller[1].value)
		local rot_y = if chbtn_RZ_RandRotationYTogg.checked
						then (rot_min_arr_y[n] + range_y * rot_seed_arr[n].y)
						else (input_arr[n].rotation.controller[2].value)
		local rot_z = if chbtn_RZ_RandRotationZTogg.checked
						then (rot_min_arr_z[n] + range_z * rot_seed_arr[n].z)
						else (input_arr[n].rotation.controller[3].value)
		input_arr[n].rotation.controller.value = eulerToQuat (eulerAngles rot_x rot_y rot_z)
		)
	)
redrawViews()
)
	---Scale-----------------------------------------------------------------------------------------------------------
local scl_min_arr_x = #()
local scl_max_arr_x = #()
local scl_min_arr_y = #()
local scl_max_arr_y = #()
local scl_min_arr_z = #()
local scl_max_arr_z = #()
	-----fn---Scale---X------------------------------------------------------------------------------------------------
FN fn_get_scl_arr_x =
(
scl_min_arr_x = #(); scl_max_arr_x = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleXTogg.checked do
	(
	local range = (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value) / 100.
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local scl_min_obj_x = input_arr[n].scale.x - range * scl_seed_arr[n].x
		append scl_min_arr_x scl_min_obj_x
		append scl_max_arr_x (scl_min_obj_x + range)
		)
	)
redrawViews()
)
	-----fn---Scale---X---------------------------------------------------------------------------------------------
FN fn_set_scl_min_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleXTogg.checked do
	(
	local range = (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value) / 100.
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.x = scl_max_arr_x[n] - (range * (1 - scl_seed_arr[n].x)))
	)
redrawViews()
)
	-----fn---Scale---X---------------------------------------------------------------------------------------------
FN fn_set_scl_max_x =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleXTogg.checked do
	(
	local range = (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.x = scl_min_arr_x[n] + range * scl_seed_arr[n].x)
	)
redrawViews()
)
	-----fn---Scale---Y---------------------------------------------------------------------------------------------
FN fn_get_scl_arr_y =
(
scl_min_arr_y = #(); scl_max_arr_y = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleYTogg.checked do
	(
	local range = (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local scl_min_obj_y = input_arr[n].scale.y - range * scl_seed_arr[n].y
		append scl_min_arr_y scl_min_obj_y
		append scl_max_arr_y (scl_min_obj_y + range)
		)
	)
redrawViews()
)
	-----fn---Scale---Y---------------------------------------------------------------------------------------------
FN fn_set_scl_min_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleYTogg.checked do
	(
	local range = (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.y = scl_max_arr_y[n] - (range * (1 - scl_seed_arr[n].y)))
	)
redrawViews()
)
	-----fn---Scale---Y---------------------------------------------------------------------------------------------
FN fn_set_scl_max_y =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleYTogg.checked do
	(
	local range = (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.y = scl_min_arr_y[n] + range * scl_seed_arr[n].y)
	)
redrawViews()
)
	-----fn---Scale---Z---------------------------------------------------------------------------------------------
FN fn_get_scl_arr_z =
(
scl_min_arr_z = #(); scl_max_arr_z = #()
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleZTogg.checked do
	(
	local range = (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local scl_min_obj_z = input_arr[n].scale.z - range * scl_seed_arr[n].z
		append scl_min_arr_z scl_min_obj_z
		append scl_max_arr_z (scl_min_obj_z + range)
		)
	)
redrawViews()
)
	-----fn---Scale---Z---------------------------------------------------------------------------------------------
FN fn_set_scl_min_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleZTogg.checked do
	(
	local range = (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.z = scl_max_arr_z[n] - (range * (1 - scl_seed_arr[n].z)))
	)
redrawViews()
)
	-----fn---Scale---Z---------------------------------------------------------------------------------------------
FN fn_set_scl_max_z =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked and chbtn_RZ_RandScaleZTogg.checked do
	(
	local range = (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(input_arr[n].scale.z = scl_min_arr_z[n] + range * scl_seed_arr[n].z)
	)
redrawViews()
)
	-----fn---Scale------------------------------------------------------------------------------------------------
FN fn_set_scl_min =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value) / 100. 
	local range_y = (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value) / 100. 
	local range_z = (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local scl_x = if chbtn_RZ_RandScaleXTogg.checked
						then (scl_max_arr_x[n] - (range_x * (1 - scl_seed_arr[n].x)))
						else (input_arr[n].scale.x)
		local scl_y = if chbtn_RZ_RandScaleYTogg.checked
						then (scl_max_arr_y[n] - (range_y * (1 - scl_seed_arr[n].y)))
						else (input_arr[n].scale.y)
		local scl_z = if chbtn_RZ_RandScaleZTogg.checked
						then (scl_max_arr_z[n] - (range_z * (1 - scl_seed_arr[n].z)))
						else (input_arr[n].scale.z)
		input_arr[n].scale = [scl_x, scl_y, scl_z]
		)
	)
redrawViews()
)
	-----fn---Scale------------------------------------------------------------------------------------------------
FN fn_set_scl_max =
(
if input_arr.count == 0 do return false
if chbtn_RZ_Preview.checked do
	(
	local range_x = (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value) / 100. 
	local range_y = (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value) / 100. 
	local range_z = (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value) / 100. 
	for n=1 to input_arr.count where isValidNode input_arr[n] do
		(
		local scl_x = if chbtn_RZ_RandScaleXTogg.checked
						then (scl_min_arr_x[n] + range_x * scl_seed_arr[n].x)
						else (input_arr[n].scale.x)
		local scl_y = if chbtn_RZ_RandScaleYTogg.checked
						then (scl_min_arr_y[n] + range_y * scl_seed_arr[n].y)
						else (input_arr[n].scale.y)
		local scl_z = if chbtn_RZ_RandScaleZTogg.checked
						then (scl_min_arr_z[n] + range_z * scl_seed_arr[n].z)
						else (input_arr[n].scale.z)
		input_arr[n].scale = [scl_x, scl_y, scl_z]
		)
	)
redrawViews()
)
	-----fn---Scale----------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_initialize =
(
input_arr = #()
initial_arr = #()
if selection.count == 0 and not chbtn_RZ_Preview.checked do return false
for objct in (ATfn_.GetNHH (selection as array) true) where isValidNode objct do
	(
	append input_arr objct
	append initial_arr objct.transform
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_restore_initial =
(
for n=1 to input_arr.count where isValidNode input_arr[n] do
	(
	input_arr[n].transform = initial_arr[n]
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_seed seed_arr lock:false =
(
if input_arr.count == 0 do return false
if lock
then
	(
	for objct in input_arr where isValidNode objct do
		(
		local lockSeed = random 0. 1
		append seed_arr [lockSeed, lockSeed, lockSeed]
		)
	)
else 
	(
	for objct in input_arr where isValidNode objct do
		(
		append seed_arr [random 0. 1, random 0. 1, random 0. 1]
		)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_preview_transform pos:true rot:true scl:true =
(
if input_arr.count == 0 do return false
for n=1 to input_arr.count where isValidNode input_arr[n] do
	(
	local objct = input_arr[n]
	if pos do
		(
		if chbtn_RZ_RandPositionXTogg.checked do
			(objct.position.controller[1].value += spnr_RZ_RandPositionXMin.value + (spnr_RZ_RandPositionXMax.value - spnr_RZ_RandPositionXMin.value) * pos_seed_arr[n].x)
		if chbtn_RZ_RandPositionYTogg.checked do
			(objct.position.controller[2].value += spnr_RZ_RandPositionYMin.value + (spnr_RZ_RandPositionYMax.value - spnr_RZ_RandPositionYMin.value) * pos_seed_arr[n].y)
		if chbtn_RZ_RandPositionZTogg.checked do
			(objct.position.controller[3].value += spnr_RZ_RandPositionZMin.value + (spnr_RZ_RandPositionZMax.value - spnr_RZ_RandPositionZMin.value) * pos_seed_arr[n].z)
		)
	if rot do
		(
		if chbtn_RZ_RandRotationXTogg.checked do
			(objct.rotation.controller[1].value += spnr_RZ_RandRotationXMin.value + (spnr_RZ_RandRotationXMax.value - spnr_RZ_RandRotationXMin.value) * rot_seed_arr[n].x)
		if chbtn_RZ_RandRotationYTogg.checked do
			(objct.rotation.controller[2].value += spnr_RZ_RandRotationYMin.value + (spnr_RZ_RandRotationYMax.value - spnr_RZ_RandRotationYMin.value) * rot_seed_arr[n].y)
		if chbtn_RZ_RandRotationZTogg.checked do
			(objct.rotation.controller[3].value += spnr_RZ_RandRotationZMin.value + (spnr_RZ_RandRotationZMax.value - spnr_RZ_RandRotationZMin.value) * rot_seed_arr[n].z)
		)
	if scl do
		(
		if chbtn_RZ_RandScaleXTogg.checked do
			(objct.scale.x = (spnr_RZ_RandScaleXMin.value)/100. + (spnr_RZ_RandScaleXMax.value - spnr_RZ_RandScaleXMin.value)/100. * scl_seed_arr[n].x)
		if chbtn_RZ_RandScaleYTogg.checked do
			(objct.scale.y = (spnr_RZ_RandScaleYMin.value)/100. + (spnr_RZ_RandScaleYMax.value - spnr_RZ_RandScaleYMin.value)/100. * scl_seed_arr[n].y)
		if chbtn_RZ_RandScaleZTogg.checked do
			(objct.scale.z = (spnr_RZ_RandScaleZMin.value)/100. + (spnr_RZ_RandScaleZMax.value - spnr_RZ_RandScaleZMin.value)/100. * scl_seed_arr[n].z)
		)
	)
-- bx = box isHidden:true; delete bx
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_rebuilds_preview restoreInit:true init:false pos:true rot:true scl:true =
(
-- escapeEnable = false
-- fn_restore_initial()
if restoreInit do fn_restore_initial()
if selection.count == 0 and not chbtn_RZ_Preview.checked do return false
if init do (fn_initialize())
if pos do (pos_seed_arr = #(); fn_seed pos_seed_arr)
if rot do (rot_seed_arr = #(); fn_seed rot_seed_arr)
if scl do (scl_seed_arr = #(); fn_seed scl_seed_arr lock:(chbtn_RZ_RandScaleLock.checked))
fn_preview_transform()
fn_get_pos_arr_x(); fn_get_pos_arr_y(); fn_get_pos_arr_z()
fn_get_rot_arr_x(); fn_get_rot_arr_y(); fn_get_rot_arr_z()
fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
redrawViews()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_restore_init_preview =
(
fn_restore_initial()
-- fn_initialize()
fn_preview_transform()
fn_get_pos_arr_x(); fn_get_pos_arr_y(); fn_get_pos_arr_z()
fn_get_rot_arr_x(); fn_get_rot_arr_y(); fn_get_rot_arr_z()
fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
)
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
on btn_RZ_Apply pressed do
(
-- callbacks.removeScripts id:#ATcallbacks_RZ_
chbtn_RZ_Preview.checked = false
local undo_initial_arr = for objct in input_arr where isValidNode objct collect objct.transform
for n=1 to input_arr.count do input_arr[n].transform = initial_arr[n]
undo on
for n=1 to input_arr.count do input_arr[n].transform = undo_initial_arr[n]
input_arr = #()
initial_arr = #()
)
	-------------------------------------------------------------------------------------------------------------------
local byPrevEnab = #(btn_RZ_RandPositionSeed, btn_RZ_RandRotationSeed, btn_RZ_RandScaleSeed, btn_RZ_RandomAllSeed, btn_RZ_Apply)
local byPrevDisab = #(btn_RZ_RandPositionZero, btn_RZ_RandRotationZero, btn_RZ_RandScaleZero)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RZ_Preview changed state do
(
if state
then
	(
	fn_rebuilds_preview restoreInit:false init:true
-- 	callbacks.addScript #selectionSetChanged "floater_Randomizer.rollouts[1].fn_rebuilds_preview()" id:#ATcallbacks_RZ_
	)
else
	(
-- 	callbacks.removeScripts id:#ATcallbacks_RZ_
	fn_restore_initial()
	)
byPrevEnab.enabled = state
byPrevDisab.enabled = not state
)
on chbtn_RZ_Preview rightclick do (if chbtn_RZ_Preview.checked do (fn_rebuilds_preview init:true))
	-------------------------------------------------------------------------------------------------------------------
-- on btn_RZ_ReinitializeInput pressed do (fn_rebuilds_preview init:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandomAllSeed pressed do with undo off (fn_rebuilds_preview())
	-------------------------------------------------------------------------------------------------------------------
	---Position--------------------------------------------------------------------------------------------------------
on spnr_RZ_RandPositionXMin buttonDown do (fn_get_pos_arr_x())
on spnr_RZ_RandPositionXMin changed val do (fn_set_pos_min_x())
	-------------
on spnr_RZ_RandPositionXMax buttonDown do (fn_get_pos_arr_x())
on spnr_RZ_RandPositionXMax changed val do (fn_set_pos_max_x())
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandPositionYMin buttonDown do (fn_get_pos_arr_y())
on spnr_RZ_RandPositionYMin changed val do (fn_set_pos_min_y())
	-------------
on spnr_RZ_RandPositionYMax buttonDown do (fn_get_pos_arr_y())
on spnr_RZ_RandPositionYMax changed val do (fn_set_pos_max_y())
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandPositionZMin buttonDown do (fn_get_pos_arr_z())
on spnr_RZ_RandPositionZMin changed val do (fn_set_pos_min_z())
	-------------
on spnr_RZ_RandPositionZMax buttonDown do (fn_get_pos_arr_z())
on spnr_RZ_RandPositionZMax changed val do (fn_set_pos_max_z())
	-------------------------------------------------------------------------------------------------------------------
local but_down_RPMin
on spnr_RZ_RandPositionAllMin buttonDown do
(
fn_get_pos_arr_x(); fn_get_pos_arr_y();  fn_get_pos_arr_z()
but_down_RPMin = [spnr_RZ_RandPositionXMin.value, spnr_RZ_RandPositionYMin.value, spnr_RZ_RandPositionZMin.value]
)
on spnr_RZ_RandPositionAllMin changed val do
(
spnr_RZ_RandPositionXMin.value = but_down_RPMin.x + val
spnr_RZ_RandPositionYMin.value = but_down_RPMin.y + val
spnr_RZ_RandPositionZMin.value = but_down_RPMin.z + val
fn_set_pos_min()
)
on spnr_RZ_RandPositionAllMin buttonUp do (spnr_RZ_RandPositionAllMin.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
local but_down_RPMax
on spnr_RZ_RandPositionAllMax buttonDown do
(
fn_get_pos_arr_x(); fn_get_pos_arr_y();  fn_get_pos_arr_z()
but_down_RPMax = [spnr_RZ_RandPositionXMax.value, spnr_RZ_RandPositionYMax.value, spnr_RZ_RandPositionZMax.value]
)
on spnr_RZ_RandPositionAllMax changed val do
(
spnr_RZ_RandPositionXMax.value = but_down_RPMax.x + val
spnr_RZ_RandPositionYMax.value = but_down_RPMax.y + val
spnr_RZ_RandPositionZMax.value = but_down_RPMax.z + val
fn_set_pos_max()
)
on spnr_RZ_RandPositionAllMax buttonUp do (spnr_RZ_RandPositionAllMax.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandPositionSeed pressed do with undo off (fn_rebuilds_preview rot:false scl:false)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandPositionZero pressed do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true
if chbtn_RZ_RandPositionXTogg.checked do InArr.pos.X = 0
if chbtn_RZ_RandPositionYTogg.checked do InArr.pos.Y = 0
if chbtn_RZ_RandPositionZTogg.checked do InArr.pos.Z = 0
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RZ_RandPositionXTogg changed state do
(
spnr_RZ_RandPositionXMin.enabled = spnr_RZ_RandPositionXMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandPositionYTogg changed state do
(
spnr_RZ_RandPositionYMin.enabled = spnr_RZ_RandPositionYMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandPositionZTogg changed state do
(
spnr_RZ_RandPositionZMin.enabled = spnr_RZ_RandPositionZMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandPositionRandSpiners pressed do
(
local PositionLimit = (units.decodeValue "1m")
spnr_RZ_RandPositionXMin.value = random -PositionLimit 0; spnr_RZ_RandPositionXMax.value = random 0 PositionLimit
spnr_RZ_RandPositionYMin.value = random -PositionLimit 0; spnr_RZ_RandPositionYMax.value = random 0 PositionLimit
spnr_RZ_RandPositionZMin.value = random -PositionLimit 0; spnr_RZ_RandPositionZMax.value = random 0 PositionLimit
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandPositionResetSpiners pressed do
(
spnr_RZ_RandPositionXMin.value = spnr_RZ_RandPositionYMin.value = spnr_RZ_RandPositionZMin.value = \
spnr_RZ_RandPositionXMax.value = spnr_RZ_RandPositionYMax.value = spnr_RZ_RandPositionZMax.value = 0.
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	---Rotation--------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandRotationXMin buttonDown do (fn_get_rot_arr_x())
on spnr_RZ_RandRotationXMin changed val do (fn_set_rot_min_x())
	-------------
on spnr_RZ_RandRotationXMax buttonDown do (fn_get_rot_arr_x())
on spnr_RZ_RandRotationXMax changed val do (fn_set_rot_max_x())
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandRotationYMin buttonDown do (fn_get_rot_arr_y())
on spnr_RZ_RandRotationYMin changed val do (fn_set_rot_min_y())
	-------------
on spnr_RZ_RandRotationYMax buttonDown do (fn_get_rot_arr_y())
on spnr_RZ_RandRotationYMax changed val do (fn_set_rot_max_y())
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandRotationZMin buttonDown do (fn_get_rot_arr_z())
on spnr_RZ_RandRotationZMin changed val do (fn_set_rot_min_z())
	-------------
on spnr_RZ_RandRotationZMax buttonDown do (fn_get_rot_arr_z())
on spnr_RZ_RandRotationZMax changed val do (fn_set_rot_max_z())
	-------------------------------------------------------------------------------------------------------------------
local but_down_RRMin
on spnr_RZ_RandRotationAllMin buttonDown do
(
fn_get_rot_arr_x(); fn_get_rot_arr_y();  fn_get_rot_arr_z()
but_down_RRMin = [spnr_RZ_RandRotationXMin.value, spnr_RZ_RandRotationYMin.value, spnr_RZ_RandRotationZMin.value]
)
on spnr_RZ_RandRotationAllMin changed val do
(
spnr_RZ_RandRotationXMin.value = but_down_RRMin.x + val
spnr_RZ_RandRotationYMin.value = but_down_RRMin.y + val
spnr_RZ_RandRotationZMin.value = but_down_RRMin.z + val
fn_set_rot_min()
)
on spnr_RZ_RandRotationAllMin buttonUp do (spnr_RZ_RandRotationAllMin.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
local but_down_RRMax
on spnr_RZ_RandRotationAllMax buttonDown do
(
fn_get_rot_arr_x(); fn_get_rot_arr_y();  fn_get_rot_arr_z()
but_down_RRMax = [spnr_RZ_RandRotationXMax.value, spnr_RZ_RandRotationYMax.value, spnr_RZ_RandRotationZMax.value]
)
on spnr_RZ_RandRotationAllMax changed val do
(
spnr_RZ_RandRotationXMax.value = but_down_RRMax.x + val
spnr_RZ_RandRotationYMax.value = but_down_RRMax.y + val
spnr_RZ_RandRotationZMax.value = but_down_RRMax.z + val
fn_set_rot_max()
)
on spnr_RZ_RandRotationAllMax buttonUp do (spnr_RZ_RandRotationAllMax.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandRotationSeed pressed do with undo off (fn_rebuilds_preview pos:false scl:false)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandRotationZero pressed do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true
for o in InArr do o.rotation.controller.value = (quat 0 0 0 0)
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RZ_RandRotationXTogg changed state do
(
spnr_RZ_RandRotationXMin.enabled = spnr_RZ_RandRotationXMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandRotationYTogg changed state do
(
spnr_RZ_RandRotationYMin.enabled = spnr_RZ_RandRotationYMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandRotationZTogg changed state do
(
spnr_RZ_RandRotationZMin.enabled = spnr_RZ_RandRotationZMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandRotationRandSpiners pressed do
(
spnr_RZ_RandRotationXMin.value = random -360 0; spnr_RZ_RandRotationXMax.value = random 0 360
spnr_RZ_RandRotationYMin.value = random -360 0; spnr_RZ_RandRotationYMax.value = random 0 360
spnr_RZ_RandRotationZMin.value = random -360 0; spnr_RZ_RandRotationZMax.value = random 0 360
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on btn_RZ_RandRotationResetSpiners pressed do
(
spnr_RZ_RandRotationXMin.value = spnr_RZ_RandRotationYMin.value = spnr_RZ_RandRotationZMin.value = \
spnr_RZ_RandRotationXMax.value = spnr_RZ_RandRotationYMax.value = spnr_RZ_RandRotationZMax.value = 0.
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	--Scale------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandScaleXMin buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = spnr_RZ_RandScaleXMin.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_x())
)
on spnr_RZ_RandScaleXMin changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = val; fn_set_scl_min())
else (fn_set_scl_min_x())
)
	-------------
on spnr_RZ_RandScaleXMax buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = spnr_RZ_RandScaleXMax.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_x())
)
on spnr_RZ_RandScaleXMax changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = val; fn_set_scl_max())
else (fn_set_scl_max_x())
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandScaleYMin buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleZMin.value = spnr_RZ_RandScaleYMin.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_y())
)
on spnr_RZ_RandScaleYMin changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = val; fn_set_scl_min())
else (fn_set_scl_min_y())
)
	-------------
on spnr_RZ_RandScaleYMax buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleZMax.value = spnr_RZ_RandScaleYMax.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_y())
)
on spnr_RZ_RandScaleYMax changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = val; fn_set_scl_max())
else (fn_set_scl_max_y())
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_RZ_RandScaleZMin buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_z())
)
on spnr_RZ_RandScaleZMin changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = val; fn_set_scl_min())
else (fn_set_scl_min_z())
)
	-------------
on spnr_RZ_RandScaleZMax buttonDown do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value
	fn_get_scl_arr_x(); fn_get_scl_arr_y(); fn_get_scl_arr_z()
	)
else (fn_get_scl_arr_z())
)
on spnr_RZ_RandScaleZMax changed val do
(
if chbtn_RZ_RandScaleLock.state
then (spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = val; fn_set_scl_max())
else (fn_set_scl_max_z())
)
	-------------------------------------------------------------------------------------------------------------------
local but_down_RSMin
on spnr_RZ_RandScaleAllMin buttonDown do
(
fn_get_scl_arr_x(); fn_get_scl_arr_y();  fn_get_scl_arr_z()
but_down_RSMin = [spnr_RZ_RandScaleXMin.value, spnr_RZ_RandScaleYMin.value, spnr_RZ_RandScaleZMin.value]
)
on spnr_RZ_RandScaleAllMin changed val do
(
spnr_RZ_RandScaleXMin.value = but_down_RSMin.x + val; if spnr_RZ_RandScaleXMin.value < 1 do spnr_RZ_RandScaleXMin.value = 1.
spnr_RZ_RandScaleYMin.value = but_down_RSMin.y + val; if spnr_RZ_RandScaleYMin.value < 1 do spnr_RZ_RandScaleYMin.value = 1.
spnr_RZ_RandScaleZMin.value = but_down_RSMin.z + val; if spnr_RZ_RandScaleZMin.value < 1 do spnr_RZ_RandScaleZMin.value = 1.
fn_set_scl_min()
)
on spnr_RZ_RandScaleAllMin buttonUp do (spnr_RZ_RandScaleAllMin.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
local but_down_RSMax
on spnr_RZ_RandScaleAllMax buttonDown do
(
fn_get_scl_arr_x(); fn_get_scl_arr_y();  fn_get_scl_arr_z()
but_down_RSMax = [spnr_RZ_RandScaleXMax.value, spnr_RZ_RandScaleYMax.value, spnr_RZ_RandScaleZMax.value]
)
on spnr_RZ_RandScaleAllMax changed val do
(
spnr_RZ_RandScaleXMax.value = but_down_RSMax.x + val; if spnr_RZ_RandScaleXMax.value < 1 do spnr_RZ_RandScaleXMax.value = 1.
spnr_RZ_RandScaleYMax.value = but_down_RSMax.y + val; if spnr_RZ_RandScaleYMax.value < 1 do spnr_RZ_RandScaleYMax.value = 1.
spnr_RZ_RandScaleZMax.value = but_down_RSMax.z + val; if spnr_RZ_RandScaleZMax.value < 1 do spnr_RZ_RandScaleZMax.value = 1.
fn_set_scl_max()
)
on spnr_RZ_RandScaleAllMax buttonUp do (spnr_RZ_RandScaleAllMax.value = 0.)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandScaleSeed pressed do with undo off (fn_rebuilds_preview pos:false rot:false)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandScaleZero pressed do with undo on ((ATfn_.GetNHH (selection as array) true).scale = [1,1,1]; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RZ_RandScaleXTogg changed state do
(
spnr_RZ_RandScaleXMin.enabled = spnr_RZ_RandScaleXMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandScaleYTogg changed state do
(
spnr_RZ_RandScaleYMin.enabled = spnr_RZ_RandScaleYMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
on chbtn_RZ_RandScaleZTogg changed state do
(
spnr_RZ_RandScaleZMin.enabled = spnr_RZ_RandScaleZMax.enabled = state
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandScaleRandSpiners pressed do
(
if chbtn_RZ_RandScaleLock.state
then
	(
	local randMin = random 1 100; local randMax = random 100 200
	spnr_RZ_RandScaleXMin.value = randMin; spnr_RZ_RandScaleXMax.value = randMax
	spnr_RZ_RandScaleYMin.value = randMin; spnr_RZ_RandScaleYMax.value = randMax
	spnr_RZ_RandScaleZMin.value = randMin; spnr_RZ_RandScaleZMax.value = randMax
	)
else
	(
	spnr_RZ_RandScaleXMin.value = random 1 100; spnr_RZ_RandScaleXMax.value = random 100 200
	spnr_RZ_RandScaleYMin.value = random 1 100; spnr_RZ_RandScaleYMax.value = random 100 200
	spnr_RZ_RandScaleZMin.value = random 1 100; spnr_RZ_RandScaleZMax.value = random 100 200
	)
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RZ_RandScaleResetSpiners pressed do
(
spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = \
spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = 100
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RZ_RandScaleLock changed state do
(
if state do
	(
	spnr_RZ_RandScaleXMin.value = spnr_RZ_RandScaleYMin.value = spnr_RZ_RandScaleZMin.value = \
	floor ((spnr_RZ_RandScaleXMin.value + spnr_RZ_RandScaleYMin.value + spnr_RZ_RandScaleZMin.value)/3)
	spnr_RZ_RandScaleXMax.value = spnr_RZ_RandScaleYMax.value = spnr_RZ_RandScaleZMax.value = \
	floor ((spnr_RZ_RandScaleXMax.value + spnr_RZ_RandScaleYMax.value + spnr_RZ_RandScaleZMax.value)/3)
	scl_seed_arr = #(); fn_seed scl_seed_arr lock:true
	)
if chbtn_RZ_Preview.checked do fn_restore_init_preview()
)
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_RZ_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_Randomizer.checked = true)catch()
	escapeEnable = false
	)
on rollout_RZ_ close do
	(
	if chbtn_RZ_Preview.checked do
		(
		byPrevEnab.enabled = false
		byPrevDisab.enabled = true
-- 		callbacks.removeScripts id:#ATcallbacks_RZ_
		fn_restore_initial()
		)
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_Randomizer.checked = false)catch()
	ATfn_.SaveFloaterINI floater_Randomizer iniFile ExcludedControls
	floater_Randomizer = undefined
	)
)
	----==============================================================================================================
floater_Randomizer = ATfn_.CreateFloater floater_Randomizer iniFile fl0W fl0H floaterTitle #(rollout_RZ_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_Randomizer iniFile ExcludedControls)
	)
)