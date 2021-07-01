within dhcSim.DHC.Networks.BaseClasses;
partial model BaseGrid "Base class for grid module"
    extends dhcSim.Fluid.Interfaces.LumpedMultiVolumeDeclarations(final mSenFac=
       1, redeclare final replaceable package Medium = Buildings.Media.Water);

  // General parameters
  parameter Integer nMix(min=1) "Number of mixing connection points";
  parameter Integer nPip(min=1) "Number of pipes";
  parameter Modelica.SIunits.Pressure pAbs = p_start[1] "Absolute pressure level of grid in pressure point";

  // Pipe
  parameter dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes dpType=dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.dp_nominal
    "Define pressure drop calculation"
    annotation (Dialog(group="Pressure drop"));
  parameter Integer[nPip] nSeg= fill(1, nPip) "Number of volume segments";
  parameter Modelica.SIunits.Length[nPip, nLev] diameter = fill(0.1, nPip, nLev)
    "Pipe diameter";
  parameter Modelica.SIunits.Length[nPip] length = fill(10, nPip) "Length of the pipe";
  parameter Modelica.SIunits.Velocity[nPip, nLev] v_nominal_pip = fill(2, nPip, nLev)
    "Velocity at m_flow_nominal (used to compute default diameter)";
  parameter Modelica.SIunits.PressureDifference[nPip, nLev] dp_fixed_nominal_pip(min=0,displayUnit="Pa") = zeros(nPip, nLev)
    "Additional nominal pressure drop of pipes"
    annotation(Dialog(enable=true));
  parameter Modelica.SIunits.Length roughness(min=0)=2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)";
  parameter Modelica.SIunits.PressureDifference[nPip, nLev] dp_nominal_pip = fill(10, nPip, nLev) "Pressure difference";
  parameter Modelica.SIunits.MassFlowRate[nPip, nLev] m_flow_nominal_pip = fill(1, nPip, nLev) "Pressure difference";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Medium.MassFlowRate[nPip, nLev] m_flow_small_pip(min=0) = 1E-4.*abs(
    m_flow_nominal_pip) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

    //  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    //    annotation (Evaluate=true,Dialog(tab="Advanced"));

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

  // Connection points
  parameter Integer MixNPrt[nMix] = ones(nMix) "Number of connection ports for each mixing volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_conPoi = 1
    "Nominal mass flow rate for connection points";
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance";

  //Heat losses
  parameter Modelica.SIunits.Length disPip=10
    "Fictive pipe distance, used to calculate fictive Resistance" annotation (Dialog(group="Heat losses"));
  parameter Modelica.SIunits.Length uniWidth=1 "Universal width" annotation (Dialog(group="Heat losses"));
  parameter Modelica.SIunits.Temperature T_surf_a_start=293.15
    "Initial temperature at surf_a, used if steadyStateInitial = false"
  annotation (Dialog(tab="Initialization",group="Heat losses"));
  parameter Modelica.SIunits.Temperature T_surf_b_start=283.15
    "Initial temperature at surf_b, used if steadyStateInitial = false"
  annotation (Dialog(tab="Initialization",group="Heat losses"));

  Buildings.Fluid.Storage.ExpansionVessel expansionVessel(
    redeclare each final package Medium = Medium,
    final V_start=1E-4,
    final p(displayUnit="Pa") = pAbs,
    final p_start(displayUnit="Pa") = pAbs,
    final T_start=T_start[1])
    annotation (Placement(transformation(extent={{-50,-58},{-30,-38}})));

  dhcSim.Fluid.Delays.MultipleDelays[nMix] mix(
    redeclare each final package Medium = Medium,
    final nPorts=MixNPrt,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final tau=tau,
    each final nLev=nLev,
    each final mDyn_flow_nominal=m_flow_nominal_conPoi) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-48})));

replaceable dhcSim.DHC.Submodules.MultiPortModules.Pipe.AdiabatePipe[nPip] pipe(
    redeclare each package Medium = Medium,
    each nLev=nLev,
    nSeg=nSeg,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each p_start=p_start,
    each T_start=T_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal,
    each mSenFac=mSenFac,
    diameter=diameter,
    dp_nominal=dp_nominal_pip,
    m_flow_nominal=m_flow_nominal_pip,
    each allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small_pip,
    each show_T=show_T,
    each ReC=ReC,
    each from_dp=from_dp,
    each linearizeFlowResistance=linearizeFlowResistance,
    each deltaM=deltaM,
    dp_fixed_nominal=dp_fixed_nominal_pip,
    length=length,
    v_nominal=v_nominal_pip,
    each roughness=roughness,
    each final dpType=dpType) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,-50})));

    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})),
              Icon(graphics={
        Line(points={{-80,-22}}, color={255,0,0}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-80,20},{-80,80},{80,80},{80,20}}, color={255,0,0}),
        Line(points={{-80,-20},{-80,-80},{80,-80},{80,-20}}, color={28,108,200}),
        Rectangle(
          extent={{-100,20},{-60,-20}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,12},{-58,-28}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Ellipse(
          extent={{60,20},{100,-20}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,14},{94,-14}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,20},{40,-20}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{6,14},{34,-14}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{20,80},{20,20}}, color={255,0,0}),
        Line(points={{20,-80},{20,-20}}, color={28,108,200})}));
end BaseGrid;
