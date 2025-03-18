-- macroScript CameraLister 
-- category:"NormLiScripts" 
-- buttonText:"Camera Lister"
(
	
	global Camera_Lister
	

	--Create a rollout
	
	rollout ro_imageCompHelper "IMAGE OVERLAY" 	width:250
	(
		/**************************************
				VARIABLES
		**************************************/		
		
		-- ONLY FOR GOLDEN SPIRAL
		local rectangles = #() -- rectangles for golden spiral
		local spiralMode = 0
		
		
		/**************************************
				GUI
		**************************************/
		
-- 		colorPicker cp_custom "" pos:[-1,52] width:23 height:22 color:(color 0 255 0)
-- 		colorPicker cp_thirds "" 				pos:[0,10] width:20 height:20 color:(color 255 255 0)
		checkbutton ckb_thirds "Rule of Thirds" width:100 height:20 toolTip:"" checked:false across:2
-- 		
-- 		colorPicker cp_diagonals "" 	pos:[170,10] width:20 height:20 color:(color 255 0 0)
-- 		checkbutton ckb_diagonals "Diagonals" pos:[200,10] width:88 height:22 toolTip:"" checked:false
		
-- 		colorPicker cp_golden "" 		pos:[-1,123] width:20 height:20 color:(color 255 110 0)
-- 		colorPicker cp_spiral "" 		pos:[-1,147] width:20 height:20 color:(color 255 255 255)
-- 		colorPicker cp_cross "" 		pos:[-1,171] width:20 height:20 color:(color 0 0 155)
		
-- 		checkbutton ckb_golden "Golden Ratio" pos:[23,123] width:88 height:22 toolTip:"" checked:false
		checkbutton ckb_cross "Center Cross" width:100 height:20 toolTip:"" checked:false
		
-- 		checkbutton ckb_custom "Custom" pos:[23,52] width:86 height:22 toolTip:"" checked:false		
-- 		checkbutton ckb_spiral "Golden Spiral" pos:[23,147] width:88 height:22 toolTip:"Rightclick to flip spiral" checked:false
-- 		GroupBox grp_custom "Custom:" pos:[1,0] width:110 height:76
-- 		spinner spn_XDivs "X Divs:" pos:[27,15] width:80 height:16 range:[0,999,4] type:#integer scale:1
-- 		spinner spn_YDivs "Y Divs:" pos:[27,33] width:80 height:16 range:[0,999,4] type:#integer scale:1
		
		
		/**************************************
				FUNCTIONS
		**************************************/	
		
		/**
			When user changes color, update the checkboxes
		**/
		fn updateHighlightColors=
		(
			local divisor = 2.5
-- 			ckb_golden.highlightColor = cp_golden.color / divisor
-- 			ckb_custom.highlightColor = cp_custom.color / divisor
-- 			ckb_cross.highlightColor = cp_cross.color / divisor
-- 			ckb_diagonals.highlightColor = cp_diagonals.color / divisor
-- 			ckb_thirds.highlightColor = cp_thirds.color / divisor
-- 			ckb_spiral.highlightColor = cp_spiral.color / divisor			
		)--end fn
		
		fn drawCircle origin radius startAngle endAngle step clr=
		(
			points = #()
			for i in startAngle to endAngle by step do
			(
				x = origin.x + radius * sin i
				y = origin.y + radius * cos i
				p = [x,y,0]
				append points p
			)--end
			
			for j=1 to (points.count-1) do
			(
				gw.wPolyline #(points[j], points[j+1]) false rgb:#(clr,clr)
			)--end for	
		)--end fn
		
		fn drawRectangle rect clr=
		(
			gw.wPolyline #(rect[1], rect[2], rect[3], rect[4]) true rgb:#(clr,clr,clr,clr)
		)--end fn		

		/**
			Gets a rectangle, calculates a new one that is part of the old
		**/
		fn calcSubRectangle rect blendFactor times=
		(
			while times > 0 do
			(
				case spiralMode of
				(				
					-- choose order of vertices for calculation
					-- basically there are just two working modes, so each is double
					-- the other two are different in the order that the newRect is created
					0: (A = rect[1]; B = rect[2]; C = rect[3]; D = rect[4])
					1: (C = rect[1]; D = rect[2]; A = rect[3]; B = rect[4])
					2: (C = rect[1]; D = rect[2]; A = rect[3]; B = rect[4])
					3: (A = rect[1]; B = rect[2]; C = rect[3]; D = rect[4])
				)--end case
			
				eX = B.x + blendFactor * (C.x - B.x)
				eY = B.y + blendFactor * (C.y - B.y)
				E = [eX, eY, 0]
				
				fX = A.x + blendFactor * (D.x - A.x)
				fY = A.y + blendFactor * (D.y - A.y)
				F = [fX, fY, 0]
				
				-- choose order for newRect
				-- create new rectangle with different vertex order, append and repeat
				case spiralMode of
				(
					0 : newRect = #(E,C,D,F)
					1 : newRect = #(E,C,D,F)
					2 : newRect = #(D,F,E,C)
					3 : newRect = #(D,F,E,C)
				)--end case
				
				append rectangles newRect -- no return needed, as this is basically the result of the fn
				
				times -= 1 
				
				if times > 0 do
				(
					rect = newRect
				)--end if
			)--end while
			
		)--end fn
		
		fn drawGoldenSpiral fieldX fieldY offsetX offsetY=
		(

			-- SETUP
			if fieldX > (fieldY * 1.618) then
			(
				local w = fieldY * 1.618
				local h = fieldY 
			)--end if
			else
			(
				local w = fieldX
				local h = fieldX / 1.618 
			)--end else
			
			local oriX = fieldX/2 - w/2 -- origin x
			local oriY = fieldY/2 - h/2 -- origin y
			
			local step = 3 -- 1 means 360 points are connected to draw a circle, 2 means 180 etc.
			local clr = cp_spiral.color
			
			-- CALCULATION
			-- main rectangle
			append rectangles #([oriX + offsetX, oriY + offsetY + h, 0], [oriX + offsetX, oriY + offsetY, 0], [oriX + offsetX + w, oriY + offsetY, 0], [oriX + offsetX + w, oriY + offsetY + h, 0])

			calcSubRectangle rectangles[1] 0.618047 12
			-- calculate n sub-rectangles by inverse of golden ratio (1/1.618) == 0.618047
			
			-- look up starting orientation to draw circles correctly
			local circleStart 
			local originIndex 
			local rotationDirection
			
			-- there has only been some method but more experimentation behind these settings
			case spiralMode of
			(	
				0 : (originIndex = 4; circleStart = 180; rotationDirection = 1)
				1 : (originIndex = 1; circleStart = 90; rotationDirection = 0)
				2 : (originIndex = 2; circleStart = 360; rotationDirection = 1)
				3 : (originIndex = 3; circleStart = 270; rotationDirection = 0)
			)--end case
			
			-- DRAWING
			for k = 1 to rectangles.count do 
			(						
				local r = rectangles[k]

				-- COMMENT THIS LINE OUT TO ONLY DRAW THE SPIRAL WITHOUT SURROUNDING RECTANGLES
				drawRectangle r (clr / 2.5)
						
				if k > 1 do -- no circle around main rectangle, so skip k==1
				(
					local prevR = rectangles[k-1]
					local degrees = 90 -- quarter circles is what we want
					
					-- CW or CCW drawing of circle
					if rotationDirection == 1 then
					(
						drawCircle r[originIndex] (distance prevR[1] prevR[2]) circleStart (circleStart + degrees) step clr				
					
						circleStart -= degrees -- decrease
						if circleStart <= 0 do circleStart = 360
					)
					else if rotationDirection == 0 do
					(
						drawCircle r[originIndex] (distance prevR[1] prevR[2]) circleStart (circleStart + degrees) step clr				
						
						circleStart += degrees -- increase
						if circleStart >= 360 do circleStart = 0
					)--end else
				)--end if
			)--end for
			
			-- reset rectangles !
			rectangles = #()
		)--end fn
		
		fn drawGoldenRatio fieldX fieldY offsetX offsetY=
		(
			gldX = fieldX as float / 1.6180
			gldY = fieldY as float / 1.6180
			gw.wPolyline #([gldX+offsetX, 0+offsetY, 0], [gldX+offsetX, fieldY+offsetY-1, 0]) true rgb:#(cp_golden.color, cp_golden.color)
			gw.wPolyline #([fieldX-gldX+offsetX, 0+offsetY, 0], [fieldX-gldX+offsetX, fieldY+offsetY-1, 0]) true rgb:#(cp_golden.color, cp_golden.color)
			gw.wPolyline #([0+offsetX, gldY+offsetY, 0], [fieldX+offsetX-1, gldY+offsetY, 0]) true rgb:#(cp_golden.color, cp_golden.color)
			gw.wPolyline #([0+offsetX, fieldY-gldY+offsetY, 0], [fieldX+offsetX-1, fieldY-gldY+offsetY, 0]) true rgb:#(cp_golden.color, cp_golden.color)
		)--end fn
		
		fn drawCross fieldX fieldY offsetX offsetY=
		(
			b = fieldX / 2
			h = fieldY / 2
			gw.wPolyline #([b+offsetX, 0+offsetY, 0], [b+offsetX, fieldY+offsetY-1, 0]) true 
			gw.wPolyline #([0+offsetX, h+offsetY, 0], [fieldX+offsetX-1, h+offsetY, 0]) true 
		)--end fn
	
		fn drawCustomLines fieldX fieldY offsetX offsetY=
		(
			if spn_XDivs.value > 0 do
			(
				b = fieldX / (spn_XDivs.value+1) as float
				for i=1 to spn_XDivs.value do
				(					
					gw.wPolyline #([i*b+offsetX, 0+offsetY, 0], [i*b+offsetX, fieldY+offsetY-1, 0]) true rgb:#(cp_custom.color, cp_custom.color)
				)--end for
			)--end if
			if spn_YDivs.value > 0 do
			(
				h = fieldY / (spn_YDivs.value+1) as float
				for i=1 to spn_YDivs.value do
				(					
					gw.wPolyline #([0+offsetX, i*h+offsetY, 0], [fieldX+offsetX-1, i*h+offsetY, 0]) true rgb:#(cp_custom.color, cp_custom.color)
				)--end for
			)--end if
		)--end fn
		
		fn drawThirds fieldX fieldY offsetX offsetY=
		(
			b = fieldX / 3
			h = fieldY / 3
			gw.wPolyline #([b+offsetX, 0+offsetY, 0], [b+offsetX, 3*h+offsetY-1, 0]) true 
			gw.wPolyline #([2*b+offsetX, 0+offsetY, 0], [2*b+offsetX, 3*h+offsetY-1, 0]) true 
			gw.wPolyline #([0+offsetX, h+offsetY, 0], [3*b+offsetX-1, h+offsetY, 0]) true 
			gw.wPolyline #([0+offsetX, 2*h+offsetY, 0], [3*b+offsetX-1, 2*h+offsetY, 0]) true
		)--end fn
		
		fn drawDiagonals  fieldX fieldY offsetX offsetY=
		(
			gw.wPolyline #([0+offsetX, 0+offsetY, 0], [fieldX+offsetX, fieldY+offsetY, 0]) true rgb:#(cp_diagonals.color, cp_diagonals.color)
			gw.wPolyline #([0+offsetX, fieldY+offsetY, 0], [fieldX+offsetX, 0+offsetY, 0]) true rgb:#(cp_diagonals.color, cp_diagonals.color)
		)--end fn
		
		/**
			MAIN EXECUTION FUNCTION (LIVES IN CALLBACK)
		**/
		fn prepareAndDraw=
		(
			if ckb_thirds.checked or /* ckb_golden.checked or */ ckb_cross.checked /*or ckb_diagonals.checked or ckb_custom.checked or ckb_spiral.checked */ do
			(
				-- PREPARE
				if (displaysafeframes==false) do (displaysafeframes=true)	
				--General Calculation of Drawing Field:
				local winX = gw.getWinSizeX()
				local winY = gw.getWinSizeY()
				local winAspect = winX as float / winY as float
				local renAspect = renderWidth as float / renderHeight as float
				
				local offsetX = 0
				local offsetY = 0
				local fieldX = 0
				local fieldY = 0

				--if width > height:
				if winAspect > renAspect then
				(
					fieldFactor = winY as float / renderHeight as float
					fieldY = winY
					fieldX = fieldFactor * renderWidth
					offsetX = (winX - fieldX)/2 + 1
				)--end if
				--if height > width:
				else
				(
					fieldFactor = winX as float / renderWidth as float
					fieldX = winX
					fieldY = fieldFactor * renderHeight
					offsetY = (winY - fieldY)/2 + 1
				)--end else
				
				-- DRAW
-- 				if ckb_custom.checked do drawCustomLines fieldX fieldY offsetX offsetY
-- 				if ckb_spiral.checked do drawGoldenSpiral fieldX fieldY offsetX offsetY
-- 				if ckb_golden.checked do drawGoldenRatio fieldX fieldY offsetX offsetY
				if ckb_thirds.checked do drawThirds fieldX fieldY offsetX offsetY
-- 				if ckb_diagonals.checked do drawDiagonals fieldX fieldY offsetX offsetY
				if ckb_cross.checked do drawCross fieldX fieldY offsetX offsetY
					
				gw.enlargeUpdateRect #whole
				gw.updateScreen()
				redrawViews()				
			)--end if
		)--end fn

		
		/**************************************
				EVENTS
		**************************************/		
		
		-- ROLLOUT
		on ro_imageCompHelper open do
		(
			unregisterRedrawViewsCallback prepareAndDraw
			registerRedrawViewsCallback prepareAndDraw
			if (displaysafeframes==false) do (displaysafeframes=true)	
			updateHighlightColors()
			redrawViews() --redraw all views to show the safe frame immediately after starting the script
			
-- 			ckb_thirds.checked = on
		)--end on
		
		
		on ro_imageCompHelper close do
		(
			unregisterRedrawViewsCallback prepareAndDraw
			redrawViews()
		)--end on
		
		-- CHECKBUTTONS
		on ckb_thirds changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_golden changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_cross changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_diagonals changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_custom changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_spiral changed theState do
		(
			updateHighlightColors()
			redrawViews()
		)--end on
		on ckb_spiral rightclick do
		(
			spiralMode += 1
			if spiralMode > 3 do spiralMode = 0
			redrawViews()
		)--end on	
		
		-- COLORPICKERS
		on cp_thirds changed clr do
		(
			redrawViews()
		)--end on
		on cp_golden changed clr do
		(
			redrawViews()
		)--end on
		on cp_cross changed clr do
		(
			redrawViews()
		)--end on
		on cp_diagonals changed clr do
		(
			redrawViews()
		)--end on
		on cp_custom changed clr do
		(
			redrawViews()
		)--end on
		on cp_spiral changed clr do
		(
			redrawViews()
		)--end on
	
		-- SPINNERS
		on spn_XDivs changed theValue do
		(
			max views redraw
		)--end on
		on spn_YDivs changed theValue do
		(
			max views redraw
		)--end on
	
	)
	
	rollout ro_camAnimation "CAMERA ANIMATION" 	width:250
	(
		button settime 			"Set Up Time" 	across:2 	width:150		height:25		align:#left
		spinner spn_frametime	"Time in Seconds"	width:100	height:25		type:#integer	range:[0,10,3]	offset:[0,5] align:#right
		button setupcamera		"Set Up Camera"		width:125	height:25		align:#left		across:2
		button delcamerakeys	"Clear Camera Keys"	width:125	height:25		align:#right
		
		--CAMERA ANIMATION - setTimeRange
		fn setframetime endframe=
		(
			-- Set up camera and scene for animations
			
-- 			endframe = (spn_frametime.value * 24)
			
			animationRange = interval 0 (endframe*24) -- set range
			frameRate = 24 -- set filmic frame rate
			realTimePlayback = true -- ensure realtime playback
			timeConfiguration.playbackSpeed = 3 -- play at 1x speed
			timeDisplayMode = #Frames -- set time display to smtpe
			renderWidth=1920 -- set width
			rendImageAspectRatio = 1.77778 -- set ratio
			rendLockImageAspectRatio = true -- lock ratio
			
			renderSceneDialog.update()
		)
		
		fn setcameraup =
		(
			if getActiveCamera() == undefined then
				(Messagebox "Please go into a camera view")
			
			else
			(
				ac = getactivecamera()
				ac.shutterSpeed = 50 -- set shutter speed to 1/50
				ac.mblurDuration = 0.48  -- set shutter speed to 1/50
				ac.shutterAngle = 172.8 -- set shutter speed to 1/50
				ac.enableCameraMb = on -- enable camera motion blur
				ac.enableGeometryMb = on -- enable geometry motion blur
				ac.shutterParam = 0 -- set to shutter speed mode
				
				ac.enableClipping = on
				ac.showClipRange = on
				ac.clippingNear = 100
			
				select (getNodeByName ac.name) -- select the active camera
			)
		)
		
		on settime pressed do
		(
			setframetime (spn_frametime.value)
			
		)
		
		on setupcamera pressed do
		(
			setcameraup ()
		)
		
		on delcamerakeys pressed do
		(
			if getActiveCamera() == undefined then
				(Messagebox "Please go into a camera view")
			
			else
			(
				ac = getactivecamera()
				select (getNodeByName ac.name)
				
				for i in selection do
				(deletekeys i #allkeys)
			)
		)
	)
	
	rollout ro_cameralister "CAMERAS" width:275
	(
		timer refreshclock "refreshrate" interval:10000 --tick once every 10seconds
		
		button loadCam 		"Refresh List"			width:275	height:15
		
		--Create the dotNet listview control
		dotNetControl theLv "system.windows.forms.listView" height: 225   /* width:550 align:#left offset: [-12,0] */
		
		group "Rename Current Camera" 
		(
			edittext et_cam		""		across:1	width:275	align:#center
		)
				
-- 		button	btn_LckCAM		"Lock"						width:100 	height:20	across:2	
-- 		button	btn_UlckCAM		"Unlock"					width:100 	height:20
-- 		button	btn_dropcam		"Drop"						width:65	height:25	tooltip: "Move camera to eye level off of a selected surface"	enabled: false
		
		group "Camera Notes:"
		(
			edittext et_camnote		""						width:275	height:1	align:#center bold:true
			label 	camnotes		""						width:25	height:15	align:#center offset:[0,15] 
		)
		
		button newCam			"Create New Camera"					width:275	height:20
		tooltip: "Create a new camera from the current camera"
		
		group "SAVE"
		(
			checkbutton chk_arsave "Aspect Ratio"		across:4	checked:true
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\2018\open_edge_extrude.png" iconsize:[15,15]
			tooltip:"Save camera Aspect Ratio"
			
			checkbutton chk_lisave "Lights"							checked:true
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\Vray\vray_l_sphere.png" iconsize:[15,15]
			tooltip:"Store current Light setup - works with CoronaSun and Daylight Systems only"
			
			checkbutton chk_tmsave "Tonemap"						checked:false
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\2014_ico\import_file - 16.png" iconsize:[15,15]
			tooltip:"Save Tonemap settings to camera"
			
			checkbutton chk_lmsave	"Lightmix"						checked:false
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\Layers\isolateSelLayer.png" iconsize:[15,15]
			tooltip:"Save Lightmix settings to camera"
		)
		
		group "RESTORE"
		(
			checkbutton chk_arauto "Aspect Ratio"		across:4	checked:true
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\2018\open_edge_extrude.png" iconsize:[15,15]
			tooltip:"Save camera Aspect Ratio"
			
			checkbutton chk_liauto "Lights"							checked:true
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\Vray\vray_l_sphere.png" iconsize:[15,15]
			tooltip:"Store current Light setup - works with CoronaSun and Daylight Systems only"
			
			checkbutton chk_tmauto "Tonemap"						checked:false
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\2014_ico\import_file - 16.png" iconsize:[15,15]
			tooltip:"Save Tonemap settings to camera"
			
			checkbutton chk_lmauto	"Lightmix"						checked:false
-- 			iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\Layers\isolateSelLayer.png" iconsize:[15,15]
			tooltip:"Save Lightmix settings to camera"
			
			checkbutton chb_anirange "Animation Range"				checked:false
			tooltip:"Restore animation keyframe range"
			align:#left
			offset:[-3,0]
			
		)
		
		button saveCam 			"SAVE CAMERA SETTINGS"	width:265	height:25	across:2 align:#left	
-- 		offset:[50,2.5]
		tooltip:"Save settings to camera"
		
		button flushCam			"REMOVE CAM SETTINGS"	width:30	height:25	align:#right		
		offset:[10,0]
		iconname:@"\\server\assets\ASSETS DEPLOYMENT\3dsmaxRemoteScripts\Icons\2018\resetXform.png" iconsize:[15,15]
		tooltip:"Remove all embedded camera settings"
		
		
		group "Options"
		(
			label 	spn_ar			""								width:200	height:25		align: #center	offset:[40,-8]
			spinner spn_w 			"Width px:"			across:2	width:100	height:25		type:#integer	align:#center		range:[0,10000,1500]	offset:[0,-7]
			spinner spn_h			"Height px:"					width:100	height:25		type:#integer						range:[0,10000,1500]	offset:[0,-7]

			radiobuttons pxtype		labels:#("1500px", "3500px", "5000px")						align:#center	offset:[0,-5]
			
			checkbox chk_ani 		"ANIMATIONS" checked:false									align:#center	offset:[-5,5]
			radiobuttons pxtypeani	labels:#("1080px", "720px", "270px")						align:#center	enabled:false
			

-- 			button saveRatio		"SAVE AR"	 across:3			width:70	height:25		offset:[0,5]
-- 			button storeLights		"SAVE LIGHT"					width:70	height:25		offset:[3,5]
-- 			button makeLayers		"CAM LAYER"						width:70	height:25		offset:[5,5]
			
-- 			checkbox chk_auto		"--RESTORE LIGHTS--" 	across:2	offset:[10,5] checked:false
-- 			checkbox chk_layer		"--RESTORE LAYERS--"				offset:[10,5] checked:false
			
		)
		
		group "Advanced"
		(
			spinner spn_FL 			"Focal Length:"			width:125	height:25		type:#integer		align:#left		range:[0,100,0]		offset:[0,0]		across:2
			spinner spn_EV 			"Exposure:"				width:125	height:25		type:#float		align:#left		range:[0,20,0]		offset:[0,0]
			
			spinner spn_HS 			"H Shift:"			width:125	height:25		type:#float		align:#left			range:[-100,100,0]		offset:[0,-5]			across:2
			spinner spn_VS 			"V Shift:"			width:125	height:25		type:#float		align:#right		range:[-100,100,0]		offset:[0,-5]
			
-- 			label lbl_clip			"Clipping:" 	align:#left
			
			checkbox ClipPln		"Clip" 		align:#left	offset:[0,2] checked:false	across:3
			spinner spn_clpnear 	"Near:"			width:100	height:25		type:#worldunits 		align:#left		range:[0,10000,0]		offset:[-25,3]
			spinner spn_clpfar 		"Far:"			width:100	height:25		type:#worldunits 		align:#left		range:[0,1000000,0]		offset:[0,3]
		)
		
	-- 	button resetlv "reset"
		
-- 		button btn_helpme		"!HELP"	 					align:#right						width:50
		
		
	-- /////////////////// FUNCTIONS ////////////////////////////////////
		
		fn saveARvalue =
		(
			if getActiveCamera() == undefined then
				(Messagebox "Please go into a camera view")
			else
				(
					ViewCam = getActiveCamera()
					AR = GetRendImageAspect()
					setUserProp ViewCam "AR" AR
				)	
		)
		
		fn getARvalue Imagepx =
		(
			AspectRatio = (getUserProp $ "AR")
					
			if AspectRatio == undefined then 
				()
			else
				(
					if AspectRatio >= 1 then 
					(
						renderheight = (RenderWidth = Imagepx)/(AspectRatio as float)
						(
							renderSceneDialog.update()
						)
						
					)
					
					if AspectRatio < 1 then
					(
						renderwidth = (RenderHeight = Imagepx)/(1/(AspectRatio as float))
						renderSceneDialog.update()
					)
				)
		)
		
		fn updatespinner =
		(
			spn_h.value = renderheight
			spn_w.value = renderwidth
			
			spn_ar.text = ("IMAGE ASPECT: " + (GetRendImageAspect() as string))
		)
		
		fn deleteUserProperties =
		(
			if getActiveCamera() == undefined then
									(
										(Messagebox "Please go into a camera view")
									)
								else
									(
										actionMan.executeAction 0 "40247"
										setUserPropBuffer $ ""
									)
		)
		
		fn savecurrentselection =
		(
			getcurrentselection
			SaveCurSel = selection as array
			selectionsets ["SaveCurSel"] = SaveCurSel
		)
		
		--Innitialize the listview control with the columns names and width and options.
		fn initLv=
		(
			local sortOrder = dotNetClass "System.Windows.Forms.SortOrder"
			
			--Setup the forms view
			theLv.view=(dotNetClass "system.windows.forms.view").details
			
			--Interface settings
			
			theLv.FullRowSelect=true							--Set so full width of listView is selected and not just first column.
			theLv.GridLines=false								--Show lines between the items. 
			theLv.MultiSelect=false								--Allow for multiple selections. 
-- 			thelv.autosize = true
-- 			thelv.AllowColumnReorder = false
			
			--Add columns and sort them
			
			theLv.columns.add "CAMERA" 135						--Add each new column to the listview control. 
			
			theLv.columns.add "L" 35
			theLv.columns.add "AR" 65							--Add each new column to the listview control. 
-- 			theLv.columns.add "EV" 30							--Add each new column to the listview control. 
			theLv.columns.add "LENS" 50
			
			
			theLv.Sorting = sortOrder.Ascending					--Sets the sorting for listview control. "sortOrder" defined as a local var above.
			
			-- Colors
			
			thelv.backColor = thelv.backcolor.fromargb 90 90 90
			thelv.foreColor = thelv.forecolor.fromargb 255 255 255
			
-- 			thelv.borderstyle = thelv.borderstyle.None
						
		)

		--Adds rows of data to the listView
		fn populateList =
		(
			rows=#()						--Empty array to collect rows of data
			
			camsort=#()					--Empty array to sort camera names
			
			for cam in cameras do		--Loop through all the objects in the scene.
			(
				local orangeColor = (dotNetClass "System.Drawing.Color").fromARGB 255 180 50
				local blueColor = (dotNetClass "System.Drawing.Color").fromARGB 74 148 208
				local greenColor = (dotNetClass "System.Drawing.Color").fromARGB 166 218 115
				local blackColor = (dotNetClass "System.Drawing.Color").fromARGB 25 25 25
				
				if ((findstring cam.name ".Target")==undefined) then 
				
				(
					append camsort cam.name
					sort camsort
					
-- 					ADD CAMERA NAME
					li=dotNetObject "System.Windows.Forms.ListViewItem" cam.name
					
-- 					CHANGE COLOR
		
					case (ClassOf cam) of
					(
						CoronaCam: li.forecolor = orangeColor
						Physical: li.forecolor = blueColor
					)
					
					
-- 					ADD WHAT TYPE OF LIGHT IS SAVED
					(
						(
							if (getUserProp cam ("SunNode")) != undefined then
								(li.subitems.add ("SUN"))
									else
									(
										if (getUserProp cam ("HDRI")) != undefined then
											(li.subitems.add ("HDRI"))
											else
												(
													if (getUserProp cam ("DLS")) != undefined then
														(li.subitems.add ("DLS"))
															else
															(li.subitems.add (""))
												)
									)
						)
						
					)
					
-- 					ADD AR VALUE
					if ((getUserProp cam "AR")==undefined) then
						li.subitems.add ("")	
					else
						li.subitems.add ((getUserProp cam "AR") as string )
					
-- 					Add camera data	
					if( (classof cam)==Physical) then
					(
-- 						li.subitems.add ((cam.exposure_value) as string)
						li.subitems.add ((cam.focal_length_mm)as string)
					)
					
					if( (classof cam)==CoronaCam) then
					(
-- 						li.subitems.add ((cam.simpleExposure) as string)						
						li.subitems.add ((cam.focalLength)as string)
					)
					
					if( (classof cam)==Targetcamera) then
					(
-- 						li.subitems.add (("") as string)						
						li.subitems.add ((cam.fov)as string)
					) 
					
					if( (classof cam)==Freecamera) then
					(
-- 						li.subitems.add (("") as string)						
						li.subitems.add ((cam.fov)as string)
					) 
					
					append rows li																		--Added the listViewItem to the rows array
				)
				
			)
			
			(theLv.items.addRange rows)													--Add the array of rows to the listView control. 
		)
		
		fn find_intersection z_node node_to_z =
		(
			local testRay = ray node_to_z.pos [0,0,-1]
			local nodeMaxZ = z_node.max.z
			testRay.pos.z = nodeMaxZ + 0.0001 * abs nodeMaxZ
			intersectRay z_node testRay
		)
		
		
		--CAMERA LIGHT SAVE AND RESTORE FUNCTIONS--
		fn ClearCameraLights =
		(
			if getActiveCamera() == undefined then
									(
										(Messagebox "Please go into a camera view")
									)
								else
									(
										actionMan.executeAction 0 "40247"
-- 										setUserPropBuffer $ ""
										setUserProp $ ("SunNode")""
										setUserProp $ ("DLS")""

									)
		)

		fn Savelights =
		(
			if getActiveCamera() == undefined then
									(
										(Messagebox "Please go into a camera view")
									)
									
								else
									(
										for i in lights do
										
										(
											case (classof i) of
											(
												VRaySun: 
													(
														ChkforDayLight = (for i in lights where ((classOf i.parent == DaylightAssemblyHead) and (i.enabled == true)) collect i)

														if ChkforDayLight.count == 0 then
														(
															if i.enabled == true then
															(
																--SET SUN VARIABLES
																Sno = i.inode.handle
																Sn = i.name
																Sx = i.pos.x
																Sy = i.pos.y
																Sz = i.pos.z
																Sv = i.enabled
																Ssize = i.size_multiplier
																Sinten = i.intensity_multiplier
																Svalue = (((i.inode.handle) as integer) as string)
																
																--SELECT CAMERA
																actionMan.executeAction 0 "40247"
																cam = #($)
																
																--SET SUN PROPERTIES INTO THE CAMERA
																setUserProp cam ("SunNode") (Sno as string + "," + Sx as string + "," + Sy as string + "," + Sz as string + "," + Sv as string + "," + Ssize as string + "," + Sinten as string)
																
																--PRINT TEST
																print ((Sn as string) + " information is saved!")
															)
														)
														else()
														
														if ChkforDaylight.count != 0 then
														(
															MyDLS = (for i in ChkforDayLight collect i.parent)
															
															fn TimeFromSolarTime dlSystem =
															(
																dlSystem.controller.solar_time.controller.value
															)
															
															fn DateFromSolarSystem dlSystem =
															(
																dlSystem.controller.solar_date.controller.value
															)
															
															--SET SUN VARIABLES
															Sno = i.inode.handle
															Shours = TimeFromSolarTime MyDLS[1]
															Sdate = DateFromSolarSystem MyDLS[1]
															
															Sv = i.enabled
															Ssize = i.size_multiplier
															Sinten = i.intensity_multiplier
															
															
															--SELECT CAMERA
															actionMan.executeAction 0 "40247"
															cam = #($)
															
															--SET SUN PROPERTIES INTO THE CAMERA
															setUserProp cam ("DLS") (Sno as string + "," + Shours as string + "," + Sdate as string + "," + Sv as string + "," + Ssize as string + "," + Sinten as string)
															
															--PRINT TEST
															print ((Sn as string) + " information is saved!")
																
														)
														else()
														
													)
													
												VRayLight:
													(
														if i.type == 1 and i.on == true do
														(
															--SET DOME VARIABLES
															Dno = i.inode.handle
															Dn = i.name
															Di = i.invisible
															Dv = i.on
															Drotz = i.rotation.z_rotation
															
															--SELECT CAMERA
															actionMan.executeAction 0 "40247"
															cam = #($)
															
															--SET DOME PROPERTIES INTO THE CAMERA
															setUserProp cam ("HDRI ") (Dno as string + "," + Di as string + "," + Dv as string + "," + Drotz as string)													
															
															--PRINT TEST
															print ((Dn as string) + " information is saved!")
															
														)
													)
												
												CoronaSun:
													(
														ChkforDayLight = (for i in lights where ((classOf i.parent == DaylightAssemblyHead) and (i.on == true)) collect i)

														print ChkforDayLight.count
														
														if ChkforDayLight.count == 0 then
														(
															if i.on == true then
															(
																--SET SUN VARIABLES
																Sno = i.inode.handle
																Sn = i.name
																Sx = i.pos.x
																Sy = i.pos.y
																Sz = i.pos.z
																Sv = i.on
																Ssize = i.sizeMultiplier
																Sinten = i.intensity
																
																Svd = i.visibleDirectly
																Svrfl = i.visibleRefl
																Svrf = i.visibleRefr
																
																Svalue = (((i.inode.handle) as integer) as string)
																
																--SELECT CAMERA
																actionMan.executeAction 0 "40247"
																cam = #($)
																
																--SET SUN PROPERTIES INTO THE CAMERA
																setUserProp cam ("SunNode") (Sno as string + "," + Sx as string + "," + Sy as string + "," + Sz as string + "," + Sv as string + "," + Ssize as string + "," + Sinten as string + "," + Svd as string + "," + Svrfl as string + "," + Svrf as string)
																
																--PRINT TEST
																print ((Sn as string) + " information is saved!")
															)
														)
-- 														
														else()
														
														if ChkforDaylight.count != 0 then
														(
															MyDLS = (for i in ChkforDayLight collect i.parent)
															
															fn TimeFromSolarTime dlSystem =
															(
																dlSystem.controller.solar_time.controller.value
															)
															
															fn DateFromSolarSystem dlSystem =
															(
																dlSystem.controller.solar_date.controller.value
															)
															
															--SET SUN VARIABLES
															Sno = i.inode.handle
															Shours = TimeFromSolarTime MyDLS[1]
															Sdate = DateFromSolarSystem MyDLS[1]
															
															Sv = i.on
															Ssize = i.sizeMultiplier
															Sinten = i.intensity
															
															
															--SELECT CAMERA
															actionMan.executeAction 0 "40247"
															cam = #($)
															
															--SET SUN PROPERTIES INTO THE CAMERA
															setUserProp cam ("DLS") (Sno as string + "," + Shours as string + "," + Sdate as string + "," + Sv as string + "," + Ssize as string + "," + Sinten as string)
															
															--PRINT TEST
															print ((Sn as string) + " information is saved!")
																
														)
														
														else()
														
													)
											)
										)
									)
		)
	
		fn RestoreLightsforCamera =
		(
			if getActiveCamera() == undefined then
									(
										(Messagebox "Please go into a camera view")
									)
									
								else
									(
										undo off
										
										for i in lights do
										(
											--TURN OFF ALL THE LIGHTS
											
											case (classof i) of
											(
												VraySun:
												(
													i.enabled = false
												)
												
												VrayLight:
												(
													if i.type == 1 do
													(
														i.on = false
													)
												)
												
												CoronaSun:
												(
													i.on = false
												)
											)
										)
										
										for i in lights do
										(
											--TURN ON LIGHTS BASED OFF THE CAMERA PROPERTIES
											case (classof i) of
											(
												VraySun:
												(
													--SELECT CAMERA
													actionMan.executeAction 0 "40247"
													
													--GET ARRAY FROM CAMERA AND SPLIT IT:
													DLSArray = (getUserProp $ ("DLS"))
													SunArray = (getUserProp $ ("SunNode"))
														
													--CHECK TO SEE IF A DAYLIGHT SYSTEM EXISTS IN THE CAMERA PROPERTIES / IF NOT THEN DO A SUN CHECK...
													if DLSArray == undefined then
													(
														if SunArray == undefined then
															()
															else
															(
																SunArrayFilter = filterString SunArray ","
																
																SunNodeID  = (maxOps.getNodeByHandle (SunArrayFilter[1] as integer))
																									
																--RESTORE SUN COORDINATES
																if SunNodeID == undefined then
																(
																	print "This light no longer exists!"
																)
															
																else
														
																(
																	select SunNodeID
																	
																	for i in selection do 
																	(
																		--RESET COORDINATES
																		i.pos.x = (SunArrayFilter[2] as integer)
																		i.pos.y = (SunArrayFilter[3] as integer)
																		i.pos.z = (SunArrayFilter[4] as integer)
																		
																		--ON/OFF
																		if ((SunArrayFilter[5]) as string) == "true" then
																			(
																				i.enabled = true
																			)
																			else
																			()
																			
																		--SUN SETTINGS
																		i.intensity_multiplier = (SunArrayFilter[7] as float)
																		i.size_multiplier = (SunArrayFilter[6] as float)
																	)
																)
															)
													)
													else
													(
														DLSArrayFilter = filterString DLSArray ","
														DLSNodeID = (maxOps.getNodeByHandle (DLSArrayFilter[1] as integer))
														
														if DLSNodeID == undefined then
														(
															print "This Daylight System no longer exists!"
														)
														
														else
														
														(
															select DLSNodeID
															
															for i in selection do
															(
																--SUN SETTINGS
																for i in selection where classof i == VraySun do
																(
																	i.intensity_multiplier = (DLSArrayFilter[6] as integer)
																	i.size_multiplier = (DLSArrayFilter[5] as integer)
																)
																
																(
																	if ((DLSArrayFilter[4]) as string) == "true" then
																	(
																		i.enabled = true
																	)
																	else
																	()
																)
															)
															
															deselect DLSNodeID
															
															--RESET TIME AND DATE
															(
																ChkforDayLight = (for i in lights where ((classOf i.parent == DaylightAssemblyHead) and (i.enabled == true)) collect i)
																
																select ChkforDayLight
																	
																RestoreDLS = (for i in ChkforDayLight collect i.parent)
																
																RestoreDLS[1].controller.solar_time.controller.value = (DLSArrayFilter[2] as float)
																RestoreDLS[1].controller.solar_date.controller.value = (DLSArrayFilter[3] as float)
															)
														)
													)
												)
												
												VRayLight:
												(
													if i.type == 1 then
													(
														--SELECT CAMERA
														actionMan.executeAction 0 "40247"
	-- 													sel = #($)
														
														--GET ARRAY FROM CAMERA AND SPLIT IT:
														DomeArray = (getUserProp $ ("HDRI"))
														
														if DomeArray == undefined then
														()
														else
														(
															DomeArrayFilter = filterString DomeArray ","
														
															DomeNodeID  = (maxOps.getNodeByHandle (DomeArrayFilter[1] as integer))
																
															--RESTORE DOME ROTATION + VISIBILITY
															if DomeNodeID == undefined then
															(
																print "This light no longer exists!"
															)
															
															else
															
															(
																select DomeNodeID
															
																for i in selection do 
																(
																	--RESET COORDINATES
																	i.rotation.z_rotation = (DomeArrayFilter[4] as integer)
																	
																	--RESET VISIBILITY
																	if ((DomeArrayFilter[2]) as string) == "true" then
																		(
																			i.invisible = on
																		)
																		else
																		(
																			i.invisible = off
																		)
																		
																	--RESET ON
																	if ((DomeArrayFilter[3]) as string) == "true" then
																		(
																			i.on = on
																		)
																		else
																		(
																			i.on = off
																		)
																)
															)
														)	
													)
													else
													()
												)
												
												CoronaSun:
												(
													--SELECT CAMERA
													actionMan.executeAction 0 "40247"
													
													--GET ARRAY FROM CAMERA AND SPLIT IT:
													DLSArray = (getUserProp $ ("DLS"))
													SunArray = (getUserProp $ ("SunNode"))
														
													--CHECK TO SEE IF A DAYLIGHT SYSTEM EXISTS IN THE CAMERA PROPERTIES / IF NOT THEN DO A SUN CHECK...
													if DLSArray == undefined then
													(
														if SunArray == undefined then
															()
															else
															(
																SunArrayFilter = filterString SunArray ","
																
																SunNodeID  = (maxOps.getNodeByHandle (SunArrayFilter[1] as integer))
																									
																--RESTORE SUN COORDINATES
																if SunNodeID == undefined then
																(
																	print "This light no longer exists!"
																)
															
																else
														
																(
																	select SunNodeID
																	
																	for i in selection do 
																	(
																		--RESET COORDINATES
																		i.pos.x = (SunArrayFilter[2] as integer)
																		i.pos.y = (SunArrayFilter[3] as integer)
																		i.pos.z = (SunArrayFilter[4] as integer)
																		
																		--ON/OFF
																		if ((SunArrayFilter[5]) as string) == "true" then
																			(
																				i.on = true
																			)
																			else
																			()
																			
																		--SUN SETTINGS
																		i.intensity = (SunArrayFilter[7] as float)
																		i.sizeMultiplier = (SunArrayFilter[6] as float)
																			
																		--SUN PARAMETERS
																		if ((SunArrayFilter[8]) as string) == "true" then
																			(
																				i.visibleDirectly = true
																			)
																			else
																			(
																				i.visibleDirectly = false
																			)
																		
																		if ((SunArrayFilter[9]) as string) == "true" then
																			(
																				i.visibleRefl = true
																			)
																			else
																			(
																				i.visibleRefl = false
																			)
																			
																		if ((SunArrayFilter[10]) as string) == "true" then
																			(
																				i.visibleRefr = true
																			)
																			else
																			(
																				i.visibleRefr = false
																			)
																			
																			
																	)
																)
															)
													)
													else
													(
														DLSArrayFilter = filterString DLSArray ","
														DLSNodeID = (maxOps.getNodeByHandle (DLSArrayFilter[1] as integer))
														
														if DLSNodeID == undefined then
														(
															print "This Daylight System no longer exists!"
														)
														
														else
														
														(
															select DLSNodeID
															
															for i in selection do
															(
																--SUN SETTINGS
																for i in selection where classof i == CoronaSun do
																(
																	i.intensity = (DLSArrayFilter[6] as float)
																	i.sizeMultiplier = (DLSArrayFilter[5] as integer)
																)
															)
															
															--TURN ON THE SUN BECAUSE 3DSMAX IS BEING AN ASSHOLE
															(
																FindDayLightOff = (for i in lights where ((classof i.parent == DaylightAssemblyHead) and (i.on == false)) collect i)
																
																for i in FindDayLightOff do (i.on = true)
															)
															
															deselect DLSNodeID
															
															--RESET TIME AND DATE
															(
																ChkforDayLight = (for i in lights where ((classOf i.parent == DaylightAssemblyHead) and (i.on == true)) collect i)
																
																select ChkforDayLight
																	
																RestoreDLS = (for i in ChkforDayLight collect i.parent)
																
																RestoreDLS[1].controller.solar_time.controller.value = (DLSArrayFilter[2] as float)
																RestoreDLS[1].controller.solar_date.controller.value = (DLSArrayFilter[3] as float)
															)
														)
													)
												)
											)
										)
										
											
									)
		)
		
		--CAMERA ADD / READ NOTES --
		fn CamAddNote =
		(
			if getActiveCamera() == undefined then
				(Messagebox "Please go into a camera view")
			else
				(
					
					note = et_camnote.text
					ViewCam = getActiveCamera()
					
					setUserProp ViewCam "CamNote" note
				)
		)
		
		fn CamReadNote cam =
		(
			NotesX = (getUserProp cam "CamNote")
			
			if NotesX == undefined then 
				(camnotes.text = "")
			else
			(
				camnotes.text = (NotesX as string)
			)
			
		)
		
		fn GetCameraSettings cam =
		(
-- 			cam = getActiveCamera()
			if cam == undefined then
			()
			else
			(
				if classof cam == Physical then
				(
					spn_FL.value = cam.focal_length_mm
-- 					spn_EV.value = cam.exposure_value
					spn_HS.value = cam.horizontal_shift
					spn_VS.value = cam.vertical_shift
					
					ClipPln.checked = cam.clip_on
					spn_clpnear.value = cam.clip_near
					spn_clpfar.value = cam.clip_far
				)
				else
				()
				
				if classof cam == CoronaCam then
				(
					spn_FL.value = cam.focalLength
-- 					spn_EV.value = cam.simpleExposure
					spn_HS.value = cam.horizontalShift
					spn_VS.value = cam.verticalShift
					
					ClipPln.checked = cam.enableClipping
					spn_clpnear.value = cam.clippingNear
					spn_clpfar.value = cam.clippingFar
				)
				else
				()
			)
		)
		
		--CAMERA ADD TOGGLE LAYERS PER CAMERA IN SCENE
		fn createCamLayer =
		(
			ViewCam = getActiveCamera()
			
			if ViewCam == undefined then
				(Messagebox "Please go into a camera view")
			else
				(
					if ((findstring ViewCam.name ".Target")==undefined) then
					(
						CamLayer = LayerManager.newLayerFromName ("!camtoggle!_" + ViewCam.name)
					)
					else
					()
				
					for i = 0 to layerManager.count-1 do
					(
						ilayer = layerManager.getLayer i
						layerName = ilayer.name
						
						if ((findstring layerName "!camtoggle!_") != undefined) then
						(
							iLayer.on = false
						)
					)
				)
		)
		
		fn restoreCamLayer = 
		(
			ViewCam = getActiveCamera()
			print viewcam.name
			
			for i = 0 to layerManager.count-1 do
			(
				ilayer = layerManager.getLayer i
				layerName = ilayer.name
				
				if ((findstring layerName "!camtoggle!_") != undefined) then
				(
					iLayer.on = false
				)
			)
			
			CamLayer = LayerManager.getLayerFromName ("!camtoggle!_" + viewcam.name)
			CamLayer.on = true
		)
		
		
		--CAMERA BAKE TM + LIGHTMIX
		fn bakevfb_tm =
		(
			cr = renderers.current
			
			-- [TONE MAPPING SETTINGS]
			(
				CMon = cr.colorMap_enabled
				CMex = cr.colorMap_simpleExposure
				CMhc = cr.colorMap_highlightCompression
				CMtp = cr.colorMap_colorTemp
				CMti = cr.colorMap_greenMagentaTint
				CMcc = cr.colorMap_contrast
				CMsa = cr.colorMap_saturation
				CMfh = cr.colorMap_filmic_highlightCompression
				CMfs = cr.colorMap_filmic_richShadows
				CMct = cr.colorMap_tint
				CMvi = cr.vignette_intensity
				CMcv = cr.curves_enable
				CMcf = cr.curves_master_nodes

				tonemap = 
					(
						CMon as string + "," + 
						CMex as string + "," + 
						CMhc as string + "," + 
						CMtp as string + "," + 
						CMti as string + "," + 
						CMcc as string + "," + 
						CMsa as string + "," + 
						CMfh as string + "," + 
						CMfs as string + "," + 
						CMct as string + "," +
						CMvi as string + "," +
						CMcv as string
					)
					
					--[CURVE NODE SETTINGS]
					
				curves = 
					(
						CMcf as string
					)
			)
			
			
			-- [LUT SETTINGS]
			(
				LTp = cr.colorMap_lut_path
				LTe = cr.colorMap_lut_enable
				LTo = cr.colorMap_lut_opacity
				-- cr.colorMap_lut_convertToLog

				lut = 
					(
						LTp as string + "," + 
						LTe as string + "," + 
						LTo as string
					)
			)


			-- [BLOOM_GLARE SETTINGS]
			(
				BGe = cr.bloomGlare_enabled
				BGs = cr.bloomGlare_size
				BGb = cr.bloomGlare_bloomIntensity
				BGg = cr.bloomGlare_glareIntensity
				BGt = cr.bloomGlare_threshold
				BGci = cr.bloomGlare_colorIntensity
				BGcs = cr.bloomGlare_colorShift
				BGsc = cr.bloomGlare_streakCount
				BGr = cr.bloomGlare_rotation
				BGsb = cr.bloomGlare_streakBlur

				bloomglare = 
					(
						BGe as string + "," + 
						BGs as string + "," + 
						BGb as string + "," + 
						BGg as string + "," + 
						BGt as string + "," + 
						BGci as string + "," + 
						BGcs as string + "," + 
						BGsc as string + "," + 
						BGr as string + "," + 
						BGsb as string
					)

			)


			-- [SHARPEN/BLUR]
			(
				Se = cr.sharpening_blurring_enable
				Sa = cr.sharpening_amount
				Sr = cr.sharpening_radius
				Br = cr.blurring_radius
	
				sharpenblur =
				(
					Se as string + "," +
					Sa as string + "," + 
					Sr as string + "," + 
					Br as string
				)
			)
			
			--SELECT CAMERA

			actionMan.executeAction 0 "40247"
			cam = #($)

			-- BAKING TONEMAP AND LIGHTMIX SETTINGS

			setUserProp cam ("TM") tonemap
			setUserProp cam ("CRV") curves
			setUserProp cam ("LUT") lut
			setUserProp cam ("BG") bloomglare
			setUserProp cam ("SB") sharpenblur
		)
		
		fn bakevfb_lm =
		(
			cr = renderers.current
			
			-- [LIGHTMIX STUFF]
			(
				-- cr.colormap_lightmix_elementNames
				LMe = cr.colorMap_lightmixEnabledLayers
				LMi = cr.colorMap_lightmixIntensities
				LMc = cr.colorMap_lightmixColors
			)
			
			--SELECT CAMERA

			actionMan.executeAction 0 "40247"
			cam = #($)
			
			-- BAKING TONEMAP AND LIGHTMIX SETTINGS
			setUserProp cam ("LMe") LMe
			setUserProp cam ("LMi") LMi
			setUserProp cam ("LMc") LMc
		)
		
		fn restorevfb_tm = 
		(
			cr = renderers.current
			
			-- 	RESTORE TONEMAPPING
			(	
				TMA = (getUserProp $ ("TM"))
				tmaF = filterString TMA ","
				
				colormaptint = filterstring tmaF[10] "() color"
				
						
				cr.colorMap_enabled 						= if tmaF[1] == "true" then true else false 
				cr.colorMap_simpleExposure 					= tmaF[2] as float
				cr.colorMap_highlightCompression			= tmaF[3] as float
				cr.colorMap_colorTemp						= tmaF[4] as float
				cr.colorMap_greenMagentaTint				= tmaF[5] as float
				cr.colorMap_contrast						= tmaF[6] as float
				cr.colorMap_saturation						= tmaF[7] as float
				cr.colorMap_filmic_highlightCompression		= tmaF[8] as float
				cr.colorMap_filmic_richShadows				= tmaF[9] as float
				cr.colorMap_tint							= color (colormaptint[1] as integer) (colormaptint[2] as integer) (colormaptint[3] as integer)
				cr.vignette_intensity						= tmaF[11] as float
				cr.curves_enable							= if tmaF[12] == "true" then true else false
			)

			-- 	RESTORE LUT
			(
				LTA = (getUserProp $ ("LUT"))
				ltaF = filterString LTA ","
					
				cr.colorMap_lut_path 	= ltaF[1]
				cr.colorMap_lut_enable	= if ltaF[2] == "true" then true else false
				cr.colorMap_lut_opacity = ltaF[3] as float
			)

			-- 	RESTORE BG
			(
				BGA = (getUserProp $ ("BG"))
				bgaF = filterstring BGA ","
					
				cr.bloomGlare_enabled 			= if bgaF[1] == "true" then true else false
				cr.bloomGlare_size				= bgaF[2] as float
				cr.bloomGlare_bloomIntensity	= bgaF[3] as float
				cr.bloomGlare_glareIntensity	= bgaF[4] as float
				cr.bloomGlare_threshold			= bgaF[5] as float
				cr.bloomGlare_colorIntensity	= bgaF[6] as float
				cr.bloomGlare_colorShift		= bgaF[7] as float
				cr.bloomGlare_streakCount		= bgaF[8] as float
				cr.bloomGlare_rotation			= bgaF[9] as float
				cr.bloomGlare_streakBlur		= bgaF[10] as float
			)

			-- 	RESTORE SHARPENBLUR
			(
				SBA = (getUserProp $ ("SB"))
				sbaF = filterstring SBA "," 
				
				cr.sharpening_blurring_enable 	= if sbaF[1] == "true" then true else false
				cr.sharpening_amount			= sbaF[2] as float
				cr.sharpening_radius			= sbaF[3] as float
				cr.blurring_radius				= sbaF[4] as float
			)
			
			--	RESTORE CURVE NODES
			(
				TMC = (getUserProp $ ("CRV"))
				tmcF1 = execute TMC
				
				tmcFix = #()
				
				for i = 1 to tmcF1.count do
				(
					append tmcFix (tmcF1[i])
-- 					print tmcFix
				)
				
				cr.curves_master_nodes = tmcFix
			)
		)
		
		fn restorevfb_lm = 
		(
			cr = renderers.current
			
			-- RESTORE LIGHTMIX

			(
			-- 	RESTORE ON/OFF
				(
					LMA = (getUserProp $ ("LMe"))
					LMAF1 = filterString LMA ", () # "
				
					LMeFix = #()
				
					for i = 1 to LMAF1.count do
					(
						if LMAF1[i] == "true" then
							append LMeFix true
						else
							append LMeFix false
					)

					cr.colorMap_lightmixEnabledLayers = LMeFix
				)
			-- 	RESTORE INTENSITIES
				(
					LMi = (getUserProp $ ("LMi"))
					LMiF1 = filterString LMi ", () # "
				
					LMiFix = #()
					
					for i = 1 to LMiF1.count do
					(
						append LMiFix (LMiF1[i] as float)
					)

					LMiFix
					
					cr.colorMap_lightmixIntensities = LMiFix
				)
			-- 	RESTORE COLORMAPPING
				(
					LMc = (getUserProp $ ("LMc"))
			-- 		LMcF1 = filterString LMc "# ' () "
					LMcF1 = execute LMc
					
					
					LMcFix = #()
						
					for i = 1 to LMcF1.count do
					(
						append LMcFix (LMcF1[i])
					)
					
					cr.colorMap_lightmixColors = LMcFix
				)	
			)
		)
		
		--CAMERA RESTORE ANIMATION_RANGE
		fn getKeyFrames obj = 
		(
			local arrayOfKeys = #()
			local lowestKey = 0
			local highestKey = 1
			local objs = #()

			-- Add the obj to the objs array, and it's target if it has one
			append objs obj
			if obj.target != undefined then append objs obj.target
				
			-- Check all objs associated with the obj (targets, etc)
			for o in objs do (
				-- Position Controller Keys
				if isProperty o #position then (
					if o.position.controller.keys.count > 0 then (
						append arrayOfKeys ((o.position.controller.keys[1].time as integer)/TicksPerFrame)
						append arrayOfKeys ((o.position.controller.keys[o.position.controller.keys.count].time as integer)/TicksPerFrame)
					)
				)
				
				-- Rotation Controller Keys
				if isProperty o #rotation then (
					if o.rotation.controller.keys.count > 0 then (
						append arrayOfKeys ((o.rotation.controller.keys[1].time as integer)/TicksPerFrame)
						append arrayOfKeys ((o.rotation.controller.keys[o.rotation.controller.keys.count].time as integer)/TicksPerFrame)
					)
				)
				
				-- Scale Controller Keys
				if isProperty o #scale then (
					if o.scale.controller.keys.count > 0 then (
						append arrayOfKeys ((o.scale.controller.keys[1].time as integer)/TicksPerFrame)
						append arrayOfKeys ((o.scale.controller.keys[o.scale.controller.keys.count].time as integer)/TicksPerFrame)		
					)
				)
				
				if (classof o.position.controller) == Path_Constraint then (
					if o.position.controller.percent.controller.keys.count > 0 then (
						append arrayOfKeys ((o.position.controller.percent.controller.keys[1].time as integer)/TicksPerFrame)
						append arrayOfKeys ((o.position.controller.percent.controller.keys[o.position.controller.percent.controller.keys.count].time as integer)/TicksPerFrame)
					)
				)
			)	-- end for o in objs
			
			sort arrayOfKeys
			
			if arrayOfKeys.count >= 2 then (
				#(arrayOfKeys[1], arrayOfKeys[arrayOfKeys.count])
			) else (
				#(0,1)
			)
		)
		
	-- /////////////////// EVENT HANDLER ////////////////////////////////////
		
		on loadCam pressed do
		(
			theLv.Clear() 		--Clears the lv
			initLv()			--Reset the lv
			populateList()		--Populates the lv
		)
		
		--DOTNET CONTROL--
		on theLv MouseClick itm do
		(
			hit=(theLv.HitTest (dotNetObject "System.Drawing.Point" itm.x itm.y))
				
				
			
			if ((itm.Button.Equals itm.Button.right) and keyboard.controlPressed) then 	
			(
				select (getnodebyname hit.item.text)
				for i in 0 to theLv.Items.count-1 do 						--We go through all the items from the lv
				theLv.Items.item[i].selected = false
				theLv.Items.item[hit.item.index].selected = true
			)
			
			if ((itm.Button.Equals itm.Button.right) and keyboard.shiftPressed) then
			(
				select (getnodebyname hit.item.text)
				for i in 0 to theLv.Items.count-1 do 						--We go through all the items from the lv
				theLv.Items.item[i].selected = false
				theLv.Items.item[hit.item.index].selected = true
				
				macros.run "Lights and Cameras" "Camera_SelectTarget"
			)
			
			if ((itm.Button.Equals itm.Button.right) and (keyboard.shiftPressed) and keyboard.controlPressed) then
			(
				select (getnodebyname hit.item.text)
				MyCamera = #($)
				
				CamTarget = getnodebyname ($.name + ".Target")
				append MyCamera CamTarget
				select MyCamera
			)
			
			if (itm.Button.Equals itm.Button.left) then
			(
				x = (getnodebyname hit.item.text)
				CamReadNote x
				
				GetCameraSettings x
			)
		)
		
		on theLv MouseDoubleClick itm do
		(
			hit=(theLv.HitTest (dotNetObject "System.Drawing.Point" itm.x itm.y))
			
			if ((itm.Button.Equals itm.Button.left) and keyboard.controlPressed) then
			(
				selectioncount = getCurrentSelection()
				if selectioncount.count != 0 then
				(deselect)
				
				cam = (getnodebyname hit.item.text)
				
				if DLSArray != undefined then
				(
					DLSArray = (getUserProp cam ("DLS"))
				)
-- 				else(print "There is no Daylight System linked to this camera!")
				
				if SunArray != undefined then
				(
					SunArray = (getUserProp cam ("SunNode"))
				)
-- 				else(print "There is no Sun linked to this camera!")
			)
			
			if (itm.Button.Equals itm.Button.left) then 	
			(
				savecurrentselection()
				
				
				viewport.setCamera (getnodebyname hit.item.text)
				select (getnodebyname hit.item.text)
				
				for i in 0 to theLv.Items.count-1 do 						--We go through all the items from the lv
					theLv.Items.item[i].selected = false
					theLv.Items.item[hit.item.index].selected = false

				if chk_ani.state == true then
				(
					if pxtypeani.state == 1 then
					(getARvalue 1920)
					
					if pxtypeani.state == 2 then
					(getARvalue 1280)
					
					if pxtypeani.state == 3 then
					(getARvalue 480)
				)
				
				else
				(
					if pxtype.state == 1 then
					(getARvalue 1500)
			
					if pxtype.state == 2 then
					(getARvalue 3500)
			
					if pxtype.state == 3 then
					(getARvalue 5000)
				)
					
				if chk_liauto.state == true then
				(
					RestoreLightsforCamera()
				)
					else()
				
-- 				if chk_layer.state == true then
-- 				(
-- 					restoreCamLayer()
-- 				)
-- 					else()
				
				if chk_tmauto.state == true then
				(
					restorevfb_tm()
				)
					else()
				
				if chk_lmauto.state == true then
				(
					restorevfb_lm()
				)
					else()
				
				if chb_anirange.state == true then
				(
					cameraList=#()
					cameraSorted=#()

					for cam in selection do
					(
						if ((findString cam.name ".Target" )==undefined) then
						(
							append cameraSorted cam.name
						)
					)

					cameraSorted = sort cameraSorted
					
					for camName in cameraSorted do
						(
							append cameraList camName
							cam = getnodebyname camName
							keyFrames = getKeyFrames cam
							
							animationRange = interval (keyFrames[1] as integer) (keyFrames[2] as integer)
						)
					
				)
				
				updatespinner()
				
				select selectionSets["SaveCurSel"]
			)
			
			if ((itm.Button.Equals itm.Button.left) and keyboard.shiftPressed) then
			(
				viewport.setCamera (getnodebyname hit.item.text)
				select (getnodebyname hit.item.text)
				delete selection
				
				theLv.Clear() 		
				initLv()			
				populateList()
			)
			
			
		)
		
		--BETA OPTIONS--
		
