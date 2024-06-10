macroScript tyActorIK
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyActorIK" 
				ButtonText: "tyActorIK" 
				( 
					on execute do StartObjectCreation tyActorIK 
					on isChecked return mcrUtils.IsCreating tyActorIK 
					) 
