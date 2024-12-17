macroScript Sweep_Profile
category:"Kstudio"
tooltip:"Sweep Pro"
buttontext:"Sweep Pro"
Icon:#("Kstudio",10)
--silentErrors:true
-- autoUndoEnabled:false
(
	global SweepProOpen,SweepProfileForm
	on execute do (
		sysinfo.currentdir = "$userScripts/Kstudio/SweepProfile"
		if classof SweepProfileForm == dotNetObject and not SweepProfileForm.isDisposed then
			(
			case  of
				(
					(SweepProfileForm.Visible and SweepProfileForm.WindowState == SweepProfileForm.WindowState.Minimized):
					(
						SweepProfileForm.WindowState = SweepProfileForm.WindowState.Normal
					)
					default:
					(
						SweepProOpen = SweepProfileForm.Visible = not SweepProfileForm.Visible
						SweepProfileForm.WindowState = SweepProfileForm.WindowState.Normal
					)
				)
			ok
			)
		else
			fileIn (sysinfo.currentdir + "/SweepProfile.mse");
		)
	on isChecked return SweepProOpen == true
)