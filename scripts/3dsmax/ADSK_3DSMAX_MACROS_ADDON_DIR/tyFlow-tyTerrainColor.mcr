macroScript tyTerrainColor
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyTerrainColor" 
				ButtonText: "tyTerrainColor" 
				( 
					on execute do StartObjectCreation tyTerrainColor 
					on isChecked return mcrUtils.IsCreating tyTerrainColor 
					) 
