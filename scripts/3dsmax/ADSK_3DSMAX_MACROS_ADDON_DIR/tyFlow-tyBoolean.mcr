macroScript tyBoolean
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyBoolean" 
				ButtonText: "tyBoolean" 
				( 
					on execute do AddMod tyBoolean 
					on isEnabled return mcrUtils.ValidMod tyBoolean 
					) 
