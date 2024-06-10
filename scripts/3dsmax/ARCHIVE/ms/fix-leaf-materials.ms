
clearListener()
-- regex = dotnetobject "System.Text.RegularExpressions.Regex" "leaf"

SME.Open()
if SME.GetViewByName("leaf-fix") < 1 then smeView = SME.getView(SME.CreateView "leaf-fix") else smeView = SME.getView(SME.GetViewByName "leaf-fix")

smeView.selectAll()
smeView.DeleteSelection()

m = $.material

smeView.CreateNode m [0,0]
smeView.ZoomExtents type:#all

messageBox "Select all leaf materials"

matList = v.getSelectedNodes()

for i = 1 to matList.count do (
	
)


-- for i = 1 to matList.count do 
-- ( if regex.ismatch(matList[i].name) then print matList[i].name)