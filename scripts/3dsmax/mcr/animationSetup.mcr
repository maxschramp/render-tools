macroScript Setup_Animation category:"render-tools" toolTip:"Setup Animation in Active Viewport"

(
	-- Set up camera and scene for animations
	maxops.setDefaultTangentType #linear #linear -- set tangents to linear
	animationRange = interval 0 120 -- set range to 5 seconds
	frameRate = 24 -- set filmic frame rate
	realTimePlayback = true -- ensure realtime playback
	timeConfiguration.playbackSpeed = 3 -- play at 1x speed
	timeDisplayMode = #smpte -- set time display to smtpe
	renderWidth=1920 -- set width
	rendImageAspectRatio = 1.77778 -- set ratio
	rendLockImageAspectRatio = true -- lock ratio

	ac = getactivecamera()

	ac.shutterSpeed = 50 -- set shutter speed to 1/50
	ac.mblurDuration = 0.48  -- set shutter speed to 1/50
	ac.shutterAngle = 172.8 -- set shutter speed to 1/50
	ac.enableCameraMb = on -- enable camera motion blur
	ac.enableGeometryMb = on -- enable geometry motion blur
	ac.shutterParam = 0 -- set to shutter speed mode

ac.enableClipping = on
ac.showClipRange = on
ac.clippingNear = 100

		
	select (getNodeByName ac.name) -- select the active camera

	renderSceneDialog.update() -- reload UI
)
