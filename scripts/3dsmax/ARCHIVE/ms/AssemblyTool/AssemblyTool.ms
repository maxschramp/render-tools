(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	-----------------
(
Global floater_AssemblyTool
Global rollout_Selector, floater_Scatter, floater_Painter, floater_MeshPacker, floater_Collider, floater_MassFX, \
	floater_Optimizer, floater_Replacer, floater_PBRConverter, rollout_ObjectClass, rollout_MaterialClass, \
	rollout_PolyCountManager, floater_ConvertTextures, floater_ResizeTextures, rollout_Collector, rollout_Renamer, \
	floater_AlphabetRenamer, floater_CopyUVChannel, floater_GridPacker, rollout_MaterialLoader, floater_Randomizer, \
	floater_DummyPlacer, rollout_BatchImport, floater_BatchExport, floater_BatchRenamer, rollout_MDLMaterial, floater_Array
	--------
try (if floater_AssemblyTool.dialogBar then (cui.UnRegisterDialogBar floater_AssemblyTool); closeRolloutFloater floater_AssemblyTool) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Assembly Tool"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "AssemblyTool_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,820])[2]
local colCHBX = ATfn_.GetINI 0 iniFile "Preferences" "color_PS_ChBxColor" [255,156,0]
	--------
Global AT_ToleranceHelperMaterial
if AT_ToleranceHelperMaterial == undefined do
	(AT_ToleranceHelperMaterial = Standardmaterial Diffuse:(ATfn_.GetINI 0 iniFile "Preferences" "AT_ToleranceHelperMaterial_diffuse" green) Opacity:(ATfn_.GetINI 0 iniFile "Preferences" "AT_ToleranceHelperMaterial_opacity" 75))
	--------
local ExcludedControls = #("prgrs_PR_ProBar", "tmr_PR_prgrsFade", "btn_TL_DockLeft", "btn_TL_DockFloat", "btn_TL_DockRight", \
	"chbtn_TL_Selector", "chbtn_TL_Scatter", "chbtn_TL_Painter", "chbtn_TL_MeshPacker", "chbtn_TL_Collider", "chbtn_TL_MassFX", \
	"chbtn_TL_Optimizer", "chbtn_TL_Replacer", "chbtn_TL_PBRConverter", "chbtn_TL_ObjectClass", "chbtn_TL_MaterialClass", "chbtn_TL_PolyCountManager", \
	"chbtn_TL_ConvertTextures", "chbtn_TL_ResizeTextures", "chbtn_TL_Collector", "chbtn_TL_Renamer", "chbtn_TL_AlphabetRenamer", \
	"chbtn_TL_CopyUVChannel", "chbtn_TL_GridPacker", "chbtn_TL_MaterialLoader", "chbtn_TL_Randomizer", "chbtn_TL_DummyPlacer", \
	"chbtn_TL_BatchImport", "chbtn_TL_BatchExport", "chbtn_TL_BatchRenamer", "chbtn_TL_MDLMaterial", "chbtn_TL_Array", \
	"chbtn_TM_MBSPickCenter", "spnr_TM_MoveByScale", "spnr_TM_MoveByX", "spnr_TM_MoveByY", "spnr_TM_MoveByZ", "chbtn_TM_TBPShShift", \
	"chbtn_GR_VisualTolerance", "color_GR_ToleranceColor", "spnr_GR_ToleranceOpacity", \
	"chbtn_PV_AffectPivotOnly", \
	"rdbtn_UV_OverrideMaterialUV", "ddl_UV_Resolution", "chbtn_UV_SelectElement", \
	"ddl_MAT_RandomMaterialClass", "chbtn_MAT_PickMaterial", \
	"chbtn_VPT_hbcGeometry", "chbtn_VPT_hbcShapes", "chbtn_VPT_hbcLights", "chbtn_VPT_hbcCameras", "chbtn_VPT_hbcHelpers", \
	"chbtn_VPT_hbcSpacewarps", "chbtn_VPT_hbcParticles", "chbtn_VPT_hbcBones", \
	"ddl_VPT_BakedProcedural", "ddl_VPT_TextureMaps", "ddl_VPT_BackEnvir", "color_VPT_VBSetColor", "rdbtn_VPT_ObjectOrMaterial", \
	"color_PS_ChBxColor", "lbl_PS_TooltipShow")
	----=Tools========================================================================================================
rollout rollout_TL_ "Tools"
(
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CloseAT = (macros.run "Utopia" "AssemblyTool")
	-----fn------------------------------------------------------------------------------------------------------------
local DockX = 181; local DockW = 13
button btn_TL_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_TL_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_TL_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_TL_DockLeft pressed do (ATfn_.DockFloaterSide floater_AssemblyTool iniFile "left")
on btn_TL_DockRight pressed do (ATfn_.DockFloaterSide floater_AssemblyTool iniFile "right")
on btn_TL_DockFloat pressed do (ATfn_.DockFloaterFloat floater_AssemblyTool iniFile fl0W fl0H)
	--------
local TL_w = 102; local TL_h = 21
local TL_x = for n=1 to 2 collect ((TL_w+2)*(n-1))
local TL_y = for n=1 to 14 collect (13 + (TL_h+2)*(n-1))
checkButton chbtn_TL_Selector "Selector" pos:[TL_x[1],TL_y[1]] width:TL_w height:TL_h checked:(rollout_Selector != undefined) highlightColor:colCHBX tooltip:" Selector Toggle "
checkButton chbtn_TL_Scatter "Scatter" pos:[TL_x[2],TL_y[1]] width:TL_w height:TL_h checked:(floater_Scatter != undefined) highlightColor:colCHBX tooltip:" Scatter Toggle "
checkButton chbtn_TL_Painter "Painter" pos:[TL_x[1],TL_y[2]] width:TL_w height:TL_h checked:(floater_Painter != undefined) highlightColor:colCHBX tooltip:" Painter Toggle "
checkButton chbtn_TL_MeshPacker "Mesh Packer" pos:[TL_x[2],TL_y[2]] width:TL_w height:TL_h checked:(floater_MeshPacker != undefined) highlightColor:colCHBX tooltip:" Mesh Packer Toggle "
checkButton chbtn_TL_Collider "Collider" pos:[TL_x[1],TL_y[3]] width:TL_w height:TL_h checked:(floater_Collider != undefined) highlightColor:colCHBX tooltip:" Collider Toggle "
checkButton chbtn_TL_MassFX "MassFX" pos:[TL_x[2],TL_y[3]] width:TL_w height:TL_h checked:(floater_MassFX != undefined) highlightColor:colCHBX tooltip:" MassFX Toggle "
checkButton chbtn_TL_Optimizer "Optimizer" pos:[TL_x[1],TL_y[4]] width:TL_w height:TL_h checked:(floater_Optimizer != undefined) highlightColor:colCHBX tooltip:" Optimizer Toggle "
checkButton chbtn_TL_Replacer "Replacer" pos:[TL_x[2],TL_y[4]] width:TL_w height:TL_h checked:(floater_Replacer != undefined) highlightColor:colCHBX tooltip:" Replacer Toggle "
checkButton chbtn_TL_PBRConverter "PBR Converter" pos:[TL_x[1],TL_y[5]] width:TL_w height:TL_h checked:(floater_PBRConverter != undefined) highlightColor:colCHBX tooltip:" PBRConverter Toggle "
checkButton chbtn_TL_ObjectClass "Object Class" pos:[TL_x[2],TL_y[5]] width:TL_w height:TL_h checked:(rollout_ObjectClass != undefined) highlightColor:colCHBX tooltip:" Object Class Manager Toggle "
checkButton chbtn_TL_MaterialClass "Material Class" pos:[TL_x[1],TL_y[6]] width:TL_w height:TL_h checked:(rollout_MaterialClass != undefined) highlightColor:colCHBX tooltip:" Material Class Manager Toggle "
checkButton chbtn_TL_PolyCountManager "Poly Count" pos:[TL_x[2],TL_y[6]] width:TL_w height:TL_h checked:(rollout_PolyCountManager != undefined) highlightColor:colCHBX tooltip:" PolyCount Manager Toggle "
checkButton chbtn_TL_ConvertTextures "Convert Textures" pos:[TL_x[1],TL_y[7]] width:TL_w height:TL_h checked:(floater_ConvertTextures != undefined) highlightColor:colCHBX tooltip:" Convert Textures Toggle "
checkButton chbtn_TL_ResizeTextures "Resize Textures" pos:[TL_x[2],TL_y[7]] width:TL_w height:TL_h checked:(floater_ResizeTextures != undefined) highlightColor:colCHBX tooltip:" Resize Textures Toggle "
checkButton chbtn_TL_Collector "Collector" pos:[TL_x[1],TL_y[8]] width:TL_w height:TL_h checked:(rollout_Collector != undefined) highlightColor:colCHBX tooltip:" Collector Toggle "
checkButton chbtn_TL_Renamer "Renamer" pos:[TL_x[2],TL_y[8]] width:TL_w height:TL_h checked:(rollout_Renamer != undefined) highlightColor:colCHBX tooltip:" Renamer Toggle "
checkButton chbtn_TL_AlphabetRenamer "Alphabet Renamer" pos:[TL_x[1],TL_y[9]] width:TL_w height:TL_h checked:(floater_AlphabetRenamer != undefined) highlightColor:colCHBX tooltip:" Alphabet Renamer Toggle "
checkButton chbtn_TL_CopyUVChannel "Copy UV Channel" pos:[TL_x[2],TL_y[9]] width:TL_w height:TL_h checked:(floater_CopyUVChannel != undefined) highlightColor:colCHBX tooltip:" Copy UV Channel Toggle "
checkButton chbtn_TL_GridPacker "Grid Packer" pos:[TL_x[1],TL_y[10]] width:TL_w height:TL_h checked:(floater_GridPacker != undefined) highlightColor:colCHBX tooltip:" Grid Packer Toggle "
checkButton chbtn_TL_MaterialLoader "Material Loader" pos:[TL_x[2],TL_y[10]] width:TL_w height:TL_h checked:(rollout_MaterialLoader != undefined) highlightColor:colCHBX tooltip:" Material Loader Toggle "
checkButton chbtn_TL_Randomizer "Randomizer" pos:[TL_x[1],TL_y[11]] width:TL_w height:TL_h checked:(floater_Randomizer != undefined) highlightColor:colCHBX tooltip:" Randomizer Toggle "
checkButton chbtn_TL_DummyPlacer "Dummy Placer" pos:[TL_x[2],TL_y[11]] width:TL_w height:TL_h checked:(floater_DummyPlacer != undefined) highlightColor:colCHBX tooltip:" Dummy Placer Toggle "
checkButton chbtn_TL_BatchImport "Batch Import" pos:[TL_x[1],TL_y[12]] width:TL_w height:TL_h checked:(rollout_BatchImport != undefined) highlightColor:colCHBX tooltip:" Batch Import Toggle "
checkButton chbtn_TL_BatchExport "Batch Export" pos:[TL_x[2],TL_y[12]] width:TL_w height:TL_h checked:(floater_BatchExport != undefined) highlightColor:colCHBX tooltip:" MDL Material Toggle "
checkButton chbtn_TL_BatchRenamer "Batch Renamer" pos:[TL_x[1],TL_y[13]] width:TL_w height:TL_h checked:(floater_BatchRenamer != undefined) highlightColor:colCHBX tooltip:" Batch Renamer Toggle "
checkButton chbtn_TL_MDLMaterial "MDL Material" pos:[TL_x[2],TL_y[13]] width:TL_w height:TL_h checked:(rollout_MDLMaterial != undefined) highlightColor:colCHBX tooltip:" MDL Material Toggle "
checkButton chbtn_TL_Array "Array" pos:[TL_x[1],TL_y[14]] width:TL_w height:TL_h checked:(floater_Array != undefined) highlightColor:colCHBX tooltip:" Array Toggle "
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_CloseFloater floater_ =
(
if floater_ != undefined do
	(
	if floater_.dialogBar do
		(
		local CurMousePos = [mouse.screenpos.X,mouse.screenpos.Y]
		cui.UnRegisterDialogBar floater_
		(dotnetClass "Cursor").Position = dotnetObject "System.Drawing.Point" (CurMousePos[1]) (CurMousePos[2])
		)
	closeRolloutFloater floater_
	)
)
FUNCTION fn_CloseRollout rollout_ = (if rollout_ != undefined do (if rollout_.dialogBar do (cui.UnRegisterDialogBar rollout_); destroyDialog rollout_))
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
-- 	/*   ---   I N S T A L L E R   ---
FUNCTION fn_RunMS scriptName = (fileIn ((getFilenamePath (getThisScriptFilename())) + scriptName))
on chbtn_TL_Selector changed state do (if state then (fn_RunMS "Selector.ms") else (fn_CloseRollout rollout_Selector))
on chbtn_TL_Scatter changed state do (if state then (fn_RunMS "Scatter.ms") else (fn_CloseFloater floater_Scatter))
on chbtn_TL_Painter changed state do (if state then (fn_RunMS "Painter.ms") else (fn_CloseFloater floater_Painter))
on chbtn_TL_MeshPacker changed state do (if state then (fn_RunMS "MeshPacker.ms") else (fn_CloseFloater floater_MeshPacker))
on chbtn_TL_Collider changed state do (if state then (fn_RunMS "Collider.ms") else (fn_CloseFloater floater_Collider))
on chbtn_TL_MassFX changed state do (if state then (fn_RunMS "MassFX.ms") else (fn_CloseFloater floater_MassFX))
on chbtn_TL_Optimizer changed state do (if state then (fn_RunMS "Optimizer.ms") else (fn_CloseFloater floater_Optimizer))
on chbtn_TL_Replacer changed state do (if state then (fn_RunMS "Replacer.ms") else (fn_CloseFloater floater_Replacer))
on chbtn_TL_PBRConverter changed state do (if state then (fn_RunMS "PBRConverter.ms") else (fn_CloseFloater floater_PBRConverter))
on chbtn_TL_ObjectClass changed state do (if state then (fn_RunMS "ObjectClass.ms") else (fn_CloseRollout rollout_ObjectClass))
on chbtn_TL_MaterialClass changed state do (if state then (fn_RunMS "MaterialClass.ms") else (fn_CloseRollout rollout_MaterialClass))
on chbtn_TL_PolyCountManager changed state do (if state then (fn_RunMS "PolyCountManager.ms") else (fn_CloseRollout rollout_PolyCountManager))
on chbtn_TL_ConvertTextures changed state do (if state then (fn_RunMS "ConvertTextures.ms") else (fn_CloseFloater floater_ConvertTextures))
on chbtn_TL_ResizeTextures changed state do (if state then (fn_RunMS "ResizeTextures.ms") else (fn_CloseFloater floater_ResizeTextures))
on chbtn_TL_Collector changed state do (if state then (fn_RunMS "Collector.ms") else (fn_CloseRollout rollout_Collector))
on chbtn_TL_Renamer changed state do (if state then (fn_RunMS "Renamer.ms") else (fn_CloseRollout rollout_Renamer))
on chbtn_TL_AlphabetRenamer changed state do (if state then (fn_RunMS "AlphabetRenamer.ms") else (fn_CloseFloater floater_AlphabetRenamer))
on chbtn_TL_CopyUVChannel changed state do (if state then (fn_RunMS "CopyUVChannel.ms") else (fn_CloseFloater floater_CopyUVChannel))
on chbtn_TL_GridPacker changed state do (if state then (fn_RunMS "GridPacker.ms") else (fn_CloseFloater floater_GridPacker))
on chbtn_TL_MaterialLoader changed state do (if state then (fn_RunMS "MaterialLoader.ms") else (fn_CloseRollout rollout_MaterialLoader))
on chbtn_TL_Randomizer changed state do (if state then (fn_RunMS "Randomizer.ms") else (fn_CloseFloater floater_Randomizer))
on chbtn_TL_DummyPlacer changed state do (if state then (fn_RunMS "DummyPlacer.ms") else (fn_CloseFloater floater_DummyPlacer))
on chbtn_TL_BatchImport changed state do (if state then (fn_RunMS "BatchImport.ms") else (fn_CloseRollout rollout_BatchImport))
on chbtn_TL_BatchExport changed state do (if state then (fn_RunMS "BatchExport.ms") else (fn_CloseFloater floater_BatchExport))
on chbtn_TL_BatchRenamer changed state do (if state then (fn_RunMS "BatchRenamer.ms") else (fn_CloseFloater floater_BatchRenamer))
on chbtn_TL_MDLMaterial changed state do (if state then (fn_RunMS "MDLMaterial.ms") else (fn_CloseRollout rollout_MDLMaterial))
on chbtn_TL_Array changed state do (if state then (fn_RunMS "Array.ms") else (fn_CloseFloater floater_Array))
	-- */
	/*   ---   W  O  R  K   ---
FUNCTION fn_RunMS scriptName =
(
local CurMousePos = [mouse.screenpos.X,mouse.screenpos.Y]
local rootDir = getFilenamePath (getThisScriptFilename())
local dirFilesArr = getFiles (rootDir + "\*.ms")
local msFilesArr = for f in dirFilesArr where (matchPattern f pattern:("*" + scriptName + "*")) collect f
local mainScript = msFilesArr[msFilesArr.count]
fileIn mainScript
(dotnetClass "Cursor").Position = dotnetObject "System.Drawing.Point" (CurMousePos[1]) (CurMousePos[2])
)
local errWorkInstallerStr = "Error: Main File in Work Mode."
on chbtn_TL_Selector changed state do try (if state then (fn_RunMS "Selector_inWork") else (fn_CloseRollout rollout_Selector)) catch(print errWorkInstallerStr)
on chbtn_TL_Scatter changed state do try (if state then (fn_RunMS "Scatter_inWork") else (fn_CloseFloater floater_Scatter)) catch(print errWorkInstallerStr)
on chbtn_TL_Painter changed state do try (if state then (fn_RunMS "Painter_inWork") else (fn_CloseFloater floater_Painter)) catch(print errWorkInstallerStr)
on chbtn_TL_MeshPacker changed state do try (if state then (fn_RunMS "MeshPacker_inWork") else (fn_CloseFloater floater_MeshPacker)) catch(print errWorkInstallerStr)
on chbtn_TL_Collider changed state do try (if state then (fn_RunMS "Collider_inWork") else (fn_CloseFloater floater_Collider)) catch(print errWorkInstallerStr)
on chbtn_TL_MassFX changed state do try (if state then (fn_RunMS "MassFX_inWork") else (fn_CloseFloater floater_MassFX)) catch(print errWorkInstallerStr)
on chbtn_TL_Optimizer changed state do try (if state then (fn_RunMS "Optimizer_inWork") else (fn_CloseFloater floater_Optimizer)) catch(print errWorkInstallerStr)
on chbtn_TL_Replacer changed state do try (if state then (fn_RunMS "Replacer_inWork") else (fn_CloseFloater floater_Replacer)) catch(print errWorkInstallerStr)
on chbtn_TL_PBRConverter changed state do try (if state then (fn_RunMS "PBRConverter_inWork") else (fn_CloseFloater floater_PBRConverter)) catch(print errWorkInstallerStr)
on chbtn_TL_ObjectClass changed state do try (if state then (fn_RunMS "ObjectClass_inWork") else (fn_CloseRollout rollout_ObjectClass)) catch(print errWorkInstallerStr)
on chbtn_TL_MaterialClass changed state do try (if state then (fn_RunMS "MaterialClass_inWork") else (fn_CloseRollout rollout_MaterialClass)) catch(print errWorkInstallerStr)
on chbtn_TL_PolyCountManager changed state do try (if state then (fn_RunMS "PolyCountManager_inWork") else (fn_CloseRollout rollout_PolyCountManager)) catch(print errWorkInstallerStr)
on chbtn_TL_ConvertTextures changed state do try (if state then (fn_RunMS "ConvertTextures_inWork") else (fn_CloseFloater floater_ConvertTextures)) catch(print errWorkInstallerStr)
on chbtn_TL_ResizeTextures changed state do try (if state then (fn_RunMS "ResizeTextures_inWork") else (fn_CloseFloater floater_ResizeTextures)) catch(print errWorkInstallerStr)
on chbtn_TL_Collector changed state do try (if state then (fn_RunMS "Collector_inWork") else (fn_CloseRollout rollout_Collector)) catch(print errWorkInstallerStr)
on chbtn_TL_Renamer changed state do try (if state then (fn_RunMS "Renamer_inWork") else (fn_CloseRollout rollout_Renamer)) catch(print errWorkInstallerStr)
on chbtn_TL_AlphabetRenamer changed state do try (if state then (fn_RunMS "AlphabetRenamer_inWork") else (fn_CloseFloater floater_AlphabetRenamer)) catch(print errWorkInstallerStr)
on chbtn_TL_CopyUVChannel changed state do try (if state then (fn_RunMS "CopyUVChannel_inWork") else (fn_CloseFloater floater_CopyUVChannel)) catch(print errWorkInstallerStr)
on chbtn_TL_GridPacker changed state do try (if state then (fn_RunMS "GridPacker_inWork") else (fn_CloseFloater floater_GridPacker)) catch(print errWorkInstallerStr)
on chbtn_TL_MaterialLoader changed state do try (if state then (fn_RunMS "MaterialLoader_inWork") else (fn_CloseRollout rollout_MaterialLoader)) catch(print errWorkInstallerStr)
on chbtn_TL_Randomizer changed state do try (if state then (fn_RunMS "Randomizer_inWork") else (fn_CloseFloater floater_Randomizer)) catch(print errWorkInstallerStr)
on chbtn_TL_DummyPlacer changed state do try (if state then (fn_RunMS "DummyPlacer_inWork") else (fn_CloseFloater floater_DummyPlacer)) catch(print errWorkInstallerStr)
on chbtn_TL_BatchImport changed state do try (if state then (fn_RunMS "BatchImport_inWork") else (fn_CloseRollout rollout_BatchImport)) catch(print errWorkInstallerStr)
on chbtn_TL_BatchExport changed state do try (if state then (fn_RunMS "BatchExport_inWork") else (fn_CloseFloater floater_BatchExport)) catch(print errWorkInstallerStr)
on chbtn_TL_BatchRenamer changed state do try (if state then (fn_RunMS "BatchRenamer_inWork") else (fn_CloseFloater floater_BatchRenamer)) catch(print errWorkInstallerStr)
on chbtn_TL_MDLMaterial changed state do try (if state then (fn_RunMS "MDLMaterial_inWork") else (fn_CloseRollout rollout_MDLMaterial)) catch(print errWorkInstallerStr)
on chbtn_TL_Array changed state do try (if state then (fn_RunMS "Array_inWork") else (fn_CloseFloater floater_Array)) catch(print errWorkInstallerStr)
	-- */
	-------------------------------------------------------------------------------------------------------------------
on rollout_TL_ close do
	(
	try (ATfn_.SaveFloaterINI floater_AssemblyTool iniFile ExcludedControls) catch (print "--- Error --->>> Close Assembly Tool")
	)
)
	----=Transform=====================================================================================================
