macroScript tyFaceExtrude
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyFaceExtrude" 
				ButtonText: "tyFaceExtrude" 
				( 
					on execute do AddMod tyFaceExtrude 
					on isEnabled return mcrUtils.ValidMod tyFaceExtrude 
					) 
