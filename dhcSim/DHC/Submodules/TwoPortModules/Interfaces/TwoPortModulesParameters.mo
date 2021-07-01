within dhcSim.DHC.Submodules.TwoPortModules.Interfaces;
record TwoPortModulesParameters
  "Record of needed parameters for two port modules"
  parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  // parameter Boolean homotopyInitialization = true "= true, use homotopy method"
  //  annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Temperature T_start=273.15+20
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwoPortModulesParameters;
