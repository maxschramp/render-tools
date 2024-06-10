macroScript tySmooth
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySmooth" 
				ButtonText: "tySmooth" 
				( 
					on execute do AddMod tySmooth 
					on isEnabled return mcrUtils.ValidMod tySmooth 
					) 
