macroScript tyBitmap
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyBitmap" 
				ButtonText: "tyBitmap" 
				( 
					on execute do StartObjectCreation tyBitmap 
					on isChecked return mcrUtils.IsCreating tyBitmap 
					) 
