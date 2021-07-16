Paste 'run_GeMA.bat' in the model's parent folder.

Folder tree should be: 
..  > one_file
        > D1
            > D1.lua
            > D1_model.lua
            > D1_solution.lua
            > options.txt 
        > run_GeMA.bat
        
- Each line of 'options.txt' corresponds to one call to GeMA.
- The content of line ("line_content") is added in the command line in the following way:
  gema D1.lua -u "line_content"

See more: https://www.tecgraf.puc-rio.br/gema/gema/doxygen/html/gema_executing.html
