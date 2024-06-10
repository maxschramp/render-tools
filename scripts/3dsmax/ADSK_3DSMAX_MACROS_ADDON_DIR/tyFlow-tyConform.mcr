macroScript tyConform
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyConform" 
				ButtonText: "tyConform" 
				( 
					on execute do AddMod tyConform 
					on isEnabled return mcrUtils.ValidMod tyConform 
					) 
