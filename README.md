# render-tools

This repository stores all of my material libraries, scripts, plugins, and anything else useful for rendering.

# instructions

The /powershell-scripts/ folder has several powershell scripts used to setup and update render-tools.

When you start, run the backup-3dsmax-settings.ps1 script to backup your current setup. It's recommended to do this every time you run the next script.

sync-3dsmax.ps1 will do several things, including adding a "render-tools" Startup Template in the Template Manager. In 3dsMax run "New from Template..." and select the render-tools template. If you would like it to open automatically open the Template Manager and press the Set to Default button. It also adjusts your Slate Material Editor to open the render-tools material libraries, this will overwrite your current setup until I fix this. You can restore your ENU folder to revert this change. It also adds all of the render-tools paths to the project folder so that all of the material-libraries won't need to be relinked, as well as adds a Render Preset that you can load from the Render Settings window of 3dsMax that creates all of the Corona Masks and Render Elements you need.