-------------------------------------------------------------
--  Numerical Solvers
-------------------------------------------------------------

NumericalSolver {
  id          = 'solver',
  typeName    = 'ArmadilloSolver',
  description = 'Direct matrix solver',

}

-------------------------------------------------------------
--  Physical Methods
-------------------------------------------------------------
PhysicalMethod {
  id       = 'PlaneStress',
  typeName = 'MechanicalFemPhysics.PlaneStress',
  
  type     = 'fem',
  mesh = 'mesh',
  elementGroups = {'TRU_1', 'QU_1', },
  materials = {'elastic',}, 
  boundaryConditions = {'cload','bc',},
  ruleSet = 1,
  reactionForceMode = 'node',
  properties = {material = 'materialM'}
} 

-------------------------------------------------------------
--  Process execution script
-------------------------------------------------------------
local solverOptions = {
    type                      = 'static nonlinear',
    tolerance                 = {mechanic = 1.000000e-05},
    stepsMax                  = 1,
    loadPredictorIncrement    = 10,
    loadMaxIncrement          = 10,
    loadMax                   = 10,
    incrementsStrategy        = 'cylindrical arc length',
    iterationsStrategy        = 'cylindrical arc length',
    newtonRaphsonMode         = 'full',
    convergenceCriterion      = 'load',
    attemptsMax               = 5,
    iterationsMax             = 10,
    normalFlow                = 'false',
    loadAdjustStep            = 'false',
}

function nodeDisp(node)
    -- Get the needed accessors.
    local mesh = modelData:mesh('mesh')
	
	-- nodal displacement accessor 
    local accU = assert(mesh:nodeValueAccessor('u'))
    assert(accU)
   
   -- nodal displacement
   local Uxy = accU:value(node)
   
   -- return vertical displacement
   return Uxy(2)	
end

function nodeReac(node)
    -- Get the needed accessors.
    local mesh = modelData:mesh('mesh')
	
	-- nodal reaction force accessor 
    local accU = assert(mesh:nodeValueAccessor('Rf'))
    assert(accU)
   
   -- nodal reaction force
   local Uxy = accU:value(node)
   
   -- return vertical reaction force
   return Uxy(2)	
end
	
function ProcessScript()
   os.execute('if not exist out mkdir out')
   -- Create the solver model  
   local solver = fem.init({'PlaneStress',}, 'solver', solverOptions)
   local file = io.prepareMeshFile('mesh', '$SIMULATIONDIR/out/$SIMULATIONNAME', 'nf', {'u', 'Rf'}, {'S', 'E'}, {split = true, saveDisplacements = true})
   local nsteps = solverOptions.stepsMax
   local loadFile = io.open(translatePath('$SIMULATIONDIR') .. '/out/output.txt', "w+")
   assert(loadFile)
   loadFile:write("Inc	U2 [mm]	Load [kN]\n")
   loadFile:write(0, "	", 0.0, "	", 0.0, "\n")
   io.addResultToMeshFile(file, 0)
   
   for i = 1, nsteps do   
      print('---- time ' .. i)
      local newLoad = fem.step(solver,i)
      -- io.printMeshNodeData('mesh', {'u'}, {header_title = true})
      -- io.printMeshGaussData('mesh', {'S', 'E', 'Sdv'}, {header_title = true})
      io.addResultToMeshFile(file, i)
	  -- Read nodal displacement
	  -- Node index
      local node = 1034  -- Center node 
	  local U2   = nodeDisp(node)
	  -- Save load fractor and nodal disp
	  loadFile:write(i,'	', -U2,'	', newLoad,'\n')
	  
   end
   io.closeMeshFile(file)
   loadFile:close()
end