rollout rollout_TM_ "Transform"
(
local yp1 = #(2, 109, 172, 216, 288, 360, 442, 509, 577)

local FRotateTTip = " Quick Rotate Selected \n Lmb - Rotate By Positive Value \n Rmb - Rotate By Negative Value "
GroupBox grp_TM_QuickRotate "Quick Rotate" pos:[2,yp1[1]] width:(fl0W-16) height:88
checkButton chbtn_TM_QuickRotateAsGroup "" pos:[12,yp1[1]+18] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Rotate As One Group "
label lbl_TM_QuickRotateAsGroup "Rotate As Group" pos:[30,yp1[1]+18] tooltip:chbtn_TM_QuickRotateAsGroup.tooltip
checkButton chbtn_TM_QuickRotateByX "X" pos:[126,yp1[1]+14] width:22 height:21 highlightColor:[204,64,64] tooltip:" Lmb - Quick Rotate By X Toggle \n Rmb - Reset Rotation By X Axis "
checkButton chbtn_TM_QuickRotateByY "Y" pos:[152,yp1[1]+14] width:22 height:21 highlightColor:[63,164,63] tooltip:" Lmb - Quick Rotate By Y Toggle \n Rmb - Reset Rotation By Y Axis "
checkButton chbtn_TM_QuickRotateByZ "Z" pos:[178,yp1[1]+14] width:22 height:21 highlightColor:[70,114,255] checked:true tooltip:" Lmb - Quick Rotate By Z Toggle \n Rmb - Reset Rotation By Z Axis "
button btn_TM_QuickRotateCustom "Rotate" pos:[8,yp1[1]+38] width:60 height:21 tooltip:FRotateTTip
spinner spnr_TM_QuickRotateVal pos:[68,yp1[1]+40] width:65 range:[-360,360,1] type:#float scale:0.01 toolTip:" Quick Rotate By Value "
button btn_TM_RotationReset "Reset" pos:[141,yp1[1]+38] width:60 height:21 tooltip:" Reset Rotation "
	
button btn_TM_QuickRotate180 "180" pos:[8,yp1[1]+62] width:30 height:21 tooltip:FRotateTTip
button btn_TM_QuickRotate90 "90" pos:[41,yp1[1]+62] width:30 height:21 tooltip:FRotateTTip
button btn_TM_QuickRotate45 "45" pos:[74,yp1[1]+62] width:30 height:21 tooltip:FRotateTTip
button btn_TM_QuickRotate10 "10" pos:[107,yp1[1]+62] width:30 height:21 tooltip:FRotateTTip
button btn_TM_QuickRotate5 "5" pos:[140,yp1[1]+62] width:29 height:21 tooltip:FRotateTTip
button btn_TM_QuickRotate1 "1" pos:[172,yp1[1]+62] width:29 height:21 tooltip:FRotateTTip

local PShPoly
local TBPShArr = #()
local ttTBPSh = "   Click&Drag - Move Objects 
   Alt+Drag - Rotate Objects 
   Alt+Ctrl+Drag - Scale Objects 
 ______________________________ 
 Change Brush Settings:
    Ctrl+Drag - Falloff (black circle). 
    Shift+Drag - Full Strength (white). 
    Shift+Alt+Drag - Strength Value. "
GroupBox grp_TM_TransformByPolyShift "Transform By Poly Shift" pos:[2,yp1[2]-16] width:(fl0W-16) height:61
checkButton chbtn_TM_TBPShShift "M" pos:[6,yp1[2]-1] width:48 height:42 images:ATIcons[49] highlightColor:colCHBX tooltip:(" Transform Selected By Shift \n" + ttTBPSh)
label lbl_TM_TBPShMoveAxis "Move Axis:" pos:[68,yp1[2]+2]
checkButton chbtn_TM_TBPShByX "X" pos:[126,yp1[2]-4] width:22 height:21 highlightColor:[204,64,64] checked:true tooltip:" Shift By X Toggle \n Rmb - Toggle Only X "
checkButton chbtn_TM_TBPShByY "Y" pos:[152,yp1[2]-4] width:22 height:21 highlightColor:[63,164,63] checked:true tooltip:" Shift By Y Toggle \n Rmb - Toggle Only Y "
checkButton chbtn_TM_TBPShByZ "Z" pos:[178,yp1[2]-4] width:22 height:21 highlightColor:[70,114,255] tooltip:" Shift By Z Toggle \n Rmb - Toggle Only Z "
label lbl_TM_TBPShRotateAxis "Rotate Axis:" pos:[61,yp1[2]+25]
checkButton chbtn_TM_TBPShRotateByX "X" pos:[126,yp1[2]+20] width:22 height:21 highlightColor:[204,64,64] tooltip:" Rotate By X Toggle "
checkButton chbtn_TM_TBPShRotateByY "Y" pos:[152,yp1[2]+20] width:22 height:21 highlightColor:[63,164,63] tooltip:" Rotate By Y Toggle "
checkButton chbtn_TM_TBPShRotateByZ "Z" pos:[178,yp1[2]+20] width:22 height:21 highlightColor:[70,114,255] checked:true tooltip:" Rotate By Z Toggle "
timer tmr_TM_CheckTBPSh interval:500 active:false

local MBSArr = #()
local MBSPosArr = #()
local MBSCenter = [0,0,0]
GroupBox grp_TM_MoveByScale "Move By Scale" pos:[2,yp1[3]-15] width:(fl0W-16) height:41
spinner spnr_TM_MoveByScale pos:[7,yp1[3]+4] width:48 range:[0.01,9999,1] type:#float scale:0.001 toolTip:" Move By Scale "
checkButton chbtn_TM_MBSMoveByX "X" pos:[60,yp1[3]] width:22 height:21 highlightColor:[204,64,64] checked:true tooltip:" Move By X Toggle \n Rmb - Toggle Only X "
spinner spnr_TM_MoveByX pos:[86,yp1[3]+5] width:8 range:[0.01,9999,1] type:#float scale:0.001 toolTip:" Move By X Only "
checkButton chbtn_TM_MBSMoveByY "Y" pos:[98,yp1[3]] width:22 height:21 highlightColor:[63,164,63] tooltip:" Move By Y Toggle \n Rmb - Toggle Only Y"
spinner spnr_TM_MoveByY pos:[124,yp1[3]+5] width:8 range:[0.01,9999,1] type:#float scale:0.001 toolTip:" Move By Y Only "
checkButton chbtn_TM_MBSMoveByZ "Z" pos:[136,yp1[3]] width:22 height:21 highlightColor:[70,114,255] tooltip:" Move By Z Toggle \n Rmb - Toggle Only Z"
spinner spnr_TM_MoveByZ pos:[162,yp1[3]+5] width:8 range:[0.01,9999,1] type:#float scale:0.001 toolTip:" Move By Z Only "
checkButton chbtn_TM_MBSPickCenter "Pick" pos:[176,yp1[3]-2] width:24 height:23 images:ATIcons[26] highlightColor:colCHBX tooltip:" Lmb - Use Move By Scale Center Toggle \n Rmb - Pick And Use Move By Scale Center "

GroupBox grp_TM_Place "Place" pos:[2,yp1[4]-15] width:(fl0W-16) height:69
checkButton chbtn_TM_PlaceMatchFace "Normal Align" pos:[8,yp1[4]] width:75 height:21 highlightColor:colCHBX toolTip:" Align Object To Surface Normal "
checkButton chbtn_TM_PlaceClone "Clone" pos:[86,yp1[4]] width:56 height:21 highlightColor:colCHBX toolTip:" Clone Objects "
checkButton chbtn_TM_PlaceClonInst "Instance" pos:[145,yp1[4]] width:55 height:21 highlightColor:colCHBX toolTip:" Instance Cloned Objects "
button btn_TM_PlaceObjects "Place" pos:[8,yp1[4]+24] width:120 height:25 tooltip:" Click&Drag - Rotate Placed \n Alt+Click&Drag - Scale Placed "
spinner spnr_TM_PlaceOffset "" pos:[128,yp1[4]+29] width:70 range:[-9999,9999,0] type:#float scale:1 toolTip:" Offset By Z "

GroupBox grp_TM_Drop "Drop" pos:[2,yp1[5]-15] width:(fl0W-16) height:69
checkButton chbtn_TM_DropMatchFace "Normal Align" pos:[8,yp1[5]] width:75 height:21 highlightColor:colCHBX toolTip:" Align Object To Surface Normal "
checkButton chbtn_TM_DropOnSelected "Drop On Selected" pos:[86,yp1[5]] width:114 height:21 highlightColor:colCHBX toolTip:" Drop Objects On Selected Too "
-- button btn_TM_DropOnScene "Scene" pos:[8,yp1[5]+24] width:62 height:25 tooltip:" Lmb - Drop Objects On Scene Surfaces \n Rmb - Select Objects Not Processed "
-- button btn_TM_DropOnPicked "Picked" pos:[73,yp1[5]+24] width:62 height:25 tooltip:" Lmb - Drop Objects On Picked Surfaces \n Rmb - Select Objects Not Processed \n Rmb In Viewport - Finish Picking And Drop "
-- button btn_TM_DropOnGrid "Z Grid" pos:[138,yp1[5]+24] width:62 height:25 tooltip:" Drop Objects On Grid By Z Axis "
button btn_TM_DropOnScene "Scene" pos:[42,yp1[5]+24] width:50 height:25 tooltip:" Lmb - Drop Objects On Scene Surfaces \n Rmb - Select Objects Not Processed "
button btn_TM_DropOnPicked "Picked" pos:[95,yp1[5]+24] width:50 height:25 tooltip:" Lmb - Drop Objects On Picked Surfaces \n Rmb - Select Objects Not Processed \n Rmb In Viewport - Finish Picking And Drop "
button btn_TM_DropOnGrid "Z Grid" pos:[148,yp1[5]+24] width:50 height:25 tooltip:" Drop Objects On Grid By Z Axis "
spinner spnr_TM_AdvDropQuality pos:[7,yp1[5]+28] width:32 range:[1,20,3] type:#integer scale:1 toolTip:" Advanced Drop Quality "

GroupBox grp_TM_Align "Align" pos:[2,yp1[6]-15] width:(fl0W-16) height:81
label lbl_TM_AlignPos "Position" pos:[20,yp1[6]]
checkButton chbtn_TM_AlignPosByX "X" pos:[7,yp1[6]+14] width:19 height:19 highlightColor:[204,64,64] tooltip:" Align Position By X Toggle "
checkButton chbtn_TM_AlignPosByY "Y" pos:[27,yp1[6]+14] width:19 height:19 highlightColor:[63,164,63] tooltip:" Align Position By Y Toggle "
checkButton chbtn_TM_AlignPosByZ "Z" pos:[47,yp1[6]+14] width:19 height:19 highlightColor:[70,114,255] tooltip:" Align Position By Z Toggle "
label lbl_TM_AlignRot "Rotation" pos:[84,yp1[6]]
checkButton chbtn_TM_AlignRotByX "X" pos:[74,yp1[6]+14] width:19 height:19 highlightColor:[204,64,64] tooltip:" Align By X Toggle "
checkButton chbtn_TM_AlignRotByY "Y" pos:[94,yp1[6]+14] width:19 height:19 highlightColor:[63,164,63] tooltip:" Align By Y Toggle "
checkButton chbtn_TM_AlignRotByZ "Z" pos:[114,yp1[6]+14] width:19 height:19 highlightColor:[70,114,255] tooltip:" Align By Z Toggle "
label lbl_TM_AlignScale "Scale" pos:[157,yp1[6]]
checkButton chbtn_TM_AlignScaleByX "X" pos:[141,yp1[6]+14] width:19 height:19 highlightColor:[204,64,64] tooltip:" Align By X Toggle "
checkButton chbtn_TM_AlignScaleByY "Y" pos:[161,yp1[6]+14] width:19 height:19 highlightColor:[63,164,63] tooltip:" Align By Y Toggle "
checkButton chbtn_TM_AlignScaleByZ "Z" pos:[181,yp1[6]+14] width:19 height:19 highlightColor:[70,114,255] tooltip:" Align By Z Toggle "
button btn_TM_PickAndAlign "Pick And Align" pos:[7,yp1[6]+36] width:80 height:25 tooltip:" Pick Object And Align Position "
radiobuttons rdbtn_TM_AlignByPivotCenter "" labels:#("Pivot","Center") pos:[94,yp1[6]+41] columns:2 offsets:#([0,0],[-2,0]) default:1 tooltip:" Align By Pivot Or Center "
-- checkButton chbtn_TM_AlignPickFrozen "Pick Frozen" pos:[178,yp1[6]+38] width:22 height:21 images:ATIcons[5] highlightColor:colCHBX toolTip:" Pick Frozen Object "

GroupBox grp_TM_QuickAlign "Quick Align" pos:[2,yp1[7]-15] width:(fl0W-16) height:65
radiobuttons rdbtn_TM_MinCenterMax "" labels:#("Minimum","Center","Maximum") pos:[10,yp1[7]+1] columns:3 offsets:#([0,0],[2,0],[-4,0]) default:1 tooltip:" Align By Minimum, Center or Maximum "
button btn_TM_QuickAlign "Quick Align" pos:[7,yp1[7]+20] width:103 height:25 tooltip:" Quick Align Objects "
checkButton chbtn_TM_QuickAlignByX "X" pos:[118,yp1[7]+22] width:22 height:21 highlightColor:[204,64,64] tooltip:" Align Axis "
checkButton chbtn_TM_QuickAlignByY "Y" pos:[147,yp1[7]+22] width:22 height:21 highlightColor:[63,164,63] checked:true tooltip:" Align Axis "
checkButton chbtn_TM_QuickAlignByZ "Z" pos:[176,yp1[7]+22] width:22 height:21 highlightColor:[70,114,255] tooltip:" Align Axis "

GroupBox grp_TM_Spacing "Line Spacing" pos:[2,yp1[8]-15] width:(fl0W-16) height:66
checkButton chbtn_TM_SetSpaceValue "" pos:[8,yp1[8]+2] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Set Space Value Toggle "
label lbl_TM_SetSpaceValue "Set Space Value" pos:[26,yp1[8]+2]
spinner spnr_TM_SetSpaceValue pos:[115,yp1[8]+2] width:80 range:[0,9999999,0] type:#float scale:0.1 toolTip:" Space Value "
button btn_TM_Spacing "Spacing" pos:[7,yp1[8]+21] width:103 height:25 tooltip:" Sets Equal Distances "
checkButton chbtn_TM_SpacingByX "X" pos:[118,yp1[8]+23] width:22 height:21 highlightColor:[204,64,64] tooltip:" Spacing Axis "
checkButton chbtn_TM_SpacingByY "Y" pos:[147,yp1[8]+23] width:22 height:21 highlightColor:[63,164,63] checked:true tooltip:" Spacing Axis "
checkButton chbtn_TM_SpacingByZ "Z" pos:[176,yp1[8]+23] width:22 height:21 highlightColor:[70,114,255] tooltip:" Spacing Axis "

GroupBox grp_TM_Order "Order" pos:[2,yp1[9]-15] width:(fl0W-16) height:90
radiobuttons rdbtn_TM_OrderBySize "" labels:#("Decrease","Increase") pos:[22,yp1[9]+1] columns:2 offsets:#([0,0],[3,0]) default:1 tooltip:" Order Objects By Size "
label lbl_TM_OrderBySizeAxis "Size Parameter:" pos:[30,yp1[9]+23]
checkButton chbtn_TM_OrderBySizeX "X" pos:[118,yp1[9]+20] width:22 height:21 highlightColor:[204,64,64] tooltip:" Size By X Axis "
checkButton chbtn_TM_OrderBySizeY "Y" pos:[147,yp1[9]+20] width:22 height:21 highlightColor:[63,164,63] tooltip:" Size By Y Axis "
checkButton chbtn_TM_OrderBySizeZ "Z" pos:[176,yp1[9]+20] width:22 height:21 highlightColor:[70,114,255] checked:true tooltip:" Size By Z Axis "
button btn_TM_Order "Order By Axis" pos:[7,yp1[9]+45] width:103 height:25 tooltip:"  "
checkButton chbtn_TM_OrderByX "X" pos:[118,yp1[9]+47] width:22 height:21 highlightColor:[204,64,64] tooltip:" Order Axis "
checkButton chbtn_TM_OrderByY "Y" pos:[147,yp1[9]+47] width:22 height:21 highlightColor:[63,164,63] checked:true tooltip:" Order Axis "
checkButton chbtn_TM_OrderByZ "Z" pos:[176,yp1[9]+47] width:22 height:21 highlightColor:[70,114,255] tooltip:" Order Axis "
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_PolyShiftReset =
(
PolyToolsUI.PSUseSelected = false
PolyToolsUI.PSIgnoreback = false
PolyToolsUI.PSFreezeEX = false
PolyToolsUI.PSFreezeEY = false
PolyToolsUI.PSFreezeEZ = false
PolyToolsUI.PSMirror = false; PolyToolsShift.UseMirror = false
PolyToolsUI.PSBrushAffect = 2
PolyToolsUI.PolyShiftSettings()
)
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_PolyShiftFreezeToggle =
(
fn_PolyShiftReset()
if PolyToolsShift.GetAxisFrozen #X == chbtn_TM_TBPShByX.state then (macros.run "Ribbon - Modeling" "PolyShiftFreezeXToggle")
if PolyToolsShift.GetAxisFrozen #Y == chbtn_TM_TBPShByY.state then (macros.run "Ribbon - Modeling" "PolyShiftFreezeYToggle")
if PolyToolsShift.GetAxisFrozen #Z == chbtn_TM_TBPShByZ.state then (macros.run "Ribbon - Modeling" "PolyShiftFreezeZToggle")
)
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_PolyShiftEnd =
(
PBEndTrack()
PolyBPolyShiftReset()
PolyToolsUI.PolyShiftActive = false
PolyToolsUI.PSButtons = #(false,false,false)
for i = 13 to 17 do PolyToolsUI.PDButtons[i] = false
)
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_DeleteControlByPShMesh = (try (delete (getNodeByName "ControlByPShMesh")) catch ())
FUNCTION fn_ClearControlByPShMesh = (try delete (for objct in objects where (matchPattern objct.name pattern:"ControlByPShMesh*") collect objct) catch())
	-----fn------------------------------------------------------------------------------------------------------------
	--Order^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByXPos o1 o2 =
(
case of
	(
	(o1.center.x < o2.center.x): -1
	(o1.center.x > o2.center.x): 1
	default: 0
	)
)
FN fn_compareByYPos o1 o2 =
(
case of
	(
	(o1.center.y < o2.center.y): -1
	(o1.center.y > o2.center.y): 1
	default: 0
	)
)
FN fn_compareByZPos o1 o2 =
(
case of
	(
	(o1.center.z < o2.center.z): -1
	(o1.center.z > o2.center.z): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByVolumeDecrease o1 o2 =
(
local oMinMax = ATfn_.GetMinMax #(o1, o2)
local o1x = (oMinMax[2][1].x - oMinMax[1][1].x)
local o2x = (oMinMax[2][2].x - oMinMax[1][2].x)
local o1y = (oMinMax[2][1].y - oMinMax[1][1].y)
local o2y = (oMinMax[2][2].y - oMinMax[1][2].y)
local o1z = (oMinMax[2][1].z - oMinMax[1][1].z)
local o2z = (oMinMax[2][2].z - oMinMax[1][2].z)
if not chbtn_TM_OrderBySizeX.checked do o1x = o2x = 1.
if not chbtn_TM_OrderBySizeY.checked do o1y = o2y = 1.
if not chbtn_TM_OrderBySizeZ.checked do o1z = o2z = 1.
local Volume1 = o1x * o1y * o1z
local Volume2 = o2x * o2y * o2z
case of
	(
	(Volume1 > Volume2): -1
	(Volume1 < Volume2): 1
	default: 0
	)
)
FN fn_compareByVolumeIncrease o1 o2 =
(
local oMinMax = ATfn_.GetMinMax #(o1, o2)
local o1x = (oMinMax[2][1].x - oMinMax[1][1].x)
local o2x = (oMinMax[2][2].x - oMinMax[1][2].x)
local o1y = (oMinMax[2][1].y - oMinMax[1][1].y)
local o2y = (oMinMax[2][2].y - oMinMax[1][2].y)
local o1z = (oMinMax[2][1].z - oMinMax[1][1].z)
local o2z = (oMinMax[2][2].z - oMinMax[1][2].z)
if not chbtn_TM_OrderBySizeX.checked do o1x = o2x = 1.
if not chbtn_TM_OrderBySizeY.checked do o1y = o2y = 1.
if not chbtn_TM_OrderBySizeZ.checked do o1z = o2z = 1.
local Volume1 = o1x * o1y * o1z
local Volume2 = o2x * o2y * o2z
case of
	(
	(Volume1 < Volume2): -1
	(Volume1 > Volume2): 1
	default: 0
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_Order pressed do with undo on
(
local InArr = ATfn_.GetNHH selection true UseChildren:true
local count = InArr.count
if count == 0 do return ATfn_.messageNS()
local axis
if chbtn_TM_OrderByX.checked do axis = 1
if chbtn_TM_OrderByY.checked do axis = 2
if chbtn_TM_OrderByZ.checked do axis = 3
case axis of
	(
	1:
		(
		qsort InArr fn_compareByXPos
		local oldCenterArr = for o in InArr collect o.center
		if rdbtn_TM_OrderBySize.state == 1 then qsort InArr fn_compareByVolumeDecrease else qsort InArr fn_compareByVolumeIncrease
		for n=1 to count do
			(
			local objct = InArr[n]
			local shift = objct.pos - objct.center
			local oldCenter = oldCenterArr[n]
			objct.pos.x = oldCenter.x + shift.x
			)
		)
	2: 
		(
		qsort InArr fn_compareByYPos
		local oldCenterArr = for o in InArr collect o.center
		if rdbtn_TM_OrderBySize.state == 1 then qsort InArr fn_compareByVolumeDecrease else qsort InArr fn_compareByVolumeIncrease
		for n=1 to count do
			(
			local objct = InArr[n]
			local shift = objct.pos - objct.center
			local oldCenter = oldCenterArr[n]
			objct.pos.y = oldCenter.y + shift.y
			)
		)
	3:
		(
		qsort InArr fn_compareByZPos
		local oldCenterArr = for o in InArr collect o.center
		if rdbtn_TM_OrderBySize.state == 1 then qsort InArr fn_compareByVolumeDecrease else qsort InArr fn_compareByVolumeIncrease
		for n=1 to count do
			(
			local objct = InArr[n]
			local shift = objct.pos - objct.center
			local oldCenter = oldCenterArr[n]
			objct.pos.z = oldCenter.z + shift.z
			)
		)
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_SetSpaceValue changed state do (spnr_TM_SetSpaceValue.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_OrderBySizeX changed state do (if not chbtn_TM_OrderBySizeY.checked and not chbtn_TM_OrderBySizeZ.checked do chbtn_TM_OrderBySizeX.checked = true)
on chbtn_TM_OrderBySizeY changed state do (if not chbtn_TM_OrderBySizeX.checked and not chbtn_TM_OrderBySizeZ.checked do chbtn_TM_OrderBySizeY.checked = true)
on chbtn_TM_OrderBySizeZ changed state do (if not chbtn_TM_OrderBySizeX.checked and not chbtn_TM_OrderBySizeY.checked do chbtn_TM_OrderBySizeZ.checked = true)
	-------------------------------------------------------------------------------------------------------------------
local SPCtrls = #(chbtn_TM_OrderByX, chbtn_TM_OrderByY, chbtn_TM_OrderByZ)
on chbtn_TM_OrderByX changed state do (SPCtrls.checked = false; chbtn_TM_OrderByX.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_OrderByY changed state do (SPCtrls.checked = false; chbtn_TM_OrderByY.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_OrderByZ changed state do (SPCtrls.checked = false; chbtn_TM_OrderByZ.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
	--Spacing^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_Spacing pressed do with undo on
(
local InArr = ATfn_.GetNHH selection true UseChildren:true
local count = InArr.count
if count == 0 do return ATfn_.messageNS()
local axis
if chbtn_TM_SpacingByX.checked do axis = 1
if chbtn_TM_SpacingByY.checked do axis = 2
if chbtn_TM_SpacingByZ.checked do axis = 3
local spaceVal = spnr_TM_SetSpaceValue.value
local shift = 0.
case axis of
	(
	1:
		(
		qsort InArr fn_compareByXPos
		local MinMaxAArr = ATfn_.GetMinMax InArr
		local sizeAll = 0.
		for sz in MinMaxAArr[5] do sizeAll += sz.x
		local sizeAllCur = MinMaxAArr[2][count].x - MinMaxAArr[1][1].x
		shift = (sizeAllCur - sizeAll)/((count - 1) as float)
		if chbtn_TM_SetSpaceValue.checked
		then (shift = spaceVal)
		else (if sizeAll > sizeAllCur do shift = 0)
		for n=2 to count do
			(
			InArr[n].pos.x = (InArr[n-1].center.x + MinMaxAArr[5][n-1].x/2. + shift + MinMaxAArr[5][n].x/2.) + (InArr[n].pos.x - InArr[n].center.x)
			)
		)
	2: 
		(
		qsort InArr fn_compareByYPos
		local MinMaxAArr = ATfn_.GetMinMax InArr
		local sizeAll = 0.
		for sz in MinMaxAArr[5] do sizeAll += sz.y
		local sizeAllCur = MinMaxAArr[2][count].y - MinMaxAArr[1][1].y
		shift = (sizeAllCur - sizeAll)/((count - 1) as float)
		if chbtn_TM_SetSpaceValue.checked
		then (shift = spaceVal)
		else (if sizeAll > sizeAllCur do shift = 0)
		for n=2 to count do
			(
			InArr[n].pos.y = (InArr[n-1].center.y + MinMaxAArr[5][n-1].y/2. + shift + MinMaxAArr[5][n].y/2.) + (InArr[n].pos.y - InArr[n].center.y)
			)
		)
	3:
		(
		qsort InArr fn_compareByZPos
		local MinMaxAArr = ATfn_.GetMinMax InArr
		local sizeAll = 0.
		for sz in MinMaxAArr[5] do sizeAll += sz.z
		local sizeAllCur = MinMaxAArr[2][count].z - MinMaxAArr[1][1].z
		shift = (sizeAllCur - sizeAll)/((count - 1) as float)
		if chbtn_TM_SetSpaceValue.checked
		then (shift = spaceVal)
		else (if sizeAll > sizeAllCur do shift = 0)
		for n=2 to count do
			(
			InArr[n].pos.z = (InArr[n-1].center.z + MinMaxAArr[5][n-1].z/2. + shift + MinMaxAArr[5][n].z/2.) + (InArr[n].pos.z - InArr[n].center.z)
			)
		)
	)
if not chbtn_TM_SetSpaceValue.checked do spnr_TM_SetSpaceValue.value = shift
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_SetSpaceValue changed state do (spnr_TM_SetSpaceValue.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
local SPCtrls = #(chbtn_TM_SpacingByX, chbtn_TM_SpacingByY, chbtn_TM_SpacingByZ)
on chbtn_TM_SpacingByX changed state do (SPCtrls.checked = false; chbtn_TM_SpacingByX.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_SpacingByY changed state do (SPCtrls.checked = false; chbtn_TM_SpacingByY.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_SpacingByZ changed state do (SPCtrls.checked = false; chbtn_TM_SpacingByZ.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
	--QuickAlign^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on btn_TM_QuickAlign pressed do with undo on
(
local InArr = ATfn_.GetNHH selection true UseChildren:true
local count = InArr.count
if count == 0 do return ATfn_.messageNS()
local axis
if chbtn_TM_QuickAlignByX.checked do axis = 1
if chbtn_TM_QuickAlignByY.checked do axis = 2
if chbtn_TM_QuickAlignByZ.checked do axis = 3
local MinMaxAArr = ATfn_.GetMinMax InArr
case rdbtn_TM_MinCenterMax.state of
(
1:
	(
	case axis of
		(
		1: for n=1 to count do (InArr[n].pos.x += MinMaxAArr[3][axis] - MinMaxAArr[1][n][axis])
		2: for n=1 to count do (InArr[n].pos.y += MinMaxAArr[3][axis] - MinMaxAArr[1][n][axis])
		3: for n=1 to count do (InArr[n].pos.z += MinMaxAArr[3][axis] - MinMaxAArr[1][n][axis])
		)
	)
2: 
	(
	local centerAver = MinMaxAArr[3] + (MinMaxAArr[4] - MinMaxAArr[3])/2
	case axis of
		(
		1: for n=1 to count do (InArr[n].pos.x += centerAver[axis] - InArr[n].center[axis])
		2: for n=1 to count do (InArr[n].pos.y += centerAver[axis] - InArr[n].center[axis])
		3: for n=1 to count do (InArr[n].pos.z += centerAver[axis] - InArr[n].center[axis])
		)
	)
3:
	(
	case axis of
		(
		1: for n=1 to count do (InArr[n].pos.x += MinMaxAArr[4][axis] - MinMaxAArr[2][n][axis])
		2: for n=1 to count do (InArr[n].pos.y += MinMaxAArr[4][axis] - MinMaxAArr[2][n][axis])
		3: for n=1 to count do (InArr[n].pos.z += MinMaxAArr[4][axis] - MinMaxAArr[2][n][axis])
		)
	)
)
)
	-------------------------------------------------------------------------------------------------------------------
local QACtrls = #(chbtn_TM_QuickAlignByX, chbtn_TM_QuickAlignByY, chbtn_TM_QuickAlignByZ)
on chbtn_TM_QuickAlignByX changed state do (QACtrls.checked = false; chbtn_TM_QuickAlignByX.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_QuickAlignByY changed state do (QACtrls.checked = false; chbtn_TM_QuickAlignByY.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_QuickAlignByZ changed state do (QACtrls.checked = false; chbtn_TM_QuickAlignByZ.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
	--Align^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on btn_TM_PickAndAlign pressed do
(
local toArr = ATfn_.GetNHH selection true UseChildren:true
if toArr.count == 0 do (return messagebox "Select Objects To Align." title:" Align")
if not (chbtn_TM_AlignPosByX.checked or chbtn_TM_AlignPosByY.checked or chbtn_TM_AlignPosByZ.checked \
	or chbtn_TM_AlignRotByX.checked or chbtn_TM_AlignRotByY.checked or chbtn_TM_AlignRotByZ.checked \
	or chbtn_TM_AlignScaleByX.checked or chbtn_TM_AlignScaleByY.checked or chbtn_TM_AlignScaleByZ.checked) \
	do (return messagebox "Check Axis." title:" Align")
for gh in toArr where (isGroupHead gh) do (setGroupOpen gh false)
local pickObj = pickObject pickFrozen:false rubberBand:selection.center
if isValidNode pickObj do
	(
	local byObj = ATfn_.GetTopParent pickObj
	local byRot = quatToEuler2 byObj.rotation.controller.value
	local byScl = byObj.scale
	local byPos = case rdbtn_TM_AlignByPivotCenter.state of
		(
		1: byObj.pivot
		2: byObj.center
		)
	if isValidNode byObj do with undo on
		(
		for toObj in toArr do
			(
			local toPCSh = toObj.pivot - toObj.center
			if rdbtn_TM_AlignByPivotCenter.state == 2 do (CenterPivot toObj)
			---rotation
			if chbtn_TM_AlignRotByX.checked do toObj.rotation.controller[1].value = byRot.X
			if chbtn_TM_AlignRotByY.checked do toObj.rotation.controller[2].value = byRot.Y
			if chbtn_TM_AlignRotByZ.checked do toObj.rotation.controller[3].value = byRot.Z
			---scale
			if chbtn_TM_AlignScaleByX.checked do toObj.scale.X = byScl.X
			if chbtn_TM_AlignScaleByY.checked do toObj.scale.Y = byScl.Y
			if chbtn_TM_AlignScaleByZ.checked do toObj.scale.Z = byScl.Z
			---position
			if chbtn_TM_AlignPosByX.checked do toObj.pos.X = byPos.X
			if chbtn_TM_AlignPosByY.checked do toObj.pos.Y = byPos.Y
			if chbtn_TM_AlignPosByZ.checked do toObj.pos.Z = byPos.Z
			----------
			if rdbtn_TM_AlignByPivotCenter.state == 2 do (toObj.pivot += toPCSh)
			)
		)
	)
)
	--Place^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local plInG
local plOutGArr = #()
local plCloneState
local plInstState
local plProceed
local plInGTransform
local plZRot = 0
local plMousePos
local plMRot = 0
local plInGscale = [1, 1, 1]
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_PlaceObjects pressed do with undo off
(
local selArr = selection as array
if selArr.count == 0 do return ATfn_.messageNS()
plCloneState = chbtn_TM_PlaceClone.checked
plInstState = chbtn_TM_PlaceClonInst.checked
chbtn_TM_PlaceClone.enabled = false
chbtn_TM_PlaceClonInst.enabled = false
plOutGArr = #()
plProceed = true
	-----fn----------------------------------------------
FN fn_mouseTrackObject msg ir obj faceNum shift ctrl alt =
(
if msg == #freeMove
then
	(
	if ctrl do plZRot = 0
	if ir != undefined
	then
		(
		plInG.pos = ir.pos
		if chbtn_TM_PlaceMatchFace.checked then plInG.dir = ir.dir else plInG.dir = plInG.dir
		)
	else
		(
		plInG.pos = mapScreenToCP mouse.pos
		if chbtn_TM_PlaceMatchFace.checked then plInG.dir = [0,0,1] else plInG.dir = plInG.dir
		)
	plInG.transform = (transMatrix [0,0,spnr_TM_PlaceOffset.value]) * (rotateZmatrix plZRot) * plInG.transform
	plMousePos = mouse.pos
	return #continue
	)
if msg == #mousePoint
then
	(
	plMousePos = mouse.pos
	if plCloneState
	then (return #end)
	else (plProceed = false; return #end)
	)
if msg == #mouseMove
then 
	(
	local SnapMRot = plMRot
	plMRot = (plMousePos.x - mouse.pos.x)/2
	local curRot = SnapMRot - plMRot
	plZRot += curRot
	local curScl = 1 + (curRot/100.)
	if keyboard.altPressed
	then (plInG.transform = (scaleMatrix [curScl, curScl, curScl]) * plInG.transform)
	else (plInG.transform = (rotateZmatrix curRot) * plInG.transform)
	return #continue
	)
if msg == #mouseAbort
then 
	(
	if plCloneState
	then (delete plInG)
	else (plInG.transform = plInGTransform)
	plProceed = false
	return #end
	)
)
	-----fn---------------------------------------
local OnGeometry = for objct in (ATfn_.ArraysDifference geometry selArr) where not objct.isHidden collect objct
local ZeroG = group selArr name:"GroupPlaceByMouseTrack_000"
plInG = ZeroG
local gArr = ATfn_.GetGroupByHead plInG ObjectsOnly:true
local gmm = ATfn_.GetMinMax gArr
plInG.pivot = gmm[3] + (gmm[4] - gmm[3])/2
plInG.pivot.z = gmm[3].z
plInGTransform = plInG.transform
plInGscale = plInG.scale

if plCloneState
then
	(
	while plProceed do
		(
		plMRot = 0
		plZRot = 0
		plInG = ATfn_.CopyObject plInG IInstance:plInstState Frozen:false Hidden:false
		plInG.scale = plInGscale
		appendifunique plOutGArr plInG
		mouseTrack on:OnGeometry trackCallBack:fn_mouseTrackObject
		if isValidNode plInG do (join OnGeometry (ATfn_.GetGroupByHead plInG ObjectsOnly:true))
		)
	)
else
	(
	plMRot = 0
	plZRot = 0
	mouseTrack on:OnGeometry trackCallBack:fn_mouseTrackObject
	)
plOutGArr = for g in plOutGArr where isValidNode g collect g
if plCloneState
then (select plOutGArr; ungroup plOutGArr; ungroup ZeroG)
else (select ZeroG; ungroup ZeroG)
select (selection as array)
chbtn_TM_PlaceClone.enabled = true
chbtn_TM_PlaceClonInst.enabled = chbtn_TM_PlaceClone.checked
clearUndoBuffer()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_PlaceClone changed state do (chbtn_TM_PlaceClonInst.enabled = state; ATfn_.chbtnColorUpdate #(chbtn_TM_PlaceClonInst) colCHBX)
	--Drop^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
FN fn_compareByZPosDecrease r1 r2 =
(
local r1ZMax = r1.pos.z
local r2ZMax = r2.pos.z
case of
	(
	(r1ZMax > r2ZMax): -1
	(r1ZMax < r2ZMax): 1
	default: 0
	)
)
FN fn_compareByZPosIncrease r1 r2 =
(
local r1ZMax = r1.pos.z
local r2ZMax = r2.pos.z
case of
	(
	(r1ZMax < r2ZMax): -1
	(r1ZMax > r2ZMax): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
	/*
on btn_TM_DropOnScene pressed do with undo on
(
local DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in DropWithArr do o.transform = o.transform; undo off
if DropWithArr.count > 0 then
	(
	local bbsz = $.max - $.min
	local boxH = units.decodeValue "1000m"
	local intBox = box width:bbsz[1] length:bbsz[2] height:boxH pos:$.center
	intBox.pos.z -= boxH/2
	local DropOnArr = for o in (ATfn_.ArraysDifference (Objects as array) (selection as array)) where ((intersects intBox o) and not o.isHidden) collect o
	delete intBox
	DropOnArr = ATfn_.GetGeometry DropOnArr
	if DropOnArr.count > 0 do
		(
		clearSelection()
		ATfn_.SetPivot DropWithArr 0 0 1 true
		qSort DropWithArr fn_compareByZPosIncrease
		if chbtn_TM_DropOnSelected.checked do (join DropOnArr (ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true))
		local zt = units.decodeValue "1mm" ---Tolerance by Z axis
		local mmDO = ATfn_.GetMinMax DropOnArr
		for wo in DropWithArr do
			(
			local IntRayArr = #()
			local RayFrom = [wo.pos.x, wo.pos.y, (mmDO[4][3] + zt)]
			for oo in DropOnArr do
				(
				local IntRay = intersectRay oo (ray RayFrom -z_axis)
				if IntRay != undefined do (if IntRay.pos.z < (wo.pos.z + zt) do append IntRayArr IntRay)
				)
			if IntRayArr.count > 0
			then
				(
				qSort IntRayArr fn_compareByZPosDecrease
				wo.pos = IntRayArr[1].pos
				if chbtn_TM_DropMatchFace.checked do (wo.dir = IntRayArr[1].dir)
				)
			else (if (wo.pos.z + zt) > 0 do wo.pos.z = 0)
			redrawViews()
			)
		resetPivot DropWithArr
		select DropWithArr
		)
	) else ()
completeRedraw()
)
	-- */
-- 	/*   -----   New Drop   -----   New Drop   -----   New Drop   -----   New Drop   -----   New Drop   -----   New Drop   
on btn_TM_DropOnScene pressed do with undo on
(
	clearListener()
-- 	local startTime = timeStamp()
-- local quality = 4
local quality = spnr_TM_AdvDropQuality.value
local DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in DropWithArr do o.transform = o.transform; undo off
if DropWithArr.count > 0 then
	(
	local boxH = units.decodeValue "1000m"
	local bbsz = $.max - $.min
	local intBox = box width:bbsz[1] length:bbsz[2] height:boxH pos:$.center
	intBox.pos.z -= boxH/2
	local DropOnAllArr = for o in (ATfn_.ArraysDifference (Objects as array) (selection as array)) where ((intersects intBox o) and not o.isHidden) collect o
	delete intBox
	DropOnAllArr = ATfn_.GetGeometry DropOnAllArr
	if DropOnAllArr.count > 0 do
		(
-- 		suspendEditing()
-- 		disableSceneRedraw()
		clearSelection()
		ATfn_.SetPivot DropWithArr 0 0 1 true
		qSort DropWithArr fn_compareByZPosIncrease
		if chbtn_TM_DropOnSelected.checked do (join DropOnAllArr (ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true))
		local zt = units.decodeValue "1mm" ---Tolerance by Z axis
		for n=1 to DropWithArr.count do
			(
			local wo = DropWithArr[n]
			bbsz = wo.max - wo.min
			intBox = box width:bbsz[1] length:bbsz[2] height:boxH pos:wo.center
			intBox.pos.z -= boxH/2
-- 			local DropOnArr = for o in DropOnAllArr where (intersects intBox o) collect o
			local DropOnArr = for o in DropOnAllArr where (intersects intBox o) and (wo.min.z > o.min.z) collect o
			delete intBox
			if DropOnArr.count > 0
			then
				(
				local mmDW = ATfn_.GetMinMax #(wo)
				local ZPlane = mmDW[1][1][3] - zt
				local woSzX = mmDW[5][1][1]; local woSzY = mmDW[5][1][2]
				local bbRat = woSzX / woSzY
				local ratLim = 7.
				local Mult = 5 * quality
				if bbRat > ratLim do bbRat = ratLim
				local XGridCount = (bbRat * Mult) as integer
				local YGridCount = Mult
				if bbRat < 1 do
					(
					bbRat = 1. / bbRat
					if bbRat > ratLim do bbRat = ratLim
					XGridCount = Mult
					YGridCount = (bbRat * Mult) as integer
					)
				local XCell = woSzX / XGridCount
				local YCell = woSzY / YGridCount
				local RayGridNet = #()
				local woMinX = mmDW[1][1][1]; local woMinY = mmDW[1][1][2]
				for nYG=0 to YGridCount do
					(
					for nXG=0 to XGridCount do
						(append RayGridNet [(woMinX + (XCell * nXG)), (woMinY + (YCell * nYG)) , ZPlane])
					)
				local woNet = #()
				for rg in RayGridNet do
					(
					local IntRay = intersectRay wo (ray rg z_axis)
					if IntRay != undefined do
						(append woNet IntRay.pos)
					)
				local allDistances = #()
				for oo in DropOnArr do
					(
					for wn in woNet do
						(
						local IntRay = intersectRay oo (ray wn -z_axis)
						if IntRay != undefined do (append allDistances (distance wn IntRay.pos))
						)
					)
				if allDistances.count > 0
				then (wo.pos.z -= (aMin allDistances))
				else (wo.pos.z = 0)
				redrawViews()
				)
			else (wo.pos.z = 0)
			)
		resetPivot DropWithArr
		select DropWithArr
-- 		resumeEditing()
-- 		enableSceneRedraw()
		)
	) else ()
redrawViews()
-- 	format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - startTime)).ToString()) ".")[1]
)
	-- */   -----   New Drop   -----   New Drop   -----   New Drop   -----   New Drop   -----   New Drop END
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_DropOnScene rightclick do with undo on
(
local DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in DropWithArr do o.transform = o.transform; undo off
local IntArr = #(); local NotIntArr = #()
if DropWithArr.count > 0 then
	(
	local bbsz = $.max - $.min
	local boxH = units.decodeValue "1000m"
	local intBox = box width:bbsz[1] length:bbsz[2] height:boxH pos:$.center
	intBox.pos.z -= boxH/2
	local DropOnArr = for o in (ATfn_.ArraysDifference (Objects as array) (selection as array)) where ((intersects intBox o) and not o.isHidden) collect o
	delete intBox
	DropOnArr = ATfn_.GetGeometry DropOnArr
	if DropOnArr.count > 0 do
		(
		clearSelection()
		ATfn_.SetPivot DropWithArr 0 0 1 true
		qSort DropWithArr fn_compareByZPosIncrease
		if chbtn_TM_DropOnSelected.checked do (join DropOnArr (ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true))
		local zt = units.decodeValue "1mm" ---Tolerance by Z axis
		local mmDO = ATfn_.GetMinMax DropOnArr
		for wo in DropWithArr do
			(
			local IntRayArr = #()
			local RayFrom = [wo.pos.x, wo.pos.y, (mmDO[4][3] + zt)]
			for oo in DropOnArr do
				(
				local IntRay = intersectRay oo (ray RayFrom -z_axis)
				if IntRay != undefined do (if IntRay.pos.z < (wo.pos.z + zt) do append IntRayArr IntRay)
				)
			if IntRayArr.count > 0
			then
				(
				qSort IntRayArr fn_compareByZPosDecrease
				wo.pos = IntRayArr[1].pos
				if chbtn_TM_DropMatchFace.checked do (wo.dir = IntRayArr[1].dir)
				appendIfUnique IntArr wo
				)
			else
				(
				appendIfUnique NotIntArr wo
-- 				wo.pos.z = 0
				)
			redrawViews()
			)
		resetPivot DropWithArr
-- 		(ATfn_.GetArrayByHeads IntArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor()
-- 		(ATfn_.GetArrayByHeads NotIntArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor()
		select NotIntArr
-- 		select DropWithArr
		)
	) else ()
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_DropOnPicked pressed do with undo on
(
Global DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in DropWithArr do o.transform = o.transform; undo off
if DropWithArr.count > 0 then
	(
	local DropOnArr = #()
	local rbc = $.center
	clearSelection()
	btn_TM_DropOnPicked.enabled = false
	FN fn_FilterDW o = (findItem DropWithArr o == 0)
	while isValidNode (objct = pickObject filter:fn_FilterDW rubberBand:rbc rubberBandColor:white)
		do (if (ATfn_.GCheck objct) do (appendifunique DropOnArr objct; objct.xray = true))
	DropOnArr.xray = false
	if DropOnArr.count > 0 do
		(
		ATfn_.SetPivot DropWithArr 0 0 1 true
		qSort DropWithArr fn_compareByZPosIncrease
		if chbtn_TM_DropOnSelected.checked do (join DropOnArr (ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true))
		local zt = units.decodeValue "1mm" ---Tolerance by Z axis
		local mmDO = ATfn_.GetMinMax DropOnArr
		for wo in DropWithArr do
			(
			local IntRayArr = #()
			local RayFrom = [wo.pos.x, wo.pos.y, (mmDO[4][3] + zt)]
			for oo in DropOnArr do
				(
				local IntRay = intersectRay oo (ray RayFrom -z_axis)
				if IntRay != undefined do (if IntRay.pos.z < (wo.pos.z + zt) do append IntRayArr IntRay)
				)
			if IntRayArr.count > 0
			then
				(
				qSort IntRayArr fn_compareByZPosDecrease
				wo.pos = IntRayArr[1].pos
				if chbtn_TM_DropMatchFace.checked do (wo.dir = IntRayArr[1].dir)
				)
			else (if (wo.pos.z + zt) > 0 do wo.pos.z = 0)
			redrawViews()
			)
		resetPivot DropWithArr
		)
	select DropWithArr
	btn_TM_DropOnPicked.enabled = true
	) else ()
GlobalVars.remove "DropWithArr"
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_DropOnPicked rightclick do with undo on
(
-- clearListener()
Global DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in DropWithArr do (o.transform = o.transform; o.wirecolor = o.wirecolor); undo off
local IntArr = #(); local NotIntArr = #()
if DropWithArr.count > 0 then
	(
	local DropOnArr = #()
	local rbc = $.center
	clearSelection()
	btn_TM_DropOnPicked.enabled = false
	FN fn_FilterDW o = (findItem DropWithArr o == 0)
	while (objct = pickObject filter:fn_FilterDW rubberBand:rbc rubberBandColor:white) != undefined do
		(if (ATfn_.GCheck objct) do (appendifunique DropOnArr objct; objct.xray = true))
	DropOnArr.xray = false
	if DropOnArr.count > 0 do
		(
		ATfn_.SetPivot DropWithArr 0 0 1 true
		qSort DropWithArr fn_compareByZPosIncrease
		if chbtn_TM_DropOnSelected.checked do (join DropOnArr (ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true))
		local zt = units.decodeValue "1mm" ---Tolerance by Z axis
		local mmDO = ATfn_.GetMinMax DropOnArr
		for wo in DropWithArr do
			(
			local IntRayArr = #()
			local RayFrom = [wo.pos.x, wo.pos.y, (mmDO[4][3] + zt)]
			for oo in DropOnArr do
				(
				local IntRay = intersectRay oo (ray RayFrom -z_axis)
				if IntRay != undefined do (if IntRay.pos.z < (wo.pos.z + zt) do append IntRayArr IntRay)
				)
			if IntRayArr.count > 0
			then
				(
				qSort IntRayArr fn_compareByZPosDecrease
				wo.pos = IntRayArr[1].pos
				if chbtn_TM_DropMatchFace.checked do (wo.dir = IntRayArr[1].dir)
				appendIfUnique IntArr wo
				)
			else (appendIfUnique NotIntArr wo)
			redrawViews()
			)
		resetPivot DropWithArr
		)
	select NotIntArr
-- 	(ATfn_.GetArrayByHeads IntArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor()
-- 	(ATfn_.GetArrayByHeads NotIntArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor()
	btn_TM_DropOnPicked.enabled = true
	) else ()
GlobalVars.remove "DropWithArr"
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_DropOnGrid pressed do with undo on
(
-- clearListener()
local DropWithArr = ATfn_.GetNHH (selection as array) true UseChildren:true
if DropWithArr.count > 0 then
(
clearSelection()
ATfn_.SetPivot DropWithArr 0 0 1 true
qSort DropWithArr fn_compareByZPosIncrease
local DropWithObjsArr = ATfn_.GetArrayByHeads DropWithArr ObjectsOnly:true
if chbtn_TM_DropOnSelected.checked
then
	(
	local zt = units.decodeValue "1mm" ---Tolerance by Z axis
	local mmDO = ATfn_.GetMinMax DropWithArr
	for wo in DropWithArr do
		(
		local IntRayArr = #()
		local RayFrom = [wo.pos.x, wo.pos.y, (mmDO[4][3] + zt)]
		for oo in DropWithObjsArr do
			(
			local IntRay = intersectRay oo (ray RayFrom -z_axis)
			if IntRay != undefined do (if IntRay.pos.z < (wo.pos.z + zt) do append IntRayArr IntRay)
			)
		if IntRayArr.count > 0
		then
			(
			qSort IntRayArr fn_compareByZPosDecrease
			wo.pos = IntRayArr[1].pos
			if chbtn_TM_DropMatchFace.checked do (wo.dir = IntRayArr[1].dir)
			)
		else (wo.pos.z = 0)
		redrawViews()
		)
	)
else (for objct in DropWithArr do (objct.pos.z = 0))
resetPivot DropWithArr
select DropWithArr
) else ()
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_QuickRotateByX rightclick do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in InArr do o.rotation.controller[1].value=0
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_QuickRotateByY rightclick do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in InArr do o.rotation.controller[2].value=0
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_QuickRotateByZ rightclick do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in InArr do o.rotation.controller[3].value=0
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_TM_RotationReset pressed do with undo on
(
local InArr = ATfn_.GetNHH (selection as array) true UseChildren:true
for o in InArr do o.rotation.controller.value = (quat 0 0 0 0)
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
FN fn_QuickRotate val =
(
local InArr = ATfn_.GetNHH (selection as array) true UseChildren:true
local Xrot = 0; if chbtn_TM_QuickRotateByX.checked then (Xrot = val)
local Yrot = 0; if chbtn_TM_QuickRotateByY.checked then (Yrot = val)
local Zrot = 0; if chbtn_TM_QuickRotateByZ.checked then (Zrot = val)
if chbtn_TM_QuickRotateAsGroup.checked
then
	(
	local gr
	gr = group InArr
	in coordsys #world rotate gr (eulerangles Xrot Yrot Zrot)
	ungroup gr
	)
else
	(
-- 	in coordsys (if rdbtn_TM_RandCoordSys.state==1 then #world else #local) rotate InArr (eulerangles Xrot Yrot Zrot)
	in coordsys #world rotate InArr (eulerangles Xrot Yrot Zrot)
	)
redrawViews()
)
on btn_TM_QuickRotate180 pressed do with undo on (fn_QuickRotate 180)
on btn_TM_QuickRotate180 rightclick do with undo on (fn_QuickRotate -180)
on btn_TM_QuickRotate90 pressed do with undo on (fn_QuickRotate 90)
on btn_TM_QuickRotate90 rightclick do with undo on (fn_QuickRotate -90)
on btn_TM_QuickRotate45 pressed do with undo on (fn_QuickRotate 45)
on btn_TM_QuickRotate45 rightclick do with undo on (fn_QuickRotate -45)
on btn_TM_QuickRotate10 pressed do with undo on (fn_QuickRotate 10)
on btn_TM_QuickRotate10 rightclick do with undo on (fn_QuickRotate -10)
on btn_TM_QuickRotate5 pressed do with undo on (fn_QuickRotate 5)
on btn_TM_QuickRotate5 rightclick do with undo on (fn_QuickRotate -5)
on btn_TM_QuickRotate1 pressed do with undo on (fn_QuickRotate 1)
on btn_TM_QuickRotate1 rightclick do with undo on (fn_QuickRotate -1)
on btn_TM_QuickRotateCustom pressed do with undo on (fn_QuickRotate spnr_TM_QuickRotateVal.value)
on btn_TM_QuickRotateCustom rightclick do with undo on (fn_QuickRotate -spnr_TM_QuickRotateVal.value)
	-------------------------------------------------------------------------------------------------------------------
	--Transform By Shift^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION fn_TBPShOff =
(
tmr_TM_CheckTBPSh.active = false
chbtn_TM_TBPShShift.checked = false
ResetPivot TBPShArr
fn_DeleteControlByPShMesh()
select TBPShArr
-- clearUndoBuffer()
gc()
redrawViews()
)
	-----fn------------------------------------------------------------------------------------------------------------
FUNCTION getAxis =
(
local axisP3
if chbtn_TM_TBPShRotateByX.checked do axisP3 = [1,0,0]
if chbtn_TM_TBPShRotateByY.checked do axisP3 = [0,1,0]
if chbtn_TM_TBPShRotateByZ.checked do axisP3 = [0,0,1]
axisP3
)
	-----fn------------------------------------------------------------------------------------------------------------
local TBPShAttributes = ATTRIBUTES TBPShAttributes  \
(
PARAMETERS Data
	(
	VirtualMesh type:#maxObject
	InputObjects type:#nodeTab tabSizeVariable:on
	Axis type:#point3 default:[0,0,1] animatable:false
	)

FUNCTION setVirtualMesh inMesh =
	(
	local instMesh = createInstance Editable_mesh
	instMesh.mesh = inMesh
	this.VirtualMesh.AppendItem instMesh
	)
FUNCTION setInputObjects inArr = (for n=1 to inArr.count do this.InputObjects[n] = inArr[n])
FUNCTION updateInputObjects cntrlPoly =
	(
	local index = 0
	local virtMesh = VirtualMesh.GetItem 1
	for obj in this.InputObjects do
		(
		local newPos = getPointPos cntrlPoly (index += 1)
		local virtMPos = meshOp.getVert virtMesh index
-- 		if newPos != virtMPos do with undo on
		if newPos != virtMPos do with undo off
			(
			if keyboard.altPressed
-- 			if keyboard.altPressed and PolyToolsUI.PSButtons[2] != true and PolyToolsUI.PSButtons[3] != true
			then
				(
				local diffPos = ((virtMPos.x + virtMPos.y + virtMPos.z) - (newPos.x + newPos.y + newPos.z))*7
				local scf = diffPos/200
				if keyboard.controlPressed
				then (if mouse.buttonStates[1] do in coordsys #world scale obj [1-scf,1-scf,1-scf])
				else (if mouse.buttonStates[1] do in coordsys #world rotate obj (angleaxis diffPos this.Axis))
				)
			else (obj.pos = newPos)
			)
		meshOp.setVert virtMesh index newPos
		polyOp.setVert cntrlPoly index obj.pos
		)
	true
	)
FUNCTION getOwner = ( (refs.dependentNodes (custAttributes.getOwner this))[1] )

on postLoad do (if isValidNode (this.getOwner()) do (when geometry refNode changes obj do with undo off obj.TBPShAttributes.updateInputObjects obj))
on postCreate do (this.VirtualMesh = RefTargContainer())
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local TBPShAttr
	-------------------------------------------------------------------------------------------------------------------
on tmr_TM_CheckTBPSh tick do (if PolyToolsUI.PolyShiftActive == false do fn_TBPShOff())
	-------------------------------------------------------------------------------------------------------------------
FUNCTION fn_PolyShiftMoveStart ToolStr State =
(
if State
then
	(
	if isValidNode PShPoly
	then (macros.run "PolyTools" ToolStr)
	else
		(
		TBPShArr = ATfn_.GetNHH (selection as array) true UseChildren:true
		tmr_TM_CheckTBPSh.active = true
		PShPoly = convertToPoly (Mesh vertices:(for obj in TBPShArr collect obj.pos) faces:#() name:"ControlByPShMesh")
		custAttributes.add PShPoly TBPShAttributes
		TBPShAttr = PShPoly.TBPShAttributes
		PShPoly.TBPShAttributes.setVirtualMesh (snapshotAsMesh PShPoly)
		PShPoly.TBPShAttributes.setInputObjects TBPShArr
		PShPoly.TBPShAttributes.Axis = getAxis()
		when geometry PShPoly changes obj do with undo off obj.TBPShAttributes.updateInputObjects obj
		select PShPoly
		if not PolyToolsUI.PolyShiftActive do (macros.run "PolyTools" ToolStr)
		fn_PolyShiftFreezeToggle()
		)
	)
else
	(
	if PolyToolsUI.PolyShiftActive do (fn_PolyShiftEnd())
	fn_TBPShOff()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_TBPShShift changed state do with undo off
(
if selection.count == 0 do (chbtn_TM_TBPShShift.checked = false; return false)
fn_PolyShiftMoveStart "PolyShiftMove" state
)
	-------------------------------------------------------------------------------------------------------------------
local TBCtrls = #(chbtn_TM_TBPShByX,chbtn_TM_TBPShByY,chbtn_TM_TBPShByZ)
on chbtn_TM_TBPShByX changed state do (if not chbtn_TM_TBPShByY.checked and not chbtn_TM_TBPShByZ.checked then (chbtn_TM_TBPShByX.checked = true); fn_PolyShiftFreezeToggle())
on chbtn_TM_TBPShByY changed state do (if not chbtn_TM_TBPShByX.checked and not chbtn_TM_TBPShByZ.checked then (chbtn_TM_TBPShByY.checked = true); fn_PolyShiftFreezeToggle())
on chbtn_TM_TBPShByZ changed state do (if not chbtn_TM_TBPShByX.checked and not chbtn_TM_TBPShByY.checked then (chbtn_TM_TBPShByZ.checked = true); fn_PolyShiftFreezeToggle())
	---
on chbtn_TM_TBPShByX rightclick do (TBCtrls.checked = false; chbtn_TM_TBPShByX.checked = true; fn_PolyShiftFreezeToggle())
on chbtn_TM_TBPShByY rightclick do (TBCtrls.checked = false; chbtn_TM_TBPShByY.checked = true; fn_PolyShiftFreezeToggle())
on chbtn_TM_TBPShByZ rightclick do (TBCtrls.checked = false; chbtn_TM_TBPShByZ.checked = true; fn_PolyShiftFreezeToggle())
	-------------------------------------------------------------------------------------------------------------------
local RBCtrls = #(chbtn_TM_TBPShRotateByX, chbtn_TM_TBPShRotateByY, chbtn_TM_TBPShRotateByZ)
on chbtn_TM_TBPShRotateByX changed state do (RBCtrls.checked = false; chbtn_TM_TBPShRotateByX.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_TBPShRotateByY changed state do (RBCtrls.checked = false; chbtn_TM_TBPShRotateByY.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
on chbtn_TM_TBPShRotateByZ changed state do (RBCtrls.checked = false; chbtn_TM_TBPShRotateByZ.checked = true; if TBPShAttr != undefined then TBPShAttr.Axis = getAxis())
	-------------------------------------------------------------------------------------------------------------------
	--Move By Scale^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local ch_TM_MBSLArr = #(chbtn_TM_MBSMoveByX,chbtn_TM_MBSMoveByY,chbtn_TM_MBSMoveByZ)
on chbtn_TM_MBSMoveByX changed state do (if not chbtn_TM_MBSMoveByY.checked and not chbtn_TM_MBSMoveByZ.checked then (chbtn_TM_MBSMoveByX.checked = true))
on chbtn_TM_MBSMoveByY changed state do (if not chbtn_TM_MBSMoveByX.checked and not chbtn_TM_MBSMoveByZ.checked then (chbtn_TM_MBSMoveByY.checked = true))
on chbtn_TM_MBSMoveByZ changed state do (if not chbtn_TM_MBSMoveByX.checked and not chbtn_TM_MBSMoveByY.checked then (chbtn_TM_MBSMoveByZ.checked = true))
	---
on chbtn_TM_MBSMoveByX rightclick do (ch_TM_MBSLArr.checked = false; chbtn_TM_MBSMoveByX.checked = true)
on chbtn_TM_MBSMoveByY rightclick do (ch_TM_MBSLArr.checked = false; chbtn_TM_MBSMoveByY.checked = true)
on chbtn_TM_MBSMoveByZ rightclick do (ch_TM_MBSLArr.checked = false; chbtn_TM_MBSMoveByZ.checked = true)
	-------------------------------------------------------------------------------------------------------------------
FN fn_MBSbuttonDown =
(
local selArr = ATfn_.GetNHH (selection as array) true UseChildren:true
UNDO ON; for objct in selArr do (objct.pos = objct.pos) --forUndo
if not chbtn_TM_MBSPickCenter.checked do (MBSCenter = [0,0,0]; for objct in selArr do (MBSCenter += objct.center); MBSCenter /= selArr.count)
MBSArr = #(); MBSPosArr = #()
for objct in selArr do (append MBSArr objct; append MBSPosArr objct.pos)
redrawViews()
)
on spnr_TM_MoveByScale buttonDown do (fn_MBSbuttonDown())
	------------------------------------
on spnr_TM_MoveByScale buttonUp do with undo off (spnr_TM_MoveByScale.value = 1)
	------------------------------------
on spnr_TM_MoveByScale changed val do with undo off
(
local Spd = 10.
local NewPos = [0,0,0]
local NewPosX = 0; local NewPosY = 0; local NewPosZ = 0
for n in 1 to MBSArr.count do
	(
	local PivCenShift = MBSArr[n].pos - MBSArr[n].center
	NewPos = MBSPosArr[n] - MBSCenter - PivCenShift
-- 	if not chbtn_TM_MBSMoveByX.checked then NewPosX = NewPos.x else NewPosX = NewPos.x * val
-- 	if not chbtn_TM_MBSMoveByY.checked then NewPosY = NewPos.y else NewPosY = NewPos.y * val
-- 	if not chbtn_TM_MBSMoveByZ.checked then NewPosZ = NewPos.z else NewPosZ = NewPos.z * val
	if not chbtn_TM_MBSMoveByX.checked then NewPosX = NewPos.x else NewPosX = NewPos.x * (pow val Spd)
	if not chbtn_TM_MBSMoveByY.checked then NewPosY = NewPos.y else NewPosY = NewPos.y * (pow val Spd)
	if not chbtn_TM_MBSMoveByZ.checked then NewPosZ = NewPos.z else NewPosZ = NewPos.z * (pow val Spd)
	MBSArr[n].pos = MBSCenter + [NewPosX, NewPosY, NewPosZ] + PivCenShift
	)
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_TM_MoveByX buttonDown do (fn_MBSbuttonDown())
on spnr_TM_MoveByX buttonUp do with undo off (spnr_TM_MoveByX.value = 1)
on spnr_TM_MoveByX changed val do with undo off (local NewPos = [0,0,0]; for n in 1 to MBSArr.count do (local PivCenShift = MBSArr[n].pos - MBSArr[n].center; NewPos = MBSPosArr[n] - MBSCenter - PivCenShift; MBSArr[n].pos = MBSCenter + [NewPos.x*val, NewPos.y, NewPos.z] + PivCenShift))
	-------------------------------------------------------------------------------------------------------------------
on spnr_TM_MoveByY buttonDown do (fn_MBSbuttonDown())
on spnr_TM_MoveByY buttonUp do with undo off (spnr_TM_MoveByY.value = 1)
on spnr_TM_MoveByY changed val do with undo off (local NewPos = [0,0,0]; for n in 1 to MBSArr.count do (local PivCenShift = MBSArr[n].pos - MBSArr[n].center; NewPos = MBSPosArr[n] - MBSCenter - PivCenShift; MBSArr[n].pos = MBSCenter + [NewPos.x, NewPos.y*val, NewPos.z] + PivCenShift))
	-------------------------------------------------------------------------------------------------------------------
on spnr_TM_MoveByZ buttonDown do (fn_MBSbuttonDown())
on spnr_TM_MoveByZ buttonUp do with undo off (spnr_TM_MoveByZ.value = 1)
on spnr_TM_MoveByZ changed val do with undo off (local NewPos = [0,0,0]; for n in 1 to MBSArr.count do (local PivCenShift = MBSArr[n].pos - MBSArr[n].center; NewPos = MBSPosArr[n] - MBSCenter - PivCenShift; MBSArr[n].pos = MBSCenter + [NewPos.x, NewPos.y, NewPos.z*val] + PivCenShift))
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_MBSPickCenter changed state do
(
if state
then
	(
	local obj = pickObject ()
	if obj != undefined
	then (MBSCenter = obj.center; chbtn_TM_MBSPickCenter.images = ATIcons[38])
	else (chbtn_TM_MBSPickCenter.checked = false)
	)
else
	(
	local selArr = selection as array
	MBSCenter = [0,0,0]; for objct in selArr do (MBSCenter += objct.center)
	MBSCenter /= selArr.count
	chbtn_TM_MBSPickCenter.images = ATIcons[26]
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_TM_MBSPickCenter rightclick do
(
local obj = pickObject ()
if obj != undefined then (MBSCenter = obj.center; chbtn_TM_MBSPickCenter.images = ATIcons[38]; chbtn_TM_MBSPickCenter.checked = true)
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on rollout_TM_ open do
	(
	fn_ClearControlByPShMesh()
	fn_PolyShiftReset()
	)
on rollout_TM_ close do
	(
	fn_ClearControlByPShMesh()
	)
)
	----=Select====================================================================================================
rollout rollout_SEL_ "Select"
(
local yp1 = #(0, 68, 134, 200, 224, 248, 272)
GroupBox grp_SEL_SelectBy "Select By:" pos:[2,yp1[1]] width:(fl0W-15) height:65
button btn_SEL_SelectByInst "Instances" pos:[5,yp1[1]+15] width:95 height:21 tooltip:" Select Instances "
button btn_SEL_SelectByMat "Material" pos:[103,yp1[1]+15] width:99 height:21 tooltip:" Select By Material "
button btn_SEL_SelectByWire "Wirecolor" pos:[5,yp1[1]+39] width:95 height:21 tooltip:" Select By Wirecolor "
button btn_SEL_SelByMultiSub "Multi/Sub" pos:[103,yp1[1]+39] width:99 height:21 tooltip:" Select by Multi/Sub-Object Material "

GroupBox grp_SEL_SelectByName "Select By Name:" pos:[2,yp1[2]] width:(fl0W-15) height:63
dropdownlist ddl_SEL_SetName items:#("Object","<Part") pos:[6,yp1[2]+15] width:20 height:33 selection:0 tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_SEL_SelectByName "" pos:[24,yp1[2]+17] width:176 height:17 bold:false tooltip:" Select By Name Part "
radiobuttons rdbtn_SEL_SelectedOrScene "" labels:#("Selected","Scene") pos:[10,yp1[2]+39] columns:2 offsets:#([0,0],[5,0]) default:2 enabled:false tooltip:" Process Selected Objects \n Or All Scene Objects "
button btn_SEL_SelectByName "Select" pos:[140,yp1[2]+37] width:60 height:21 tooltip:" Select By Name Part "

GroupBox grp_SEL_SelectBySize "Select By Size:" pos:[2,yp1[3]] width:(fl0W-15) height:61
spinner spnr_SEL_SelectBySizeMin "Min:" pos:[15,yp1[3]+15] width:84 range:[0,999999,0] type:#float scale:0.001 toolTip:" Minimal Size Parameter "
spinner spnr_SEL_SelectBySizeMax "Max:" pos:[114,yp1[3]+15] width:87 range:[0,999999,0] type:#float scale:0.001 toolTip:" Maximal Size Parameter "
checkButton chbtn_SEL_SelectBySizeX "X" pos:[126,yp1[3]+34] width:22 height:21 highlightColor:[204,64,64] checked:true tooltip:" X Axis Size Parameter \n Rmb - Get Min Max of Selecton "
checkButton chbtn_SEL_SelectBySizeY "Y" pos:[152,yp1[3]+34] width:22 height:21 highlightColor:[63,164,63] tooltip:" Y Axis Size Parameter \n Rmb - Get Min Max of Selecton "
checkButton chbtn_SEL_SelectBySizeZ "Z" pos:[178,yp1[3]+34] width:22 height:21 highlightColor:[70,114,255] tooltip:" Z Axis Size Parameter \n Rmb - Get Min Max of Selecton "
button btn_SEL_SelectBySize "Select" pos:[8,yp1[3]+34] width:110 height:21 tooltip:" Selected by Size "

button btn_SEL_InstancesOnly "Instances Only" pos:[0,yp1[4]] width:100 height:21 tooltip:" Only Instances In Selected "
button btn_SEL_UniqueOnly "Unique Only" pos:[103,yp1[4]] width:103 height:21 tooltip:" Only Unique In Selected "

button btn_SEL_InstancesTrim "Instances Trim" pos:[0,yp1[5]] width:100 height:21 tooltip:" Deselects Instances Except One "
button btn_SEL_MakeUnique "Make Unique" pos:[103,yp1[5]] width:103 height:21 tooltip:" Make Objects Unique "

button btn_SEL_SelectAll "Select All" pos:[0,yp1[6]] width:100 height:21 tooltip:" Select All "
button btn_SEL_SelectInvert "Select Invert" pos:[103,yp1[6]] width:103 height:21 tooltip:" Invert Selection "

button btn_SEL_SelectSimilar "Select Similar" pos:[0,yp1[7]] width:100 height:21 tooltip:" Select Similar Objects "
button btn_SEL_SelectEmptyObjects "Select Empty" pos:[103,yp1[7]] width:103 height:21 tooltip:" Select Empty Objects "
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectBySize pressed do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
local axis = #(chbtn_SEL_SelectBySizeX.checked, chbtn_SEL_SelectBySizeY.checked, chbtn_SEL_SelectBySizeZ.checked)
local mn = spnr_SEL_SelectBySizeMin.value
local mx = spnr_SEL_SelectBySizeMax.value
local InArr = selection as array
local szArr = (ATfn_.GetMinMax InArr)[5]
local toSelArr = #()
for n=1 to szArr.count do
	(
	local state = true
	for nax=1 to 3 do
		(
		local mmState = if axis[nax] then (mn <= szArr[n][nax] and szArr[n][nax] <= mx) else true
		if not mmState do state = mmState
		)
	if state do append toSelArr InArr[n]
	)
select toSelArr
)
	-------------------------------------------------------------------------------------------------------------------
	-----fn--------------------------------------------------
FN fn_MinMaxSize InArr axis:1 = 
(
if selection.count == 0 do (return false)
local szArr = (ATfn_.GetMinMax InArr)[5]
local minSzs = [999999,999999,999999]; local maxSzs = [0,0,0]
for sz in szArr do
	(
	minSzs = [(if sz[1] < minSzs[1] then sz[1] else minSzs[1]), (if sz[2] < minSzs[2] then sz[2] else minSzs[2]), (if sz[3] < minSzs[3] then sz[3] else minSzs[3])]
	maxSzs = [(if sz[1] > maxSzs[1] then sz[1] else maxSzs[1]), (if sz[2] > maxSzs[2] then sz[2] else maxSzs[2]), (if sz[3] > maxSzs[3] then sz[3] else maxSzs[3])]
	)
-- local shift = units.decodeValue "0,01mm"
local shift = 0.001
spnr_SEL_SelectBySizeMin.value = minSzs[axis] - shift
spnr_SEL_SelectBySizeMax.value = maxSzs[axis] + shift
)
	-----fn-----------------------------------
on chbtn_SEL_SelectBySizeX rightclick do (fn_MinMaxSize (selection as array) axis:1)
	----------------------------------------
on chbtn_SEL_SelectBySizeY rightclick do (fn_MinMaxSize (selection as array) axis:2)
	----------------------------------------
on chbtn_SEL_SelectBySizeZ rightclick do (fn_MinMaxSize (selection as array) axis:3)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_SEL_SelectBySizeX changed state do (chbtn_SEL_SelectBySizeY.checked = chbtn_SEL_SelectBySizeZ.checked = false; chbtn_SEL_SelectBySizeX.checked = true)
on chbtn_SEL_SelectBySizeY changed state do (chbtn_SEL_SelectBySizeX.checked = chbtn_SEL_SelectBySizeZ.checked = false; chbtn_SEL_SelectBySizeY.checked = true)
on chbtn_SEL_SelectBySizeZ changed state do (chbtn_SEL_SelectBySizeX.checked = chbtn_SEL_SelectBySizeY.checked = false; chbtn_SEL_SelectBySizeZ.checked = true)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectByName pressed do with undo on
(
local txt = edt_SEL_SelectByName.text
if txt == "" do return false
local patArr = ATfn_.CollectByPattern txt inside:(if rdbtn_SEL_SelectedOrScene.state == 1 then selection else objects)
for o in patArr where not o.isHidden collect o
if patArr.count == 0
then (return messageBox ("Objects with \"" + txt + "\" in Name not Found.") title:"Objects not Found." beep:false)
else (select patArr)
)
	-------------------------------------------------------------------------------------------------------------------
on ddl_SEL_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_SEL_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_SEL_SetName.items = deepCopy savedNamesArr)
	ATfn_.ddlWidthDynamic ddl_SEL_SetName
	)
else (edt_SEL_SelectByName.text = (ddl_SEL_SetName.items)[item])
)
on ddl_SEL_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_SEL_SetName.items
	appendIfUnique savedNamesArr edt_SEL_SelectByName.text
	sort savedNamesArr
	ddl_SEL_SetName.items = deepCopy savedNamesArr
	ATfn_.ddlWidthDynamic ddl_SEL_SetName
	setFocus edt_SEL_SelectByName
	)
else
	(
	edt_SEL_SelectByName.text = ""
	setFocus edt_SEL_SelectByName
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_UniqueOnly pressed do with undo on
(
local UniqArr = for objct in selection where not (InstanceMgr.CanMakeObjectsUnique #(objct)) collect objct
clearSelection(); select UniqArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_InstancesOnly pressed do with undo on
(
local InstArr = for objct in selection where (InstanceMgr.CanMakeObjectsUnique #(objct)) collect objct
clearSelection(); select InstArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_MakeUnique pressed do with undo on (InstanceMgr.MakeObjectsUnique selection #individual)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_InstancesTrim pressed do with undo on (select (ATfn_.InstancesTrim selection))
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectEmptyObjects pressed do with undo on
(
ATfn_.CheckEmpty objects
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectSimilar pressed do with undo on (actionMan.executeAction 0 "40099")
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectAll pressed do with undo on (max select all)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectInvert pressed do with undo on (max select invert)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectByInst pressed do
(
local instArr = ATfn_.InstancesAppend (selection as array)
undo on
ATfn_.SelectInGroups instArr
redrawViews()
max modify mode
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectByMat pressed do
(
local matArr = #(); matArr = for selObj in selection where (selObj.material != undefined) collect selObj.material
local objArr = #(); for objct in objects where not objct.isHidden do (for mat in matArr where objct.material == mat do (appendIfUnique objArr objct))
undo on
ATfn_.SelectInGroups objArr
redrawViews()
max modify mode
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelectByWire pressed do
(
local WColArr = #(); local WColObjArr = #()
for sobj in selection do (appendIfUnique WColArr sobj.wirecolor)
for objct in objects where not objct.isHidden do (for wc in WColArr where objct.wirecolor == wc do (appendIfUnique WColObjArr objct))
undo on
ATfn_.SelectInGroups WColObjArr
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SEL_SelByMultiSub pressed do
(
local MultiSubMatArr = #(); local MultiSubObjArr = #()
-- for objct in selection where classOf objct.material == Multimaterial do (appendIfUnique MultiSubMatArr objct.material)
MultiSubMatArr = getclassinstances Multimaterial
for objct in objects where not objct.isHidden do (for sm in MultiSubMatArr where objct.material == sm do (appendIfUnique MultiSubObjArr objct))
undo on
select MultiSubObjArr
redrawViews()
max modify mode
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_SEL_ open do
-- 	(
-- 	)
-- on rollout_SEL_ close do
-- 	(
-- 	)
)
	----=Pivot====================================================================================================
local lines_color = ATfn_.GetINI 0 iniFile "Preferences" "color_PS_LatticeColor_Color" gray
local points_color = ATfn_.GetINI 0 iniFile "Preferences" "color_PS_PointsColor_Color" white
	-------------------------------------------------------------------------------------------------------------------
rollout rollout_PV_ "Pivot"
(
local yp1 = #(0, 24, 51, 97, 121)
checkButton chbtn_PV_AffectPivotOnly "Edit Pivot" pos:[0,yp1[1]] width:103 height:21 checked:(maxops.pivotmode == #pivotonly) highlightColor:colCHBX tooltip:" Edit Pivot Toggle "
button btn_PV_ResetPivot "Reset Pivot" pos:[106,yp1[1]] width:100 height:21 tooltip:" Reset Pivot "

button btn_PV_MoveToCenter "Move Center" pos:[0,yp1[2]] width:103 height:21 tooltip:" Set Pivot Position To Object Center "
button btn_PV_MoveToZMin "Move Z Min" pos:[106,yp1[2]] width:100 height:21 tooltip:" Set Pivot Position To Minimum By Z Axis "

GroupBox grp_PV_PivotLattice "Pivot  Lattice" pos:[2,yp1[3]] width:(fl0W-15) height:41
button btn_PV_PivotLattice "Set Pivot" pos:[5,yp1[3]+15] width:75 height:21 tooltip:" Activate Pivot Lattice "
-- checkButton chbtn_PV_PivotLattice "Set Pivot" pos:[5,yp1[3]+15] width:70 height:21 highlightColor:colCHBX tooltip:" Toggle Pivot Lattice "
radiobuttons rdbtn_PV_MultipleSingle "" labels:#("Multiple","Single") pos:[85,yp1[3]+18] columns:2 offsets:#([0,0],[4,0]) default:1 tooltip:" Unique Pivot Position For Each Object Or \n One For All Objects "

button btn_PV_MoveToObject "Move To Object" pos:[0,yp1[4]] width:93 height:21 tooltip:" Set Pivot Position To Picked Object Pivot "
button btn_PV_MoveToSubObject "Move To Subobject" pos:[96,yp1[4]] width:110 height:21 tooltip:" Set Position Pivot To Subobject Selection "

button btn_PV_AlignToWorld "Orient To World" pos:[0,yp1[5]] width:103 height:21 tooltip:" Orient Pivot To World Axis "
button btn_PV_AlignToObject "Orient To Object" pos:[106,yp1[5]] width:100 height:21 tooltip:" Lmb - Pivot Orientation From Picked Object \n Rmb - Pivot Orientation And Position From Picked "

	-----fn------------------------------------------------------------------------------------------------------------
	---Pivot Lattice---------------------------------------------------------------------------------------------------
global fngw_draw_lattice
local points_arr = #()
local lines_arr = #()
local snap_point = undefined
local snap_target = undefined
local target_index = undefined
	-----fn------------------------------------------------------------------------------------------------------------
FN fngw_draw_lines =
(
-- 	/*
lines_color_array = #(lines_color, lines_color)
for la in lines_arr do gw.Polyline la true rgb:lines_color_array
	-- */
	/*
lines_color = blue
lines_color_array = #(lines_color, lines_color)
for n=1 to lines_arr.count do
	(
	if n > 9 then if n > 18 then lines_color_array = #(green, green) else lines_color_array = #(red, red)
	gw.Polyline lines_arr[n] true rgb:lines_color_array
	)
	-- */
)

FN fn_trans_point pt =
(
local trans_point = gw.wTransPoint pt
trans_point.z = 0.
return trans_point
)

FN fngw_draw_points = (for p in points_arr do gw.wMarker (fn_trans_point p) #circle color:points_color)

FN fngw_snap_points =
(
snap_point = undefined
-- snap_tolerance = units.decodeValue "10cm"
snap_tolerance = 13
points_screen = #(); for p in points_arr do (tp = gw.transPoint p; append points_screen [tp[1], tp[2]])
for n=1 to points_screen.count do
	(
	p = points_screen[n]
	dist = distance p mouse.pos
	if dist < snap_tolerance
	then
		(
		snap_tolerance = dist
		snap_point = points_arr[n]
		)
	)
if snap_point != undefined do (gw.wMarker (fn_trans_point snap_point) #bigBox color:green)
if snap_target != undefined do (gw.wMarker (fn_trans_point snap_target) #bigBox color:red)
)

FN fngw_draw_lattice =
(
gw.setTransform (matrix3 1)
fngw_draw_lines()
fngw_draw_points()
fngw_snap_points()
gw.enlargeUpdateRect #whole
gw.UpdateScreen()
if keyboard.escPressed do (unregisterRedrawViewsCallback fngw_draw_lattice)
)

FN fn_pivotByIndex inputArr index =
(
for objct in inputArr do
	(
	bb = nodeGetBoundingBox objct (matrix3 1)
	mn = bb[1]
	mx = bb[2]
	cn = mn + (mx - mn)/2
	x1 = mn[1]; x2 = mx[1]; x0 = cn[1]
	y1 = mn[2]; y2 = mx[2]; y0 = cn[2]
	z1 = mn[3]; z2 = mx[3]; z0 = cn[3]
	points_arr = #()
	for x in #(x1, x0, x2) do
		for y in #(y1, y0, y2) do
			for z in #(z1, z0, z2) do append points_arr [x, y, z]
	objct.pivot = points_arr[index]
	)
)

FN mouseTrack_PivotLattice msg ir obj faceNum shift ctrl alt =
(
if msg == #freeMove do (redrawViews(); return #continue)
if msg == #mousePoint do
	(
	if snap_point != undefined
	then (snap_target = snap_point; target_index = findItem points_arr snap_point)
	else (snap_target = undefined)
	redrawViews()
	return #continue
	)
if msg == #mouseMove do return #continue
if msg == #mouseAbort do return #end
)
	-----fn------------------------------------------------------------------------------------------------------------
on btn_PV_PivotLattice pressed do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
-- max zoomext sel
commandmode = toolmode.commandmode
toolmode.commandmode = #select

mm = ATfn_.GetMinMax selection
mn = mm[3]
mx = mm[4]
cn = mn + (mx - mn)/2
x1 = mn[1]; x2 = mx[1]; x0 = cn[1]
y1 = mn[2]; y2 = mx[2]; y0 = cn[2]
z1 = mn[3]; z2 = mx[3]; z0 = cn[3]

for x in #(x1, x0, x2) do
	for y in #(y1, y0, y2) do
		for z in #(z1, z0, z2) do append points_arr [x, y, z]

points_plane = #()
for x in #(x1, x0, x2) do for y in #(y1, y0, y2) do append points_plane [x, y, z1]
for p in points_plane do append lines_arr #(p, [p[1], p[2], z2])
points_plane = #()
for y in #(y1, y0, y2) do for z in #(z1, z0, z2) do append points_plane [x1, y, z]
for p in points_plane do append lines_arr #(p, [x2, p[2], p[3]])
points_plane = #()
for x in #(x1, x0, x2) do for z in #(z1, z0, z2) do append points_plane [x, y1, z]
for p in points_plane do append lines_arr #(p, [p[1], y2, p[3]])

unregisterRedrawViewsCallback fngw_draw_lattice
registerRedrawViewsCallback fngw_draw_lattice

track_return = mouseTrack trackCallBack:mouseTrack_PivotLattice
if track_return == #continue or track_return == #end do
	(
	unregisterRedrawViewsCallback fngw_draw_lattice
	if snap_target != undefined do
		(
		if track_return != #continue do
			(
			if rdbtn_PV_MultipleSingle.state == 1
			then (fn_pivotByIndex selection target_index)
			else (selection.pivot = snap_target)
			)
		)
	points_arr = #()
	lines_arr = #()
	snap_point = undefined
	snap_target = undefined
	target_index = undefined
	)

try (toolmode.commandmode = commandmode) catch (toolmode.commandmode = #select)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_MoveToSubObject pressed do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
local CurrentModifier = modPanel.getCurrentObject()
if (classof CurrentModifier == Edit_Poly or classof CurrentModifier == Editable_Poly) and subobjectLevel != 0 do
	(
	local selVertArr = #()
	local avgPosArr = #()
	local avgPos = 0
	if subobjectLevel != 1 do (CurrentModifier.ConvertSelection #CurrentLevel #Vertex; subobjectLevel = 1)
	if (classof CurrentModifier == Edit_Poly) and ((CurrentModifier.getSelection #Vertex).numberSet >= 1) then
		(
		selVertArr = CurrentModifier.getSelection #Vertex
		avgPosArr = for vert in selVertArr collect (CurrentModifier.GetVertex vert)
		)
	else if (classof CurrentModifier == Editable_Poly) and (selection[1].selectedVerts.count >= 1) then 
			(
			selVertArr = for i in selection[1].selectedVerts collect i.index
			avgPosArr = for vert in selVertArr collect selection[1].verts[vert].pos
			)
	for p = 1 to avgPosArr.count do avgPos += avgPosArr[p]
	avgPos = avgPos/avgPosArr.count
	$.pivot = avgPos
	subObjectLevel = 0
-- 	setCoordCenter #local
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_MoveToObject pressed do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
local pickObj = pickObject pickFrozen:false rubberBand:selection.center
if isValidNode pickObj do
	(
	local byObj = ATfn_.GetTopParent pickObj
	if byObj != undefined do (selection.pivot = byObj.pos)
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_AlignToObject pressed do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
local pickObj = pickObject pickFrozen:false rubberBand:selection.center
if isValidNode pickObj do
	(
	local byObj = ATfn_.GetTopParent pickObj
	if byObj != undefined do (for objct in selection do ATfn_.AlignPivotTo objct byObj)
	redrawViews()
	)
)
	------
on btn_PV_AlignToObject rightclick do with undo on
(
if selection.count == 0 do (return ATfn_.messageNS())
local pickObj = pickObject pickFrozen:false rubberBand:selection.center
if isValidNode pickObj do
	(
	local byObj = ATfn_.GetTopParent pickObj
	if byObj != undefined do (for objct in selection do ATfn_.AlignPivotTo objct byObj SetPosition:true)
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_AlignToWorld pressed do with undo on (for objct in selection do ATfn_.AlignPivotTo objct (matrix3 1))
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_MoveToCenter pressed do with undo on (ATfn_.SetPivot selection 0 0 0 false)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_MoveToZMin pressed do with undo on (ATfn_.SetPivot selection undefined undefined 1 false)
	-------------------------------------------------------------------------------------------------------------------
on btn_PV_ResetPivot pressed do with undo on (resetPivot selection)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_PV_AffectPivotOnly changed state do 
(
if state then maxops.pivotmode = #pivotonly else maxops.pivotmode = #none
ATfn_.Refresh()
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_PV_ open do
-- 	(
-- 	)
-- on rollout_PV_ close do
-- 	(
-- 	)
)
	----=ID=================================================================================================
rollout rollout_ID_ "ID"
(
local yp1 = #(0)
local ID_w = 22; local ID_start = 5; local ID_x = for n=1 to 8 collect (ID_start + ((ID_w+3)*(n-1)))
local ID_yp_1 = yp1[1]+15; local ID_yp_2 = yp1[1]+39; local ID_yp_3 = yp1[1]+63; local ID_yp_4 = yp1[1]+87; local ID_yp_5 = yp1[1]+111
local ttpID = " Lmb - Set ID For Selected \n Rmb - Select Polygons By ID "
GroupBox grp_ID_SetID "Set ID" pos:[2,yp1[1]] width:(fl0W-15) height:137
button btn_ID_ID1 "1" pos:[ID_x[1],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID2 "2" pos:[ID_x[2],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID3 "3" pos:[ID_x[3],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID4 "4" pos:[ID_x[4],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID5 "5" pos:[ID_x[5],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID6 "6" pos:[ID_x[6],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID7 "7" pos:[ID_x[7],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID8 "8" pos:[ID_x[8],ID_yp_1] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID9 "9" pos:[ID_x[1],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID10 "10" pos:[ID_x[2],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID11 "11" pos:[ID_x[3],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID12 "12" pos:[ID_x[4],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID13 "13" pos:[ID_x[5],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID14 "14" pos:[ID_x[6],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID15 "15" pos:[ID_x[7],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID16 "16" pos:[ID_x[8],ID_yp_2] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID17 "17" pos:[ID_x[1],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID18 "18" pos:[ID_x[2],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID19 "19" pos:[ID_x[3],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID20 "20" pos:[ID_x[4],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID21 "21" pos:[ID_x[5],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID22 "22" pos:[ID_x[6],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID23 "23" pos:[ID_x[7],ID_yp_3] width:ID_w height:21 tooltip:ttpID
button btn_ID_ID24 "24" pos:[ID_x[8],ID_yp_3] width:ID_w height:21 tooltip:ttpID
spinner spnr_ID_CustomID "ID" pos:[ID_x[1]+12,ID_yp_4+3] width:40 range:[1,999,1] type:#Integer scale:1 tooltip:" Custom ID "
button btn_ID_SetCustomID "Set ID" pos:[ID_x[3]+5,ID_yp_4] width:64 height:21 tooltip:" Set ID For Selected "
button btn_ID_SelectCustomID "Select ID" pos:[ID_x[6]-3,ID_yp_4] width:75 height:21 tooltip:" Select Polygons By ID "
button btn_ID_CheckerID "ID Checker Material" pos:[ID_x[1],ID_yp_5] width:119 height:21 tooltip:" Assign ID Checker Material "
button btn_ID_InfoID "Show Info" pos:[ID_x[6]-3,ID_yp_5] width:75 height:21 tooltip:" Show Oblects ID "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SetID id =
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local EPid = id-1
max modify mode
if Filters.Is_EPolySpecifyLevel #{5,6}
then
	(
	if (classof (modPanel.getCurrentObject()) == Edit_Poly)
	then
		(
		$.modifiers[#Edit_Poly].SetOperation #SetMaterial
		$.modifiers[#Edit_Poly].materialIDToSet = EPid
		$.modifiers[#Edit_Poly].Commit ()
		)
	else (polyOp.setFaceMatID $ (polyop.getFaceSelection $) id)
	)
else
    (
    for objct in GArr do
        (
		local modMat = objct.modifiers[1]
		if (modMat != undefined and classOf modMat == Materialmodifier)
		then (modMat.materialID = id)
		else (addModifier objct (Materialmodifier materialID:id))
		)
    )
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectID id =
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
max modify mode
local EPid = id-1
for objct in GArr do
	(
	select objct
	if Filters.Is_EPoly()
	then
		(
		subobjectLevel = 4
		if (classof (modPanel.getCurrentObject()) == Edit_Poly)
		 then
			(
			$.modifiers[#Edit_Poly].SetSelection #Face #{}
			$.modifiers[#Edit_Poly].selectByMaterialID = EPid
			$.modifiers[#Edit_Poly].ButtonOp #SelectByMaterial
			)
		 else
			(
			$.SetSelection #Face #{}
			$.selectByMaterial id
			)
		)
	else
		(
		addModifier $ (Edit_Poly ())
		subobjectLevel = 4
		$.modifiers[#Edit_Poly].selectByMaterialID = EPid
		$.modifiers[#Edit_Poly].ButtonOp #SelectByMaterial
		)
	subobjectLevel = 0
	)
if GArr.count != 1 do
	(
	select GArr
	modPanel.addModToSelection (Edit_Poly ()) ui:on
	)
subobjectLevel = 4
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_ID_ID1 pressed do with undo on (fn_SetID 1)
on btn_ID_ID2 pressed do with undo on (fn_SetID 2)
on btn_ID_ID3 pressed do with undo on (fn_SetID 3)
on btn_ID_ID4 pressed do with undo on (fn_SetID 4)
on btn_ID_ID5 pressed do with undo on (fn_SetID 5)
on btn_ID_ID6 pressed do with undo on (fn_SetID 6)
on btn_ID_ID7 pressed do with undo on (fn_SetID 7)
on btn_ID_ID8 pressed do with undo on (fn_SetID 8)
on btn_ID_ID9 pressed do with undo on (fn_SetID 9)
on btn_ID_ID10 pressed do with undo on (fn_SetID 10)
on btn_ID_ID11 pressed do with undo on (fn_SetID 11)
on btn_ID_ID12 pressed do with undo on (fn_SetID 12)
on btn_ID_ID13 pressed do with undo on (fn_SetID 13)
on btn_ID_ID14 pressed do with undo on (fn_SetID 14)
on btn_ID_ID15 pressed do with undo on (fn_SetID 15)
on btn_ID_ID16 pressed do with undo on (fn_SetID 16)
on btn_ID_ID17 pressed do with undo on (fn_SetID 17)
on btn_ID_ID18 pressed do with undo on (fn_SetID 18)
on btn_ID_ID19 pressed do with undo on (fn_SetID 19)
on btn_ID_ID20 pressed do with undo on (fn_SetID 20)
on btn_ID_ID21 pressed do with undo on (fn_SetID 21)
on btn_ID_ID22 pressed do with undo on (fn_SetID 22)
on btn_ID_ID23 pressed do with undo on (fn_SetID 23)
on btn_ID_ID24 pressed do with undo on (fn_SetID 24)
	-------------
on btn_ID_ID1 rightclick do with undo on (fn_SelectID 1)
on btn_ID_ID2 rightclick do with undo on (fn_SelectID 2)
on btn_ID_ID3 rightclick do with undo on (fn_SelectID 3)
on btn_ID_ID4 rightclick do with undo on (fn_SelectID 4)
on btn_ID_ID5 rightclick do with undo on (fn_SelectID 5)
on btn_ID_ID6 rightclick do with undo on (fn_SelectID 6)
on btn_ID_ID7 rightclick do with undo on (fn_SelectID 7)
on btn_ID_ID8 rightclick do with undo on (fn_SelectID 8)
on btn_ID_ID9 rightclick do with undo on (fn_SelectID 9)
on btn_ID_ID10 rightclick do with undo on (fn_SelectID 10)
on btn_ID_ID11 rightclick do with undo on (fn_SelectID 11)
on btn_ID_ID12 rightclick do with undo on (fn_SelectID 12)
on btn_ID_ID13 rightclick do with undo on (fn_SelectID 13)
on btn_ID_ID14 rightclick do with undo on (fn_SelectID 14)
on btn_ID_ID15 rightclick do with undo on (fn_SelectID 15)
on btn_ID_ID16 rightclick do with undo on (fn_SelectID 16)
on btn_ID_ID17 rightclick do with undo on (fn_SelectID 17)
on btn_ID_ID18 rightclick do with undo on (fn_SelectID 18)
on btn_ID_ID19 rightclick do with undo on (fn_SelectID 19)
on btn_ID_ID20 rightclick do with undo on (fn_SelectID 20)
on btn_ID_ID21 rightclick do with undo on (fn_SelectID 21)
on btn_ID_ID22 rightclick do with undo on (fn_SelectID 22)
on btn_ID_ID23 rightclick do with undo on (fn_SelectID 23)
on btn_ID_ID24 rightclick do with undo on (fn_SelectID 24)
	-------------
on btn_ID_SetCustomID pressed do with undo on (fn_SetID spnr_ID_CustomID.value)
on btn_ID_SelectCustomID pressed do with undo on (fn_SelectID spnr_ID_CustomID.value)
	-------------
on btn_ID_CheckerID pressed do with undo on (selection.mat = ATfn_.IDCheckerMaterial())
on btn_ID_InfoID pressed do with undo off
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local idList = #()
for objct in GArr do
	(
	local bArr = #{}
	local os = snapshotAsMesh objct
	for f=1 to os.numfaces do bArr[getFaceMatID os f] = on
	delete os
	for id in (bArr as array) do appendIfUnique idList id
	)
local id_string = "Objects Contain " + (idList.count as string) + " ID:\n\n"
for n=1 to idList.count do
	(
	id_string += idList[n] as string
	if n != idList.count do id_string += ", "
	if n/10. == n/10 do  id_string += "\n"
	)
messageBox id_string title:"ID Info" beep:false
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_ID_ open do
-- 	(
-- 	)
-- on rollout_ID_ close do
-- 	(
-- 	)
)
	----=EditGeometry=================================================================================================
rollout rollout_EG_ "Geometry"
(
local yp1 = #(0, 24, 48, 72, 96, 120, 144, 168, 190, 233)
button btn_EG_PrepareModels "Prepare Models For Work" pos:[0,yp1[1]] width:206 height:21 tooltip:" Prepare Models For Work: \n  - Recreate Groups \n  - Reset XForm \n  (Inside Groups Preserved XForm) "

button btn_EG_ResetXForm "Reset XForm" pos:[0,yp1[2]] width:98 height:21 tooltip:" Reset XForm "
button btn_EG_PreservedXForm "Preserved XForm" pos:[101,yp1[2]] width:105 height:21 tooltip:" Reset XForm With Preserved Pivot Orientation "

button btn_EG_AddTurnToPoly "Turn To Poly" pos:[0,yp1[3]] width:75 height:21 tooltip:" Lmb - Add Turn To Poly Modifier \n Rmb - Add Unique Turn To Poly Modifier "
button btn_EG_AddEditPoly "Edit Poly" pos:[78,yp1[3]] width:52 height:21 tooltip:" Lmb - Add Edit Poly Modifier \n Rmb - Add Unique Edit Poly Modifier "
button btn_EG_ConvertToEP "Editable Poly" pos:[133,yp1[3]] width:73 height:21 tooltip:" Convert To Editable Poly "

button btn_EG_AddTurboSmooth "TurboSmooth" pos:[0,yp1[4]] width:75 height:21 tooltip:" Lmb - Add Turbo Smooth Modifier \n Rmb - Add Turbo Smooth Modifier, \n           by Smoothing Groups "
button btn_EG_SmoothingGroupsByUV "Smooth by UV" pos:[78,yp1[4]] width:76 height:21 tooltip:" Smoothing Groups By UV Shells "
button btn_EG_AddSmooth "Smooth" pos:[157,yp1[4]] width:49 height:21 tooltip:" Lmb - Add Smooth Modifier \n Rmb - Add Unique Smooth Modifier "

button btn_EG_AddNormal "Normal" pos:[0,yp1[5]] width:55 height:21 tooltip:" Lmb - Add Normal Modifier \n Rmb - Add Unique Normal Modifier "
button btn_EG_FlipNormals "Flip" pos:[58,yp1[5]] width:45 height:21 tooltip:" Flip Normals "
button btn_EG_AddWeightedNormals "Weighted Normals" pos:[106,yp1[5]] width:100 height:21 tooltip:" Lmb - Add Weighted Normals Modifier \n Rmb - Add Unique Weighted Normals Modifier "

button btn_EG_Quadrify "Quadrify All" pos:[0,yp1[6]] width:75 height:21 tooltip:" Quadrify Selected Objects "
button btn_EG_Weld "Weld" pos:[78,yp1[6]] width:75 height:21 tooltip:" Weld "
spinner spnr_EG_WeldThreshold "" pos:[153,yp1[6]+3] width:52 range:[0.001,9999,0.001] type:#Float scale:0.001 tooltip:" Weld Threshold "

button btn_EG_Attach "Attach" pos:[0,yp1[7]] width:82 height:21 tooltip:" Lmb - Attach Selected Objects "
spinner spnr_EG_AttachParts "" pos:[82,yp1[7]+3] width:35 range:[1,999,1] type:#Integer scale:1 tooltip:" Attach Parts "
button btn_EG_Detach "Detach" pos:[121,yp1[7]] width:85 height:21 tooltip:" Lmb - Detach Element As Object \n Rmb - Detach Element With Dialog "

button btn_EG_Explode "Explode" pos:[0,yp1[8]] width:82 height:21 tooltip:" Lmb - Explode Objects to Elements \n Rmb - Explode to Elements (Set Name) "
spinner spnr_EG_ExplodeParts "" pos:[82,yp1[8]+3] width:35 range:[0,999,0] type:#Integer scale:1 tooltip:" Explode Parts "
button btn_EG_ExplodeByID "Explode By ID" pos:[121,yp1[8]] width:85 height:21 tooltip:" Lmb - Explode Objects by ID \n Rmb - Explode by ID (Set Name) "

GroupBox grp_EG_SelectByAngle "Select Polygons By Angle" pos:[2,yp1[9]] width:(fl0W-15) height:40
spinner spnr_EG_SelectByAngleVal "Angle:" pos:[25,yp1[9]+18] width:75 range:[0,180,45] type:#float scale:0.1 toolTip:" Select By Angle Value "
button btn_EG_SelectByAngleOn "On" pos:[104,yp1[9]+15] width:50 height:21 tooltip:" Select By Angle On "
button btn_EG_SelectByAngleOff "Off" pos:[157,yp1[9]+15] width:45 height:21 tooltip:" Select By Angle Off "

button btn_EG_SelectBySG "Select By Smoothing Groups" pos:[0,yp1[10]] width:206 height:21 tooltip:" Select By Smoothing Groups "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectByAngleToggle state =
(
if selection.count == 1 do
	(
	if not (Filters.Is_EPoly()) do
		(try (addModifier $ (Edit_Poly ())) catch (return false))
	max modify mode
	if state do subObjectLevel = 4
	if Filters.Is_EditPolyMod()
	then ((modPanel.getCurrentObject()).SelectByAngle = state)
	else ($.SelectByAngle = state)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SetAngleValue val =
(
if Filters.Is_EPoly() do
	(
	max modify mode
	if Filters.Is_EditPolyMod()
	then ((modPanel.getCurrentObject()).selectAngle = val)
	else ($.selectAngle = val)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CollapseToEP inArr =
(
for objct in inArr do
	(
-- 	addModifier objct (Edit_Mesh ())
	addModifier objct (Edit_Poly ())
	maxOps.CollapseNodeTo objct 1 true
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Weld objArr Threshold =
(
for objct in objArr do
	(
	objct.EditablePoly.SetSelection #Vertex #{1..(objct.verts.count)}
	objct.weldThreshold = Threshold
	objct.EditablePoly.weldFlaggedVertices ()
	objct.EditablePoly.SetSelection #Vertex #{}
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on spnr_EG_SelectByAngleVal entered do with undo off (fn_SetAngleValue spnr_EG_SelectByAngleVal.value)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_SelectByAngleOff pressed do with undo off (fn_SelectByAngleToggle off)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_SelectByAngleOn pressed do with undo off (fn_SelectByAngleToggle on; fn_SetAngleValue spnr_EG_SelectByAngleVal.value)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_SelectBySG pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
if Filters.Is_EPolySpecifyLevel #{5,6} do
	(
	local sgArr = #()
	local msh = copy $.mesh
	for f in (msh.selectedFaces as bitarray) do (appendIfUnique sgArr (getfacesmoothgroup msh f))
	local bitSel = 0; for b in sgArr do bitSel += b  --- To set smoothing groups 1, 5, and 17, you need to add 2^(1-1) + 2^(5-1) + 2^(17-1) = 65553. 
	if (classof (modPanel.getCurrentObject()) == Edit_Poly)
	then
		(
		$.modifiers[#Edit_Poly].selectBySmoothingGroup = bitSel
-- 		$.modifiers[#Edit_Poly].selectBySmoothingGroupClear = on
		$.modifiers[#Edit_Poly].ButtonOp #SelectBySmooth
		)
	else ($.EditablePoly.selectBySmoothGroup bitSel)
	)
)
	-------------------------------------------------------------------------------------------------------------------
-- on btn_EG_ResetXForm pressed do with undo on (ATfn_.ResetsXForm 0 (ATfn_.GetGeometry selection VRProxy:false))
on btn_EG_ResetXForm pressed do with undo on (PolyBoost.Resetxfunc())
on btn_EG_PreservedXForm pressed do with undo on (ATfn_.ResetsXForm 1 (ATfn_.GetGeometry selection VRProxy:false))
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_SmoothingGroupsByUV pressed do with undo on
	(
	modPanel.addModToSelection (Weighted_Normals useUVSeams:true) ui:on
	modPanel.addModToSelection (Edit_Poly()) ui:on
-- 	fn_CollapseToEP (ATfn_.InstancesTrim (ATfn_.GetGeometry selection))
	)
on btn_EG_SmoothingGroupsByUV rightclick do
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
undo on
for objct in GArr do 
	(
	addModifier objct (Weighted_Normals useUVSeams:true)
	addModifier objct (Edit_Poly())
	)
-- fn_CollapseToEP GArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddWeightedNormals pressed do (modPanel.addModToSelection (Weighted_Normals()) ui:on)
on btn_EG_AddWeightedNormals rightclick do
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
undo on
for objct in GArr do (addModifier objct (Weighted_Normals()) )
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddSmooth pressed do (modPanel.addModToSelection (Smooth autosmooth:on) ui:on)
on btn_EG_AddSmooth rightclick do
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
undo on
for objct in GArr do (addModifier objct (Smooth autosmooth:on) )
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddTurboSmooth pressed do (modPanel.addModToSelection (TurboSmooth()) ui:on)
on btn_EG_AddTurboSmooth rightclick do (modPanel.addModToSelection (TurboSmooth sepBySmGroups:on) ui:on)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_Detach pressed do with undo on
(
max modify mode
if Filters.Is_EPolySpecifyLevel #{5,6} and (PolyBGetSel 3).count!=0
then
	(
	local objName = ATfn_.RemoveCounter ($.name)
	local newName = uniqueName "ldkfdflsds" numDigits:9
	if classOf (modPanel.getCurrentObject()) == Edit_Poly
	then
		(
		local CurrentModifier = modPanel.getCurrentObject()
		local fSel = CurrentModifier.GetSelection #Face
		if (fSel as array).count > 0 do (CurrentModifier.DetachToObject newName)
		)
	else
		(
		local fSel = polyop.getFaceSelection $
		if (fSel as array).count > 0 do (polyOp.detachFaces $ fSel asNode:true name:newName)
		)
	local newObj = getnodebyname newName
	ATfn_.RenameAddCounter objName #(newObj)
	newObj.SetSelection #Face #{}
-- 	newObj.pivot = newObj.center
-- 	subobjectLevel = 0
-- 	select newObj
-- 	resetXForm selection; ConvertTo selection Editable_Poly
	)
else (try (subobjectLevel = 5) catch ())
)
	----------------------------
on btn_EG_Detach rightclick do with undo on
(
if Filters.Is_EPolySpecifyLevel #{5,6} and (PolyBGetSel 3).count!=0 then
	(
	macros.run "Editable Polygon Object" "EPoly_Detach"
-- 	subobjectLevel = 0
	)
)
	-------Explode---------------------------------------------------------------------------------------------------
FN fn_Explode =
(
local OArr = ATfn_.GetGeometry selection; qsort OArr ATfn_.CompareNames
if OArr.count == 0 do (return ATfn_.messageNGNS())
max create mode; explodeGroup selection
local oldIsoArr = #(); local newIsoArr = #(); local IsoActive = IsolateSelection.IsolateSelectionModeActive(); local vTM; local vFDist
if IsoActive then (for objct in objects where (IsolateSelection.IsNodeIsolated objct) do (append oldIsoArr objct); newIsoArr = ATfn_.ArraysDifference oldIsoArr OArr; vTM = viewport.getTM(); vFDist = viewport.getFocalDistance())
local newObjArr = #()
resetXForm OArr; ConvertTo OArr Editable_Poly
for objct in OArr do
	(
	local prts = spnr_EG_ExplodeParts.value
	local objName = ATfn_.RemoveCounter (objct.name)
	local tArr = #()
	if prts == 0
	then
		(
		while polyOp.getNumFaces objct != 0 do 
			(
			local tName = uniqueName "ldkfdflsds" numDigits:9
			local f_list = polyOp.getElementsUsingFace objct #{1}
			local elem = polyOp.detachFaces objct f_list asNode:true name:tName
			append tArr (getnodebyname tName)
			)
		)
	else
		if prts == 1
		then
			(
			local tName = uniqueName "ldkfdflsds" numDigits:9
			local elem = polyOp.detachFaces objct #{1..(objct.numfaces)} asNode:true name:tName
			append tArr (getnodebyname tName)
			)
		else
			(
			local OtArr = #()
			while polyOp.getNumFaces objct != 0 do 
				(
				local tName = uniqueName "ldkfdflsds" numDigits:9
				local f_list = polyOp.getElementsUsingFace objct #{1}
				local elem = polyOp.detachFaces objct f_list asNode:true name:tName
				append OtArr (getnodebyname tName)
				)
			if ((OtArr.count)/(prts as float)) > 1
			then
				(
				local partsArr = #(); local t1Arr = #()
				for p=1 to prts do (for o=p to OtArr.count by prts do (append t1Arr OtArr[o]); append partsArr t1Arr; t1Arr = #())
				for prtObjs in partsArr do (append tArr (ATfn_.Attach_ prtObjs))
				)
			else (tArr = OtArr)
			)
	delete objct
	ATfn_.RenameAddCounter objName tArr
	join newObjArr tArr
	)
-- 	for objct in newObjArr do (objct.pivot = objct.center)
-- 	resetXForm newObjArr; ConvertTo newObjArr Editable_Poly
join newIsoArr newObjArr; if IsoActive then (select newIsoArr; IsolateSelection.EnterIsolateSelectionMode(); if viewport.getType() == #view_persp_user then (viewport.setTM vTM; viewport.setFocalDistance vFDist))
select newObjArr
max modify mode
return newObjArr
)
on btn_EG_Explode pressed do with undo on (fn_Explode())
	----------------------------
on btn_EG_Explode rightclick do with undo on
(
local detachedObjArr = fn_Explode()
if detachedObjArr.count == 0 do return false
local NewStringEntered = ATfn_.GetStringDialog(); if NewStringEntered != undefined then (ATfn_.RenameAddCounter NewStringEntered detachedObjArr)
)
	-------ExplodeByID-------------------------------------------------------------------------------------------------
FN fn_ExplodeByID =
(
local OArr = ATfn_.GetGeometry selection; qsort OArr ATfn_.CompareNames
if OArr.count == 0 do (return ATfn_.messageNGNS())
max create mode; explodeGroup selection
local oldIsoArr = #(); local newIsoArr = #(); local IsoActive = IsolateSelection.IsolateSelectionModeActive(); local vTM; local vFDist
if IsoActive then (for objct in objects where (IsolateSelection.IsNodeIsolated objct) do (append oldIsoArr objct); newIsoArr = ATfn_.ArraysDifference oldIsoArr OArr; vTM = viewport.getTM(); vFDist = viewport.getFocalDistance())
local newObjArr = #()
local detachedObjArr = #()
for objct in OArr do
	(
	local objName = ATfn_.RemoveCounter (objct.name)
	local tArr = #()
	local oMat = objct.material
-- 	/*
	local bArr = #{}
	local os = snapshotAsMesh objct
	for f=1 to os.numfaces do bArr[getFaceMatID os f] = on
	delete os
	local idList = bArr as array
-- */
	if idList.count > 1
	then
		(
		resetXForm objct; ConvertTo objct Editable_Poly
		for id in idList do
			(
			local tName = uniqueName "ldkfdflsds" numDigits:9
			objct.selectbymaterial id; local fList = getfaceselection objct; objct.SetSelection #Face #{}
			polyOp.detachFaces objct fList asnode:true name:tName
			newObjct = getnodebyname tName
			if classOf oMat == Multimaterial do newObjct.material = oMat[id]
			append tArr newObjct
			)
		delete objct
		join detachedObjArr tArr
		)
	else
		(
		append tArr objct
		if classOf oMat == Multimaterial do objct.material = oMat[idList[1]]
		)
	ATfn_.RenameAddCounter objName tArr
	join newObjArr tArr
	)
-- 	for objct in newObjArr do (objct.pivot = objct.center)
-- 	resetXForm newObjArr; ConvertTo newObjArr Editable_Poly
join newIsoArr newObjArr; if IsoActive then (select newIsoArr; IsolateSelection.EnterIsolateSelectionMode(); if viewport.getType() == #view_persp_user then (viewport.setTM vTM; viewport.setFocalDistance vFDist))
select newObjArr
max modify mode
return detachedObjArr
)
on btn_EG_ExplodeByID pressed do with undo on (fn_ExplodeByID())
	----------------------------
on btn_EG_ExplodeByID rightclick do with undo on
(
local detachedObjArr = fn_ExplodeByID()
if detachedObjArr.count == 0 do return false
local NewStringEntered = ATfn_.GetStringDialog(); if NewStringEntered != undefined then (ATfn_.RenameAddCounter NewStringEntered detachedObjArr)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_Attach pressed do with undo on
(
local OArr = ATfn_.GetGeometry selection
-- qsort OArr ATfn_.CompareNames
if OArr.count != 0
then
	(
	max create mode; explodeGroup selection
	local prts = spnr_EG_AttachParts.value
	local newObjArr =#()
	if prts == 1
	then
		(
		resetXForm OArr; ConvertTo OArr Editable_Poly
		append newObjArr (ATfn_.Attach_ OArr)
		)
	else
		(
		if ((OArr.count)/(prts as float)) > 1
		then
			(
			resetXForm OArr; ConvertTo OArr Editable_Poly
			local partsArr = #(); local t1Arr = #()
			for p=1 to prts do (for o=p to OArr.count by prts do (append t1Arr OArr[o]); append partsArr t1Arr; t1Arr = #())
			for prtObjs in partsArr do (append newObjArr (ATfn_.Attach_ prtObjs))
			)
-- 		else (append newObjArr (ATfn_.Attach_ OArr))
		)
	for objct in newObjArr do (objct.pivot = objct.center)
-- 	if chbtn_UVP_SetColorState.checked then (for objct in newObjArr do (objct.wirecolor = color_UVP_ProcessWireColor.color))
	max modify mode
	)
else (ATfn_.messageNGNS())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddTurnToPoly pressed do (modPanel.addModToSelection (Turn_to_Poly keepConvex:true limitPolySize:true) ui:on)
on btn_EG_AddTurnToPoly rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
for objct in GArr do (addModifier objct (Turn_to_Poly()))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddEditPoly pressed do (modPanel.addModToSelection (Edit_Poly()) ui:on)
on btn_EG_AddEditPoly rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
for objct in GArr do (addModifier objct (Edit_Poly()))
)
	-------------------------------------------------------------------------------------------------------------------
-- 	/*
on btn_EG_Quadrify pressed do
(
max modify mode
local selArr = selection as array
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
undo on
-- for objct in GArr do (with undo off (select objct); addModifier objct (Edit_Poly()); macros.run "PolyTools" "Quadrify")
for objct in GArr do (with undo off (select objct); macros.run "PolyTools" "Quadrify")
select selArr
)
--  */
-- on btn_EG_Quadrify pressed do with undo on (ATfn_.AddModifer (Quadify_Mesh()) (ATfn_.GetGeometry))
-- on btn_EG_Quadrify rightclick do with undo on (ATfn_.AddModifer (Quadify_Mesh()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_FlipNormals pressed do
(
if Filters.Is_EPolySpecifyLevel #{5,6} and (PolyBGetSel 3).count!=0 then
	(
	macros.run "Editable Polygon Object" "EPoly_Flip"
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_Weld pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
max create mode
fn_CollapseToEP GArr
fn_Weld GArr spnr_EG_WeldThreshold.value
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_AddNormal pressed do with undo on
(
local curSel = selection as array
select (ATfn_.GetGeometry selection)
max modify mode
modPanel.addModToSelection (normalModifier flip:true)
select curSel
)
	----------------------------
on btn_EG_AddNormal rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
for objct in GArr do (addModifier objct (normalModifier flip:true))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_ConvertToEP pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
fn_CollapseToEP GArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_EG_PrepareModels pressed do with undo on
(
local NHHArr = ATfn_.GetNHH selection false
local NotHeadsArr = NHHArr[1]
local HeadsArr = NHHArr[2]
local NewHeadsArr = #()
if HeadsArr.count > 0 do
	(
	for h in HeadsArr do
		(
		local GName = h.name
		local GObjsArr = ATfn_.GetGroupByHead h ObjectsOnly:true
		explodeGroup h
		local GObjsGeomArr = ATfn_.GetGeometry GObjsArr
-- 		ATfn_.SetPivot GObjsGeomArr 0 0 0 false
		ATfn_.ResetsXForm 1 GObjsGeomArr
		local NewGroup = group GObjsArr name:GName
		append NewHeadsArr NewGroup
		)
	)
local GeomArr = ATfn_.GetGeometry NotHeadsArr
if GeomArr.count > 0 do
	(
-- 	ATfn_.SetPivot GeomArr 0 0 0 true
-- 	ATfn_.ResetsXForm 0 GeomArr
	select GeomArr; PolyBoost.Resetxfunc()
	)
select (NotHeadsArr + NewHeadsArr)
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_EG_ open do
-- 	(
-- 	)
-- on rollout_EG_ close do
-- 	(
-- 	)
)
	----=Material====================================================================================================
rollout rollout_MAT_ "Material"
(
local yp1 = #(0, 24, 48, 80, 125, 188, 212, 236, 260)
button btn_MAT_MeditCompact "Compact Editor" pos:[0,yp1[1]] width:102 height:21 tooltip:" Lmb - Open Compact Material Editor \n Rmb - Close Material Editor "
button btn_MAT_MeditSlate "Slate Editor" pos:[105,yp1[1]] width:101 height:21 tooltip:" Lmb - Open Slate Material Editor \n Rmb - Close Material Editor "

button btn_MAT_SetWireColor "Set Wire Color" pos:[0,yp1[2]] width:85 height:21 tooltip:" Set Objects Wire Color "
colorpicker color_MAT_SetWireColor "" pos:[82,yp1[2]] width:25 height:21 color:[255,156,0] modal:false tooltip:" Set Objects Wire Color "
button btn_MAT_RemoveMaterial "Remove Material" pos:[110,yp1[2]] width:96 height:21 tooltip:" Remove Material From Objects "

button btn_MAT_WirecolorByMaterial "Wire Color By Material" pos:[0,yp1[3]] width:206 height:21 tooltip:" Wire Color By Material "

GroupBox grp_MAT_RandomWire "Random Wire Color" pos:[2,yp1[4]-6] width:(fl0W-16) height:42
button btn_MAT_RandomWireMultiple "Multiple" pos:[7,yp1[4]+10] width:101 height:21 tooltip:" Set Random Wire Color For Every Object "
button btn_MAT_RandomWireSingle "Single" pos:[111,yp1[4]+10] width:90 height:21 tooltip:" Set Random Wire Color For All Objects "

GroupBox grp_MAT_RandomMat "Random Material" pos:[2,yp1[5]-6] width:(fl0W-16) height:66
dropdownlist ddl_MAT_RandomMaterialClass items:(#("Standard (Legacy)", "VRayMtl", "PhysicalMaterial", "PBRMetalRough", "PBRSpecGloss")) pos:[7,yp1[5]+10] width:194 height:7 selection:1 tooltip:" Select Random Material Class "
button btn_MAT_RandomMaterialMultiple "Multiple" pos:[7,yp1[5]+34] width:101 height:21 tooltip:" Assign Random Material For Every Object "
button btn_MAT_RandomMaterialSingle "Single" pos:[111,yp1[5]+34] width:90 height:21 tooltip:" Assign Random Material For All Objects "

button btn_MAT_AttachByMaterial "Attach By Material" pos:[0,yp1[6]] width:206 height:21 tooltip:" Attach Objects By Material "

button btn_MAT_MergeMultisub "Merge Multi/Sub Material" pos:[0,yp1[7]] width:206 height:21 tooltip:" Merge To Multi/Sub Material "

button btn_MAT_ExplodeByMultisub "Explode By Multi/Sub Material" pos:[0,yp1[8]] width:206 height:21 tooltip:" Lmb - Explode Objects By Multi/Sub Material \n Rmb - Explode Objects By Multi/Sub (Set Name) "

checkButton chbtn_MAT_PickMaterial "Pick Material" pos:[0,yp1[9]] width:206 height:21 highlightColor:colCHBX tooltip:" Pick Material For Selected Objects "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CreateRandMat index =
(
case index of
	(
	1: (StandardMaterial Diffuse:(ATfn_.RandomColor()))
	2: (VRayMtl Diffuse:(ATfn_.RandomColor()))
	3: (PhysicalMaterial Base_Color:(ATfn_.RandomColor()))
	4: (PBRMetalRough basecolor:(ATfn_.RandomColor()))
	5: (PBRSpecGloss basecolor:(ATfn_.RandomColor()))
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByName a b = stricmp a.name b.name
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MAT_PickMaterial changed state do with undo on
(
local selArr = selection as array
if selArr.count == 0 do (chbtn_MAT_PickMaterial.checked = false; return ATfn_.messageNS())
local pickObj = pickObject pickFrozen:false rubberBand:selection.center
if isValidNode pickObj do
	(
	local pickMat = pickObj.mat
	if pickMat == undefined do (chbtn_MAT_PickMaterial.checked = false; return (messageBox "Picked Object Doesn't Contain a Material." title:" Assembly Tool" beep:false))
	selArr.mat = pickMat
	)
chbtn_MAT_PickMaterial.checked = false
)
	------AttachByMaterial--------------------------------------------------------------------------------------------
on btn_MAT_AttachByMaterial pressed do with undo on
(
local OArr = ATfn_.GetGeometry selection; qsort OArr ATfn_.CompareNames
local matArr = #(); for objct in OArr where (objct.material != undefined) do (appendIfUnique matArr objct.material)
local objByMatArr = #(); local tArr = #(); for mat in matArr do (for objct in OArr where objct.material == mat do (appendIfUnique tArr objct); qSort tArr ATfn_.CompareNames; append objByMatArr tArr; tArr = #())
if matArr.count != 0
then
	(
	max create mode; explodeGroup selection
	local newObjArr =#()
	for objArr in objByMatArr do
		(
		resetXForm objArr
		ConvertTo objArr Editable_Poly
		append newObjArr (ATfn_.Attach_ objArr)
		)
	for objct in newObjArr do (objct.pivot = objct.center)
-- 	if chbtn_UVP_SetColorState.checked then (for objct in newObjArr do (objct.wirecolor = color_UVP_ProcessWireColor.color))
	resetXForm newObjArr
	ConvertTo newObjArr Editable_Poly
	max modify mode
	)
else (messageBox "Objects Not Selected Or Haven't Material." title:" Edit Geometry" beep:false)
)
	------ExplodeByMultisub--------------------------------------------------------------------------------------------
FN fn_ExplodeByMultisub =
(
local OArr = ATfn_.GetGeometry selection; qsort OArr ATfn_.CompareNames
if OArr.count == 0 do (return ATfn_.messageNGNS())
if not (ATfn_.CheckEmpty OArr) do return false
local MultimatArr = for objct in OArr where (classOf objct.material == Multimaterial) collect objct
if MultimatArr.count == 0 do (return (messageBox "Objects Haven't Multi/Sub Materials." title:" Material" beep:false))
max create mode; explodeGroup selection
local oldIsoArr = #(); local newIsoArr = #(); local IsoActive = IsolateSelection.IsolateSelectionModeActive(); local vTM; local vFDist
if IsoActive then (for objct in objects where (IsolateSelection.IsNodeIsolated objct) do (append oldIsoArr objct); newIsoArr = ATfn_.ArraysDifference oldIsoArr OArr; vTM = viewport.getTM(); vFDist = viewport.getFocalDistance())
local newObjArr = #()
local detachedObjArr = #()
for objct in MultimatArr do
	(
	local objName = ATfn_.RemoveCounter (objct.name)
	local tArr = #()
	local oMat = objct.material
-- 	/*
	local bArr = #{}
	local os = snapshotAsMesh objct
	for f=1 to os.numfaces do bArr[getFaceMatID os f] = on
	delete os
	local idList = bArr as array
-- */
	if idList.count > 1
	then
		(
		ATfn_.ResetsXForm 1 #(objct); ConvertTo objct Editable_Poly
		for id in idList do
			(
			local tName = uniqueName "ldkfdflsds" numDigits:9
			objct.selectbymaterial id; local fList = getfaceselection objct; objct.SetSelection #Face #{}
			polyOp.detachFaces objct fList asnode:true name:tName
			newObjct = getnodebyname tName
			newObjct.material = oMat[id]
			newObjct.pivot = objct.pivot
			append tArr newObjct
			)
		delete objct
		join detachedObjArr tArr
		)
	else
		(
		append tArr objct
		objct.material = oMat[idList[1]]
		)
	ATfn_.RenameAddCounter objName tArr
	join newObjArr tArr
	)
join newIsoArr newObjArr; if IsoActive then (select newIsoArr; IsolateSelection.EnterIsolateSelectionMode(); if viewport.getType() == #view_persp_user then (viewport.setTM vTM; viewport.setFocalDistance vFDist))
select newObjArr
max modify mode
return detachedObjArr
)
on btn_MAT_ExplodeByMultisub pressed do with undo on (fn_ExplodeByMultisub())
	----------------------------
on btn_MAT_ExplodeByMultisub rightclick do with undo on
(
local detachedObjArr = fn_ExplodeByMultisub()
if detachedObjArr.count == 0 do return false
local NewStringEntered = ATfn_.GetStringDialog(); if NewStringEntered != undefined then (ATfn_.RenameAddCounter NewStringEntered detachedObjArr)
)
	------MergeMultisub----------------------------------------------------------------------------------------------
FN fn_MergeMultisub =
(
-- 	clearListener()
local OArr = ATfn_.GetGeometry (ATfn_.InstancesTrim selection)
if OArr.count == 0 do (return ATfn_.messageNGNS())
OArr = for o in OArr where o.mat != undefined collect o
if OArr.count == 0 do (return (messageBox "Objects Haven't Materials." title:" Material" beep:false))
max modify mode
local UsedMats = #(); local UMatNames = #()
disableSceneRedraw()
for objct in OArr do
	(
	local mat = objct.mat
	if classOf mat == Multimaterial
	then
		(
		local bArr = #{}
		local os = snapshotAsMesh objct
		for f=1 to os.numfaces do bArr[getFaceMatID os f] = on
		delete os
		local idList = bArr as array
		for id in idList do
			(
			if mat.materialList[id] != undefined and findItem UMatNames mat.materialList[id].name == 0 do
				(
				append UsedMats mat.materialList[id]
				append UMatNames mat.materialList[id].name
				)
			)
		)
	else
		(
		if findItem UMatNames mat.name == 0 do
			(
			append UsedMats mat
			append UMatNames mat.name
			)
		)
	)
qSort UsedMats fn_compareByName
local NewMMat = Multimaterial materialList:UsedMats name:("MergedMultisub_" + (ATfn_.Counter (random 1 99999) CounterDigits:5))
-- 	/*
for objct in OArr do
	(
	local mat = objct.mat
	if classOf mat == Multimaterial
	then
		(
		local EPmod = Edit_Poly()
		select objct
		addModifier objct EPmod
		local idArr = #(); local selSetArr = #()
		for n=1 to UsedMats.count do
			(
			local umat = UsedMats[n]
			for sl=1 to (getnumsubmtls mat) do
				(
				if umat.name == mat.materialList[sl].name do
					(
					append idArr n
					subobjectLevel = 4
					EPmod.SetSelection #Face #{}
					EPmod.selectByMaterialID = sl - 1
					EPmod.ButtonOp #SelectByMaterial
					append selSetArr (EPmod.getSelection #Face)
					)
				)
			)
		for n=1 to idArr.count do
			(
			local id = idArr[n]
			EPmod.SetSelection #Face selSetArr[n]
			EPmod.SetOperation #SetMaterial
			EPmod.MaterialIDtoSet = id - 1
			EPmod.Commit()
			)
		EPmod.SetSelection #Face #{}
		subobjectLevel = 0
		)
	else
		(
		for n=1 to UsedMats.count do
			(
			if UsedMats[n].name == mat.name do
				(addModifier objct (Materialmodifier materialID:n))
			)
		)
	objct.mat = NewMMat
	)
	-- */
enableSceneRedraw()
select OArr
return NewMMat
)
on btn_MAT_MergeMultisub pressed do with undo on (fn_MergeMultisub())
	----------------------------
on btn_MAT_MergeMultisub rightclick do with undo on
(
local NewMultisubMat = fn_MergeMultisub()
if NewMultisubMat == Undefined do return false
local NewStringEntered = ATfn_.GetStringDialog(); if NewStringEntered != undefined then (NewMultisubMat.name = NewStringEntered)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_WirecolorByMaterial pressed do with undo on
(
local MatArr = #(); local matNames = #()
for o in selection where o.material != undefined and (findItem matNames o.mat.name == 0)
	do (append MatArr o.material; append matNames o.mat.name)
local ObjByMatArr = #()
for m in MatArr do (append ObjByMatArr (for o in selection where o.material == m collect o))
for oa in ObjByMatArr do oa.wirecolor = ATfn_.RandomColor()
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_RandomMaterialMultiple pressed do with undo on
(
local ObjArr = selection as array
if ObjArr.count != 0 do
	(
	for objct in ObjArr do
		(
		local NewMat = fn_CreateRandMat (ddl_MAT_RandomMaterialClass.selection)
-- 		NewMat.name = "Random_" + (random 0 999999999) as string
		NewMat.name = objct.name
		objct.material = NewMat
		)
-- 	layermanager.newLayerFromName "Random_Material"; local objctLayer = LayerManager.getlayerfromName "Random_Material"
-- 	for objct in ObjArr do (objctLayer.addNode objct)
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_RandomMaterialSingle pressed do with undo on
(
local ObjArr = selection as array
if ObjArr.count != 0 do
	(
	local NewMat = fn_CreateRandMat (ddl_MAT_RandomMaterialClass.selection)
	NewMat.name = selection[1].name
	ObjArr.material = NewMat
-- 	layermanager.newLayerFromName "Random_Material"; local objctLayer = LayerManager.getlayerfromName "Random_Material"
-- 	for objct in ObjArr do (objctLayer.addNode objct)
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_MeditSlate pressed do (MatEditor.mode = #advanced; MatEditor.Open())
on btn_MAT_MeditSlate rightclick do (MatEditor.Close())
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_MeditCompact pressed do (MatEditor.mode = #basic; MatEditor.Open())
on btn_MAT_MeditCompact rightclick do (MatEditor.Close())
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_SetWireColor pressed do with undo on (for objct in selection do (objct.wirecolor = color_MAT_SetWireColor.color))
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_RemoveMaterial pressed do with undo on (selection.material = undefined)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_RandomWireMultiple pressed do with undo on
(
local ObjArr = selection as array
if ObjArr.count != 0 do
	(
	for objct in ObjArr do objct.wirecolor = ATfn_.RandomColor()
	redrawViews()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MAT_RandomWireSingle pressed do with undo on
(
local ObjArr = selection as array
if ObjArr.count != 0 do
	(
	ObjArr.wirecolor = ATfn_.RandomColor()
	redrawViews()
	)
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_MAT_ open do
-- 	(
-- 	)
-- on rollout_MAT_ close do
-- 	(
-- 	)
)
	----=UV==========================================================================================================
local uv_over_lastPath = (ATfn_.GetINI 1 iniFile "UV" "uv_over_lastPath" "C:\\")
	-------------------------------------------------------------------------------------------------------------------
rollout rollout_UV_ "UV"
(
local yp1 = #(0, 27, 51, 95, 119, 164, 209, 254, 323, 389, 434)
-- checkButton chbtn_UV_Vertex "Vertex" pos:[3,yp1[6]+15] width:96 height:21 highlightColor:colCHBX enabled:false
checkButton chbtn_UV_SelectElement "Select By Elements Mode" pos:[6,yp1[1]] width:(fl0W-24) height:21 highlightColor:colCHBX

spinner spnr_UV_AddUnwrapChannel "Channel" pos:[28,yp1[2]+3] width:42 range:[1,99,1] type:#Integer scale:1 tooltip:" Unwrap Channel "
button btn_UV_AddUnwrapUVW "Unwrap" pos:[73,yp1[2]] width:50 height:21 tooltip:" Lmb - Add Unwrap UVW \n Rmb - Open Unwrap UVW "
button btn_UV_UnwrapUVWCheck "Check" pos:[126,yp1[2]] width:40 height:21 tooltip:" Lmb - Add Check Unwrap UVW \n Rmb - Delete Check Unwrap UVW "
button btn_UV_UnwrapClear "Clear" pos:[169,yp1[2]] width:37 height:21 tooltip:" Lmb - Add UVW Mapping Clear \n Rmb - Add Unique UVW Mapping Clear "

GroupBox grp_UV_CopyUVWChannel "Copy UVW Channel" pos:[2,yp1[3]] width:(fl0W-15) height:40
spinner spnr_UV_CopyFromChannel "From" pos:[28,yp1[3]+18] width:47 range:[1,999,1] type:#integer scale:1 tooltip:" Copy From Channel "
spinner spnr_UV_CopyToChannel "To" pos:[92,yp1[3]+18] width:40 range:[1,999,1] type:#integer scale:1 tooltip:" Copy To Channel "
button btn_UV_CopyChannel "Copy" pos:[140,yp1[3]+11] width:62 height:23 tooltip:" Copy Channel "

checkButton chbtn_UV_UVWMapX "X" pos:[0,yp1[4]] width:23 height:21 highlightColor:[204,64,64] tooltip:" Alignment By X Toggle "
checkButton chbtn_UV_UVWMapY "Y" pos:[26,yp1[4]] width:23 height:21 highlightColor:[63,164,63] tooltip:" Alignment By Y Toggle "
checkButton chbtn_UV_UVWMapZ "Z" pos:[52,yp1[4]] width:23 height:21 highlightColor:[70,114,255] checked:true tooltip:" Alignment By Z Toggle "
spinner spnr_UV_UVWMapSize "" pos:[78,yp1[4]+3] width:55 range:[0,999999,100] type:#integer scale:1 tooltip:" UVW Map Size "
button btn_UV_AddUVWMap "UVW Map" pos:[137,yp1[4]] width:69 height:21 tooltip:" Lmb - Add UVW Map Modifier \n Rmb - Add Unique UVW Map Modifier "

GroupBox grp_UV_Mapping "Mapping:" pos:[2,yp1[5]] width:(fl0W-15) height:42
button btn_UV_MappingFlatten "Flatten" pos:[7,yp1[5]+15] width:63 height:21 tooltip:" Lmb - Flatten Mapping Using the Current Settings \n Rmb - Flatten Mapping With Dialog "
button btn_UV_MappingNormal "Normal" pos:[73,yp1[5]+15] width:63 height:21 tooltip:" Lmb - Normal Mapping Using the Current Settings \n Rmb - Normal Mapping With Dialog "
button btn_UV_MappingUnfold "Unfold" pos:[139,yp1[5]+15] width:63 height:21 tooltip:" Lmb - Unfold Mapping Using the Current Settings \n Rmb - Unfold Mapping With Dialog "

GroupBox grp_UV_BreakAndStitch "Break, Stitch, Weld:" pos:[2,yp1[6]] width:(fl0W-15) height:42
button btn_UV_Break "Break" pos:[7,yp1[6]+15] width:50 height:21 tooltip:" Break(Detach) Selected Polygons "
button btn_UV_Stitch "Stitch" pos:[60,yp1[6]+15] width:50 height:21 tooltip:" Lmb - Stitch Using the Current Settings \n Rmb - Open the Stitch Dialog "
button btn_UV_Weld "Weld" pos:[113,yp1[6]+15] width:45 height:21 tooltip:" Weld Selected "
spinner spnr_UV_WeldThreshold "" pos:[159,yp1[6]+17] width:42 range:[0,10,1] type:#Float scale:0.1 tooltip:" Sets Threshold Values For Welds "

GroupBox grp_UV_Reshape "Reshape:" pos:[2,yp1[7]] width:(fl0W-15) height:42
button btn_UV_Straighten "Straighten" pos:[7,yp1[7]+15] width:96 height:21 tooltip:" Straighten Selected "
button btn_UV_Relax "Relax" pos:[106,yp1[7]+15] width:96 height:21 tooltip:" Lmb - Relax Using the Current Settings \n Rmb - Relax With Dialog "

GroupBox grp_UV_AlignLongest "Align Shells By Longest Side:" pos:[2,yp1[8]] width:(fl0W-15) height:66
button btn_UV_AlignLongestByX "Horizontally  X" pos:[7,yp1[8]+16] width:96 height:21 tooltip:" Lmb - Add Unwrap and Align By X \n Rmb - Add Unwrap, Align By X and Open Unwrap "
button btn_UV_AlignLongestByY "Vertically  Y" pos:[106,yp1[8]+16] width:96 height:21 tooltip:" Lmb - Add Unwrap and Align By Y \n Rmb - Add Unwrap, Align By Y and Open Unwrap "
button btn_UV_RotElemMinus90 "- 90" pos:[7,yp1[8]+40] width:36 height:21 tooltip:" Rotate Elements By Selected Polygons On -90 "
button btn_UV_RotElemPlus90 "+ 90" pos:[46,yp1[8]+40] width:36 height:21 tooltip:" Rotate Elements By Selected Polygons On +90 "
button btn_UV_RotElem180 "180" pos:[85,yp1[8]+40] width:37 height:21 tooltip:" Rotate 686Elements By Selected Polygons On 180 "
button btn_UV_AlignToEdge "Align To Edge" pos:[125,yp1[8]+40] width:77 height:21 tooltip:" Lmb - Align Element By Edge Horizontally (X) \n Rmb - Align Element By Edge Vertically (Y) "

GroupBox grp_UV_TexelDensity "Texel Density" pos:[2,yp1[9]] width:(fl0W-15) height:63 tooltip:" Pixel / Meter "
button btn_UV_TexelDensityGet "Get" pos:[7,yp1[9]+17] width:50 height:41 tooltip:" Get Texel Density From UV \n If Poligons Not Selected Get Density from All UV "
spinner spnr_UV_TexelDensity "" pos:[60,yp1[9]+17] width:88 range:[1,9999999,4096] type:#integer scale:1 tooltip:" Texel Density "
local ddlResolution = #("128x128", "256x256", "512x512", "1024x1024", "2048x2048", "4096x4096", "8192x8192")
dropdownlist ddl_UV_Resolution items:ddlResolution pos:[61,yp1[9]+36] width:87 height:8 selection:6 tooltip:" Select Resolution "
button btn_UV_TexelDensitySet "Set" pos:[152,yp1[9]+17] width:50 height:41 tooltip:" Set Texel Density \n If Poligons Not Selected Set Density to All UV "

groupBox grp_UV_Pack "Pack UVs" pos:[2,yp1[10]] width:(fl0W-15) height:42
button btn_UV_Pack "Pack" pos:[7,yp1[10]+15] width:(fl0W-24) height:21 tooltip:" Lmb - Pack Using the Current Settings \n RMB - Pack With Dialog "

GroupBox grp_UV_OverrideMaterialUV "Override Material UV" pos:[2,yp1[11]] width:(fl0W-15) height:62
spinner spnr_UV_OverrideMaterialUVTextureTile "Texture Tile:" pos:[40,yp1[11]+17] width:70 range:[0.1,999,1] type:#float scale:0.01 tooltip:" Override Material UV Texture Tile "
radiobuttons rdbtn_UV_OverrideMaterialUV "" labels:#("Off","On") pos:[118,yp1[11]+17] columns:2 offsets:#([0,0],[4,0]) default:(if (NitrousGraphicsManager.GetActiveViewportSetting()).OverrideMaterialOption == #none then 1 else (if (NitrousGraphicsManager.GetActiveViewportSetting()).OverrideMaterialOption == #UVChecker then 2)) tooltip:" Display Shaded Object Or Material Color "
button btn_UV_SetOverrideMaterialUVTexture "Set Override Material UV Texture" pos:[5,yp1[11]+36] width:(fl0W-24) height:21 tooltip:" Lmb - Set Override Material UV Texture \n Rmb - Restore Default UV Texture \n Note: If this feature doesn't work you may need to run 3d max with admin rights "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_messageUnvrUV = messageBox "Works Only With Unwrap UVW." title:" Assembly Tool" beep:false
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetModifiers classMod =
(
local modArr = #()
for objct in selection do (for m in objct.modifiers where classOf m == classMod do appendIfUnique modArr m)
return modArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_DefineUnwrap subobjlvl:0 TVstate:true = 
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr
local curObj = modpanel.getcurrentobject()
if curObj != undefined and classOf curObj == Unwrap_UVW
	then (unvr = curObj)
	else (unvr = Unwrap_UVW(); ATfn_.AddModifer unvr GArr)
if unvr != undefined do
	(
	subobjectLevel = subobjlvl
	unvr.unwrap2.setTVElementMode TVstate
	unvr.unwrap.move()
	)
return unvr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MeterSS = 
(
local meter = case units.systemType of
	(
	#Kilometers: 1000.0
	#Meters: 1.0
	#Centimeters: 0.01
	#Millimeters: 0.001
	#Inches: 0.0254
	#Feet: 0.3048
	#Miles: 1609.0
	)
return (meter * units.SystemScale)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetRes = 
(
case ddl_UV_Resolution.selection of
	(
	1: 128
	2: 256
	3: 512
	4: 1024
	5: 2048
	6: 4096
	7: 8192
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_UV_SelectElement changed state do
(
if state
then
	(
	FN fnCB_ElementSelect ev nd =
	(
	local unvr = modpanel.getcurrentobject()
	if classOf unvr == Unwrap_UVW do (unvr.selectElement())
	)
	global ATcallback_UnvrapElementSelect
	ATcallback_UnvrapElementSelect = NodeEventCallback mouseUp:true subobjectSelectionChanged:fnCB_ElementSelect
	)
else
	(
	ATcallback_UnvrapElementSelect = undefined
	gc light:true
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Relax pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap subobjlvl:subobjectLevel
-- unvr.RelaxOneClick()
unvr.relax2() 
)
	--------------------------------------
on btn_UV_Relax rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap subobjlvl:subobjectLevel
unvr.edit()
-- subobjectLevel = 0
unvr.relax2dialog()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Straighten pressed do
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
-- if not (subobjectLevel == 3 and ((unvr.getSelectedFaces()) as array).count != 0) do return (messageBox "Select Poligons To Straighten." title:" Assembly Tool" beep:false)
local curSub = subobjectLevel
if subobjectLevel == 1 do unvr.vertToFaceSelect()
if subobjectLevel == 2 do unvr.edgeToFaceSelect()
subobjectLevel = 3
if ((unvr.getSelectedFaces()) as array).count == 0 do return (messageBox "Select Elements To Straighten." title:" Assembly Tool" beep:false)
unvr.Straighten()
subobjectLevel = curSub
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Weld pressed do
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
if subObjectLevel == 3 do (unvr.faceToEdgeSelect(); subObjectLevel = 2)
unvr.setWeldThreshold (spnr_UV_WeldThreshold.value)
unvr.weldSelected() 
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_UV_WeldThreshold entered do
(
local unvr = modpanel.getcurrentobject()
if (unvr != undefined and classOf unvr == Unwrap_UVW) do (unvr.setWeldThreshold (spnr_UV_WeldThreshold.value))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Break pressed do
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
unvr.breakSelected()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Stitch pressed do
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
unvr.stitchVertsNoParams()
)
	----------------------------------
on btn_UV_Stitch rightclick do
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
unvr.stitchVertsDialog()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_Pack pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
-- local unvr = fn_DefineUnwrap subobjlvl:0
unvr.packNoParams()
select GArr
subobjectLevel = 0
)
	----------------------------------
on btn_UV_Pack rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
-- local unvr = fn_DefineUnwrap()
local unvr = fn_DefineUnwrap subobjlvl:0
unvr.edit()
unvr.packDialog()
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
	-----fn-----------------------------
FN fn_GetTexelDensity unvr mapSize =
(
local texDens
if unvr != undefined do
	(
	local curSel = unvr.getSelectedFaces()
	if (curSel as array).count == 0 do (curSel = #{1..unvr.numberPolygons()})
	unvr.getArea curSel &minX &nimY &sizeX &sizeY &areaUVW &areaGeom
	texDens = sqrt ((areaUVW * (mapSize^2)) / areaGeom)
	)
return texDens
)
	-----fn---------------------------
FN fn_SetTexelDensity unvr =
(
local curSel = unvr.getSelectedFaces()
if (curSel as array).count == 0 do (unvr.selectFaces #{1..unvr.numberPolygons()})
actionMan.executeAction 2077580866 "40207"  -- Unwrap UVW: Rescale Clusters
unvr.selectElement()
unvr.scaleSelectedCenter ((spnr_UV_TexelDensity.value * (fn_MeterSS())) / (fn_GetTexelDensity unvr (fn_GetRes()))) 0
unvr.selectFaces curSel
)
	-----fn---------------------------
on btn_UV_TexelDensitySet pressed do
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
max modify mode
local unvr
if GArr.count == 1 and (modpanel.getcurrentobject()) != undefined
then
	(
	local flag = true
	if not (classOf (modpanel.getcurrentobject()) == Unwrap_UVW)
		then (flag = not (subobjectLevel == 4 or subobjectLevel == 5); subobjectLevel = 0)
		else (flag = subobjectLevel != 3)
	unvr = fn_DefineUnwrap subobjlvl:3
	if flag do (unvr.selectFaces #{})
	fn_SetTexelDensity unvr
	subobjectLevel = 0
	)
else
	(
	for objct in GArr do
		(
		select objct
		unvr = fn_DefineUnwrap subobjlvl:3
		unvr.selectFaces #{}
		fn_SetTexelDensity unvr
		subobjectLevel = 0
		)
	select GArr
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_TexelDensityGet pressed do
(
if not (selection.count == 1 and ATfn_.GCheck selection[1]) do return (ATfn_.messageOGO())
max modify mode
local unvr
local flag = true
if not (classOf (modpanel.getcurrentobject()) == Unwrap_UVW)
	then (flag = not (subobjectLevel == 4 or subobjectLevel == 5); subobjectLevel = 0)
	else (flag = subobjectLevel != 3)
unvr = fn_DefineUnwrap subobjlvl:3
if flag do (unvr.selectFaces #{})
spnr_UV_TexelDensity.value = (fn_GetTexelDensity unvr (fn_GetRes())) / fn_MeterSS()
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
	-----fn---------------------------
FN fn_AlignToEdge Rmb:false =
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
if not (subobjectLevel == 2 and ((unvr.getSelectedEdges()) as array).count == 1) do return (messageBox "Select One Edge." title:" Assembly Tool" beep:false)
unvr.edgeToVertSelect()
local vertsArr = (unvr.getSelectedVertices()) as array
local vert1 = unvr.getVertexPosition 0 vertsArr[1]
local vert2 = unvr.getVertexPosition 0 vertsArr[2]
local vec = vert2 - vert1
local angleDeg = 0
if not Rmb
then
	(
	angleDeg = acos (dot [1,0,0] (normalize vec))
	if vec[2] > 0 do angleDeg *= -1
	)
else
	(
	angleDeg = acos (dot [0,1,0] (normalize vec))
	if vec[1] < 0 do angleDeg *= -1
	)
local curSel = unvr.getSelectedEdges()
unvr.selectElement()
unvr.rotateSelectedCenter (degToRad angleDeg)
unvr.selectEdges curSel
)
	-----fn---------------------------
on btn_UV_AlignToEdge pressed do with undo on (fn_AlignToEdge Rmb:false)
-- on btn_UV_AlignToEdge pressed do with undo on
-- (
-- 	clearListener()
-- local unvr = modpanel.getcurrentobject()
-- unvr.edgeToVertSelect()
-- local vertsArr = (unvr.getSelectedVertices()) as array
-- 	print vertsArr
-- )
	-------------------------------------------
on btn_UV_AlignToEdge rightclick do with undo on (fn_AlignToEdge Rmb:true)
	-------------------------------------------------------------------------------------------------------------------
	-----fn---------------------------
FN fn_RotateElements degrees =
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
if subobjectLevel != 3
then (subobjectLevel = 3)
else
	(
	local curSel = unvr.getSelectedFaces()
	unvr.selectElement()
	unvr.unwrap2.RotateSelectedCenter (degToRad degrees)
	unvr.selectFaces curSel
	)
)
	-----fn---------------------------
on btn_UV_RotElemMinus90 pressed do (fn_RotateElements -90)
on btn_UV_RotElemPlus90 pressed do (fn_RotateElements 90)
on btn_UV_RotElem180 pressed do (fn_RotateElements 180)
	-------------------------------------------------------------------------------------------------------------------
	-----fn---------------------------
FN fn_RotateElementsRMB degrees =
(
local unvr = modpanel.getcurrentobject()
if not (unvr != undefined and classOf unvr == Unwrap_UVW) do return (fn_messageUnvrUV())
if subobjectLevel != 3
then (subobjectLevel = 3)
else
	(
	unvr.breakSelected()
	unvr.unwrap2.RotateSelectedCenter (degToRad degrees)
	)
)
	-----fn---------------------------
on btn_UV_RotElemMinus90 rightclick do (fn_RotateElementsRMB -90)
on btn_UV_RotElemPlus90 rightclick do (fn_RotateElementsRMB 90)
on btn_UV_RotElem180 rightclick do (fn_RotateElementsRMB 180)
	-------------------------------------------------------------------------------------------------------------------
	-----fn---------------------------
-- 	/*
FN fn_AlignLongestBy axis openUnwrap:false =
(
-- 	clearListener()
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr
for objct in GArr do
	(
	select objct
	unvr = fn_DefineUnwrap subobjlvl:3
	local numPolArr = for n=1 to unvr.numberPolygons() collect n
	while (numPolArr.count > 0) do
		(
		unvr.selectFaces #{numPolArr[1]}
		unvr.selectElement()
		local selBitArr = unvr.getSelectedFaces()
		unvr.unwrap4.getArea selBitArr &minX &nimY &sizeX &sizeY &areaUVW &areaGeom
		if (if axis == "X" then (sizeX / sizeY < 1) else (sizeX / sizeY > 1)) do (unvr.unwrap2.RotateSelectedCenter (degToRad 90.0))
		for f in (selBitArr as array) do deleteItem numPolArr (findItem numPolArr f)
		)
	unvr.selectFaces #{}
	subobjectLevel = 0
	)
if GArr.count == 1
then
	(
	if openUnwrap do
		(
		unvr.edit()
-- 		subobjectLevel = 3
		subobjectLevel = 0
		unvr.unwrap2.setTVElementMode true
		unvr.unwrap.move()
		)
	)
else (select GArr)
)
--  */
	-----fn---------------------------
on btn_UV_AlignLongestByX pressed do (fn_AlignLongestBy "X")
on btn_UV_AlignLongestByY pressed do (fn_AlignLongestBy "Y")
	------------------------------------------------------------
on btn_UV_AlignLongestByX rightclick do (fn_AlignLongestBy "X" openUnwrap:true)
on btn_UV_AlignLongestByY rightclick do (fn_AlignLongestBy "Y" openUnwrap:true)
	-------------------------------------------------------------------------------------------------------------------
on spnr_UV_OverrideMaterialUVTextureTile changed val do with undo off
(
local temp_box = box isHidden:true; temp_box.mat = uvchecker_mtl
uvchecker_mtl.diffuseMap.coords.u_tiling = uvchecker_mtl.diffuseMap.coords.V_Tiling = val
delete temp_box
-- redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_UV_OverrideMaterialUV changed state do
(
case state of
	(
	1: (NitrousGraphicsManager.GetActiveViewportSetting()).OverrideMaterialOption = #none
	2: (NitrousGraphicsManager.GetActiveViewportSetting()).OverrideMaterialOption = #UVChecker
	)
showTextureMap uvchecker_mtl true
)
	-------------------------------------------------------------------------------------------------------------------
local uv_over_mappath = pathConfig.GetDir #maxroot + "maps\\uvwunwrap\\UV_Checker.png"
local uv_over_mapBup = pathConfig.GetDir #maxroot + "maps\\uvwunwrap\\UV_Checker.png.bup"
-- local uv_over_ms = pathConfig.GetDir #startupScripts + "\\uvchecker_override_material.ms"
	-------------
on btn_UV_SetOverrideMaterialUVTexture pressed do with undo off
(
local NewPath = getOpenFileName caption:"Load Texture..." types:"(*.png)|*.png|" filename:uv_over_lastPath
if NewPath != undefined then
	(
	if not doesFileExist uv_over_mapBup do (copyFile uv_over_mappath uv_over_mapBup)
	deleteFile uv_over_mappath
	copyFile NewPath uv_over_mappath
	uv_over_lastPath = NewPath
	setINISetting iniFile "UV" "uv_over_lastPath" uv_over_lastPath
	)
)
	-------------
on btn_UV_SetOverrideMaterialUVTexture rightclick do with undo off
(
if doesFileExist uv_over_mapBup do
	(
	deleteFile uv_over_mappath
	copyFile uv_over_mapBup uv_over_mappath
	deleteFile uv_over_mapBup
	)
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_UV_UVWMapSize changed val do (local mods = fn_GetModifiers UVWMap; mods.length = mods.width = mods.height = val; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
local chbtnUVWMapAxis = #(chbtn_UV_UVWMapX, chbtn_UV_UVWMapY, chbtn_UV_UVWMapZ)
on chbtn_UV_UVWMapX changed state do with undo on (chbtnUVWMapAxis.checked = false; chbtn_UV_UVWMapX.checked = true; (fn_GetModifiers UVWMap).axis = 0; redrawViews())
on chbtn_UV_UVWMapY changed state do with undo on (chbtnUVWMapAxis.checked = false; chbtn_UV_UVWMapY.checked = true; (fn_GetModifiers UVWMap).axis = 1; redrawViews())
on chbtn_UV_UVWMapZ changed state do with undo on (chbtnUVWMapAxis.checked = false; chbtn_UV_UVWMapZ.checked = true; (fn_GetModifiers UVWMap).axis = 2; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_AddUVWMap pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local MapSize = spnr_UV_UVWMapSize.value
local Axis = (if chbtn_UV_UVWMapX.checked then 0 else (if chbtn_UV_UVWMapY.checked then 1 else 2))
select GArr
modPanel.addModToSelection (UVWMap maptype:4 length:MapSize width:MapSize height:MapSize axis:Axis) ui:on
)
	-------------
on btn_UV_AddUVWMap rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
local MapSize = spnr_UV_UVWMapSize.value
local Axis = (if chbtn_UV_UVWMapX.checked then 0 else (if chbtn_UV_UVWMapY.checked then 1 else 2))
for objct in GArr do (addModifier objct (UVWMap maptype:4 length:MapSize width:MapSize height:MapSize axis:Axis) )
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_CopyChannel pressed do with undo on
(
max modify mode
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
for objct in GArr do
	(
-- 	/*
	select objct
	local unvr = Unwrap_UVW setMapChannel:spnr_UV_CopyFromChannel.value
	modPanel.addModToSelection unvr ui:on
	unvr.setMapChannel spnr_UV_CopyToChannel.value
-- 	unvr.updateMap()
	subobjectLevel = 0
-- 	modPanel.addModToSelection (Edit_Poly()) ui:on
-- 	deleteModifier objct 1
	-- */
-- 	select objct
-- 	modPanel.addModToSelection (Edit_Poly()) ui:on
-- 	channelInfo.CopyChannel objct 3 (spnr_UV_CopyFromChannel.value)
-- 	channelInfo.PasteChannel objct 3 (spnr_UV_CopyToChannel.value)
	)
select GArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_UnwrapClear pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
select GArr
modPanel.addModToSelection (UVW_Mapping_Clear mapID:spnr_UV_AddUnwrapChannel.value) ui:on
)
	-------------
on btn_UV_UnwrapClear rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
for objct in GArr do (addModifier objct (UVW_Mapping_Clear mapID:spnr_UV_AddUnwrapChannel.value) )
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_MappingUnfold pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
-- unvr.selectFaces #{}
unvr.selectFaces #{1..unvr.numberPolygons()}
subobjectLevel = 3
unvr.unfoldMapNoParams()
subobjectLevel = 0
)
	----------------------------
on btn_UV_MappingUnfold rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
-- unvr.selectFaces #{}
unvr.selectFaces #{1..unvr.numberPolygons()}
subobjectLevel = 3
unvr.unfoldMapDialog()
unvr.edit()
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_MappingNormal pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
unvr.selectFaces #{}
unvr.normalMapNoParams()
subobjectLevel = 0
)
	----------------------------
on btn_UV_MappingNormal rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
unvr.selectFaces #{}
unvr.normalMapDialog()
unvr.edit()
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_MappingFlatten pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
unvr.selectFaces #{}
unvr.flattenMapNoParams()
subobjectLevel = 0
)
	----------------------------
on btn_UV_MappingFlatten rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
local unvr = fn_DefineUnwrap()
unvr.selectFaces #{}
unvr.flattenMapDialog()
-- format "unvr.flattenMapDialog() -> % \n" (unvr.flattenMapDialog())
unvr.edit()
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_UnwrapUVWCheck pressed do with undo on
(
subobjectLevel = 0
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
select GArr
modPanel.addModToSelection (Edit_Poly name:"Poly UVW Check") ui:on
local unvr = Unwrap_UVW()
unvr.setMapChannel spnr_UV_AddUnwrapChannel.value
unvr.name = "Unwrap UVW Check"
modPanel.addModToSelection unvr ui:on
-- unvr.updateMap()
unvr.edit()
subobjectLevel = 0
-- forcecompleteredraw dodisabled:true
)
	----------------------------
on btn_UV_UnwrapUVWCheck rightclick do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return false
for objct in GArr do
	(
	local ModifiersInStackCount = (for m in objct.modifiers collect m).count
	if ModifiersInStackCount > 0
	then
		(
		local theModsArr = for mdfr in objct.modifiers where (mdfr.name == "Unwrap UVW Check" or mdfr.name == "Poly UVW Check") collect mdfr
		for m in theModsArr do deleteModifier objct m
		)
	subobjectLevel = 0
	)
subobjectLevel = 0
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UV_AddUnwrapUVW pressed do with undo on
(
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
select GArr
local unvr = Unwrap_UVW ()
unvr.setMapChannel spnr_UV_AddUnwrapChannel.value
modPanel.addModToSelection unvr ui:on
-- subobjectLevel = 3
subobjectLevel = 0
unvr.unwrap2.setTVElementMode true
unvr.unwrap.move()
)
	----------------------------
on btn_UV_AddUnwrapUVW rightclick do with undo on
(
max modify mode
local GArr = ATfn_.InstancesTrim (ATfn_.GetGeometry selection)
if GArr.count == 0 do return ATfn_.messageNGNS()
select GArr
local toChVal = spnr_UV_AddUnwrapChannel.value
-- if selection.count == 1
-- then
-- 	(
	if (ClassOf (modPanel.getCurrentObject())) == Unwrap_UVW
	then
		(
		local unvr = modPanel.getCurrentObject()
		local getCh; if unvr.getMapChannel() == 0 then (getCh = 1) else (getCh = unvr.getMapChannel())
		if getCh != toChVal then (unvr.setMapChannel toChVal; unvr.Reset())
		unvr.edit()
-- 		subobjectLevel = 3
		subobjectLevel = 0
		unvr.unwrap2.setTVElementMode true
		unvr.unwrap.move ()
		)
	else
		(
		local unvr = Unwrap_UVW ()
		unvr.setMapChannel toChVal
		modPanel.addModToSelection unvr ui:on
		unvr.edit()
-- 		subobjectLevel = 3
		subobjectLevel = 0
		unvr.unwrap2.setTVElementMode true
		unvr.unwrap.move ()
		)
-- 	)
-- else
-- 	(
-- 	local unvr = Unwrap_UVW ()
-- 	unvr.setMapChannel toChVal
-- 	modPanel.addModToSelection unvr ui:on
-- 	unvr.edit()
-- 	subobjectLevel = 3
-- 	unvr.unwrap2.setTVElementMode true
-- 	unvr.unwrap.move ()
-- 	)
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on rollout_UV_ open do
	(
	local uv_over_tile = ATfn_.GetINI 0 iniFile "UV" "spnr_UV_OverrideMaterialUVTextureTile_Value" 1
	local temp_box = box isHidden:true; temp_box.mat = uvchecker_mtl
	uvchecker_mtl.diffuseMap.coords.u_tiling = uvchecker_mtl.diffuseMap.coords.V_Tiling = uv_over_tile
	delete temp_box
	)
-- on rollout_UV_ close do
-- 	(
-- 	ATcallback_UnvrapElementSelect = undefined
-- 	gc light:true
-- 	)
)
	----=Group========================================================================================================
local TolHelpArr = #()
	-------------------------------------------------------------------------------------------------------------------
rollout rollout_GR_ "Group"
(
local yp1 = #(0, 24, 48, 180, 205)
button btn_GR_GroupGroup "Group" pos:[0,yp1[1]] width:38 height:21 tooltip:" Lmb - Fast Group \n Rmb - Group with Dialog "
button btn_GR_Ungroup "Ungroup" pos:[41,yp1[1]] width:47 height:21 tooltip:" Lmb - Ungroup "
button btn_GR_ExplodeGroups "Explode" pos:[91,yp1[1]] width:46 height:21 tooltip:" Lmb - Explode Groups "
button btn_GR_OpenGroup "Open" pos:[140,yp1[1]] width:31 height:21 tooltip:" Lmb - Open Group \n Rmb - Open Groups Recursively "
button btn_GR_CloseGroup "Close" pos:[174,yp1[1]] width:32 height:21 tooltip:" Lmb - Close Groups "

button btn_GR_AttachSelected "Attach Selected" pos:[0,yp1[2]] width:80 height:21 tooltip:" Attach Selected To Picked Group "
button btn_GR_AttachByPick "Attach By Pick" pos:[83,yp1[2]] width:75 height:21 tooltip:" Attach Picked Objects To Selected Group "
button btn_GR_Detach "Detach" pos:[161,yp1[2]] width:45 height:21 tooltip:" Detach Selected "

GroupBox grp_GR_AutoGroup "Auto Group" pos:[2,yp1[3]] width:(fl0W-16) height:128
spinner spnr_GR_DetectTolerance "Detect Tolerance:" pos:[51,yp1[3]+16] width:95 range:[0,999999,0.] type:#float scale:.001 toolTip:" Autodetect Group of Objects Tolerance "
checkButton chbtn_GR_VisualTolerance "Preview" pos:[149,yp1[3]+14] width:52 height:21 highlightColor:colCHBX tooltip:" Detect Group of Objects Tolerance Preview "
colorpicker color_GR_ToleranceColor "Preview Diffuse" width:100 height:21 pos:[11,yp1[3]+34] color:AT_ToleranceHelperMaterial.Diffuse modal:false tooltip:" Tolerance Helper Material Diffuse Color "
spinner spnr_GR_ToleranceOpacity "Opacity" pos:[145,yp1[3]+38] width:55 range:[5,100,AT_ToleranceHelperMaterial.Opacity] type:#integer scale:1 toolTip:" Tolerance Helper Material Opacity "
checkButton chbtn_GR_GroupSolid "" pos:[12,yp1[3]+60] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Create Group For Single Object "
label lbl_GR_GroupSolid "Group Solid" pos:[30,yp1[3]+61] tooltip:chbtn_GR_GroupSolid.tooltip
checkButton chbtn_GR_UseGroups "" pos:[102,yp1[3]+60] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Create Subgroup From Groups "
label lbl_GR_UseGroups "Use Groups" pos:[120,yp1[3]+61] tooltip:chbtn_GR_UseGroups.tooltip
checkButton chbtn_GR_NameFromModel "" pos:[12,yp1[3]+80] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Get Group Name From Model (If Possible) "
label lbl_GR_NameFromModel "Group Name From Model" pos:[30,yp1[3]+81] tooltip:chbtn_GR_NameFromModel.tooltip
button btn_GR_AutoGroup "Auto Group" pos:[8,yp1[3]+100] width:(fl0W-28) height:23 tooltip:" Automatic Create Groups By Distance "

button btn_GR_RecreateGroups "Recreate Groups" pos:[0,yp1[4]] width:206 height:21 tooltip:" Recreate Groups "

button btn_GR_GroupToDummy "Group To Dummy" pos:[0,yp1[5]] width:130 height:21 tooltip:" Replace Groups With Dummies "
spinner spnr_GR_DummySize "Size" pos:[145,yp1[5]+3] width:60 range:[1,99999,10] type:#integer scale:1 toolTip:" Dummy Size Value "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_delTolHelpers = with undo off (for o in TolHelpArr where isValidNode o do delete o; TolHelpArr = #(); chbtn_GR_VisualTolerance.checked = false)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_GroupToDummy pressed do with undo on
(
local ghArr = for o in (ATfn_.GetNHH selection true) where (isGroupHead o) collect o
for gh in ghArr where isOpenGroupHead gh do setGroupOpen gh false
for gh in ghArr do
	(
	local tm = gh.transform
	local nm = gh.name
	local gObjs = for o in gh.children collect o
	ungroup gh
	local dum = Dummy size:spnr_GR_DummySize.value name:nm transform:tm
	gObjs.parent = dum
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_GR_VisualTolerance changed state do with undo off
(
local InArr = if chbtn_GR_UseGroups.checked then (ATfn_.GetNHH selection true) else (ATfn_.GetNotGroupHeads selection)
if state
then
	(
	if InArr.count == 0 do (chbtn_GR_VisualTolerance.checked = false; return ATfn_.messageNS())
	TolHelpArr = ATfn_.CreateBoundingBoxes InArr baseName:"VisualToleranceHelper"
	TolHelpArr.material = AT_ToleranceHelperMaterial
	TolHelpArr.scale = [1. + spnr_GR_DetectTolerance.value, 1. + spnr_GR_DetectTolerance.value, 1. + spnr_GR_DetectTolerance.value]
	)
else (fn_delTolHelpers())
ATfn_.Refresh()
)
	------------------------------------------
on spnr_GR_DetectTolerance changed val do with undo off
(
if chbtn_GR_VisualTolerance.checked and TolHelpArr.count != 0 do
	(for o in TolHelpArr do o.scale = [1 + val, 1 + val, 1 + val])
)	
	------------------------------------------
on color_GR_ToleranceColor changed col do (AT_ToleranceHelperMaterial.Diffuse = col)
	------------------------------------------
on spnr_GR_ToleranceOpacity changed val do with undo off (AT_ToleranceHelperMaterial.Opacity = val)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_AutoGroup pressed do with undo on
(
fn_delTolHelpers()
if not chbtn_GR_UseGroups.checked do (if (ATfn_.GetNHH selection false)[2].count != 0 do return (ATfn_.messageGF()))
local InArr = if chbtn_GR_UseGroups.checked then (ATfn_.GetNHH selection true UseChildren:true) else (ATfn_.GetNotGroupHeads selection)
if InArr.count == 0 do return ATfn_.messageNS title:" Group"
-- local startTime= timeStamp()
local groupArr = ATfn_.GroupCollect InArr tolerance:spnr_GR_DetectTolerance.value
-- format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - startTime)).ToString()) ".")[1]
local GArr = #()
for g in groupArr where (if chbtn_GR_GroupSolid.checked then true else (g.count > 1)) do
	(
	local GroupName = ""
	if chbtn_GR_NameFromModel.checked
	then
		(
		if g.count == 1
		then (GroupName = g[1].name)
		else
			(
			local fStr = FilterString g[1].name "_"
			if fStr.count > 3 and fStr[1] == "SM"
				then (GroupName = fStr[1] + "_" + fStr[2] + "_" + fStr[3] + "_01")
				else (GroupName = uniquename "UndefinedName_" numDigits:2)
			)
		)
	else (GroupName = uniquename "Group_" numDigits:2)
	g.wirecolor = ATfn_.RandomColor()
	local grp = group g
	grp.name = GroupName
	append GArr grp
	)
ATfn_.Refresh()
clearSelection()
select GArr
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_GR_UseGroups changed state do with undo off
(
if chbtn_GR_VisualTolerance.checked do
	(
	with undo off (for o in TolHelpArr where isValidNode o do delete o; TolHelpArr = #())
	local InArr = if state then (ATfn_.GetNHH selection true) else (ATfn_.GetNotGroupHeads selection)
	TolHelpArr = ATfn_.CreateBoundingBoxes InArr baseName:"VisualToleranceHelper"
	TolHelpArr.material = AT_ToleranceHelperMaterial
	TolHelpArr.scale = [1. + spnr_GR_DetectTolerance.value, 1. + spnr_GR_DetectTolerance.value, 1. + spnr_GR_DetectTolerance.value]
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_RecreateGroups pressed do with undo on
(
local HeadsArr = (ATfn_.GetNHH selection false)[2]
local NewHeadsArr = #()
if HeadsArr.count > 0 do
	(
	for h in HeadsArr do
		(
		local GName = h.name
		local GObjsArr = ATfn_.GetGroupByHead h ObjectsOnly:true
		explodeGroup h
		local NewGroup = group GObjsArr name:GName
		append NewHeadsArr NewGroup
		)
	)
select NewHeadsArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_Detach pressed do (max group detach)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_AttachByPick pressed do
(
undo off
-- local ghArr = for o in selection where IsGroupHead o and (not isGroupMember o) collect o
local ghArr = for o in selection where IsGroupHead o collect o
if ghArr.count == 0 do (return (messageBox "Selection Does Not Contain Groups." title:" Group" beep:false))
local pickArr = #()
while isValidNode (pickObj = pickObject pickFrozen:false rubberBand:selection.center)
	do (appendIfUnique pickArr pickObj; pickObj.isFrozen = true)
if pickArr.count > 0 do
	(
	undo on
	attachNodesToGroup pickArr ghArr[1]
	pickArr.isFrozen = false
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_AttachSelected pressed do (max group attach)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_ExplodeGroups pressed do (max group explode)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_CloseGroup pressed do (max group close)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_OpenGroup pressed do (max group open)
on btn_GR_OpenGroup rightclick do (max group open recursively)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_Ungroup pressed do (max group ungroup)
	-------------------------------------------------------------------------------------------------------------------
on btn_GR_GroupGroup pressed do (if selection.count != 0 then (group $ name:(uniqueName ("Group_" + (ATfn_.RemoveCounter selection[1].name) + "_") numDigits:3) select:true))
on btn_GR_GroupGroup rightclick do (max group group)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_GR_ open do
-- 	(
-- 	)
on rollout_GR_ close do
	(
	fn_delTolHelpers()
	)
)
	----=Viewport=================================================================================================
rollout rollout_VPT_ "Viewport"
(
--- free index        f
local yp1 = #(0, 92, 135, 135, 159, 185, 277, 345, 436, 506, 526, 588, 654, 675)
GroupBox grp_VPT_HideByCategory "Hide By Category" pos:[2,yp1[1]] width:(fl0W-15) height:65
checkButton chbtn_VPT_hbcGeometry "G" pos:[5,yp1[1]+15] width:22 height:21 images:ATIcons[73] highlightColor:colCHBX checked:(hideByCategory.Geometry) tooltip:" Hide/Unhide Geometry "
checkButton chbtn_VPT_hbcShapes "S" pos:[30,yp1[1]+15] width:22 height:21 images:ATIcons[74] highlightColor:colCHBX checked:(hideByCategory.Shapes) tooltip:" Hide/Unhide Shapes "
checkButton chbtn_VPT_hbcLights "L" pos:[55,yp1[1]+15] width:22 height:21 images:ATIcons[75] highlightColor:colCHBX checked:(hideByCategory.Lights) tooltip:" Hide/Unhide Lights "
checkButton chbtn_VPT_hbcCameras "C" pos:[80,yp1[1]+15] width:22 height:21 images:ATIcons[76] highlightColor:colCHBX checked:(hideByCategory.Cameras) tooltip:" Hide/Unhide Cameras "
checkButton chbtn_VPT_hbcHelpers "H" pos:[105,yp1[1]+15] width:22 height:21 images:ATIcons[77] highlightColor:colCHBX checked:(hideByCategory.Helpers) tooltip:" Hide/Unhide Helpers "
checkButton chbtn_VPT_hbcSpacewarps "SW" pos:[130,yp1[1]+15] width:22 height:21 images:ATIcons[78] highlightColor:colCHBX checked:(hideByCategory.Spacewarps) tooltip:" Hide/Unhide Spacewarps "
checkButton chbtn_VPT_hbcParticles "PS" pos:[155,yp1[1]+15] width:22 height:21 images:ATIcons[79] highlightColor:colCHBX checked:(hideByCategory.Particles) tooltip:" Hide/Unhide Particles "
checkButton chbtn_VPT_hbcBones "B" pos:[180,yp1[1]+15] width:22 height:21 images:ATIcons[80] highlightColor:colCHBX checked:(hideByCategory.Bones) tooltip:" Hide/Unhide Bones "
button btn_VPT_hbcAll "All" pos:[5,yp1[1]+39] width:46 height:21 tooltip:" Check All "
button btn_VPT_hbcNone "None" pos:[54,yp1[1]+39] width:46 height:21 tooltip:" Uncheck All "
button btn_VPT_hbcInvert "Invert" pos:[103,yp1[1]+39] width:46 height:21 tooltip:" Invert Checked "
button btn_VPT_hbcRefresh "Refresh" pos:[152,yp1[1]+39] width:50 height:21

button btn_VPT_GrabViewport "Grab Viewport" pos:[3,yp1[2]-23] width:(fl0W-18) height:21 tooltip:" Grab Viewport "

GroupBox grp_VPT_DisplayShaded "Display Shaded" pos:[2,yp1[2]] width:(fl0W-16) height:38
radiobuttons rdbtn_VPT_ObjectOrMaterial "" labels:#("Object Color","Material Color") pos:[15,yp1[2]+16] columns:2 offsets:#([0,0],[0,0]) default:(if displayColor.shaded == #object then 1 else 2) tooltip:" Display Shaded Object Or Material Color "

button btn_VPT_DisableViewport "Disable" pos:[0,yp1[4]] width:72 height:21
button btn_VPT_ViewportsConfiguration "Viewports Configuration" pos:[75,yp1[4]] width:132 height:21 tooltip:" Viewports Configuration "

button btn_VPT_ViewportClipping "Viewport Clipping" pos:[0,yp1[5]] width:88 height:21 tooltip:" Viewport Clipping Toggle "
button btn_VPT_SafeFrame "Safe Frame" pos:[91,yp1[5]] width:63 height:21 tooltip:" Viewport Clipping Toggle "
button btn_VPT_ShowStatistics "Statistics" pos:[157,yp1[5]] width:50 height:21 tooltip:" Display Statistics Toggle "

local ddlDRitems = #("256", "512", "1024", "2048", "4096", "8192")
GroupBox grp_VPT_DisplayResolution "Display Resolution" pos:[2,yp1[6]] width:(fl0W-16) height:89
label lbl_VPT_BakedProcedural "Baked:............." pos:[10,yp1[6]+20] tooltip:" Baked Procedural Maps Display Resolution "
button btn_VPT_BakedProcedural "Apply" pos:[100,yp1[6]+15] width:45 height:21 tooltip:lbl_VPT_BakedProcedural.tooltip
dropdownlist ddl_VPT_BakedProcedural items:ddlDRitems pos:[148,yp1[6]+16] width:54 height:7 selection:3 tooltip:" Select Resolution "
label lbl_VPT_TextureMaps "Texture:..........." pos:[10,yp1[6]+44] tooltip:" Set Texture Maps Display Resolution "
button btn_VPT_TextureMaps "Apply" pos:[100,yp1[6]+39] width:45 height:21 tooltip:lbl_VPT_TextureMaps.tooltip
dropdownlist ddl_VPT_TextureMaps items:ddlDRitems pos:[148,yp1[6]+40] width:54 height:7 selection:3 tooltip:" Select Resolution "
label lbl_VPT_BackEnvir "Background:......" pos:[10,yp1[6]+68] tooltip:" Set Background / Environment Maps Resolution "
button btn_VPT_BackEnvir "Apply" pos:[100,yp1[6]+63] width:45 height:21 tooltip:lbl_VPT_BackEnvir.tooltip
dropdownlist ddl_VPT_BackEnvir items:ddlDRitems pos:[148,yp1[6]+64] width:54 height:7 selection:3 tooltip:" Select Resolution "

GroupBox grp_VPT_ViewportBackground "Viewport Background" pos:[2,yp1[7]] width:(fl0W-16) height:65
button btn_VPT_VBGradient "Gradient" pos:[5,yp1[7]+15] width:95 height:21 tooltip:" Set Gradient Background "
button btn_VPT_VBSolid "Solid" pos:[103,yp1[7]+15] width:99 height:21 tooltip:" Set Solid Background "
button btn_VPT_VBEnvironment "Environment" pos:[5,yp1[7]+39] width:72 height:21 tooltip:" Lmb - Set Environment Background \n Rmb - Open Environment Dialog "
colorpicker color_VPT_VBSetColor "" pos:[75,yp1[7]+39] width:25 height:21 color:(backgroundColor) modal:false tooltip:" Set Solid Background Color "
button btn_VPT_VBConfig "Configuration" pos:[103,yp1[7]+39] width:99 height:21 tooltip:" Viewport Background Configuration "

GroupBox grp_VPT_ViewportSettings "Viewport Settings" pos:[2,yp1[8]] width:(fl0W-16) height:89
button btn_VPT_HighQuality "High Quality" pos:[5,yp1[8]+15] width:68 height:21 tooltip:" Set High Quality "
button btn_VPT_Standard "Standard" pos:[76,yp1[8]+15] width:55 height:21 tooltip:" Set Standard Quality "
button btn_VPT_Performance "Performance" pos:[134,yp1[8]+15] width:68 height:21 tooltip:" Set Performance Quality "
button btn_VPT_Transparency "Transparency" pos:[5,yp1[8]+39] width:80 height:21 tooltip:" Transparency Toggle "
button btn_VPT_Shadows "Shadows" pos:[88,yp1[8]+39] width:55 height:21 tooltip:" Shadows Toggle "
button btn_VPT_AmbientOcclusion "AO" pos:[146,yp1[8]+39] width:56 height:21 tooltip:" Ambient Occlusion Toggle "
button btn_VPT_DefaultLight "Default Lights" pos:[5,yp1[8]+63] width:95 height:21 tooltip:" Default Lights Toggle "
button btn_VPT_SceneLight "Scene Lights" pos:[103,yp1[8]+63] width:99 height:21 tooltip:" Scene Lights Toggle "

GroupBox grp_VPT_MenuControl "Menu Control" pos:[2,yp1[9]] width:(fl0W-16) height:65
button btn_VPT_Timeline "Timeline" pos:[5,yp1[9]+15] width:48 height:21 tooltip:" Timeline Toggle "
button btn_VPT_StatusPanel "Status Panel" pos:[56,yp1[9]+15] width:68 height:21 tooltip:" Status Panel Toggle "
button btn_VPT_MainToolbar "Main Toolbar" pos:[127,yp1[9]+15] width:75 height:21 tooltip:" Main Toolbar Toggle "
button btn_VPT_CommandPanel "Command Panel" pos:[5,yp1[9]+39] width:95 height:21 tooltip:" Command Panel Toggle "
button btn_VPT_ExpertMode "Expert Mode" pos:[103,yp1[9]+39] width:99 height:21 tooltip:" Expert Mode Toggle "

label lbl_VPT_ShowShadedMaterial "Show Shaded Material:" pos:[10,yp1[10]+1] tooltip:" Show Shaded Material For Selected "
button btn_VPT_ShadedMaterialOn "On" width:35 height:21 pos:[127,yp1[10]] tooltip:" Shaded Material For Selected On "
button btn_VPT_ShadedMaterialOff "Off" width:35 height:21 pos:[167,yp1[10]] tooltip:" Shaded Material For Selected Off "

GroupBox grp_VPT_FreezeTool "Freeze" pos:[2,yp1[11]] width:(fl0W-16) height:60
checkButton chbtn_VPT_FreezeAffectInstances "" pos:[8,yp1[11]+17] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Freeze Or Unfreeze Instances "
label lbl_VPT_FreezeAffectInstances "Affect Instances" pos:[26,yp1[11]+17]
button btn_VPT_Freeze "Freeze" width:91 height:21 pos:[110,yp1[11]+10] tooltip:" Freeze Selected Objects "
button btn_VPT_UnfreezeAll "Unfreeze All" width:91 height:21 pos:[110,yp1[11]+34] tooltip:" Unfreeze All Scene Objects "
button btn_VPT_UnfreezeByHit "Unfreeze By Hit" width:102 height:21 pos:[5,yp1[11]+34] tooltip:" Unfreeze Objects By Hit "

GroupBox grp_VPT_HideTool "Hide" pos:[2,yp1[12]] width:(fl0W-16) height:60
checkButton chbtn_VPT_HideAffectInstances "" pos:[8,yp1[12]+17] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Hide Or UnHide Instances "
label lbl_VPT_HideAffectInstances "Affect Instances" pos:[26,yp1[12]+17]
button btn_VPT_Hide "Hide" width:91 height:21 pos:[110,yp1[12]+10] tooltip:" Hide Selected Objects "
button btn_VPT_UnhideAll "Unhide All" width:91 height:21 pos:[110,yp1[12]+34] tooltip:" Unhide All Scene Objects "
button btn_VPT_UnhideByName "Unhide By Name" width:102 height:21 pos:[5,yp1[12]+34] tooltip:" Unhide Objects By Name "

label lbl_VPT_DisplayObjAsBox "Display Selected As Box:" pos:[6,yp1[13]] tooltip:" Display Selected Objects Toggle "
button btn_VPT_DisObjAsBoxOn "On" width:35 height:21 pos:[127,yp1[13]-3] tooltip:" Display Selected Objects As Bounding Box "
button btn_VPT_DisObjAsBoxOff "Off" width:35 height:21 pos:[167,yp1[13]-3] tooltip:" Display Selected Objects As Mesh "

button btn_VPT_IsolateSelection "Isolate Selection" pos:[0,yp1[14]] width:100 height:21 tooltip:" Isolate Selection "
button btn_VPT_BracketToggle "Bounding Box" pos:[103,yp1[14]] width:103 height:21 tooltip:" Bounding Box Toggle "
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_GrabViewport pressed do (macros.run "Tools" "ViewportGrab")
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_DisObjAsBoxOn pressed do with undo on
(
selection.displaybylayer = false
(ATfn_.InstancesAppend (selection as array)).boxmode = on
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_DisObjAsBoxOff pressed do with undo on
(
selection.displaybylayer = false
(ATfn_.InstancesAppend (selection as array)).boxmode = off
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Hide pressed do with undo on
(
local inArr = if chbtn_VPT_HideAffectInstances.checked \
	then (ATfn_.InstancesAppend (selection as array))
	else (selection as array)
inArr.isHidden = true
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_UnhideAll pressed do with undo on (max unhide all; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_UnhideByName pressed do with undo on (max unhide by name; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Freeze pressed do with undo on
(
local inArr = if chbtn_VPT_FreezeAffectInstances.checked \
	then (ATfn_.InstancesAppend (selection as array))
	else (selection as array)
inArr.isFrozen = true
redrawViews()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_UnfreezeAll pressed do with undo on (max unfreeze all; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_UnfreezeByHit pressed do with undo on
(
local pickObj = undefined do
	(
	pickObj = pickObject pickFrozen:true
	if pickObj != undefined
	then
		(
		if chbtn_VPT_FreezeAffectInstances.checked
			then (InstanceMgr.GetInstances pickObj &Instances; Instances.isFrozen = false)
-- 			then (local Instances = ATfn_.InstancesAppend #(pickObj); Instances.isFrozen = false)
			else (pickObj.isFrozen = false)
		redrawViews()
		)
	) while (pickObj != undefined)
)
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_ShowShadedMaterial state =
(
-- local matArr = #()
-- local mapArr = #()
for objct in selection where objct.mat != undefined do
	(
	local mat = objct.mat
-- 	if (getNumSubMtls mat) > 0
	while (getNumSubMtls mat) do (mat = getSubMtl mat 1)
	local NumSubTexmaps = getNumSubTexmaps mat
	if NumSubTexmaps > 0
	then
		(
		for n=1 to NumSubTexmaps where (getSubTexmap mat n) != undefined do
			(
-- 			format "getSubTexmapSlotName % % \n" n (getSubTexmapSlotName mat n)
			local SlotName = getSubTexmapSlotName mat n
			if  (matchPattern SlotName pattern:"*Diffuse*") or
				(matchPattern SlotName pattern:"*Base Color*") do
					(
					showTextureMap mat off
					showTextureMap mat (getSubTexmap mat n) state
					)
			)
		)
	else
		(
		if classOf mat == MDLMaterial do
			(
			showTextureMap mat state
			)
		)
-- 	appendIfUnique matArr mat
	)
for mat in sceneMaterials do updateMTLInMedit mat
)
	-----fn------------------------------------------------------------------------------------------------------------
on btn_VPT_ShadedMaterialOn pressed do (fn_ShowShadedMaterial on)
on btn_VPT_ShadedMaterialOff pressed do (fn_ShowShadedMaterial off)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_VPT_ObjectOrMaterial changed state do (displayColor.shaded = if state == 1 then #object else #material)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_SceneLight pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).LightOption = #SceneLight)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_DefaultLight pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).LightOption = #DefaultLight)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_AmbientOcclusion pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).AmbientOcclusionEnabled = not (NitrousGraphicsManager.GetActiveViewportSetting()).AmbientOcclusionEnabled)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Shadows pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).ShadowsEnabled = not (NitrousGraphicsManager.GetActiveViewportSetting()).ShadowsEnabled)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Transparency pressed do (viewport.SetTransparencyLevel (if (viewport.GetTransparencyLevel()) == 1 then 3 else 1))
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Performance pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).ViewportPreset = #Performance; rollout_UV_.rdbtn_UV_OverrideMaterialUV.state = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Standard pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).ViewportPreset = #Standard; rollout_UV_.rdbtn_UV_OverrideMaterialUV.state = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_HighQuality pressed do ((NitrousGraphicsManager.GetActiveViewportSetting()).ViewportPreset = #Quality; rollout_UV_.rdbtn_UV_OverrideMaterialUV.state = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_VBConfig pressed do (max background display toggle)
	-------------------------------------------------------------------------------------------------------------------
on color_VPT_VBSetColor changed col do (backgroundColor = col; completeRedraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_VBEnvironment pressed do (actionMan.executeAction 0 "619")
on btn_VPT_VBEnvironment rightclick do (actionMan.executeAction 0 "40029")
	-------------------------------------------------------------------------------------------------------------------
-- on btn_VPT_VBSolid pressed do (viewport.EnableSolidBackgroundColorMode true; completeRedraw())
on btn_VPT_VBSolid pressed do (actionMan.executeAction 0 "618")
	-------------------------------------------------------------------------------------------------------------------
-- on btn_VPT_VBGradient pressed do (viewport.EnableSolidBackgroundColorMode false; completeRedraw())
on btn_VPT_VBGradient pressed do (actionMan.executeAction 0 "617")
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_BackEnvir pressed do (NitrousGraphicsManager.SetBackgroundTextureSizeLimit (ddl_VPT_BackEnvir.selected as number) true)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_TextureMaps pressed do (NitrousGraphicsManager.SetTextureSizeLimit (ddl_VPT_TextureMaps.selected as number) true)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_BakedProcedural pressed do (NitrousGraphicsManager.SetProceduralTextureSizeLimit (ddl_VPT_BakedProcedural.selected as number))
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_IsolateSelection pressed do
(
if (IsolateSelection.IsolateSelectionModeActive())
then (IsolateSelection.ExitIsolateSelectionMode())
else (IsolateSelection.EnterIsolateSelectionMode())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_ExpertMode pressed do
(
local state = cui.getExpertMode()
if state
then
	(
	cui.expertModeOff()
	)
else
	(
	local dockState = "undefined"
	if floater_AssemblyTool.dialogBar do
		(dockState = ((try (cui.getDockState floater_AssemblyTool) catch(undefined)) as string); cui.UnRegisterDialogBar floater_AssemblyTool)
	cui.expertModeOn()
	timeSlider.setVisible false
	trackbar.visible = false
	case dockState of
		(
		"cui_dock_left": (cui.RegisterDialogBar floater_AssemblyTool style:#(#cui_dock_vert); cui.DockDialogBar floater_AssemblyTool #cui_dock_left)
		"cui_dock_right": (cui.RegisterDialogBar floater_AssemblyTool style:#(#cui_dock_vert); cui.DockDialogBar floater_AssemblyTool #cui_dock_right)
		)
	)
-- timeSlider.setVisible state
-- trackbar.visible = state
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_MainToolbar pressed do (actionMan.executeAction 0 "411")
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_CommandPanel pressed do (cui.commandPanelOpen = not cui.commandPanelOpen)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_StatusPanel pressed do (StatusPanel.visible = not StatusPanel.visible)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_Timeline pressed do
(
local state = timeSlider.isVisible()
timeSlider.setVisible (not state)
trackbar.visible = not state
)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_DisableViewport pressed do (max vpt disable)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_ViewportsConfiguration pressed do (max vptconfig)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_SafeFrame pressed do (max SafeFrame Toggle)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_ShowStatistics pressed do (max Show Statistics Toggle)
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_ViewportClipping pressed do (actionMan.executeAction 0 "374")
	-------------------------------------------------------------------------------------------------------------------
on btn_VPT_BracketToggle pressed do
(
actionMan.executeAction 0 "370"  -- Tools: Viewport Selection Show Selection Bracket Toggle
-- disp = NitrousGraphicsManager.GetActiveViewportSetting()
-- disp.ShowSelectionBracketsEnabled = not disp.ShowSelectionBracketsEnabled
-- max wire smooth
-- max wire smooth
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_VPT_hbcGeometry changed state do (hideByCategory.Geometry = state)
on chbtn_VPT_hbcShapes changed state do (hideByCategory.Shapes = state)
on chbtn_VPT_hbcLights changed state do (hideByCategory.Lights = state)
on chbtn_VPT_hbcCameras changed state do (hideByCategory.Cameras = state)
on chbtn_VPT_hbcHelpers changed state do (hideByCategory.Helpers = state)
on chbtn_VPT_hbcSpacewarps changed state do (hideByCategory.Spacewarps = state)
on chbtn_VPT_hbcParticles changed state do (hideByCategory.Particles = state)
on chbtn_VPT_hbcBones changed state do (hideByCategory.Bones = state)
	-------------------------------------------------------------------------------------------------------------------
local hbcCntrls = #(chbtn_VPT_hbcGeometry, chbtn_VPT_hbcShapes, chbtn_VPT_hbcLights, chbtn_VPT_hbcCameras, chbtn_VPT_hbcHelpers, chbtn_VPT_hbcSpacewarps, chbtn_VPT_hbcParticles, chbtn_VPT_hbcBones)
on btn_VPT_hbcAll pressed do (hideByCategory.all(); hbcCntrls.checked = true)
on btn_VPT_hbcNone pressed do (hideByCategory.none(); hbcCntrls.checked = false)
on btn_VPT_hbcInvert pressed do
(
hideByCategory.Geometry = hbcCntrls[1].checked = not hideByCategory.Geometry
hideByCategory.Shapes = hbcCntrls[2].checked = not hideByCategory.Shapes
hideByCategory.Lights = hbcCntrls[3].checked = not hideByCategory.Lights
hideByCategory.Cameras = hbcCntrls[4].checked = not hideByCategory.Cameras
hideByCategory.Helpers = hbcCntrls[5].checked = not hideByCategory.Helpers
hideByCategory.Spacewarps = hbcCntrls[6].checked = not hideByCategory.Spacewarps
hideByCategory.Particles = hbcCntrls[7].checked = not hideByCategory.Particles
hideByCategory.Bones = hbcCntrls[8].checked = not hideByCategory.Bones
)
on btn_VPT_hbcRefresh pressed do
(
hideByCategory.Geometry = hbcCntrls[1].checked
hideByCategory.Shapes = hbcCntrls[2].checked
hideByCategory.Lights = hbcCntrls[3].checked
hideByCategory.Cameras = hbcCntrls[4].checked
hideByCategory.Helpers = hbcCntrls[5].checked
hideByCategory.Spacewarps = hbcCntrls[6].checked
hideByCategory.Particles = hbcCntrls[7].checked
hideByCategory.Bones = hbcCntrls[8].checked
)
	-------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_VPT_ open do
-- 	(
-- 	)
-- on rollout_VPT_ close do
-- 	(
-- 	)
)
	----=Layer=================================================================================================
rollout rollout_LYR_ "Layer"
(
local yp1 = #(0, 24, 48, 72, 96)
button btn_LYR_AddToLayer "Add To Layer" pos:[0,yp1[1]] width:80 height:21 tooltip:" Lmb - Add To Layer \n Rmb - Add To Layer (Set Name) "
button btn_LYR_AddToDefaultLayer "Add To Default Layer" pos:[83,yp1[1]] width:123 height:21 tooltip:" Add To Default Layer "

button btn_LYR_DelEmptyLayers "Delete Empty Layers" pos:[0,yp1[2]] width:115 height:21 tooltip:" Delete Empty Layers "
button btn_LYR_LayerExplorer "Layer Explorer" pos:[118,yp1[2]] width:88 height:21 tooltip:" Toggle Layer Explorer "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_AddToLayer lName =
(
local selArr = selection as array
if selArr.count == 0 do return ATfn_.messageNS()
local newLayer
if lName == undefined
then
	(
	newLayer = LayerManager.newLayer()
	)
else
	(
	layermanager.newLayerFromName lName
	newLayer = layermanager.getLayerFromName lName
	)
for objct in selArr do newLayer.addNode objct
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_LYR_LayerExplorer pressed do
(
if SceneExplorerManager.ExplorerIsOpen "Layer Explorer"
then (SceneExplorerManager.CloseExplorer "Layer Explorer")
else (macros.run "Scene Explorer" "SELayerExplorer")
)
	-------------------------------------------------------------------------------------------------------------------
on btn_LYR_DelEmptyLayers pressed do with undo on (ATfn_.DeleteEmptyLayers())
	-------------------------------------------------------------------------------------------------------------------
on btn_LYR_AddToDefaultLayer pressed do with undo on (fn_AddToLayer "0")
	-------------------------------------------------------------------------------------------------------------------
on btn_LYR_AddToLayer pressed do with undo on (fn_AddToLayer undefined)
	----------------------------
on btn_LYR_AddToLayer rightclick do with undo on (fn_AddToLayer (ATfn_.GetStringDialog()))
	-------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_LYR_ open do
-- 	(
-- 	)
-- on rollout_LYR_ close do
-- 	(
-- 	)
)
	----=Modifiers=================================================================================================
rollout rollout_MOD_ "Modifiers"
(
local yp1 = #(0, 24, 48, 72, 96, 120, 144, 168, 192, 216)
local ttpAddMod = " Lmb - Add Modifiers \n Rmb - Add Unique Modifiers "
button btn_MOD_FFD "FFD" pos:[0,yp1[1]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_FFD222 "FFD 2x2x2" pos:[69,yp1[1]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Bend "Bend" pos:[138,yp1[1]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Shell "Shell" pos:[0,yp1[2]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Bevel "Bevel" pos:[69,yp1[2]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Extrude "Extrude" pos:[138,yp1[2]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Lathe "Lathe" pos:[0,yp1[3]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Chamfer "Chamfer" pos:[69,yp1[3]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_CapHoles "Cap Holes" pos:[138,yp1[3]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_FloatMirror "Mirror Float" pos:[0,yp1[4]] width:66 height:21 tooltip:" Run Mirror Floater "
button btn_MOD_Mirror "Mirror" pos:[69,yp1[4]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Symmetry "Symmetry" pos:[138,yp1[4]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Tessellate "Tessellate" pos:[0,yp1[5]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Subdivide "Subdivide" pos:[69,yp1[5]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_TurboSmooth "TurboSmooth" pos:[138,yp1[5]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Relax "Relax" pos:[0,yp1[6]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Smooth "Smooth" pos:[69,yp1[6]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_TurnToPoly "Turn To Poly" pos:[138,yp1[6]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Lattice "Lattice" pos:[0,yp1[7]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Surface "Surface" pos:[69,yp1[7]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Displace "Displace" pos:[138,yp1[7]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Normal "Normal" pos:[0,yp1[8]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_Slice "Slice" pos:[69,yp1[8]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_WeightedNormals "Weighted N" pos:[138,yp1[8]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_Retopology "Retopology" pos:[0,yp1[9]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_ProBoolean "ProBoolean" pos:[69,yp1[9]] width:66 height:21 tooltip:" Create ProBoolean Compound Object "
button btn_MOD_MeshCleaner "Mesh Cleaner" pos:[138,yp1[9]] width:68 height:21 tooltip:ttpAddMod

button btn_MOD_ProOptimizer "Pro Optimizer" pos:[0,yp1[10]] width:66 height:21 tooltip:ttpAddMod
button btn_MOD_QuadifyMesh "Quadify Mesh" pos:[69,yp1[10]] width:66 height:21 tooltip:ttpAddMod
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_PassAll sel = sel
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_QuadifyMesh pressed do with undo on (ATfn_.AddModifer (Quadify_Mesh()) (ATfn_.GetGeometry))
on btn_MOD_QuadifyMesh rightclick do with undo on (ATfn_.AddModifer (Quadify_Mesh()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_ProOptimizer pressed do with undo on (ATfn_.AddModifer (ProOptimizer()) (ATfn_.GetGeometry))
on btn_MOD_ProOptimizer rightclick do with undo on (ATfn_.AddModifer (ProOptimizer()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_ProBoolean pressed do with undo on
(
if selection.count != 1 do return messageBox "Select Single Object." title:" ProBoolean" beep:false
local objct = selection[1]
if not (ATfn_.GCheck objct) do return messageBox "Select Geometry Object." title:" ProBoolean" beep:false
max modify mode
ProBoolean.createBooleanObjects objct #() 2 2 0
select objct
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_MeshCleaner pressed do with undo on (ATfn_.AddModifer (MeshCleaner()) (ATfn_.GetGeometry))
on btn_MOD_MeshCleaner rightclick do with undo on (ATfn_.AddModifer (MeshCleaner()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Retopology pressed do with undo on (ATfn_.AddModifer (RetopologyComponent()) (ATfn_.GetGeometry))
on btn_MOD_Retopology rightclick do with undo on (ATfn_.AddModifer (RetopologyComponent()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_WeightedNormals pressed do with undo on (ATfn_.AddModifer (Weighted_Normals()) (ATfn_.GetGeometry))
on btn_MOD_WeightedNormals rightclick do with undo on (ATfn_.AddModifer (Weighted_Normals()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Slice pressed do with undo on (ATfn_.AddModifer (SliceModifier()) (ATfn_.GetGeometry))
on btn_MOD_Slice rightclick do with undo on (ATfn_.AddModifer (SliceModifier()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Normal pressed do with undo on (ATfn_.AddModifer (Normalmodifier()) (ATfn_.GetGeometry))
on btn_MOD_Normal rightclick do with undo on (ATfn_.AddModifer (Normalmodifier()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Displace pressed do with undo on (ATfn_.AddModifer (Displace()) fn_PassAll)
on btn_MOD_Displace rightclick do with undo on (ATfn_.AddModifer (Displace()) fn_PassAll Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Surface pressed do with undo on (ATfn_.AddModifer (Surface()) (ATfn_.GetShapes))
on btn_MOD_Surface rightclick do with undo on (ATfn_.AddModifer (Surface()) (ATfn_.GetShapes) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Lattice pressed do with undo on (ATfn_.AddModifer (Lattice()) (ATfn_.GetShapeXGeometry))
on btn_MOD_Lattice rightclick do with undo on (ATfn_.AddModifer (Lattice()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_TurnToPoly pressed do with undo on (ATfn_.AddModifer (Turn_to_Poly()) (ATfn_.GetGeometry))
on btn_MOD_TurnToPoly rightclick do with undo on (ATfn_.AddModifer (Turn_to_Poly()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Smooth pressed do with undo on (ATfn_.AddModifer (Smooth autosmooth:on) (ATfn_.GetGeometry))
on btn_MOD_Smooth rightclick do with undo on (ATfn_.AddModifer (Smooth autosmooth:on) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Relax pressed do with undo on (ATfn_.AddModifer (Relax()) (ATfn_.GetGeometry))
on btn_MOD_Relax rightclick do with undo on (ATfn_.AddModifer (Relax()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_TurboSmooth pressed do with undo on (ATfn_.AddModifer (TurboSmooth()) (ATfn_.GetGeometry))
on btn_MOD_TurboSmooth rightclick do with undo on (ATfn_.AddModifer (TurboSmooth()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Subdivide pressed do with undo on (ATfn_.AddModifer (Subdivide()) (ATfn_.GetShapeXGeometry))
on btn_MOD_Subdivide rightclick do with undo on (ATfn_.AddModifer (Subdivide()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Tessellate pressed do with undo on (ATfn_.AddModifer (Tessellate()) (ATfn_.GetGeometry))
on btn_MOD_Tessellate rightclick do with undo on (ATfn_.AddModifer (Tessellate()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Symmetry pressed do with undo on (ATfn_.AddModifer (Symmetry()) (ATfn_.GetGeometry))
on btn_MOD_Symmetry rightclick do with undo on (ATfn_.AddModifer (Symmetry()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Mirror pressed do with undo on (ATfn_.AddModifer (Mirror()) (ATfn_.GetShapeXGeometry))
on btn_MOD_Mirror rightclick do with undo on (ATfn_.AddModifer (Mirror()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_FloatMirror pressed do with undo on (max mirror)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_CapHoles pressed do with undo on (ATfn_.AddModifer (Cap_Holes()) (ATfn_.GetGeometry))
on btn_MOD_CapHoles rightclick do with undo on (ATfn_.AddModifer (Cap_Holes()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Chamfer pressed do with undo on (ATfn_.AddModifer (Chamfer()) (ATfn_.GetGeometry))
on btn_MOD_Chamfer rightclick do with undo on (ATfn_.AddModifer (Chamfer()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Lathe pressed do with undo on (ATfn_.AddModifer (Lathe()) (ATfn_.GetShapes))
on btn_MOD_Lathe rightclick do with undo on (ATfn_.AddModifer (Lathe()) (ATfn_.GetShapes) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Extrude pressed do with undo on (ATfn_.AddModifer (Extrude()) (ATfn_.GetShapes))
on btn_MOD_Extrude rightclick do with undo on (ATfn_.AddModifer (Extrude()) (ATfn_.GetShapes) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Bevel pressed do with undo on (ATfn_.AddModifer (Bevel()) (ATfn_.GetShapes))
on btn_MOD_Bevel rightclick do with undo on (ATfn_.AddModifer (Bevel()) (ATfn_.GetShapes) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Shell pressed do with undo on (ATfn_.AddModifer (Shell()) (ATfn_.GetGeometry))
on btn_MOD_Shell rightclick do with undo on (ATfn_.AddModifer (Shell()) (ATfn_.GetGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_Bend pressed do with undo on (ATfn_.AddModifer (Bend()) (ATfn_.GetShapeXGeometry))
on btn_MOD_Bend rightclick do with undo on (ATfn_.AddModifer (Bend()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_FFD222 pressed do with undo on (ATfn_.AddModifer (FFD_2x2x2()) (ATfn_.GetShapeXGeometry))
on btn_MOD_FFD222 rightclick do with undo on (ATfn_.AddModifer (FFD_2x2x2()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
on btn_MOD_FFD pressed do with undo on (ATfn_.AddModifer (FFDBox()) (ATfn_.GetShapeXGeometry))
on btn_MOD_FFD rightclick do with undo on (ATfn_.AddModifer (FFDBox()) (ATfn_.GetShapeXGeometry) Unique:true)
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_MOD_ open do
-- 	(
-- 	)
-- on rollout_MOD_ close do
-- 	(
-- 	)
)
	----=File=================================================================================================
rollout rollout_FL_ "File"
(
local yp1 = #(0, 24, 48, 72)
button btn_FL_Import "Import" pos:[0,yp1[1]] width:100 height:21 tooltip:" Open Import Dialog "
button btn_FL_Merge "Merge" pos:[103,yp1[1]] width:103 height:21 tooltip:" Open Merge Dialog "

button btn_FL_Export "Export" pos:[0,yp1[2]] width:50 height:21 tooltip:" Open Export Dialog "
button btn_FL_ExportSelected "Export Selected" pos:[53,yp1[2]] width:85 height:21 tooltip:" Open Export Selected Dialog "
button btn_FL_ExportFBX "Export FBX" pos:[141,yp1[2]] width:65 height:21 tooltip:" Lmb - Export Selection As FBX \n Rmb - Export Selection As FBX With Dialog "

button btn_FL_Save "Save" pos:[0,yp1[3]] width:60 height:21 tooltip:" Open Save Dialog "
button btn_FL_SaveAs "Save As" pos:[63,yp1[3]] width:60 height:21 tooltip:" Open Save As Dialog "
button btn_FL_SaveSelected "Save Selected" pos:[126,yp1[3]] width:80 height:21 tooltip:" Open Save Selected Dialog "

button btn_FL_Open "Open" pos:[0,yp1[4]] width:100 height:21 tooltip:" Open Dialog "
button btn_FL_Reset "Reset" pos:[103,yp1[4]] width:103 height:21 tooltip:" Open Reset Dialog "
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Reset pressed do (max reset file)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Open pressed do (max file open)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_SaveSelected pressed do (if selection.count > 0 do max file save selected)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_SaveAs pressed do (max file saveas)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Save pressed do (max file save)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_ExportSelected pressed do (if selection.count > 0 do max file export selected)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Export pressed do (max file export)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Merge pressed do (max file merge)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_Import pressed do (max file import)
	-------------------------------------------------------------------------------------------------------------------
on btn_FL_ExportFBX pressed do
(
if selection.count != 0 then
	(
-- 	local lastUsedDir = fn_GetINIExecuteStr iniFile "General" "LastUsedExportDir" ""
-- 	if lastUsedDir.count == 3 then ( for w = 1 to lastUsedDir.count do (if lastUsedDir[w] == "/" then (lastUsedDir = replace lastUsedDir w 1 "")) )
-- 	if lastUsedDir[lastUsedDir.count] == "\\" then (lastUsedDir = replace lastUsedDir lastUsedDir.count 1 "")
	local lastUsedDir = "D:"
	local SaveInFile = getSaveFileName caption:"Export FBX..." filename:(lastUsedDir + "\\") types:"Autodesk (*.FBX)|*.FBX|All|*.*|"
	if SaveInFile != undefined then
		(
		exportFile SaveInFile #noprompt selectedOnly:true using:FbxExp
-- 		setINISetting iniFile "General" "LastUsedExportDir" (getFilenamePath SaveInFile)
		)
	)
)
on btn_FL_ExportFBX rightclick do
(
if selection.count != 0 then
	(
-- 	local lastUsedDir = fn_GetINIExecuteStr iniFile "General" "LastUsedExportDir" ""
-- 	if lastUsedDir.count == 3 then ( for w = 1 to lastUsedDir.count do (if lastUsedDir[w] == "/" then (lastUsedDir = replace lastUsedDir w 1 "")) )
-- 	if lastUsedDir[lastUsedDir.count] == "\\" then (lastUsedDir = replace lastUsedDir lastUsedDir.count 1 "")
	local lastUsedDir = "D:"
	local SaveInFile = getSaveFileName caption:"Export FBX..." filename:(lastUsedDir + "\\") types:"Autodesk (*.FBX)|*.FBX|All|*.*|"
	if SaveInFile != undefined then
		(
		exportFile SaveInFile selectedOnly:true using:FbxExp
-- 		setINISetting iniFile "General" "LastUsedExportDir" (getFilenamePath SaveInFile)
		)
	)
)
	-------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_FL_ open do
-- 	(
-- 	)
-- on rollout_FL_ close do
-- 	(
-- 	)
)
	----=Utilities==================================================================================================
rollout rollout_UT_ "Utilities"
(
local yp1 = #(0, 32, 100, 124, 148, 172)
progressBar prgrs_UT_UsedRAM pos:[0,yp1[1]] width:(fl0W-13) height:7 value:0 color:green tooltip:" Memory Used "
timer tmr_UT_UpdateRAM interval:100 active:true
button btn_UT_FreeSceneBitmaps "Free Bitmaps" pos:[0,yp1[1]+9] width:75 height:21 tooltip:" Free Scene Bitmaps "
button btn_UT_ClearUndoBuffer "Clear Undo" pos:[78,yp1[1]+9] width:63 height:21 tooltip:" Clear Undo Buffer "
button btn_UT_GarbageCollection "GC" pos:[144,yp1[1]+9] width:30 height:21 tooltip:" Garbage Collection "
button btn_UT_AllMethods "All" pos:[177,yp1[1]+9] width:30 height:21 tooltip:" Free Scene Bitmaps \n Clear Undo Buffer \n Garbage Collection "

GroupBox grp_UT_QuickRenamer "Quick Renamer" pos:[2,yp1[2]] width:(fl0W-15) height:63
edittext edt_UT_QRenamerName "" pos:[2,yp1[2]+16] width:170 height:17 enabled:true
button btn_UT_QRenamerGetName "Get" pos:[175,yp1[2]+15] width:27 height:19 tooltip:" Lmb - Get Name From Object \n Rmb - Get Name From Material "
checkButton chbtn_UT_QRenamerAddCounter pos:[5,yp1[2]+40] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Add Counter "
label lbl_UT_QRenamerAddCounter "Counter" pos:[23,yp1[2]+40]
spinner spnr_UT_QRCounterDigits "" pos:[65,yp1[2]+40] width:30 range:[0,9,3] type:#Integer scale:1 tooltip:" Counter Digits "
button btn_UT_QRenamerRename "Rename" pos:[109,yp1[2]+37] width:93 height:21 tooltip:" Lmb - Rename Selected Objects \n Rmb - Names Repair For Selected "
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_QRenamerRename pressed do with undo on
(
local OArr = for objct in selection where (isValidNode objct) collect objct
if chbtn_UT_QRenamerAddCounter.checked
then (ATfn_.RenameAddCounter (edt_UT_QRenamerName.text) OArr Separator:"_" CounterDigits:(spnr_UT_QRCounterDigits.value))
else (OArr.name = edt_UT_QRenamerName.text)
local dum = Dummy(); delete dum
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_QRenamerRename rightclick do with undo on
(
local OArr = for objct in selection where (not(SuperClassOf objct == helper)) collect objct
local matArr = #(); for objct in OArr where (objct.material != undefined) do (appendIfUnique matArr objct.material)
local objByMatArr = #(); local tArr = #(); for mat in matArr do (for objct in OArr where objct.material == mat do (appendIfUnique tArr objct); qSort tArr ATfn_.CompareNames; append objByMatArr tArr; tArr = #())
for mArr in objByMatArr do (ATfn_.RenameAddCounter (ATfn_.RemoveCounter (mArr[1].name)) mArr Separator:"_" CounterDigits:(spnr_UT_QRCounterDigits.value))
local dum = Dummy(); delete dum
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_QRenamerGetName pressed do
(
local NHHArr = ATfn_.GetNHH selection false; local OArr = NHHArr[1]; local GHArr = NHHArr[2]
if GHArr.count != 0
then (edt_UT_QRenamerName.text = (ATfn_.RemoveCounter (GHArr[1].name)))
else (if OArr.count != 0 then (edt_UT_QRenamerName.text = (ATfn_.RemoveCounter (OArr[1].name))))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_QRenamerGetName rightclick do
(
local omnArr = for o in selection where o.mat != undefined collect o.mat.name
if omnArr.count > 0 do (edt_UT_QRenamerName.text = omnArr[1])
)
	-------------------------------------------------------------------------------------------------------------------
on tmr_UT_UpdateRAM tick do
(
escapeEnable = false
local curCol = prgrs_UT_UsedRAM.color
local percentsMem = (sysinfo.getSystemMemoryInfo())[1] as float
prgrs_UT_UsedRAM.value = percentsMem
curCol.h = 100 - percentsMem
prgrs_UT_UsedRAM.color = curCol
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_messageMemoryInfo Start End strPlus = (messageBox (strPlus + (((floor (abs ((Start - End)/(1024*1024))) as integer)) as string) + "  mb") title:"Freed Memory" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
on btn_UT_FreeSceneBitmaps pressed do
(
local freeMem_Start = (sysinfo.getSystemMemoryInfo())[3]
freeSceneBitmaps()
local freeMem_End = (sysinfo.getSystemMemoryInfo())[3]
fn_messageMemoryInfo freeMem_Start freeMem_End "Free Scene Bitmaps\n\nFreed : "
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_ClearUndoBuffer pressed do
(
local freeMem_Start = (sysinfo.getSystemMemoryInfo())[3]
clearUndoBuffer()
local freeMem_End = (sysinfo.getSystemMemoryInfo())[3]
fn_messageMemoryInfo freeMem_Start freeMem_End "Clear Undo Buffer\n\nFreed : "
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_GarbageCollection pressed do
(
local freeMem_Start = (sysinfo.getSystemMemoryInfo())[3]
gc()
local freeMem_End = (sysinfo.getSystemMemoryInfo())[3]
fn_messageMemoryInfo freeMem_Start freeMem_End "Garbage Collection\n\nFreed : "
)
	-------------------------------------------------------------------------------------------------------------------
on btn_UT_AllMethods pressed do
(
local freeMem_Start = (sysinfo.getSystemMemoryInfo())[3]
freeSceneBitmaps()
clearUndoBuffer()
gc()
local freeMem_End = (sysinfo.getSystemMemoryInfo())[3]
fn_messageMemoryInfo freeMem_Start freeMem_End "Free Scene Bitmaps\nClear Undo Buffer\nGarbage Collection\n\nFreed : "
)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_UT_ open do
-- 	(
-- 	)
-- on rollout_UT_ close do
-- 	(
-- 	)
)
	----=Preferences==================================================================================================
rollout rollout_PS_ "Preferences"
(
local yp1 = #(0, 26, 51, 72, 72)
button btn_PS_OpenINIdir "Open .ini Files Directory" pos:[0,yp1[1]] width:206 height:22

colorpicker color_PS_ChBxColor "CheckButtons Highlight Color:" width:203 height:22 pos:[4,yp1[2]] color:colCHBX modal:false tooltip:" Check Buttons Color (Restart Required) "

checkButton chbtn_PS_TooltipShow "" pos:[4,yp1[3]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Show Tooltip Toggle \n (Script Reload Required) "

label lbl_PS_TooltipShow "Show Tooltip (Script Reload Required)" pos:[22,yp1[3]] tooltip:chbtn_PS_TooltipShow.tooltip

GroupBox grp_PS_PivotLatticeColors "Pivot  Lattice" pos:[2,yp1[5]] width:(fl0W-15) height:41
colorpicker color_PS_LatticeColor "Lattice Color:" width:92 height:22 pos:[10,yp1[5]+15] color:gray modal:false tooltip:" Pivot Lattice Lines Color "
colorpicker color_PS_PointsColor "Points Color:" width:88 height:22 pos:[112,yp1[5]+15] color:white modal:false tooltip:" Pivot Lattice Points Color "
	-------------------------------------------------------------------------------------------------------------------
on color_PS_LatticeColor changed col do (lines_color = col; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on color_PS_PointsColor changed col do (points_color = col; redrawViews())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_PS_TooltipShow changed state do (setINISetting iniFile "Preferences" "TooltipShow" (state as string))
	-------------------------------------------------------------------------------------------------------------------
on btn_PS_OpenINIdir pressed do (shellLaunch "explorer.exe" iniPath)
	-------------------------------------------------------------------------------------------------------------------
on color_PS_ChBxColor changed col do
(
setINISetting iniFile "Preferences" "color_PS_ChBxColor" (color_PS_ChBxColor.color as string)
local Floaters = #(floater_AssemblyTool, floater_Scatter, floater_Painter, floater_MeshPacker, floater_Collider, \
	floater_MassFX, floater_Optimizer, floater_Replacer, floater_PBRConverter, floater_ConvertTextures, floater_ResizeTextures, \
	floater_AlphabetRenamer, floater_CopyUVChannel, floater_GridPacker, floater_Randomizer, floater_DummyPlacer, \
	floater_BatchExport, floater_BatchRenamer, floater_Array)
local Rollouts = #(rollout_Selector, rollout_ObjectClass, rollout_MaterialClass, rollout_PolyCountManager, \
	rollout_Collector, rollout_Renamer, rollout_MaterialLoader, rollout_BatchImport, rollout_MDLMaterial)
for f in Floaters where (f != undefined) do (for r in f.rollouts do (for c in r.controls where (classOf c == CheckButtonControl) do (c.highlightColor = col; c.state = not c.state; c.state = not c.state)))
for r in Rollouts where (r != undefined) do (for c in r.controls where (classOf c == CheckButtonControl) do (c.highlightColor = col; c.state = not c.state; c.state = not c.state))
)
	-------------------------------------------------------------------------------------------------------------------
on rollout_PS_ open do
	(
	callbacks.addScript #preSystemShutdown "floater_AssemblyTool.rollouts[1].fn_CloseAT()" id:#ATcallbacks_AT_
	)
on rollout_PS_ close do
	(
	setINISetting iniFile "Preferences" "color_PS_ChBxColor" (color_PS_ChBxColor.color as string)
	setINISetting iniFile "Preferences" "AT_ToleranceHelperMaterial_diffuse" (AT_ToleranceHelperMaterial.Diffuse as string)
	setINISetting iniFile "Preferences" "AT_ToleranceHelperMaterial_opacity" (AT_ToleranceHelperMaterial.Opacity as string)
	callbacks.removeScripts id:#ATcallbacks_AT_
	ATcallback_UnvrapElementSelect = undefined
	floater_AssemblyTool = undefined
	gc light:true
	)
)
	----=About=================================================================================================
rollout rollout_ABT_ "About"
(
local yp1 = #(3, 23, 23, 37)
local lastVer = "Version:  1." + "191"
label lbl_ABT_Version lastVer pos:[15,yp1[1]]
-- label lbl_ABT_Version "Version:  1.191" pos:[15,yp1[1]]
label lbl_ABT_MadeBy "Made By:" pos:[16,yp1[2]]
local authPos = 70
label lbl_ABT_Author1 "Andrew Averkin" pos:[authPos,yp1[3]]
label lbl_ABT_Author2 "Viacheslav Sutormin" pos:[authPos,yp1[4]]
)
	/*
	----=NewRolloutNew=================================================================================================
rollout rollout_XXX_ "NewRolloutNew"
(
local yp1 = #(0, 24, 48, 72, 96)
button btn_XXX_ "Prepare Models For Work" pos:[0,yp1[1]] width:206 height:21 tooltip:" Prepare Models For Work: \n  - Recreate Groups \n  - Reset XForm \n  (Inside Groups Preserved XForm) "

	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_XXX_ pressed do with undo on ()
	-------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_XXX_ open do
-- 	(
-- 	)
-- on rollout_XXX_ close do
-- 	(
-- 	)
)
	-- */
	----===============================================================================================================
floater_AssemblyTool = ATfn_.CreateFloater floater_AssemblyTool iniFile fl0W fl0H floaterTitle \
#(rollout_TL_, rollout_TM_, rollout_SEL_, rollout_EG_, rollout_ID_, rollout_MAT_, rollout_UV_, rollout_GR_, rollout_PV_, \
	rollout_VPT_, rollout_LYR_, rollout_MOD_, rollout_FL_, rollout_UT_, rollout_PS_, rollout_ABT_)
on execute do
	(
-- 	/*
	if floater_AssemblyTool.dialogBar do
		(
-- 		ATfn_.DockFloaterFloat floater_AssemblyTool iniFile fl0W fl0H
		cui.UnRegisterDialogBar floater_AssemblyTool
		floater_AssemblyTool.size = ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,fl0H]
		cui.RegisterDialogBar floater_AssemblyTool style:#(#cui_dock_vert)
		case (ATfn_.GetINI 1 iniFile floaterTitle "DockState" "undefined") of
			(
			"cui_dock_left": cui.DockDialogBar floater_AssemblyTool #cui_dock_left
			"cui_dock_right": cui.DockDialogBar floater_AssemblyTool #cui_dock_right
			)
		)
--  */
	if (hasINISetting iniFile rollout_PS_.title) do
		(
		ATfn_.LoadFloaterINI floater_AssemblyTool iniFile ExcludedControls
		)
	)
)