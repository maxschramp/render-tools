macroScript tyFaceFracture
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyFaceFracture" 
				ButtonText: "tyFaceFracture" 
				( 
					on execute do AddMod tyFaceFracture 
					on isEnabled return mcrUtils.ValidMod tyFaceFracture 
					) 
