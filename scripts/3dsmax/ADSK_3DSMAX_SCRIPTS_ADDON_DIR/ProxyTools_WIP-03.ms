(
-- ##### PREFUNCTIONS  ##### --
	
-- ##### This sets up the files for selection in multilistbox  ##### --
	
		tabXref = #()
	
		fn getXrefsScenes = 
			(
				nbrXref=xrefs.getXRefFileCount()

				for i = 1 to nbrXref do
					(
						bXref = xrefs.getXRefFile i
						tabXref[i] = bXref as string
					)
			return tabXref
			)
		
		tabXref = getXrefsScenes()
		
		
-- ##### PREFUNCTIONS END  ##### --
		
-- ##### ROLLOUT ##### --
	
	rollout prox_handler "Proxy Tools V3.0" 
	(

-- ##### LOCAL VARS  ##### --
		
		local col_prox_vray = #()
		local col_prox_corona = #()
		
-- ##### CONTROLS  ##### --
		
		group "Settings" 
			(
				checkbox chk_all "All Proxies" 				across:2 	checked: False
				checkbox chk_selected "Selected Proxies" 				checked: True
-- 				button btn_refresh "Refresh" 	height:30 width:220
		-- 		checkbox chk_useUndo "Use Undo, will slow down."
			)
			
		--Create the dotNet listview control
		dotNetControl theLv "system.windows.forms.listView" height: 175
			
		group "Hide/Show"
			(
				button btn_show "Show" 		across:3		width:60 height:30		
				button btn_hide "Hide" 						width:60 height:30
				button btn_select "Select"					width:60 height:30
				
				label lbl_1 "Right-click to show/hide/select Corona Proxies"
			)
			
		group "Display Mode" 
		
			(
				button btn_bound 	"BOX" 	across:2 	width:100 height:30
				button btn_prev 	"PREV" 				width:100 height:30
				button btn_faces 	"FACE" 	across:2 	Width:100 height:30
				button btn_full 	"FULL" 				width:100 height:30
			)
		
		group "Scene Xrefs"
			(
				
				listbox xmlv "" items: tabxref
				on xmlv selected xref do format "%\n" xref xmlv.selection
		-- 		on xmlv doubleclicked val do format "doubleclicked: % - %\n" val xmlv.selection[val]
		-- 		on xmlv selectionEnd do format "selectionEnd: %\n" xmlv.selection
			)
		
		group "Xref Proxy Display Mode"
			(
				button btn_xbound "Bounding Box" across:2 width:110 height:30
				button btn_xprev "Preview" width:110 height:30
				button btn_xfaces "Faces" across:2 width:110 height:30
				button btn_xwhole "Whole" width:110 height:30 enabled: false
				checkbox chb_unsafemode "Un-safe Mode" width:100 height:15 align: #center	
			)
			
-- ##### FUNCTIONS VRAY ##### --
		
		fn CollectProxiesVRAY all:True = 
			(
				if all == True then
					(
						tot = objects.count
						inc = 0
						
						for v in objects do
							(
								if (classof v) == VRayProxy then(append col_prox_vray v)
								inc += 1
							)
					)
					else
					(
						sel= (selection as array)
						inc = 0
						for v in sel do(
							if (classof v) == VRayProxy then
							(
								append col_prox_vray v	
							)
					)
				)
			)
	
		fn displayModeVRAY mode:1 = 
			(
				if state == True then
					(
						col_prox_vray = #()
						CollectProxiesVray()
					)
				else
					(
						col_prox_vray = #()
						CollectProxiesVray all:False
					)
				
				if chk_selected.checked then
					(
						tot = col_prox_vray.count
						inc = 0
						for vv in col_prox_vray do
							(
								if vv != undefined then(vv.display = mode)
								inc += 1
							)	
					)
				else
					(
						temp_prox_v = (getClassInstances VRayProxy)
						inc = 0
						for tv in temp_prox_v do
							(
								if tv != undefined then(tv.display = mode)
								inc += 1
							)
					)
			)
			
		fn hide_show_proxies_VRAY hidden:True = 
			(
				tot = col_prox_vray.count
				if hidden == True then
					(
						inc = 0
						for vv in col_prox_vray do
							(
								if vv != undefined then(hide vv)
								inc += 1
							)
					)
				else
					(
						inc = 0
						for v in col_prox_vray do
							(
								unhide v
								inc += 1
							)
					)
			)

-- ##### FUNCTIONS CORONA ##### --
	
		fn CollectProxiesCORONA all:True = 
			(
				if all == True then
					(
						tot = objects.count
						inc = 0
						
						for c in objects do
							(
								if (classof c) == CProxy then(append col_prox_corona c)
								inc += 1
							)
					)
					else
					(
						sel= (selection as array)
						inc = 0
						for c in sel do(
							if (classof c) == CProxy then
							(
								append col_prox_corona c	
							)
					)
				)
			)
		
		fn displayModeCORONA mode:1 = 
			(
				if state == True then
					(
						col_prox_corona = #()
						CollectProxiesCORONA()
					)
				else
					(
						col_prox_corona = #()
						CollectProxiesCORONA all:False
					)
				
				if chk_selected.checked then
					(
						tot = col_prox_corona.count
						inc = 0
						for cc in col_prox_corona do
							(
								if cc != undefined then(cc.previzType = mode)
								inc += 1
							)	
					)
				else
					(
						temp_prox_c = (getClassInstances CProxy)
						inc = 0
						for tc in temp_prox_c do
							(
								if tc != undefined then(tc.previzType = mode)
								inc += 1
							)
					)
			)
			
		fn hide_show_proxies_CORONA hidden:True = 
			(
				tot = col_prox_corona.count
				if hidden == True then
					(
						inc = 0
						for cc in col_prox_corona do
							(
								if cc != undefined then(hide cc)
								inc += 1
							)
					)
				else
					(
						inc = 0
						for c in col_prox_corona do
							(
								unhide c
								inc += 1
							)
					)
			)
			
-- ##### FUNCTIONS XREF ##### --
		
		fn displaymode_xVRAY xrefinteger displaymodevalue =
			(
				x = xrefs.getXRefFile xrefinteger
				y = x.tree.children
				for o in y where classof o == vrayproxy do o.display = displaymodevalue
			)
			
		fn displaymode_xCORONA xrefinteger displaymodevalue =
			(
				x = xrefs.getXRefFile xrefinteger
				y = x.tree.children
				for o in y where classof o == cproxy do o.display = displaymodevalue
			)
			
-- ##### FUNCTIONS LISTER ##### --
			
		--Innitialize the listview control with the columns names and width and options.
		fn initLv=
		(
			local sortOrder = dotNetClass "System.Windows.Forms.SortOrder"
			
			--Setup the forms view
			theLv.view=(dotNetClass "system.windows.forms.view").details
			
			--Interface settings
			
			theLv.FullRowSelect=true							--Set so full width of listView is selected and not just first column.
			theLv.GridLines=false								--Show lines between the items. 
			theLv.MultiSelect=true								--Allow for multiple selections. 
-- 			thelv.autosize = true
-- 			thelv.AllowColumnReorder = false
			
			--Add columns and sort them
			
			theLv.columns.add "PROXY" 120						--Add each new column to the listview control. 
			
-- 			theLv.columns.add "POLYS" 50
			theLv.columns.add "MODE" 90							
			
			
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
			
			prxysort=#()					--Empty array to sort camera names
			
			for prxy in objects do		--Loop through all the objects in the scene.
			(
				local orangeColor = (dotNetClass "System.Drawing.Color").fromARGB 255 180 50
				local blueColor = (dotNetClass "System.Drawing.Color").fromARGB 74 148 208
				local greenColor = (dotNetClass "System.Drawing.Color").fromARGB 166 218 115
				local blackColor = (dotNetClass "System.Drawing.Color").fromARGB 25 25 25
				
				case (ClassOf prxy) of 
				
				(
					CProxy:
					(
						append prxysort prxy.name
						
						li=dotNetObject "System.Windows.Forms.ListViewItem" prxy.name
						li.forecolor = orangeColor
						
						--MESH VIEW TYPE
						(li.subitems.add (""))
						append rows li
					)
					
					VrayProxy:
					(
						append prxysort prxy.name
						
						li=dotNetObject "System.Windows.Forms.ListViewItem" prxy.name
						li.forecolor = blueColor
						
						--MESH VIEW TYPE
						(li.subitems.add (""))
						append rows li
					)
					
		
-- 					case (ClassOf prxy) of
-- 					(
-- 						CProxy: li.forecolor = orangeColor
-- 						VrayProxy: li.forecolor = blueColor
-- 					)
					
					
-- 					ADD WHAT TYPE OF LIGHT IS SAVED
-- 					(
-- 						(li.subitems.add (""))
-- 					)
																							--Added the listViewItem to the rows array
				)
				
			)
			
			(theLv.items.addRange rows)													--Add the array of rows to the listView control. 
		)
		
		
		
-- ##### EVENTS  ##### --
			
		on prox_handler open do
			(
				CollectProxiesCORONA()
				CollectProxiesVRAY()
				
				initLv()
				populateList()
				
				if tabxref.count == 0 then
					(

						btn_xbound.enabled = false
						btn_xprev.enabled = false
						btn_xfaces.enabled = false
						btn_xwhole.enabled = false
						
						chb_unsafemode.enabled = false
					)
			)
			
		on theLv MouseClick itm do
		(
			hit=(theLv.HitTest (dotNetObject "System.Drawing.Point" itm.x itm.y))
			
			if (itm.Button.Equals itm.Button.left) then
			(
				select (getnodebyname hit.item.text)
				
			)
		)
			
		on btn_refresh pressed do
			(
				if chk_all == True then
					(
						CollectProxiesCORONA()
						CollectProxiesVRAY()
					)
				else
					(
						CollectProxiesCORONA all:False
						CollectProxiesVRAY all:False
					)
			)
		
		on chk_all changed state do
			(
				if state == True then
					(
						chk_selected.state = False
						col_prox_vray = #()
						col_prox_corona = #()
						CollectProxiesVRAY()
						CollectProxiesCORONA()
					)
				else
					(
						chk_selected.state = True
						col_prox_vray = #()
						col_prox_corona = #()
						CollectProxiesVRAY all:False
						CollectProxiesCORONA all:False
					)
			)
		
		on chk_selected changed state do
			(
				if state == True then
					(
						chk_all.state = False
						col_prox_vray = #()
						col_prox_corona = #()
						CollectProxiesVRAY all:False
						CollectProxiesCORONA all:False
					)
				else
					(
						chk_all.state = True 
						col_prox_vray = #()
						col_prox_corona = #()
						CollectProxiesVRAY()
						CollectProxiesCORONA()
					)
			)
		
		on btn_bound pressed do
			(
				displayModeVRAY mode:0
				displayModeCORONA mode:0
			)
		
		on btn_prev pressed do
			(
				displayModeVRAY mode:1
				displayModeCORONA mode:1
			)
		
		on btn_faces pressed do
			(
				displayModeVRAY mode:3
				displayModeCORONA mode:2
			)
			
		on btn_full pressed do
			(
				displayModeVRAY mode:4
				displayModeCORONA mode:3
			)
	
		on btn_show pressed do
			(
				hide_show_proxies_VRAY hidden:False
			)
		
		on btn_show rightclick do
			(
				hide_show_proxies_CORONA hidden:False
			)
			
		on btn_hide pressed do
			(
				hide_show_proxies_VRAY hidden:True
			)
		
		on btn_hide rightclick do
			(
				hide_show_proxies_CORONA hidden:True
			)
		
		on btn_select pressed do
			(
				select col_prox_vray
			)
		
		on btn_select rightclick do
			(
				select col_prox_corona
			)
	
-- ##### XREF EVENTS ##### --
	
		on chb_unsafemode changed state do
		(
			btn_xwhole.enabled = state
		)
		
		on btn_xbound pressed do
		(
			displaymode_xVRAY xmlv.selection 0
			displaymode_xCORONA xmlv.selection 0
		)
		
		on btn_xprev pressed do
		(
			displaymode_xVRAY xmlv.selection 1
			displaymode_xCORONA xmlv.selection 1
		)
		
		on btn_xfaces pressed do
		(
			displaymode_xVRAY xmlv.selection 3
			displaymode_xCORONA xmlv.selection 2
		)
		
		on btn_xwhole pressed do
		(
			displaymode_xVRAY xmlv.selection 4
			displaymode_xCORONA xmlv.selection 3
		)
	
	)
	createDialog prox_handler 240 600
)