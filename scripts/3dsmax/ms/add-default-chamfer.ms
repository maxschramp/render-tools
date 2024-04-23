macroScript "add-default-chamfer" category:"#render-tools"
( max modify mode
c = Chamfer()
c.name = "Quad Chamfer"
c.miteringType = 0
c.chamfertype = 0
c.quadIntersectionMode = off
c.amount = 1
c.segments = 2
c.tension = 0.5
c.SmoothType = 1
c.smoothtoadjacent = on
c.enabledInViews = false
addModifier $ c )