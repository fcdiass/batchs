Paste 'run_GeMA.bat' in the models' parent folder.

Folder tree should be: 
..  > multiple_files
        > D1_E=32370
            > D1_E=32370.lua
            > D1_E=32370_model.lua
            > D1_E=32370_solution.lua
        > D1_E=35000
            > D1_E=35000.lua
            > D1_E=35000_model.lua
            > D1_E=35000_solution.lua
        > D1_E=40000
            > D1_E=40000.lua
            > D1_E=40000_model.lua
            > D1_E=40000_solution.lua
        > D1_E=45000
            > D1_E=45000.lua
            > D1_E=45000_model.lua
            > D1_E=45000_solution.lua
        > D1_E=50000
            > D1_E=50000.lua
            > D1_E=50000_model.lua
            > D1_E=50000_solution.lua
        > D1_E=55000
            > D1_E=55000.lua
            > D1_E=55000_model.lua
            > D1_E=55000_solution.lua
        > run_GeMA.bat
        > runFolders.txt
        
- Each line of 'runFolders.txt' corresponds to a subfolder name.
- If you want to run all folders you can:
    - Add "*" (with no quotes) in the first line of 'runFolders.txt'; or
    - Exclude 'runFolders.txt'.
