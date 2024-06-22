function GetDate = (
	d_year = ((getUniversalTime())[1] - 2000) as string
	d_month = ((getUniversalTime())[2] as string)
	if (getUniversalTime())[2] < 10 do d_month = "0" + d_month
	d_day = (getUniversalTime())[4] as string
	if (getUniversalTime())[4] < 10 do d_day = "0" + d_day

	return d_year + d_month + d_day
)

function SetOutputFilename = (
	f_project = "\\\\NAS-02\\"
	python.execute("rt.f_project = os.path.basename(os.path.dirname(os.path.dirname(rt.maxFilePath)))")
	f_date = GetDate()

	if getActiveCamera() == undefined then f_camera = replace (viewport.getType() as string) 1 5 "" -- set to #view_type
	else ( f_camera = (getActiveCamera()).name )

	return "\\\\NAS-02\\deadline\\output\\" + f_project + "\\"  + f_camera + "\\" + f_date + "\\" + f_camera + "_.cxr"
	
	)
	
print(SetOutputFilename())
rendSaveFile = True
rendOutputFilename = SetOutputFilename()
rendOutputFilepath = pathConfig.stripPathToLeaf(rendOutputFilename)
python.execute("os.makedirs(os.path.dirname(rt.rendOutputFilename), exist_ok=True)")
format "\nSaving file to: %" rendOutputFilename
renderSceneDialog.update
