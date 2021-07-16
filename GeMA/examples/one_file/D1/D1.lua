Simulation 
{
  name        = 'D1',
  description = 'Three-point Bending - D1 specimen - Omar et al. (2009)'
}

dofile('$SIMULATIONDIR/$SIMULATIONNAME_model.lua')
dofile('$SIMULATIONDIR/$SIMULATIONNAME_solution.lua')
