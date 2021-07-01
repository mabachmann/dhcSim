within dhcSim.DHC.Submodules.MultiPortModules.BaseClasses;
partial model BaseMultiPortModule
  extends dhcSim.Fluid.Interfaces.LumpedMultiVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
  final computeFlowResistance=true);

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)=10
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
                                                                           annotation (Dialog(tab="Dynamics"));

  // Diagnostics
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));

  Modelica.Fluid.Interfaces.FluidPorts_a[nLev] ports_a(
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,40},{110,-40}})));
  Modelica.Fluid.Interfaces.FluidPorts_b[nLev] ports_b(
    redeclare final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,40},{-110,-40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseMultiPortModule;
