
	-- Set up camera and scene for animations
	animationRange = interval 0 120 -- set range to 5 seconds
	frameRate = 24 -- set filmic frame rate
	realTimePlayback = true -- ensure realtime playback
	timeConfiguration.playbackSpeed = 3 -- play at 1x speed
	timeDisplayMode = #smpte -- set time display to smtpe
	renderWidth=1920 -- set width
	rendImageAspectRatio = 1.77778 -- set ratio
	rendLockImageAspectRatio = true -- lock ratio

	ac = getactivecamera()

	ac.shutterSpeed = 50
	ac.mblurDuration = 0.48
	ac.shutterAngle = 172.8
	ac.enableCameraMb = on
	ac.enableGeometryMb = on
	ac.shutterParam = 0
		
	select (getNodeByName ac.name)

	renderSceneDialog.update()