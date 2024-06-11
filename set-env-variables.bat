@echo off

echo render-tools located at: %~dp0
:: Assign Environment variables for scripts
setx ADSK_3DSMAX_MACROS_ADDON_DIR "%~dp0scripts\3dsmax\ADSK_3DSMAX_MACROS_ADDON_DIR" /m
setx ADSK_3DSMAX_SCRIPTS_ADDON_DIR "%~dp0scripts\3dsmax\ADSK_3DSMAX_SCRIPTS_ADDON_DIR" /m
setx ADSK_3DSMAX_STARTUPSCRIPTS_ADDON_DIR "%~dp0scripts\3dsmax\ADSK_3DSMAX_STARTUPSCRIPTS_ADDON_DIR" /m

pause