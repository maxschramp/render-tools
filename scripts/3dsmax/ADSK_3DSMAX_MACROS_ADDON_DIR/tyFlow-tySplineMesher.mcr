macroScript tySplineMesher
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySplineMesher" 
				ButtonText: "tySplineMesher" 
				( 
					on execute do AddMod tySplineMesher 
					on isEnabled return mcrUtils.ValidMod tySplineMesher 
					) 
