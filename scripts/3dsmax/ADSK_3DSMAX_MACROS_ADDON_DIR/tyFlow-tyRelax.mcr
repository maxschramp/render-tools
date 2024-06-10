macroScript tyRelax
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyRelax" 
				ButtonText: "tyRelax" 
				( 
					on execute do AddMod tyRelax 
					on isEnabled return mcrUtils.ValidMod tyRelax 
					) 
