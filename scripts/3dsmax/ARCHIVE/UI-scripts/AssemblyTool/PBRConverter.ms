(
Global floater_PBRConverter
Global floater_AssemblyTool
try (if floater_PBRConverter.dialogBar then (cui.UnRegisterDialogBar floater_PBRConverter); closeRolloutFloater floater_PBRConverter) catch()
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local floaterTitle = "PBR Converter"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "PBRConverter_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,270])[2]
-- local fl0P = ATfn_.GetINI 0 iniFile floaterTitle "LastPosition" [50,50]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_PC_ProBar", "tmr_PC_prgrsFade", "btn_PC_DockLeft", "btn_PC_DockFloat", "btn_PC_DockRight", \
	"lbl_PC_Plus", "ddl_PC_Extensions")
	----=PBRConverter==========================================================================================================================
rollout rollout_PC_ "PBR Converter"
(
local yp1 = #(20, 84, 163, 184, 227)
local DockX = 181; local DockW = 13
button btn_PC_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_PC_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_PC_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_PC_DockLeft pressed do (ATfn_.DockFloaterSide floater_PBRConverter iniFile "left")
on btn_PC_DockRight pressed do (ATfn_.DockFloaterSide floater_PBRConverter iniFile "right")
on btn_PC_DockFloat pressed do (ATfn_.DockFloaterFloat floater_PBRConverter iniFile fl0W fl0H)
	-------
label lbl_PC_Warning "  Standard  And  VRay  Materials " pos:[5,yp1[1]-18]

radiobuttons rdbtn_PC_SelectedOrScene "" labels:#("Selected","Scene") pos:[4,yp1[1]+3] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process All Scene Objects \n Or Selected Objects "

checkButton chbtn_PC_CollapseMapTree "" pos:[4,yp1[2]-36] width:14 height:14 checked:true highlightColor:colCHBX
label lbl_PC_CollapseMapTree "Collapse Complex Map Tree" pos:[22,yp1[2]-36]

GroupBox grp_PC_CollapseMapTree "Collapsed Map Settings" pos:[1,yp1[2]-20] width:(fl0W-14) height:92
checkButton chbtn_PC_UseScenePath "Scene Path" pos:[4,yp1[2]-1] width:76 height:19 checked:true highlightColor:colCHBX tooltip:" Use Scene Path To Save \n Collapsed Texture Files "
label lbl_PC_Plus "+ \\" pos:[83,yp1[2]+1]
edittext edt_PC_PlusFolder "" text:"CollapsedMaps" pos:[97,yp1[2]] width:103 height:17 bold:false
dropdownlist ddl_PC_SetName items:#() pos:[4,yp1[2]+20] width:20 height:33 selection:0 enabled:(not chbtn_PC_UseScenePath.checked) tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_PC_CustomPath "" pos:[21,yp1[2]+22] width:(fl0W-62) height:17 bold:false enabled:(not chbtn_PC_UseScenePath.checked) tooltip:" Custom Path To Save \n Collapsed Texture Files "
button btn_PC_GetScenePath " Get" width:23 height:19 pos:[180,yp1[2]+21] enabled:(not chbtn_PC_UseScenePath.checked) tooltip:" Lmb - Set Path \n Rmb - Get Scene Path "

spinner spnr_PC_TextureSize "Size:" pos:[21,yp1[2]+46] width:60 range:[1,99999,2048] type:#Integer scale:1 toolTip:" Collapsed Texture Size "
label lbl_PC_Format "Format:" pos:[90,yp1[2]+46]
dropdownlist ddl_PC_Extensions items:#(".bmp", ".jpg", ".jpeg", ".png", ".tga", ".tiff") pos:[130,yp1[2]+45] width:54 height:33 selection:2 tooltip:" Collapsed Texture Extension "
button btn_PC_FormatSetup "S" pos:[184,yp1[2]+46] width:18 height:18 tooltip:" Format Setup "

checkButton chbtn_PC_ToRoughOnly "" pos:[4,yp1[3]] width:14 height:14 checked:false highlightColor:colCHBX
label lbl_PC_ToRoughOnly "Convert To PBR Rough Mode Only" pos:[22,yp1[3]]

button btn_PC_Convert "Convert" pos:[5,yp1[4]] width:(fl0W-20) height:37

progressBar prgrs_PC_ProBar pos:[0,yp1[5]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_PC_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_PC_prgrsFade tick do (ATfn_.ProgBarFade prgrs_PC_ProBar tmr_PC_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_ddlWidthDynamic ddl =
(
local ddl_koef = 5.; local ddlLim = 30.
local itemsArr = ddl.items
local maxStr = 100; if itemsArr.count != 0 then (strCountArr = (for f in itemsArr collect f.count);  maxStr = aMax strCountArr)
windows.sendmessage ddl.hwnd[1] 352 (maxStr*(ddl_koef + ddlLim/maxStr)) 0
)
	-----fn------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_getSubMaps inArr deleteInputState =
(
local allSubMaps = #()
local subMaps = #()
for asmp in inArr do
	(
	subMaps = #(asmp)
	for smp in subMaps do
		(
		local getSub = #()
		for i = 1 to (getNumSubTexmaps smp) do
			(
			local Mat = copy (getSubTexmap smp i)
			setSubTexmap smp i Mat
			if Mat != undefined then AppendIfUnique getSub Mat
			)
		join subMaps getSub
		)
	if deleteInputState then (deleteItem subMaps 1)
	for smp in subMaps do (append allSubMaps smp)
	subMaps = #()
	)
return allSubMaps
)
	-----fn---------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_ShiftMapOffset inputMap =
(
local OffsetScaleClasses = #(Cellular, Dent, Marble, Noise, Perlin_Marble, Smoke, Speckle, Splat, Stucco, Water, Wood)
local allSubMaps = fn_getSubMaps #(inputMap) false
for m in allSubMaps do
	(
	if (FindItem OffsetScaleClasses (ClassOf m) > 0) do
		(
		local offs = m.coords.offset
		local tlng = m.coords.tiling
		m.coords.offset = [offs[1]-(m.size*(1.5*(50/m.size))*tlng[1]), offs[2]-(m.size*(1.5*(50/m.size))*tlng[2]), offs[3]]
		)
	)
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_CollapseReplaceMap map mapName =
(
-- local newMap = map
local newMap
if map != undefined do
(
if classOf map != Bitmaptexture
then
	(
	if classOf map == VRayBitmap or classOf map == VRayHDRI
	then
		(
		newMap = Bitmaptexture fileName:(map.HDRIMapName) name:mapName
		newMap.apply = map.cropplace_on
		newMap.cropPlace = map.cropplace_mode
		newMap.clipu = map.cropplace_u
		newMap.clipv = map.cropplace_v
		newMap.clipw = map.cropplace_width
		newMap.cliph = map.cropplace_height
		replaceInstances newMap.coords map.coords
		replaceInstances newMap.output map.output
		replaceInstances map newMap
		)
	else
		(
		if chbtn_PC_CollapseMapTree.checked
		then
			(
			local textureDir = if chbtn_PC_UseScenePath.checked then ((trimright maxFilePath "\\") + "\\" + edt_PC_PlusFolder.text) else (edt_PC_CustomPath.text)
			makeDir textureDir
			local CopyMap = copy map
			fn_ShiftMapOffset CopyMap
			local rMap = renderMap CopyMap size:[spnr_PC_TextureSize.value,spnr_PC_TextureSize.value] scale:(units.decodeValue "1500mm")
			rMap.fileName = textureDir + "\\" + mapName + ddl_PC_Extensions.selected
			save rMap
			newMap = Bitmaptexture fileName:(rMap.fileName) name:mapName
			close rMap; free rMap
-- 			replaceInstances map newMap
			)
-- 		else (newMap = map)
		else (newMap = copy map; newMap.name = mapName)
		)
	)
-- else (newMap = map)
else (newMap = copy map; newMap.name = mapName)
)
return newMap
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_CreatePBR_MetalRough \
base_color_map: \
metalness_map: \
roughness_map: \
ao_map: \
norm_map: \
emit_color_map: \
displacement_map: \
opacity_map: =
(
local mat = PBRMetalRough()
if base_color_map != undefined do mat.base_color_map = base_color_map
if metalness_map != undefined do mat.metalness_map = metalness_map
if roughness_map != undefined do mat.roughness_map = roughness_map
if ao_map != undefined do mat.ao_map = ao_map
if norm_map != undefined do mat.norm_map = norm_map
if emit_color_map != undefined do mat.emit_color_map = emit_color_map
if displacement_map != undefined do mat.displacement_map = displacement_map
if opacity_map != undefined do mat.opacity_map = opacity_map
return mat
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_CreatePBR_SpecGloss \
base_color_map: \
specular_map: \
glossiness_map: \
ao_map: \
norm_map: \
emit_color_map: \
displacement_map: \
opacity_map: =
(
local mat = PBRSpecGloss()
if base_color_map != undefined do mat.base_color_map = base_color_map
if specular_map != undefined do mat.specular_map = specular_map
if glossiness_map != undefined do mat.glossiness_map = glossiness_map
if ao_map != undefined do mat.ao_map = ao_map
if norm_map != undefined do mat.norm_map = norm_map
if emit_color_map != undefined do mat.emit_color_map = emit_color_map
if displacement_map != undefined do mat.displacement_map = displacement_map
if opacity_map != undefined do mat.opacity_map = opacity_map
return mat
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_FindByName Arr input =
(
local index = 0
for o in Arr do (if o.name == input.name do index = findItem Arr o)
return index
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_PC_Convert pressed do with undo on
(
freeSceneBitmaps()
local inputArr = (if rdbtn_PC_SelectedOrScene.state == 1 then selection else objects) as array
local textureDir = if chbtn_PC_UseScenePath.checked then ((trimright maxFilePath "\\") + "\\" + edt_PC_PlusFolder.text) else (edt_PC_CustomPath.text)
if chbtn_PC_CollapseMapTree.checked do
	(
	if textureDir == ("\\" + edt_PC_PlusFolder.text) do (return messagebox "Save Scene To Define Scene Path." title:" PBRConverter")
	if textureDir == "" do (return messagebox "Set Path To Save Collapsed Texture Files." title:" PBRConverter")
	)
MatEditor.Close()
disableSceneRedraw()
tmr_PC_prgrsFade.active = false; prgrs_PC_ProBar.value = 0; prgrs_PC_ProBar.color = orange
inputArr = for objct in inputArr where objct.material != undefined collect objct
-- print inputArr
local objsMatArr = for o in inputArr where fn_FindByName inputArr o.material == 0 collect o.material
-- objsMatArr = for m in objsMatArr where classOf m == VRayMtl or classOf m == StandardMaterial or classOf m == Multimaterial collect m
local SubMatsArr = #()
for pm in objsMatArr do
(
local passSubMatsArr = #(pm)
for smt in passSubMatsArr do
	(
	local getSub = #()
	for i = 1 to (getNumSubMtls smt) do
		(
		local Mat = getSubMtl smt i
		if Mat != undefined then append getSub Mat
		)
	join passSubMatsArr getSub
	)
-- passSubMatsArr = for smt in passSubMatsArr where classOf smt == VRayMtl or classOf smt == StandardMaterial collect smt
passSubMatsArr = for smt in passSubMatsArr where classOf smt == VRayMtl or classOf smt == StandardMaterial or classOf smt == PBRSpecGloss collect smt
for m in passSubMatsArr where fn_FindByName SubMatsArr m == 0 do appendIfUnique SubMatsArr m
)
-- print SubMatsArr

for n=1 to SubMatsArr.count do
	(
	local mat = SubMatsArr[n]
	if classOf mat == Standardmaterial do
		(
		local metalMap = if mat.specularMap != undefined then mat.specularMap else mat.specularLevelMap
		local PBRmat = fn_CreatePBR_MetalRough \
		base_color_map:(fn_CollapseReplaceMap (mat.diffuseMap) (mat.name + "_Albedo")) \
		metalness_map:(fn_CollapseReplaceMap metalMap (mat.name + "_Metalness")) \   --- Specular Color Or Specular level
		roughness_map:(fn_CollapseReplaceMap (mat.glossinessMap) (mat.name + "_Roughness")) \
		ao_map:undefined \
		norm_map:(fn_CollapseReplaceMap (mat.bumpMap) (mat.name + "_Normal")) \
		emit_color_map:(fn_CollapseReplaceMap (mat.SelfIllumMap) (mat.name + "_Emission")) \
		displacement_map:(fn_CollapseReplaceMap (mat.displacementMap) (mat.name + "_Displacement")) \
		opacity_map:(fn_CollapseReplaceMap (mat.opacityMap) (mat.name + "_Opacity"))
		PBRmat.name = mat.name
		replaceInstances mat PBRmat
		)
	if classOf mat == VRayMtl do
		(
		if mat.brdf_useRoughness == off and chbtn_PC_ToRoughOnly.checked == false
		then
			(
			local PBRmat = fn_CreatePBR_SpecGloss \
			base_color_map:(fn_CollapseReplaceMap (mat.texmap_diffuse) (mat.name + "_Albedo")) \
			specular_map:(fn_CollapseReplaceMap (mat.texmap_reflection) (mat.name + "_Specular")) \
			glossiness_map:(fn_CollapseReplaceMap (mat.texmap_reflectionGlossiness) (mat.name + "_Glossiness")) \
			ao_map:undefined \
			norm_map:(fn_CollapseReplaceMap (mat.texmap_bump) (mat.name + "_Normal")) \
			emit_color_map:(fn_CollapseReplaceMap (mat.texmap_self_illumination) (mat.name + "_Emission")) \
			displacement_map:(fn_CollapseReplaceMap (mat.texmap_displacement) (mat.name + "_Displacement")) \
			opacity_map:(fn_CollapseReplaceMap (mat.texmap_opacity) (mat.name + "_Opacity"))
			PBRmat.name = mat.name
			replaceInstances mat PBRmat
			)
		else
			(
			local PBRmat = fn_CreatePBR_MetalRough \
			base_color_map:(fn_CollapseReplaceMap (mat.texmap_diffuse) (mat.name + "_Albedo")) \
			metalness_map:(fn_CollapseReplaceMap (mat.texmap_reflection) (mat.name + "_Metalness")) \
			roughness_map:(fn_CollapseReplaceMap (mat.texmap_reflectionGlossiness) (mat.name + "_Roughness")) \
			ao_map:undefined \
			norm_map:(fn_CollapseReplaceMap (mat.texmap_bump) (mat.name + "_Normal")) \
			emit_color_map:(fn_CollapseReplaceMap (mat.texmap_self_illumination) (mat.name + "_Emission")) \
			displacement_map:(fn_CollapseReplaceMap (mat.texmap_displacement) (mat.name + "_Displacement")) \
			opacity_map:(fn_CollapseReplaceMap (mat.texmap_opacity) (mat.name + "_Opacity"))
			PBRmat.name = mat.name
			replaceInstances mat PBRmat
			)
		)
	if classOf mat == PBRSpecGloss and chbtn_PC_ToRoughOnly.checked do
		(
		local PBRmat = fn_CreatePBR_MetalRough \
		base_color_map:(fn_CollapseReplaceMap (mat.base_color_map) (mat.name + "_Albedo")) \
		metalness_map:(fn_CollapseReplaceMap (mat.specular_map) (mat.name + "_Metalness")) \
		roughness_map:(fn_CollapseReplaceMap (mat.glossiness_map) (mat.name + "_Roughness")) \
		ao_map:undefined \
		norm_map:(fn_CollapseReplaceMap (mat.norm_map) (mat.name + "_Normal")) \
		emit_color_map:(fn_CollapseReplaceMap (mat.emit_color_map) (mat.name + "_Emission")) \
		displacement_map:(fn_CollapseReplaceMap (mat.displacement_map) (mat.name + "_Displacement")) \
		opacity_map:(fn_CollapseReplaceMap (mat.opacity_map) (mat.name + "_Opacity"))
		PBRmat.name = mat.name
		replaceInstances mat PBRmat
		)
	prgrs_PC_ProBar.value = 100.0*n/(SubMatsArr.count)
	)
prgrs_PC_ProBar.color = green; tmr_PC_prgrsFade.active = true
ATfn_.SelectInGroups inputArr
enableSceneRedraw()
completeRedraw()
freeSceneBitmaps()
)
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_PC_CollapseMapTree changed state do
(
local CMTcontrols = #(btn_PC_FormatSetup, ddl_PC_Extensions, lbl_PC_Format, spnr_PC_TextureSize, btn_PC_GetScenePath, \
	edt_PC_CustomPath, ddl_PC_SetName, edt_PC_PlusFolder, lbl_PC_Plus, chbtn_PC_UseScenePath, grp_PC_CollapseMapTree)
if state
then
	(
	CMTcontrols.enabled = state
	edt_PC_PlusFolder.enabled = chbtn_PC_UseScenePath.checked
	#(ddl_PC_SetName, edt_PC_CustomPath, btn_PC_GetScenePath).enabled = not chbtn_PC_UseScenePath.checked
	)
else
	(
	CMTcontrols.enabled = state
	)
ATfn_.chbtnColorUpdate CMTcontrols colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_PC_UseScenePath changed state do (edt_PC_PlusFolder.enabled = state; #(ddl_PC_SetName, edt_PC_CustomPath, btn_PC_GetScenePath).enabled = not state)
	-------------------------------------------------------------------------------------------------------------------
on ddl_PC_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_PC_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_PC_SetName.items = deepCopy savedNamesArr)
	ATfn_.ddlWidthDynamic ddl_PC_SetName
	)
else (edt_PC_CustomPath.text = (ddl_PC_SetName.items)[item])
)
on ddl_PC_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_PC_SetName.items
	appendIfUnique savedNamesArr edt_PC_CustomPath.text
	sort savedNamesArr
	ddl_PC_SetName.items = deepCopy savedNamesArr
	ATfn_.ddlWidthDynamic ddl_PC_SetName
	setFocus edt_PC_CustomPath
	)
else
	(
	edt_PC_CustomPath.text = ""
	setFocus edt_PC_CustomPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_PC_GetScenePath pressed do
(
local SavePath = getSavePath initialDir:(edt_PC_CustomPath.text) "\\"
if SavePath != undefined do (edt_PC_CustomPath.text = try(trimright SavePath)catch(edt_PC_CustomPath.text))
)
on btn_PC_GetScenePath rightclick do if maxFilePath != "" do (edt_PC_CustomPath.text = trimright maxFilePath "\\")
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_SetupBMP =
(
rollout rolloutSetupBMP "BMP Configuration"
(
groupBox grp_Colors "Colors" pos:[10,6] width:212 height:60
radiobuttons rdbtn_ColorPalette "" labels:#("8 Bit Optimized palette  (256 Colors)","RGB 24 bit  (16.7 Million Colors)") pos:[22,24] columns:1 default:(def; case (bmp.getType()) of (#paletted: def=1; #true24: def=2); def)
button btn_OK "OK" pos:[30,72] width:80 height:24
button btn_Cancel "Cancel" pos:[122,72] width:80 height:24
on btn_OK pressed do
(
case rdbtn_ColorPalette.state of 
	(
	1: bmp.setType #paletted
	2: bmp.setType #true24
	)
destroyDialog rolloutSetupBMP
)
on btn_Cancel pressed do (destroyDialog rolloutSetupBMP)
)
X = mouse.screenpos.X; Y = mouse.screenpos.Y
CreateDialog rolloutSetupBMP 232 104 pos:[(X-114),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_SetupJPEG =
(
rollout rolloutSetupJPEG "JPEG Image Control"
(
groupBox grp_ImageControl "Image Control" pos:[10,6] width:212 height:44
spinner spnr_Quality "Quality:" pos:[48,26] width:56 range:[1,100,(JPEG.getQuality())] type:#integer scale:1 enabled:true tooltip:"JPEG Quality"
spinner spnr_Smoothing "Smoothing:" pos:[150,26] width:60 range:[0,100,(JPEG.getSmoothing())] type:#integer scale:1 enabled:true tooltip:"JPEG Smoothing"
button btn_OK "OK" pos:[30,56] width:80 height:24
button btn_Cancel "Cancel" pos:[122,56] width:80 height:24
on btn_OK pressed do (JPEG.setQuality spnr_Quality.value; JPEG.setSmoothing spnr_Smoothing.value; destroyDialog rolloutSetupJPEG)
on btn_Cancel pressed do (destroyDialog rolloutSetupJPEG)
)
X = mouse.screenpos.X; Y = mouse.screenpos.Y
CreateDialog rolloutSetupJPEG 232 88 pos:[(X-114),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_SetupPNG =
(
rollout rolloutSetupPNG "PNG Configuration"
(
groupBox grp_Colors "Colors" pos:[10,6] width:180 height:102
radiobuttons rdbtn_ColorPalette "" labels:#("Optimized palette  (256)", "RGB 24bit  (16.7 Million)", "RGB 48 bit  (281 Trillion)", "Grayscale 8 bit  (256)", "Grayscale 16 bit  (65,536)") pos:[22,24] columns:1 default:(def; case (pngIO.getType()) of (#paletted: def=1; #true24: def=2; #true48: def=3; #gray8: def=4; #gray16: def=5); def)
checkbox chbx_AlphaChannel "Alpha channel" pos:[16,114] checked:(pngIO.getAlpha())
checkbox chbx_Interlaced "Interlaced" pos:[116,114] checked:(pngIO.getInterlaced())
button btn_OK "OK" pos:[15,142] width:80 height:24
button btn_Cancel "Cancel" pos:[107,142] width:80 height:24
on btn_OK pressed do
(
pngIO.setAlpha (chbx_AlphaChannel.checked)
pngIO.setInterlaced (chbx_Interlaced.checked)
case rdbtn_ColorPalette.state of 
	(
	1: pngIO.setType #paletted
	2: pngIO.setType #true24
	3: pngIO.setType #true48
	4: pngIO.setType #gray8
	5: pngIO.setType #gray16
	)
destroyDialog rolloutSetupPNG
)
on btn_Cancel pressed do (destroyDialog rolloutSetupPNG)
)
X = mouse.screenpos.X; Y = mouse.screenpos.Y
CreateDialog rolloutSetupPNG 200 174 pos:[(X-100),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_SetupTGA =
(
rollout rolloutSetupTGA "Targa Image Control"
(
groupBox grp_ImageAttributes "Image Attributes" pos:[10,6] width:264 height:74
label lbl_BitsPerPixel "Bits-Per-Pixel:" pos:[22,37]
radiobuttons rdbtn_ColorPalette "" labels:#("16", "24", "32") pos:[92,24] columns:1 default:(def; case (Targa.getColorDepth()) of (16: def=1; 24: def=2; 32: def=3); def)
checkbox chbx_Compress "Compress" pos:[152,24] checked:(Targa.getCompressed()==1)
checkbox chbx_AlphaSplit "Alpha Split" pos:[152,39] checked:(Targa.getAlphaSplit())
checkbox chbx_PreMultAlpha "Pre-Multiplied Alpha" pos:[152,54] checked:(Targa.getPreMultAlpha())
button btn_OK "OK" pos:[52,86] width:80 height:24
button btn_Cancel "Cancel" pos:[150,86] width:80 height:24
on btn_OK pressed do
(
Targa.setCompressed (chbx_Compress.checked)
Targa.setAlphaSplit (chbx_AlphaSplit.checked)
Targa.setPreMultAlpha (chbx_PreMultAlpha.checked)
case rdbtn_ColorPalette.state of 
	(
	1: Targa.setColorDepth 16
	2: Targa.setColorDepth 24
	3: Targa.setColorDepth 32
	)
destroyDialog rolloutSetupTGA
)
on btn_Cancel pressed do (destroyDialog rolloutSetupTGA)
)
X = mouse.screenpos.X; Y = mouse.screenpos.Y
CreateDialog rolloutSetupTGA 284 118 pos:[(X-140),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_SetupTIFF =
(
rollout rolloutSetupTIFF "Targa Image Control"
(
groupBox grp_ImageType "Image Type" pos:[10,6] width:138 height:126
radiobuttons rdbtn_ColorPalette "" labels:#("8-bit Greyscale", "8-bit Color", "16-bit Color", "16-bit SGI LogL", "32-bit SGI LogLUV") pos:[22,24] columns:1 default:(def; case (TIF.getType()) of (#mono: def=1; #color: def=2; #color16: def=3; #logL: def=4; #logLUV: def=5); def)
checkbox chbx_AlphaChannel "Store Alpha Channel" pos:[22,106] checked:(if TIF.getAlpha()==#true then true else false)
groupBox grp_CompressionType "Compression Type" pos:[154,6] width:138 height:56
radiobuttons rdbtn_Compression "" labels:#("No Compression", "Packbits") pos:[166,24] columns:1 default:(if TIF.getCompression()==#none then 1 else 2)
spinner spnr_DPI "Dots Per Inch" pos:[204,69] width:84 range:[0,12000,(TIF.getDPI())] type:#float scale:1 enabled:true
button btn_OK "OK" pos:[156,106] width:64 height:24
button btn_Cancel "Cancel" pos:[227,106] width:64 height:24
on btn_OK pressed do
(
case rdbtn_ColorPalette.state of 
	(
	1: TIF.setType #mono
	2: TIF.setType #color
	3: TIF.setType #color16
	4: TIF.setType #logL
	5: TIF.setType #logLUV
	)
TIF.setAlpha (if chbx_AlphaChannel.checked then #true else #false)
case rdbtn_Compression.state of 
	(
	1: TIF.setCompression #none
	2: TIF.setCompression #packBits
	)
TIF.setDPI (spnr_DPI.value)
destroyDialog rolloutSetupTIFF
)
on btn_Cancel pressed do (destroyDialog rolloutSetupTIFF)
)
X = mouse.screenpos.X; Y = mouse.screenpos.Y
CreateDialog rolloutSetupTIFF 300 140 pos:[(X-150),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
on btn_PC_FormatSetup pressed do
	(
	case ddl_PC_Extensions.selection of
		(
		1: fn_SetupBMP()
		2: fn_SetupJPEG()
		3: fn_SetupJPEG()
		4: fn_SetupPNG()
		5: fn_SetupTGA()
		6: fn_SetupTIFF()
		)
	)
	----================================================================================================================================
on rollout_PC_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_PBRConverter.checked = true)catch()
	ATfn_.ddlWidthDynamic ddl_PC_SetName
	)
on rollout_PC_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_PBRConverter.checked = false)catch()
	ATfn_.SaveFloaterINI floater_PBRConverter iniFile ExcludedControls
	floater_PBRConverter = undefined
	)
)
	----================================================================================================================================
floater_PBRConverter = ATfn_.CreateFloater floater_PBRConverter iniFile fl0W fl0H floaterTitle #(rollout_PC_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_PBRConverter iniFile ExcludedControls)
-- 	for r in floater_PBRConverter.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)