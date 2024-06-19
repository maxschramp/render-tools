function RemoveAllRenderElementOutputFilenames = (
	print "Cleaning element output filenames!"
	
	render_element_manager = maxOps.GetRenderElementMgr #Production
	setsilentmode true -- used to avoid error message when checking the filename of element

	for index = 0 to (render_element_manager.numrenderelements () - 1) do 
	(
		render_element = render_element_manager.getrenderelement index -- get render element
		render_element_filename = render_element_manager.GetRenderElementFilename index -- get render element output filename
		format "\nRender Element #%: % (%)" index render_element.elementname render_element_filename
		format "\nRemoving output filename: %" render_element_filename
		render_element_manager.SetRenderElementFilename index "" -- remove filename
		
	)

	renderSceneDialog.update()
)


RemoveAllRenderElementOutputFilenames()