macroScript tyMesher
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyMesher" 
				ButtonText: "tyMesher" 
				( 
					on execute do StartObjectCreation tyMesher 
					on isChecked return mcrUtils.IsCreating tyMesher 
					) 
