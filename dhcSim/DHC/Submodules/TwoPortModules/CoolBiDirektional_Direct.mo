within dhcSim.DHC.Submodules.TwoPortModules;
model CoolBiDirektional_Direct
  "Two port model of bidirectional consumer and producer using direct heat transfer"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.TwoPortModules.Interfaces.TwoPortModulesParameters(
      T_start=Medium.T_default);

  Modelica.SIunits.MassFlowRate m_flow_calc "Calculated mass flow rate according to temperatures and load profile";
  Modelica.SIunits.MassFlowRate m_flow_max "Maximum mass flow rate of participant";
  Modelica.SIunits.SpecificEnthalpy hIn;
  Modelica.SIunits.SpecificEnthalpy hSet;

  Buildings.Fluid.Interfaces.PrescribedOutlet coolPro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final T_start=T_start,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final m_flow_small=m_flow_small,
    final use_X_wSet=false)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
protected
  parameter Modelica.SIunits.SpecificEnthalpy deltah=cp_default*0.5
   "Small value for deltah used for regularization";
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  Medium.ThermodynamicState state_inflow_a=Medium.setState_phX(
      p=port_a.p,
      h=noEvent(inStream(port_a.h_outflow)),
      X=noEvent(inStream(port_a.Xi_outflow))) "Inflow state port_a";
  Medium.ThermodynamicState state_inflow_b=Medium.setState_phX(
      p=port_b.p,
      h=noEvent(inStream(port_b.h_outflow)),
      X=noEvent(inStream(port_b.Xi_outflow))) "Inflow state port_b";
  Medium.ThermodynamicState state_set_a=Medium.setState_pTX(
      p=port_a.p,
      T=TRet_in,
      X=Medium.X_default[1:Medium.nXi]) "Set state port_a";
  Medium.ThermodynamicState state_set_b=Medium.setState_pTX(
      p=port_b.p,
      T=TSup_in,
      X=Medium.X_default[1:Medium.nXi]) "Set state port_b";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";
public
  Buildings.Fluid.Interfaces.PrescribedOutlet coolCon(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final T_start=T_start,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final m_flow_small=m_flow_small,
    final use_X_wSet=false)
    annotation (Placement(transformation(extent={{-60,10},{-80,-10}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    m_flow_small=m_flow_small,
    final control_m_flow=true,
    final control_dp=false)
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Modelica.Blocks.Interfaces.RealInput QLoad_in
    "positive = cool consumer; negative = cool producer" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-80})));
  Modelica.Blocks.Interfaces.RealInput TRet_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,80})));
  Modelica.Blocks.Interfaces.RealInput TSup_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,80})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
Modelica.Blocks.Math.Add add
  annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final replaceable package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(final y=m_flow_calc)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,40})));
  Modelica.Blocks.Sources.RealExpression set_dp(final y=dp)
                                                      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={68,40})));
  Modelica.Blocks.Interfaces.RealOutput dp_out "Pressure drop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,60}),  iconTransformation(extent={{100,50},{120,70}})));
equation

  m_flow_max = abs(QLoad_in)/deltah;

 if QLoad_in>=0 then
   hIn = Medium.specificEnthalpy(state=state_inflow_b);
   hSet = Medium.specificEnthalpy(state=state_set_a);
 else
   hIn = Medium.specificEnthalpy(state=state_inflow_a);
   hSet = Medium.specificEnthalpy(state=state_set_b);
 end if;

 m_flow_calc = -sign(QLoad_in)*min(abs(QLoad_in)/max(abs(hIn-hSet), deltah),m_flow_max);

  connect(coolPro.port_b, port_b)
    annotation (Line(points={{80,0},{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, coolCon.port_b)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(coolCon.TSet, TRet_in)
    annotation (Line(points={{-59,-8},{-50,-8},{-50,-120}}, color={0,0,127}));
  connect(TSup_in, coolPro.TSet) annotation (Line(points={{50,-120},{50,-120},{50,
          -58},{50,8},{59,8}}, color={0,0,127}));
  connect(coolCon.port_a, ideSou.port_a)
    annotation (Line(points={{-60,0},{-38,0},{-16,0}}, color={0,127,255}));
  connect(add.y, Q_flow_out)
    annotation (Line(points={{91,-50},{100,-50},{100,-60},{110,-60}},
                                                  color={0,0,127}));
  connect(coolPro.Q_flow, add.u1) annotation (Line(points={{81,8},{90,8},{90,-20},
          {60,-20},{60,-44},{68,-44}}, color={0,0,127}));
  connect(coolCon.Q_flow, add.u2) annotation (Line(points={{-81,-8},{-90,-8},{-90,
          -56},{68,-56}}, color={0,0,127}));
  connect(ideSou.port_b, res.port_a)
    annotation (Line(points={{4,0},{20,0}}, color={0,127,255}));
  connect(res.port_b, coolPro.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(realExpression.y, ideSou.m_flow_in)
    annotation (Line(points={{-1,40},{-12,40},{-12,8}}, color={0,0,127}));
  connect(set_dp.y, dp_out) annotation (Line(points={{79,40},{94,40},{94,60},{
          110,60}}, color={0,0,127}));
  annotation (
    defaultComponentName="ActPro",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-6},{100,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}));
end CoolBiDirektional_Direct;
