/*
	This is a script that will help the user to copy and paste objects between
	Mulitple opened max scenes.
	In reality it's a quick merge operation done without any prompts for any sort of duplicated names or materials.
	Duplicated names and materials will be renamed upon merge
	
	Created by Miled Rizk
	e-mail: miledrizk@gmail.com
*/

macroscript CopyObjects buttontext: "Copy Objects" category: "render-tools"
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


macroscript PasteObjects buttontext: "Paste Objects" category: "render-tools"
(
	try
	(
		sys_dir = getdir #autoback
		max_file_path = (sys_dir + "\\copypaste" + "\\")
		mergemaxfile (max_file_path + "copypaste.max") #mergedups #AutoRenameDups #renameMtlDups #select
	)-- end try
	catch()
)-- end macroscript