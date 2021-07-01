within dhcSim.DHC.Submodules.TwoPortModules.Pipe.BaseClasses;
partial model BasePipe "Base model of two port pipe model"
  extends Buildings.Fluid.FixedResistances.BaseClasses.Pipe(
    final dp_nominal=dp_nominal_internal+dp_fixed_nominal,
    final m_flow_nominal=m_flow_nominal_internal,
    final length=length_set,
    final diameter=diameter_internal,
    preDro(final deltaM=deltaM));

  parameter dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes dpType=dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal
    "Define pressure drop calculation"
    annotation (Dialog(group="Pressure drop"));
  parameter Modelica.SIunits.Length diameter_set = 0.1
    "Pipe diameter"
    annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter));
  parameter Modelica.SIunits.Length length_set = 1 "Length of the pipe"
  annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));
  parameter Modelica.SIunits.Velocity v_nominal = 0.15
    "Velocity at m_flow_nominal (used to compute default diameter)"
    annotation(Dialog(group="Pressure drop", enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)"
    annotation(Dialog(
      group="Pressure drop",
      enable=(dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter)));
   final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
       Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
       m_flow=m_flow_nominal,
       rho_a=rho_default,
       rho_b=rho_default,
       mu_a=mu_default,
       mu_b=mu_default,
       length=length_set,
       diameter=diameter_internal,
       roughness=roughness,
       m_flow_small=m_flow_small)
     "Pressure loss of a straight pipe at m_flow_nominal";
  parameter Modelica.SIunits.PressureDifference dp_nominal_set(min=0,displayUnit="Pa") = 10
    "Pressure difference"
    annotation(Dialog(group = "Pressure drop",
      enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_set(displayUnit="kg/s")=1 "Pressure difference"
    annotation (
      Dialog(
        group = "Pressure drop",
        enable=dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter
           or dpType == dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal));

  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
    annotation (Dialog(tab="Flow resistance"));

  //  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
  //  annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.SIunits.PressureDifference dp_fixed_nominal(min=0,displayUnit="Pa") = 0
    "Additional nominal pressure drop of installations and fitting"
    annotation(Dialog(group = "Pressure drop",
      enable=true));

 final parameter Modelica.SIunits.PressureDifference dp_nominal_internal(displayUnit="Pa")=(
   if dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.no_dp then 0
   elseif dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal then dp_nominal_set
   elseif dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter then dpStraightPipe_nominal
   elseif dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal then dpStraightPipe_nominal
   else 0)
   "Pressure difference for internal calculations"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
 final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_internal(displayUnit="kg/s")=(
    if dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.no_dp then 1
    else m_flow_nominal_set)
   "Nominal mass flow rate for internal calculations"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
 final parameter Modelica.SIunits.Length diameter_internal=(
   if dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter then
     diameter_set
   elseif dpType==dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.v_nominal then
     sqrt(4*m_flow_nominal_internal/rho_default/v_nominal/Modelica.Constants.pi)
   else
     diameter_set);

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
end BasePipe;
