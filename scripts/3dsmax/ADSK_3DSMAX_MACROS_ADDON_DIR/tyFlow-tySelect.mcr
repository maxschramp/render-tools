macroScript tySelect
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySelect" 
				ButtonText: "tySelect" 
				( 
					on execute do AddMod tySelect 
					on isEnabled return mcrUtils.ValidMod tySelect 
					) 
