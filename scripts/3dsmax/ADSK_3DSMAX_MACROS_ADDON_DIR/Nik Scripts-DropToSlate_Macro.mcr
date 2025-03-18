macroScript DropToSlateRW
<<<<<<< HEAD
category:"#render-tools"
=======
category:"Nik Scripts"
>>>>>>> 34a817b3cfcbf04a78d9398cefe7d2fb7a0f30a5
toolTip:"DropToSlate Resize"
icon:#("DropToSlateRW",1)
(
	if ::SMEDragAndDropHandler != undefined then SMEDragAndDropHandler.OpenRwSizeQuery()
	else messagebox "DropToSlate is not started"
)


macroScript DropToSlateSetup
category:"Nik Scripts"
toolTip:"DropToSlate Settings"
icon:#("DropToSlate",1)
(
	if ::SMEDragAndDropHandler != undefined then SMEDragAndDropHandler.OpenSettings()
	else messagebox "DropToSlate is not started"
)