macroScript tyMultifracture
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyMultifracture" 
				ButtonText: "tyMultifracture" 
				( 
					on execute do AddMod tyMultifracture 
					on isEnabled return mcrUtils.ValidMod tyMultifracture 
					) 
