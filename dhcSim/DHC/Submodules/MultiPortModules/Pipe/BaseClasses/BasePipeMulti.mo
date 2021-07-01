within dhcSim.DHC.Submodules.MultiPortModules.Pipe.BaseClasses;
partial model BasePipeMulti "Base model of multi port pipe model"
  extends dhcSim.Fluid.Interfaces.LumpedMultiVolumeDeclarations;
  parameter dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes dpType=dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal
    "Define pressure drop calculation"
    annotation (Dialog(group="Pressure drop"));
  parameter Integer nSeg(min=1)= 1 "Number of volume segments";
  parameter Modelica.SIunits.Length[nLev] diameter = ones(nLev)
    "Pipe diameter"
    annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter));
  parameter Modelica.SIunits.PressureDifference[nLev] dp_fixed_nominal(min=0,displayUnit="Pa") = zeros(nLev)
    "Additional nominal pressure drop of installations and fitting"
    annotation(Dialog(group = "Pressure drop",
      enable=true));
  parameter Modelica.SIunits.Length length = 10 "Length of the pipe"
  annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));
  parameter Modelica.SIunits.Velocity[nLev] v_nominal = ones(nLev)
    "Velocity at m_flow_nominal (used to compute default diameter)"
    annotation(Dialog(group="Pressure drop", enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)"
    annotation(Dialog(
      group="Pressure drop",
      enable=(dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter)));
  parameter Modelica.SIunits.PressureDifference[nLev] dp_nominal = ones(nLev)    "Nominal pressure difference"
    annotation(Dialog(group = "Pressure drop",
      enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal));
  parameter Modelica.SIunits.MassFlowRate[nLev] m_flow_nominal = ones(nLev) "Nominal mass flow"
    annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Medium.MassFlowRate[nLev] m_flow_small(min=0) = 1E-4.*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  // parameter Boolean homotopyInitialization=true "= true, use homotopy method"
  //  annotation (Evaluate=true,Dialog(tab="Advanced"));

  // Diagnostics
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
    annotation (Dialog(tab="Flow resistance"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance,
               tab="Flow resistance"));
  parameter Real deltaM = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

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

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,255}),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,255}),
        Text(
          extent={{-40,14},{42,-10}},
          lineColor={0,0,0},
          textString="%nSeg")}));
end BasePipeMulti;
