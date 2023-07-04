macroscript CopyObjects buttontext: "Copy Objects" toolTip:"Copy Objects" category: "render-tools"
(
	if selection.count > 0 then
	(
		try
		(
			sys_dir = getdir #autoback
			new_file_path = (sys_dir + "\\copypaste" + "\\")
			new_dir = makedir new_file_path
			new_max_file = (new_file_path + "copypaste.max")
			save_objects = savenodes selection new_max_file
		)-- end try
		catch()
	)-- end if
)--end macroscript


macroscript PasteObjects buttontext: "Paste Objects" toolTip:"Paste Objects" category: "render-tools"
(
	try
	(
		sys_dir = getdir #autoback
		max_file_path = (sys_dir + "\\copypaste" + "\\")
		mergemaxfile (max_file_path + "copypaste.max") #mergedups #AutoRenameDups #renameMtlDups #select
	)-- end try
	catch()
)-- end macroscript