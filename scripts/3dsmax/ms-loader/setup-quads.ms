-- grab the existing quads
quadExisting = (menuMan.getViewportRightClickMenu #nonePressed)

-- temporarily set the default quads to max's preference
quadDefault = menuMan.findQuadMenu "Default Viewport Quad"
menuMan.setViewportRightClickMenu #nonePressed quadDefault

-- delete Render Tools quads if it exists
if ((menuMan.findQuadMenu "Render Tools") != undefined) do menuMan.unRegisterQuadMenu (menuMan.findQuadMenu "Render Tools")

-- if render tools was quadExisting then set quadExisting to DefaultLightWorldGenFragment
if quadExisting == undefined do quadExisting = quadDefault

-- create render tools quad menu
menuMan.createQuadMenu "Render Tools" ((quadDefault.getMenu 1).getTitle()) ((quadDefault.getMenu 2).getTitle()) ((quadDefault.getMenu 3).getTitle()) "render-tools"
quadRenderTools = menuMan.findQuadMenu "Render Tools"
menuMan.setShowAllQuads quadRenderTools true

-- create seperator
sep = menuMan.createSeparatorItem()

-- duplicate the default menu
for x = 1 to 4 do (
	for y = 1 to (quadDefault.getMenu x).numItems() do (
		format "adding menu % item %\n" x y
		(quadRenderTools.getMenu x).addItem ((quadDefault.getMenu x).getitem y) -1
	)
)

-- add a seperator before adding all the maxscript
(quadRenderTools.getMenu 4).addItem sep 1
(quadRenderTools.getMenu 4).addItem (menuMan.createActionItem "Setup_Animation" "render-tools") 1
(quadRenderTools.getMenu 4).addItem (menuMan.createActionItem "AssemblyTool" "Utopia") 1
(quadRenderTools.getMenu 4).addItem (menuMan.createActionItem "PasteObjects" "render-tools") 1
(quadRenderTools.getMenu 4).addItem (menuMan.createActionItem "CopyObjects" "render-tools") 1



menuMan.setViewportRightClickMenu #nonePressed quadRenderTools
