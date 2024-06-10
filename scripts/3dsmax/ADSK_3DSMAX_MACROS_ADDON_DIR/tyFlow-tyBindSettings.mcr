macroScript tyBindSettings
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyBindSettings" 
				ButtonText: "tyBindSettings" 
				( 
					on execute do AddMod tyBindSettings 
					on isEnabled return mcrUtils.ValidMod tyBindSettings 
					) 
