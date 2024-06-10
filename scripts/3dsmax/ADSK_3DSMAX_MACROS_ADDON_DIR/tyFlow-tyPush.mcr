macroScript tyPush
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyPush" 
				ButtonText: "tyPush" 
				( 
					on execute do AddMod tyPush 
					on isEnabled return mcrUtils.ValidMod tyPush 
					) 
