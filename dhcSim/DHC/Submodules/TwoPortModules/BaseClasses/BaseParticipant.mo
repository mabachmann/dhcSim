within dhcSim.DHC.Submodules.TwoPortModules.BaseClasses;
partial model BaseParticipant
  "Base model of active participant with prescribed flow direction"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.TwoPortModules.Interfaces.TwoPortModulesParameters(
      T_start=Medium.T_default);

  parameter Boolean use_Q_flow_in=false "=true to use QLoad port" annotation (Dialog(group="Thermal load"));
  parameter Boolean use_TSet_in=false "=true to use TSet port" annotation (Dialog(group="Thermal load"));
  parameter Boolean fixedGradient=true
    "=true, to fixed gradient instead of fixed reflow temperature" annotation (Dialog(group="Thermal load", enable=not use_TSet_in));
  parameter Modelica.SIunits.HeatFlowRate QLoad=0.0 "Constant thermal load" annotation (Dialog(group="Thermal load", enable=not use_Q_flow_in));
  parameter Modelica.SIunits.Temperature TSet=Medium.T_default "Reflow temperature" annotation (Dialog(group="Thermal load", enable=not use_TSet_in and not fixedGradient));
  parameter Modelica.SIunits.Temperature TGrad(displayUnit="K")=10
    "Temperature gradient" annotation(Dialog(group="Thermal load", enable=not use_TSet_in and fixedGradient));

  Modelica.SIunits.MassFlowRate m_flow_calc "Calculated mass flow rate according to temperatures and load profile";
  Modelica.SIunits.MassFlowRate m_flow_max "Maximum mass flow rate of participant";
  Modelica.SIunits.HeatFlowRate Q_flow_abs "Absolute of heat flow rate";
  Modelica.SIunits.SpecificEnthalpy hIn;
  Modelica.SIunits.Temperature TIn;
  Modelica.SIunits.SpecificEnthalpy hSet;

  replaceable Buildings.Fluid.HeatExchangers.BaseClasses.PartialPrescribedOutlet heaCoo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final tau=tau,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM)
    annotation (Placement(transformation(extent={{-40,10},{-20,-10}})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow=true,
    final m_flow_small=m_flow_small,
    final show_T=show_T)
    annotation (Placement(transformation(extent={{40,10},{60,-10}})));

  Modelica.Blocks.Interfaces.RealInput QLoad_in(unit="W") if use_Q_flow_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-80})));
  Modelica.Blocks.Interfaces.RealInput TSet_in(unit="K") if use_TSet_in annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-80})));
  Modelica.Blocks.Interfaces.RealOutput dp_out "Pressure drop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70})));

  Modelica.Blocks.Sources.RealExpression set_mFlow(final y=m_flow_calc)
                                                             annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={70,-30})));
  Modelica.Blocks.Sources.RealExpression set_TSet(final y=TSet_internal)
                                                                   annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-70,-30})));
  Modelica.Blocks.Sources.RealExpression set_dp(final y=dp)
                                                      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,70})));

protected
  Modelica.Blocks.Interfaces.RealInput QLoad_internal(unit="W");
  Modelica.Blocks.Interfaces.RealInput TSet_internal(unit="K");

  parameter Modelica.SIunits.SpecificEnthalpy deltah=cp_default*0.5
   "Small value for deltah used for regularization";
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  Medium.ThermodynamicState state_inflow=Medium.setState_phX(
      p=port_a.p,
      h=noEvent(inStream(port_a.h_outflow)),
      X=noEvent(inStream(port_a.Xi_outflow))) "Inflow state";
  parameter Modelica.SIunits.Density rho_default=Medium.density(state=state_default);
  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(state=state_default)
    "Dynamic viscosity at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";
public
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out "Heat flow" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Interfaces.RealOutput QRea_flow_out "Residuum heat flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-70})));
  Modelica.Blocks.Sources.RealExpression set_QFlow(final y=Q_flow_abs)
                                                   annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={30,-76})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM,
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(QLoad_in, QLoad_internal);
  connect(TSet_in, TSet_internal);
  if not use_Q_flow_in then
    QLoad_internal = QLoad;
  end if;

  Q_flow_abs = abs(QLoad_internal);
  hIn = Medium.specificEnthalpy(state=state_inflow);
  TIn = Medium.temperature(state=state_inflow);
  hSet = Medium.specificEnthalpy(state=Medium.setState_pTX(
      p=Medium.p_default,
      T=TSet_internal,
      X=Medium.X_default));

  connect(set_mFlow.y, ideSou.m_flow_in) annotation (Line(points={{59,-30},{44,-30},{44,-8}}, color={0,0,127}));
  connect(set_dp.y, dp_out) annotation (Line(points={{81,70},{110,70}}, color={0,0,127}));
  connect(add.y, QRea_flow_out)
    annotation (Line(points={{81,-70},{110,-70}}, color={0,0,127}));
  connect(set_QFlow.y, add.u2) annotation (Line(points={{41,-76},{49.5,-76},{58,-76}}, color={0,0,127}));
  connect(port_a, heaCoo.port_a) annotation (Line(points={{-100,0},{-70,0},{-40,0}}, color={0,127,255}));
  connect(ideSou.port_b, port_b) annotation (Line(points={{60,0},{80,0},{100,0}}, color={0,127,255}));
  connect(res.port_b, ideSou.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(res.port_a, heaCoo.port_b)
    annotation (Line(points={{0,0},{-20,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}));
end BaseParticipant;
