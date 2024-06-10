macroScript tyBend
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyBend" 
				ButtonText: "tyBend" 
				( 
					on execute do AddMod tyBend 
					on isEnabled return mcrUtils.ValidMod tyBend 
					) 