-- 		on btn_tmsave pressed do
-- 		(
-- 			bakevfb_tm()
-- 		)
		
-- 		on btn_lmsave pressed do
-- 		(
-- 			bakevfb_lm()
-- 		)
				
		--CAMERA OPTIONS--
		
		on chk_ani changed state do
		(
			if state == true then
			(
				pxtypeani.enabled = true
				pxtype.enabled = false
			)
			
			else 
			(
				pxtypeani.enabled = false
				pxtype.enabled = true
			)
		)
		
		on newCam pressed do
		(
	 			currentCam= getActiveCamera()
			if(currentCam!=undefined) then
			(
				camNode = #(currentCam)
				maxOps.cloneNodes camNode cloneType:#copy newNodes:&new #nodialog
				
				deleteKeys new #allKeys
	 			viewport.setCamera new[1]
				 
				select (getActiveCamera())
				loadCam.pressed()
				
			)
			else
			messagebox("This will only work if you're viewport is a camera")
			
			loadCam.pressed()
		)
			
-- 		on saveRatio pressed do
-- 		(
-- 			saveARvalue()
-- 			loadCam.pressed()
-- 		)
		
-- 		on storeLights pressed do
-- 		(
-- 			ClearCameraLights()
-- 			Savelights()
-- 			saveARvalue()
-- 			loadCam.pressed()			
-- 		)
		
		on makeLayers pressed do
		(
			createCamLayer()
		)
			
		on btn_LckCAM pressed do
		(

			(
				if getActiveCamera() == undefined then
					(
						(Messagebox "Please go into a camera view")
					)
				else
					(
						actionMan.executeAction 0 "40247"
						sel = #($)
						
						MyCam = (for i in selection where classof i == Physical_Camera collect i)
						setTransformLockFlags mycam #all
						
						MyCamTarget = (for i in cameras where classof i == targetobject collect i)
						setTransformLockFlags MyCamTarget #all
					)
			)
		)
		
		on btn_UlckCAM pressed do
		(

			(
				if getActiveCamera() == undefined then
					(
						(Messagebox "Please go into a camera view")
					)
				else
					(
						actionMan.executeAction 0 "40247"
						sel = #($)
						
						MyCam = (for i in selection where classof i == Physical_Camera collect i)
						setTransformLockFlags mycam #none
						
						MyCamTarget = (for i in cameras where classof i == targetobject collect i)
						setTransformLockFlags MyCamTarget #none
					)
			)
		)
		
		on et_cam entered newcamtxt do
		(
			currentCamera=getActiveCamera()
			
			
			if (currentCamera == undefined) then
			(
				Messagebox "You need to be in a camera view to rename the current camera."
			)
			else
			(
				currentCamera.name = newcamtxt
			)
			
			loadCam.pressed()
			
			et_cam.text = ""
			
		)
		
		on et_camnote entered newnotetxt do
		(
			CamAddNote()
			
			et_camnote.text = ""
			
			theLv.Clear()
			initLv()
			populateList()
		)
		
		on flushCam pressed do
		(
			deleteUserProperties()
		)
		
		on saveCam pressed do
		(
-- 			deleteUserProperties()
			
			a = chk_arsave.checked
			b = chk_lisave.checked
			c = chk_tmsave.checked
			d = chk_lmsave.checked
			
			if a == true then
			(
				saveARvalue()
			)
			else()
			
			if b == true then
			(
-- 				ClearCameraLights()
-- 				deleteUserProperties
				Savelights()
			)
			else()
			
			if c == true then
			(
				bakevfb_tm()
			)
			else()
			
			if d == true then
			(
				bakevfb_lm()
			)
			
			loadcam.pressed()
			
		)
		
		-- ADVANCED OPTIONS--
		
		on spn_FL changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.focal_length_mm = spn_FL.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.focalLength = spn_FL.value
				)
			
				
			theLv.Clear() 		--Clears the lv
			initLv()			--Reset the lv
			populateList()		--Populates the lv
		)
		
		on spn_HS changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.horizontal_shift = spn_HS.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.horizontalshift = spn_HS.value
				)

		)
		
		on spn_VS changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.vertical_shift = spn_VS.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.vertical_shift = spn_VS.value
				)
				
			theLv.Clear() 		--Clears the lv
			initLv()			--Reset the lv
			populateList()		--Populates the lv

		)
		
		on ClipPln changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.clip_on = ClipPln.checked
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.enableClipping = ClipPln.checked
				)
		)
		
		on spn_clpnear changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.clip_near = spn_clpnear.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.clippingNear = spn_clpnear.value
				)
		)
		
		on spn_clpfar changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.clip_far = spn_clpfar.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.clippingFar = spn_clpfar.value
				)
		)
		
		on spn_EV changed state do
		(
			currentCamera=getActiveCamera()
			
			if (currentCamera == undefined) then
			(
				Messagebox "Go into the current camera to quick adjust settings"
			)
			else
			
			if classof currentCamera == Physical then
				(
					currentCamera.exposure_value = spn_EV.value
				)
			else
			()
			
			if classof currentCamera == CoronaCam then
				(
					currentCamera.simpleExposure = spn_EV.value
				)
				
			theLv.Clear() 		--Clears the lv
			initLv()			--Reset the lv
			populateList()		--Populates the lv
		)
		
		--LABELS--
		on btn_helpme pressed do
		(
			messageBox "Double click to enter camera. \n Ctrl + Right Click to select camera. \n Shift + Right Click to select target. \n Drop will move camera to eye level off a floor." beep:true
		)
		
		on spn_h changed state do
		(
			if renderSceneDialog.isOpen() == true then
			(
				renderheight = spn_h.value
				renderSceneDialog.update()
				
				spn_ar.text = ("IMAGE ASPECT: " + (GetRendImageAspect() as string))
			)
			
			else
			
			(
				renderheight = spn_h.value
				renderSceneDialog.update()
				
				spn_ar.text = ("IMAGE ASPECT: " + (GetRendImageAspect() as string))
			)
		)
		
		on spn_w changed state do
		(
			if renderSceneDialog.isOpen() == true then
			(
				renderwidth = spn_w.value
				renderSceneDialog.update()
				
				spn_ar.text = ("IMAGE ASPECT: " + (GetRendImageAspect() as string))
			)
			
			else
			
			(
				renderwidth = spn_w.value
				renderSceneDialog.update()
				
				spn_ar.text = ("IMAGE ASPECT: " + (GetRendImageAspect() as string))
			)
		)

		--ON OPEN--
		on ro_cameralister open do
		(
			initLv()
			populateList()
			
			currentCamera=getActiveCamera()
			
-- 			populate the render width and height
			
			(
				updatespinner()
			)
			
			--Set radiobutton based of renderwidth px
			(
				RAW = getRendApertureWidth()
				print RAW
				
				if RAW == 36.0 then
				(
					chk_ani.state = false
					pxtypeani.enabled = false
					pxtype.enabled = true
					
					if renderwidth == 1500 then
					pxtype.state = 1
					
					if renderwidth == 3500 then
					pxtype.state = 2

					if renderwidth == 5000 then
					pxtype.state = 3

				)
				else
				()
				
				if RAW == 20.120 then
				(
					chk_ani.state = true
					pxtypeani.enabled = true
					pxtype.enabled = false
					
					if renderwidth == 1920 then
					pxtypeani.state = 1
					
					if renderwidth == 1280 then
					pxtypeani.state = 2
					
					if renderwidth == 270 then
					pxtypeani.state = 3
				)
				else
				()
			)
			
			--Set radiobutton based of renderheight px
			(
				if RAW == 36.0 then
				(
					chk_ani.state = false
					pxtypeani.enabled = false
					pxtype.enabled = true
					
					if renderheight == 1500 then
					pxtype.state = 1
					
					if renderheight == 3500 then
					pxtype.state = 2

					if renderheight == 5000 then
					pxtype.state = 3

				)
				else
				()
				
				if RAW == 20.120 then
				(
					chk_ani.state = true
					pxtypeani.enabled = true
					pxtype.enabled = false
					
					if renderheight == 1080 then
					pxtypeani.state = 1
					
					if renderheight == 720 then
					pxtypeani.state = 2
					
					if renderheight == 480 then
					pxtypeani.state = 3
				)
				else
				()
			)
			
			if (currentCamera != undefined) then
			(
				GetCameraSettings currentCamera
			)
			
			else 
			()
			
						
		)
		
		--ON REFRESHRATE--
		on refreshclock tick do
		(
			theLv.Clear() 		--Clears the lv
			initLv()			--Reset the lv
			populateList()		--Populates the lv
		)
		
	)
	
	rollout os_ro "---------   OVERSCAN   ---------" 
	(
		label l1 "Old size:" across:3	offset:[0,4] align:#left
		label startRes "" 				offset:[-50,4]
		
		button resetRes "UPDATE" width:100 height:20 tooltip:"Use current render size as reference"
		
		spinner xres_s "NEW WX: " range:[-10000,10000,1] type:#integer width:125 align:#left across:2
		spinner yres_s "NEW HX: " range:[-10000,10000,1] type:#integer width:125 align:#right
		
-- 		checkbutton relB "Use Relative"  width:100 height:30 tooltip:"Use numbers as relative values added to the current render size"

		checkbox newCamCheck "COPY" checked:false align:#center offset:[0,5] across:2

		button go_b "OVERSCAN" tooltip:"Modify/create camera and adjust render settings to match desired resolution" width:150

		local currentXres, currentYres

		on resetRes pressed do 
		(
-- 			relB.checked = false
			xres_s.value = currentXres = renderWidth
			yres_s.value = currentYres = renderHeight
			startRes.text = ( (currentXres as string) + "x" + (currentYres as string) )  
		)

		on relB changed state do 
		(
			if state then (
				xres_s.value -= currentXres
				yres_s.value -= currentYres
			) else (
				xres_s.value += currentXres
				yres_s.value += currentYres
			)
		)

		on go_b pressed do 
		(
			local cam = getActiveCamera()
			if (cam!=undefined) then (
				undo "Overscan" on (
					renderSceneDialog.close()				-- need to close dialog to make changes stick
					-- if newCam.checked then cam = copy cam	-- create copy of camera
					local newCam
					if newCamCheck.checked then (
						-- create copy of camera
						if not (maxOps.cloneNodes cam newNodes:&newCam) then throw "Overscan: error! cannot copy camera"
						newCam[1].name = (cam.name + "_overscan")
						-- newCam[1].name = (cam.name + "_overscan" + (xres_s.value as string) + "x" + (yres_s.value as string))
						
						cam = newCam[1]
					)
					local xres = xres_s.value
					local yres = yres_s.value
-- 					if relB.checked then (
-- 						xres += currentXres
-- 						yres += currentYres
-- 					)
					
					local aw_h = getRendApertureWidth() * 0.5
					local old_f = aw_h / (tan (cam.fov*0.5))
					local new_f = old_f * (renderWidth/(xres as float))

						if((ClassOf cam)==CoronaCam) then
						(
							--cam.fovSource = 0
							cam.fov = 2 * atan (aw_h / new_f)
						)
						else
						(
							
							cam.specify_fov = true	

							cam.fov = 2 * atan (aw_h / new_f)
							--cam.focal_length_mm = new_f
							cam.specify_fov = false
						)

					
					-- set new render resolution
					renderWidth = xres		-- no undo possible
					renderHeight = yres		-- no undo possible
					viewport.setCamera cam
				)
			) else (
				messageBox "Active viewport is not a camera viewport"
			)
		)
		
		on os_ro open do 
		(
			xres_s.value = currentXres = renderWidth
			yres_s.value = currentYres = renderHeight
			startRes.text = ((currentXres as string)+"x"+(currentYres as string))
		)
	)

	(
--		Destroy dialog if it already exists.
-- 		try(destroyDialog theRollout)catch()
		try ( closeRolloutFloater Camera_Lister ) catch ()
		
		rollout Camera_Lister "Camera Lister V.5.2" width:350
		(	
				subRollout sub_left ""   	width:325 height:825 	align:#left across:1
				subRollout sub_bot ""		width:325 height:110	offset:[0,0]
				
				
				on Camera_Lister open do
				(
					AddSubRollout sub_left ro_camAnimation
					ro_camAnimation.open = true
					
					addsubRollout sub_left ro_imageCompHelper
					ro_imageCompHelper.open = false
					
					addsubRollout sub_left ro_cameralister
					
					addsubRollout sub_bot os_ro
					os_ro.open = true
				)
		)
		
		CreateDialog Camera_Lister style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing) lockwidth:false lockheight:false
		setFocus ro_cameralister.theLv
		
	)
)