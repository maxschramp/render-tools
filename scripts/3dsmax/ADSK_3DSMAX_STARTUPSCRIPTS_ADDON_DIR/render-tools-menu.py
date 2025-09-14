"""
Creates a simple menu with two menu items which reference actions defined via macroScript.
"""
# pylint: disable=invalid-name,import-error
from pymxs import runtime as rt
import os, re, uuid

dir = os.getenv("ADSK_3DSMAX_MACROS_ADDON_DIR") # set to 3dsmax macros environment variable

def sort(e):
    return isinstance(e, dict) # sort dictionaries to bottom

def getActionID(file: os.path) -> str:
    macroscript = file # set macroscript to item
    with open(os.path.join(os.getenv("ADSK_3DSMAX_MACROS_ADDON_DIR"), macroscript), 'r') as f: # read the macroscript file
        content = f.read()
        actionID = ((re.split(r"(?i)macroScript", content)[1].split(" ")[1]).split("category:")[0]).split("\n")[0] # pull the actionID (name without spaces between macroScript and category)
        category = ((re.split(r"(?i)category:", content)[1].split('"')[1])) # pull the category
    print(fr"macroscript name: {macroscript} macroscript ID: {actionID} category: {category}") # print the name of the macroscript and the actionID
    return {actionID: category} # return as a dictionary with the key: value as actionID: category (e.g. CameraLister: #render-tools)

def createMenu(dir: str) -> list:
    menu: list = [] # create list
    for item in os.scandir(dir):
        if os.path.isdir(item): # if a directory is found create dictionary with list of macros inside
            menu.append({item.name:createMenu(os.path.realpath(item))})
        elif os.path.splitext(item)[-1] == ".mcr": # if a macroscript is found add to list
            # print(f"Macro: {item.name}")
            menu.append(getActionID(item.path))
        else:
            # print(f"Unknown {item.name}:") # if an unknown file is found do nothing
            pass
    return menu

def createSubmenu(parentMenu: any, children: list): # input the parent menu and the list of items to add
    macroscriptTableid = 647394 # default macroscipt table ID value
    for child in children: # for each menu item check if it's a dictionary, in which case create a submenu with the dictionary name and then the list inside of it.
        for key, value in child.items():
            if isinstance(value, list):
                createSubmenu(parentMenu.createSubmenu(f"{uuid.uuid4()}", key), value)
            else:
                for key, value in child.items():
                    parentMenu.createAction(f"{uuid.uuid4()}", macroscriptTableid, f"{key}`{value}") # tableId: 647394 actionId: AssemblyTool`#render-tools

menuItems = createMenu(dir)
menuItems.sort(key=sort)

print(menuItems)

# ------------- Definition of MacroScript Actions that can be triggered by your plugin menu items --------------------
""" # ------------- Define plugin action 1 --------------------
# Create a macroscript that executes our plugin specific code
# (this macroscript defines an action that can be used as an Action menu item)
rt.macros.new(
    "Menu Demo Category",   # Category for the macro script
    "MenuAction1",          # Name of the macro script
    "Action 1 Tooltip Text",  # Tooltip text for the action
    "Action 1 Menu Text",   # Text displayed in the menu
    "executeAction1()"      # Function to execute when this action is triggered
)

# Our plugin specific function that gets called when the user clicks the menu item
def executeAction1():
    print("Action 1 executed")
    
# Expose this function to the maxscript global namespace
rt.executeAction1 = executeAction1

# ------------- Define plugin action 2 --------------------
# Create a second macroscript for another plugin-specific action
rt.macros.new(
    "Menu Demo Category",
    "Menu Action 2",
    "Action 2 Tooltip Text",
    "Action 2 Menu Text",
    "executeAction2()")

# Our plugin specific function that gets called when the user clicks the menu item    
def executeAction2():
    print("Action 2 executed")
    
# Expose this function to the maxscript global namespace
rt.executeAction2 = executeAction2 """

# ------------- Menu Creation Callback --------------------
# This callback is called every time the menu structure is newly evaluated, such as on 3ds Max startup or when the menu preset changes
def menucallback():
    """Register the a menu and its items.
    This callback is registered on the "cuiRegistermenus" event of 3dsMax and
    is typically called in the startup of 3dsMax.
    """
    menumgr = rt.callbacks.notificationparam()
    mainmenubar = menumgr.mainmenubar
    
    # Create a new submenu at the end of the 3dsMax main menu bar
    # To place the menu at a specific position, use the 'beforeID' parameter with the GUID of the suceeding menu item
    # Note that every menu item in the menu system needs a persistent Guid for identification and referencing
    submenu = mainmenubar.createSubmenu("F7B07F21-B82C-4A84-8557-1CA9EAB40A9B",
        "DSAI Scripts")
   
    # build the menus
    createSubmenu(submenu, menuItems)

# Make sure menucallback is called on cuiRegisterMenus events
# so that it can register menus at the appropriate moment
MENU_DEMO_SCRIPT = rt.name("pySimpleMenuDemo")
rt.callbacks.removescripts(id=MENU_DEMO_SCRIPT)
rt.callbacks.addscript(rt.name("cuiRegisterMenus"), menucallback, id=MENU_DEMO_SCRIPT)

# To test this script, you can un-comment the line below to force the menu system to reload every time you run the script in the 3dsMax Scripting Editor.
# Important: This line needs to be commented out again before you put the script into the 3dsMax startup folder, as it will impact system performance.
# Another alternative is to toggle the menu preset in the menu editor, as this also re-loads the menu system.
# If your script is evaluated successfully your menus are listed in the menu editor for customization.
#
# rt.maxops.GetICuiMenuMgr().LoadConfiguration(rt.maxops.GetICuiMenuMgr().GetCurrentConfiguration())
