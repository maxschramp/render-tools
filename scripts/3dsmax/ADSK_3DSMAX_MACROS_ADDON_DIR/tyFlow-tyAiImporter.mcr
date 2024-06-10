macroScript tyAiImporter
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyAiImporter" 
				ButtonText: "tyAiImporter" 
				( 
					on execute do StartObjectCreation tyAiImporter 
					on isChecked return mcrUtils.IsCreating tyAiImporter 
					) 
