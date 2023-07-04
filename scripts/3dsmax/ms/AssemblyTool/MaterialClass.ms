(
Global rollout_MaterialClass
Global floater_AssemblyTool
try(if rollout_MaterialClass.dialogBar then (cui.UnRegisterDialogBar rollout_MaterialClass); destroyDialog rollout_MaterialClass)catch()
	-------------------------------------------------------------------------------------------------------------------
local rollTitle = "Material Class"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "MaterialClass_Settings.ini"
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [220,500]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_MCM_DockLeft", "btn_MCM_DockFloat", "btn_MCM_DockRight", "mlbx_MCM_ByClassList", \
	"mlbx_MCM_MaterialsList", "ddl_MCM_AllClasses")
	-------------------------------------------------------------------------------------------------------------------
local FoundMats = #()
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareClassStr class1 class2 = stricmp (class1 as string) (class2 as string)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_getMatsClasses =
(
local clss = material.classes
-- deleteItem clss (findItem clss NoMaterial)
deleteItem clss (findItem clss Standardmaterial)
deleteItem clss (findItem clss PhysicalMaterial)
deleteItem clss (findItem clss PBRMetalRough)
deleteItem clss (findItem clss PBRSpecGloss)
-- for n=clss.count to 1 by -1 where (matchPattern (clss[n] as string) pattern:"VRay*") do (deleteItem clss n)
-- for n=clss.count to 1 by -1 where (matchPattern (clss[n] as string) pattern:"Corona*") do (deleteItem clss n)
for n=clss.count to 1 by -1 where (matchPattern (clss[n] as string) pattern:"ai_*") do (deleteItem clss n)
qSort clss fn_compareClassStr
local ClassNameArr = (for c in clss collect (c as string))
return #(clss, ClassNameArr)
)
	-----fn------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
rollout rollout_MaterialClass rollTitle
(
local DockX = 15; local DockW = 13
button btn_MCM_DockLeft "<" pos:[DockX-DockW,2] width:DockW height:10 tooltip:" Dock Left "
button btn_MCM_DockFloat "::" pos:[DockX,2] width:DockW height:10 tooltip:" Float "
button btn_MCM_DockRight ">" pos:[DockX+DockW,2] width:DockW height:10 tooltip:" Dock Right "
on btn_MCM_DockLeft pressed do (ATfn_.DockRolloutSide rollout_MaterialClass iniFile "left")
on btn_MCM_DockRight pressed do (ATfn_.DockRolloutSide rollout_MaterialClass iniFile "right")
on btn_MCM_DockFloat pressed do (ATfn_.DockRolloutFloat rollout_MaterialClass iniFile roll0W roll0H)
	-------
local yp1 = #(18, 198)
radiobuttons rdbtn_MCM_SelectedOrScene "" labels:#("Selected","Scene") pos:[6,yp1[1]-4] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process Selected Objects \n Or All Scene Objects "
button btn_MCM_Refresh "Refresh" pos:[130,yp1[1]-14] width:86 height:26 border:true tooltip:" Refresh List "
multilistbox mlbx_MCM_ByClassList items:#() pos:[0,yp1[1]+15] width:(rollout_MaterialClass.width-0) height:1000 tooltip:" Lmb - Select Objects By Material Class \n Rmb - Selected Materials To MatEditor "

checkButton chbtn_MCM_Standard "Standard (Legacy)" pos:[4,yp1[2]-60] width:110 height:21 checked:true highlightColor:colCHBX tooltip:" Show Standard Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_PhysicalMaterial "Physical Material" pos:[117,yp1[2]-60] width:99 height:21 checked:true highlightColor:colCHBX tooltip:" Show Physical Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_PBRMetalRough "PBR Metal/Rough" pos:[4,yp1[2]-36] width:105 height:21 checked:true highlightColor:colCHBX tooltip:" Show PBRMetalRough Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_PBRSpecGloss "PBR Spec/Gloss" pos:[112,yp1[2]-36] width:104 height:21 checked:true highlightColor:colCHBX tooltip:" Show PBRSpecGloss Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_ShowByClass "Show" pos:[4,yp1[2]-12] width:32 height:21 checked:true highlightColor:colCHBX tooltip:" Show Materials In List \n By Selected Class \n Rmb - Switch All "
dropdownlist ddl_MCM_AllClasses items:(fn_getMatsClasses())[2] pos:[38,yp1[2]-11] width:178 height:33 selection:1 tooltip:" Select Class "
checkButton chbtn_MCM_AllVRay "All V-Ray" pos:[4,yp1[2]+12] width:83 height:21 checked:true highlightColor:colCHBX tooltip:" Show All VRay Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_AllCorona "All Corona" pos:[90,yp1[2]+12] width:83 height:21 checked:true highlightColor:colCHBX tooltip:" Show All Corona Materials In List \n Rmb - Switch All "
checkButton chbtn_MCM_Other "Other" pos:[176,yp1[2]+12] width:40 height:21 checked:true highlightColor:colCHBX tooltip:" Show Materials Not Described Above \n Rmb - Switch All "
checkButton chbtn_MCM_Identic "Identical Names Only" pos:[4,yp1[2]+36] width:212 height:21 checked:false highlightColor:colCHBX tooltip:" Identic Material Names Only "

edittext edt_MCM_StringToSearch "" pos:[0,yp1[2]+60] width:(roll0W-2) height:17 bold:true tooltip:" String To Search "
multilistbox mlbx_MCM_MaterialsList items:#() pos:[0,yp1[2]+81] width:(rollout_MaterialClass.width-0) height:1000 tooltip:" Lmb - Select Objects By Material \n Rmb - Selected Materials To MatEditor "
	-----Locals-------------------------------------------------------------------------------------------------------
local bcObjects = #(); local bcMaterials = #()
	-----Locals-------------------------------------------------------------------------------------------------------
local chbtnMatArr = #(chbtn_MCM_Standard, chbtn_MCM_PhysicalMaterial, chbtn_MCM_PBRMetalRough, chbtn_MCM_PBRSpecGloss, \
	chbtn_MCM_AllVRay, chbtn_MCM_AllCorona, chbtn_MCM_Other, chbtn_MCM_ShowByClass)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareNames mat1 mat2 = stricmp mat1.name mat2.name
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_BCgetMaterials = 
(
local objsByMatArrArr = #()
local matByClassArrArr = #()
local noMatObjs = #()
local allMatObjs = #()
for objct in (if rdbtn_MCM_SelectedOrScene.state == 1 then selection else objects) do
	(
	if objct.material == undefined then (append noMatObjs objct) else (append allMatObjs objct)
	)
if noMatObjs.count != 0 then (objsByMatArrArr[1] = noMatObjs; matByClassArrArr[1] = #())
local matClasses = #()
for objct in allMatObjs do (appendIfUnique matClasses (classOf objct.material)); qsort matClasses fn_compareClassStr
for c in matClasses do
	(
	local tArr1 = #(); local tArr2 = #()
	for objct in allMatObjs where (classOf objct.material) == c do (appendIfUnique tArr1 objct; appendIfUnique tArr2 objct.material)
	append objsByMatArrArr tArr1; append matByClassArrArr tArr2
	)
local mltlstbxInfoArr = #()
for n=1 to objsByMatArrArr.count do (append mltlstbxInfoArr (" " + (matByClassArrArr[n].count as string) + "   " + (if (classOf objsByMatArrArr[n][1].material) == undefinedClass then "Objects Without Material" else ((classOf objsByMatArrArr[n][1].material) as string)) ))
mlbx_MCM_ByClassList.items = mltlstbxInfoArr; mlbx_MCM_ByClassList.selection = #{}
return #(objsByMatArrArr,matByClassArrArr)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_BCgetData =
(
bcObjects = (fn_BCgetMaterials())[1]
bcMaterials = (fn_BCgetMaterials())[2]
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_getMaterials txt =
(
FoundMats = #()
local SceneMats = #()
for objct in (if rdbtn_MCM_SelectedOrScene.state == 1 then selection else objects) where (objct.material != undefined) do (appendIfUnique SceneMats objct.material)
local matchArr = for sm in SceneMats where (matchPattern sm.name pattern:("*" + txt + "*")) collect sm
local standardArr = for m in matchArr where (classOf m == Standardmaterial) collect m
local PhysMatArr = for m in matchArr where (classOf m == PhysicalMaterial) collect m
local pbrMRArr = for m in matchArr where (classOf m == PBRMetalRough) collect m
local pbrSGArr = for m in matchArr where (classOf m == PBRSpecGloss) collect m
local customClass = (fn_getMatsClasses())[1][ddl_MCM_AllClasses.selection]
local customArr = for m in matchArr where (classOf m == customClass) collect m
local vrayArr = for m in matchArr where (matchPattern ((classOf m) as string) pattern:"VRay*") and not (chbtn_MCM_ShowByClass.checked and classOf m == customClass) collect m
local coronaArr = for m in matchArr where (matchPattern ((classOf m) as string) pattern:"Corona*") and not (chbtn_MCM_ShowByClass.checked and classOf m == customClass) collect m
local otherArr = (ATfn_.ArraysDifference matchArr (standardArr + PhysMatArr + pbrMRArr + pbrSGArr + vrayArr + coronaArr + customArr))
if chbtn_MCM_Standard.checked then FoundMats += standardArr
if chbtn_MCM_PhysicalMaterial.checked then FoundMats += PhysMatArr
if chbtn_MCM_PBRMetalRough.checked then FoundMats += pbrMRArr
if chbtn_MCM_PBRSpecGloss.checked then FoundMats += pbrSGArr
if chbtn_MCM_AllVRay.checked then FoundMats += vrayArr
if chbtn_MCM_AllCorona.checked then FoundMats += coronaArr
if chbtn_MCM_Other.checked then FoundMats += otherArr
if chbtn_MCM_ShowByClass.checked then FoundMats += customArr
if chbtn_MCM_Identic.checked
then
	(
	local namesDups = #(); local namesUniques = #(); for m in FoundMats where not (appendifunique namesUniques m.name) do appendifunique namesDups m.name
	local matsDups = #(); for sm in FoundMats do (for nd in namesDups where (sm.name == nd) do (append matsDups sm))
	FoundMats = matsDups
	)
qSort FoundMats fn_compareNames
local FoundMatsNames = for fm in FoundMats collect fm.name
return #(FoundMats,FoundMatsNames)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MatsToList =
(
local Mats = fn_getMaterials edt_MCM_StringToSearch.text
FoundMats = Mats[1]
mlbx_MCM_MaterialsList.items = Mats[2]
mlbx_MCM_MaterialsList.selection = #{}
-- setFocus edt_MCM_StringToSearch
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_getAllData = (fn_BCgetData(); fn_MatsToList())
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on mlbx_MCM_ByClassList selectionEnd do
with undo on 
(
clearSelection()
local objArr = #()
for s in mlbx_MCM_ByClassList.selection do (join objArr bcObjects[s])
ATfn_.SelectInGroups objArr
forceCompleteRedraw()
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_MCM_ByClassList rightclick arg do
(
local selMats = #(); for s in mlbx_MCM_ByClassList.selection do (join selMats bcMaterials[s])
local count = if selMats.count <= 24 then selMats.count else 24
if selMats.count != 0
then
	(
	if queryBox "Open Selected Materials in Material Editor?" title:"Open Materials?" beep:false
	then (MatEditor.Open(); for n=1 to count do (meditMaterials[n] = selMats[n]))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MCM_Refresh pressed do (fn_BCgetData(); fn_MatsToList())
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_MCM_SelectedOrScene changed state do (fn_BCgetData(); fn_MatsToList())
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_chbtnRMB chbtn = (chbtnMatArr.checked = not chbtn.checked; fn_MatsToList())
	-----fn------------------------------------------------------------------------------------------------------------
on chbtn_MCM_ShowByClass changed state do (fn_MatsToList())
on chbtn_MCM_ShowByClass rightclick do (fn_chbtnRMB chbtn_MCM_ShowByClass)
	-------------------------------------------------------------------------------------------------------------------
on ddl_MCM_AllClasses selected item do
(
local Mats = fn_getMaterials edt_MCM_StringToSearch.text
FoundMats = Mats[1]
mlbx_MCM_MaterialsList.items = Mats[2]
mlbx_MCM_MaterialsList.selection = #{}
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_Identic changed state do (fn_MatsToList())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_Other changed state do (fn_MatsToList())
on chbtn_MCM_Other rightclick do (fn_chbtnRMB chbtn_MCM_Other)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_AllCorona changed state do (fn_MatsToList())
on chbtn_MCM_AllCorona rightclick do (fn_chbtnRMB chbtn_MCM_AllCorona)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_AllVRay changed state do (fn_MatsToList())
on chbtn_MCM_AllVRay rightclick do (fn_chbtnRMB chbtn_MCM_AllVRay)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_PBRSpecGloss changed state do (fn_MatsToList())
on chbtn_MCM_PBRSpecGloss rightclick do (fn_chbtnRMB chbtn_MCM_PBRSpecGloss)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_PBRMetalRough changed state do (fn_MatsToList())
on chbtn_MCM_PBRMetalRough rightclick do (fn_chbtnRMB chbtn_MCM_PBRMetalRough)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_PhysicalMaterial changed state do (fn_MatsToList())
on chbtn_MCM_PhysicalMaterial rightclick do (fn_chbtnRMB chbtn_MCM_PhysicalMaterial)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MCM_Standard changed state do (fn_MatsToList())
on chbtn_MCM_Standard rightclick do (fn_chbtnRMB chbtn_MCM_Standard)
	-------------------------------------------------------------------------------------------------------------------
on edt_MCM_StringToSearch changed txt do
(
local Mats = fn_getMaterials txt
FoundMats = Mats[1]
mlbx_MCM_MaterialsList.items = Mats[2]
mlbx_MCM_MaterialsList.selection = #{}
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_MCM_MaterialsList selectionEnd do
with undo on 
(
clearSelection()
local matArr = #()
for s in mlbx_MCM_MaterialsList.selection do (appendIfUnique matArr FoundMats[s])
local objArr = #()
for objct in objects do (for mat in matArr where objct.material == mat do (appendIfUnique objArr objct))
ATfn_.SelectInGroups objArr
forceCompleteRedraw()
-- setFocus edt_MCM_StringToSearch
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_MCM_MaterialsList rightclick arg do
(
local selMats = #(); for s in mlbx_MCM_MaterialsList.selection do (appendIfUnique selMats FoundMats[s])
local count = if selMats.count <= 24 then selMats.count else 24
if selMats.count != 0
then
	(
	if queryBox "Open Selected Materials in Material Editor?" title:"Open Materials?" beep:false
	then (MatEditor.Open(); for n=1 to count do (meditMaterials[n] = selMats[n]))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MaterialClass resized size do
	(
	mlbx_MCM_MaterialsList.width = size[1] - 0
	mlbx_MCM_MaterialsList.height = size[2] - 279
	mlbx_MCM_ByClassList.width = size[1] - 0
	edt_MCM_StringToSearch.width = size[1] - 6
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MaterialClass open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_MaterialClass iniFile ExcludedControls)
	mlbx_MCM_ByClassList.height = 100
	mlbx_MCM_MaterialsList.height = rollout_MaterialClass.height - 279
-- 	fn_BCgetData()
-- 	local getMats = fn_getMaterials edt_MCM_StringToSearch.text
-- 	FoundMats = getMats[1]
-- 	mlbx_MCM_MaterialsList.items = getMats[2]
	fn_getAllData()
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_MaterialClass.checked = true)
	callbacks.addScript #nodePostDelete "rollout_MaterialClass.fn_getAllData()" id:#ATcallbacks_MCM_
	callbacks.addScript #filePostOpenProcess "rollout_MaterialClass.fn_getAllData()" id:#ATcallbacks_MCM_
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MaterialClass close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_MaterialClass.checked = false)
	ATfn_.SaveRolloutINI rollout_MaterialClass iniFile ExcludedControls
	callbacks.removeScripts id:#ATcallbacks_MCM_
	rollout_MaterialClass = undefined
	gc light:true
	)
)
	----===============================================================================================================
rollout_MaterialClass = ATfn_.CreateRollout rollout_MaterialClass iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
