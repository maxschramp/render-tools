macroScript DropToSlateRW
category:"#render-tools"
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