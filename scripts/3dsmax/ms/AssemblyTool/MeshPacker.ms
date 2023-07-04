(
Global floater_MeshPacker
Global floater_AssemblyTool
try (if floater_MeshPacker.dialogBar then (cui.UnRegisterDialogBar floater_MeshPacker); closeRolloutFloater floater_MeshPacker) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Mesh Packer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "MeshPacker_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,200])[2]
-- local fl0P = ATfn_.GetINI 0 iniFile floaterTitle "LastPosition" [50,50]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_MP_ProBar", "tmr_MP_prgrsFade", "btn_MP_DockLeft", "btn_MP_DockFloat", "btn_MP_DockRight", \
	"ddl_MP_PackingAlgorithm")
	----=MeshPacker==========================================================================================================================
rollout rollout_MP_ "Mesh Packer"
(
local yp1 = #(0, 20, 42, 57, 102)
local DockX = 181; local DockW = 13
button btn_MP_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_MP_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_MP_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_MP_DockLeft pressed do (ATfn_.DockFloaterSide floater_MeshPacker iniFile "left")
on btn_MP_DockRight pressed do (ATfn_.DockFloaterSide floater_MeshPacker iniFile "right")
on btn_MP_DockFloat pressed do (ATfn_.DockFloaterFloat floater_MeshPacker iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_MP_HullType "" pos:[4,yp1[1]] labels:#("Bounding Box","Hull Shape") offsets:#([0,0],[0,0]) default:1 tooltip:" Pack Objects As Bounding Box or Convex Shape "

checkButton chbtn_MP_RandomRotate "" pos:[4,yp1[2]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Random Rotate Models 90, -90 or 180 Degrees (Z Axis) "
label lbl_MP_RandomRotate "Random Rotate" pos:[22,yp1[2]] tooltip:chbtn_MP_RandomRotate.tooltip
spinner spnr_MP_RandomRotate "" pos:[103,yp1[2]] width:50 range:[0,100,100] type:#integer scale:1 toolTip:" Percentage Of Models That Will Be Rotated "
label lbl_MP_Percent "%" pos:[157,yp1[2]]

spinner spnr_MP_PackRatio "Pack Ratio:" pos:[120,yp1[3]] width:70 range:[0.01,99,1] type:#float scale:0.01 toolTip:" Pack Ratio X/Y (U/V) "
button btn_MP_ResetRatio "R" pos:[193,yp1[3]+1] width:14 height:14 images:ATIcons[19] toolTip:" Reset Pack Ratio Value "

checkButton chbtn_MP_CopyObjects "C" pos:[57,yp1[4]-15] width:28 height:42 images:ATIcons[36] checked:false highlightColor:colCHBX toolTip:" Copy Packing Objects "
dropdownlist ddl_MP_PackingAlgorithm items:(#("Linear Packing","Recursive Packing","Non-Convex","Unfold3D")) pos:[87,yp1[4]+3] width:120 height:5 selection:4 tooltip:" Packing Algorithm "
spinner spnr_MP_Spacing "Spacing Multiplier:" pos:[106,yp1[4]+26] width:85 range:[0.01,99,1] type:#float scale:0.01 toolTip:" Objects Spacing Multiplier "
button btn_MP_ResetSpacing "R" pos:[193,yp1[4]+27] width:14 height:14 images:ATIcons[19] toolTip:" Reset Spacing Multiplier Value "

button btn_MP_Pack "Pack" pos:[0,yp1[3]] width:55 height:55 tooltip:" Pack Objects Like Shell "
progressBar prgrs_MP_ProBar pos:[0,yp1[5]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_MP_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_MP_prgrsFade tick do (ATfn_.ProgBarFade prgrs_MP_ProBar tmr_MP_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByXYAreaIncrease o1 o2 =
(
local oMinMax = ATfn_.GetMinMax #(o1, o2)
-- local Area1 = (oMinMax[2][1][1] - oMinMax[1][1][1]) * (oMinMax[2][1][2] - oMinMax[1][1][2])
-- local Area2 = (oMinMax[2][2][1] - oMinMax[1][2][1]) * (oMinMax[2][2][2] - oMinMax[1][2][2])
local Area1 = oMinMax[5][1][1] * oMinMax[5][1][2]
local Area2 = oMinMax[5][2][1] * oMinMax[5][2][2]
case of
	(
	(Area1 < Area2): -1
	(Area1 > Area2): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MP_RandomRotate changed state do (#(lbl_MP_RandomRotate, spnr_MP_RandomRotate, lbl_MP_Percent).enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on btn_MP_ResetRatio pressed do with undo off (spnr_MP_PackRatio.value = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_MP_ResetSpacing pressed do with undo off (spnr_MP_Spacing.value = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_MP_Pack pressed do with undo off
(
local inArr = ATfn_.GetNHH (selection as array) true
if (ATfn_.CheckEmpty inArr) do
(
local Count = inArr.count
if Count != 0 then
(
local PackWithArr = #()
local CurrentTaskMode = getCommandPanelTaskMode()
setCommandPanelTaskMode mode:#modify
tmr_MP_prgrsFade.active = false; prgrs_MP_ProBar.value = 0; prgrs_MP_ProBar.color = orange

local PackWithArr = #()
if chbtn_MP_CopyObjects.checked
then (PackWithArr = ATfn_.GetNHH (ATfn_.CopyArray inArr IInstance:false Frozen:false Hidden:false) true)
else (PackWithArr = deepCopy inArr)
qsort PackWithArr fn_compareByXYAreaIncrease

if chbtn_MP_RandomRotate.checked do
	(
	local angleArr = #(-90, 90, 180)
-- 	for objct in (ATfn_.RandomFromArray PackWithArr spnr_MP_RandomRotate.value) do (rotate objct (angleaxis (angleArr[random 1 3]) [0,0,1]))
	for objct in (ATfn_.RandomFromArray PackWithArr spnr_MP_RandomRotate.value) do (objct.transform = (rotateZmatrix angleArr[random 1 3]) * objct.transform)
	)

ATfn_.SetPivot PackWithArr 0 0 0 true
-- ATfn_.ResetsXForm 0 (ATfn_.GetGeometry PackWithArr)

clearSelection()
local CHarr = #()
-- local PackGeomArr = ATfn_.GetGeometry PackWithArr
for objct in PackWithArr do
	(
-- 	windows.processPostedMessages()
	local ch = case rdbtn_MP_HullType.state of
		(
		1: (nvpx.CreateBoundingBox objct)
		2: (
-- 			if (findItem PackGeomArr objct > 0)
			if (ATfn_.GCheck objct)
			then (nvpx.CreateBoundingShapeConvex objct 64 0 1)
			else (nvpx.CreateBoundingBox objct)
			)
		)
	ch.name = "ConvexHull_" + objct.name
	ch.wirecolor = green
	ch.pivot = objct.pivot
	append CHarr ch
	prgrs_MP_ProBar.value = 100.0*(findItem PackWithArr objct)/Count
	redrawViews()
	)
select CHarr
-- ATfn_.SetPivot CHarr 0 0 1 true
ATfn_.SetPivot PackWithArr 0 0 1 true

local PackRatVal = spnr_MP_PackRatio.value
local mRat = 1.
local mapX = 100.; local mapY = 100.
if PackRatVal > 1 then (mRat = PackRatVal; mapX *= mRat)
if PackRatVal < 1 then (mRat = 1/PackRatVal; mapY *= mRat)
local UVmap = UVWmap maptype:0 width:mapX length:mapY height:(10^10) axis:2
modPanel.addModToSelection UVmap
resetXForm CHarr; ConvertTo CHarr Editable_Poly

local PA = ddl_MP_PackingAlgorithm.selection - 1
local Unwrap = unwrap_uvw()
modPanel.addModToSelection Unwrap
Unwrap.setTVSubObjectMode 3
Unwrap.SetPackRescaleCluster false
Unwrap.pack PA 0.005 true false true

local CHAllW = 0.0; for objct in CHarr do (CHAllW += (objct.max[1] - objct.min[1]))
local CHAllH = 0.0; for objct in CHarr do (CHAllH += (objct.max[2] - objct.min[2]))
local sqrtTotalAreaGeom  = 0.; local sqrtTotalAreaUV = 0.
for n=1 to Count do
	(
	Unwrap.selectFacesByNode #{} CHarr[n]
	Unwrap.selectFacesByNode #{1..(Unwrap.numberPolygonsByNode CHarr[n])} CHarr[n]
	Unwrap.getArea #{1..(Unwrap.numberPolygonsByNode CHarr[n])} &uvX &uvY &uvWidth &uvHeight &uvFaceAreaUVW &uvFaceAreaGeom
	Unwrap.selectFacesByNode #{} CHarr[n]
	sqrtTotalAreaGeom  += sqrt uvFaceAreaGeom
	sqrtTotalAreaUV += sqrt uvFaceAreaUVW
	prgrs_MP_ProBar.value = 100.0*n/Count
	)
-- local Factor = (spnr_MP_Spacing.value) * (sqrtTotalAreaGeom / sqrtTotalAreaUV) * (0.63 * mRat^(-0.476))
-- local Factor = (spnr_MP_Spacing.value) * (sqrtTotalAreaGeom / sqrtTotalAreaUV) * (mRat^(-0.476)) * 0.65
local Factor = (spnr_MP_Spacing.value) * (sqrtTotalAreaGeom / sqrtTotalAreaUV) * (mRat^(-0.476)) * 0.767

local mmArr = ATfn_.GetMinMax PackWithArr
for n=1 to Count do
	(
	Unwrap.selectFacesByNode #{} CHarr[n]
	Unwrap.selectFacesByNode #{1..(Unwrap.numberPolygonsByNode CHarr[n])} CHarr[n]
	local ShellCenter = CHarr[n].modifiers[#Unwrap_UVW].getSelCenter()
	PackWithArr[n].position.X = mmArr[3][1] + ShellCenter[1] * Factor * (if PackRatVal > 1 then mRat else 1)
	PackWithArr[n].position.Y = mmArr[3][2] + ShellCenter[2] * Factor * (if PackRatVal < 1 then mRat else 1)
	Unwrap.selectFacesByNode #{} CHarr[n]
	)
PackWithArr.position.Z = mmArr[3][3]

resetPivot PackWithArr
select PackWithArr
delete CHarr
-- select CHarr
prgrs_MP_ProBar.color = green
tmr_MP_prgrsFade.active = true
setCommandPanelTaskMode CurrentTaskMode
-- clearUndoBuffer()
-- gc light:true
gc()
) else (messageBox "Selection Is Empty." title:" Pack Like Shell" beep:false)
)
)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MP_ open do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_MeshPacker.checked = true)
	)
on rollout_MP_ close do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_MeshPacker.checked = false)
	ATfn_.SaveFloaterINI floater_MeshPacker iniFile ExcludedControls
	floater_MeshPacker = undefined
	)
)
	----================================================================================================================================
floater_MeshPacker = ATfn_.CreateFloater floater_MeshPacker iniFile fl0W fl0H floaterTitle #(rollout_MP_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_MeshPacker iniFile ExcludedControls)
	)
)