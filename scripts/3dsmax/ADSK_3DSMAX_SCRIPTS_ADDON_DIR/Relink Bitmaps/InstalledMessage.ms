messageBox "Relink Bitmaps is now installed!\n\nTo run it goto:\n   Customize -> Customize User Interface -> Toolbars\nCategory: \"ColinScripts\" and drag \"Relink Bitmaps\" to a toolbar.\n\nClick the toolbar icon to run it!"
colorman.reInitIcons()
global RelinkBitmapsIniFile = (getDir #userScripts + "\\Relink Bitmaps.ini")

-- Delete the old INI file to accomodate new settings in 2.03
--try ( deleteFile RelinkBitmapsIniFile ) catch ()