within dhcSim.DHC.Submodules.TwoPortModules;
model ActiveCoolProducer_Direct
  "Two port model of active district cooling grid using direct heat transfer"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.TwoPortModules.Interfaces.TwoPortModulesParameters(
      T_start=Medium.T_default);

  Buildings.Fluid.Interfaces.PrescribedOutlet pro2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final T_start=T_start,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final m_flow_small=m_flow_small,
    final use_X_wSet=false,
    final use_TSet=true,
    QMax_flow=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
protected
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.Density rho_default=Medium.density(state_default);
  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at nominal condition";
public
  Buildings.Fluid.Interfaces.PrescribedOutlet pro1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final T_start=T_start,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final m_flow_small=m_flow_small,
    final use_X_wSet=false,
    QMin_flow=0) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-70,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final control_dp=true,
    m_flow_small=m_flow_small,
    final control_m_flow=false)
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Modelica.Blocks.Interfaces.RealInput dp_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-80})));
  Modelica.Blocks.Interfaces.RealInput THea_in( unit="K", displayUnit="degC") annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,80})));
  Modelica.Blocks.Interfaces.RealInput TCoo_in( unit="K", displayUnit="degC") annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,80})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
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
    // final homotopyInitialization=homotopyInitialization,
  Modelica.Blocks.Interfaces.RealOutput m_flow_out(unit="kg/s") annotation (
      Placement(transformation(extent={{100,40},{120,60}}), iconTransformation(
          extent={{100,40},{120,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=ideSou.m_flow)
    annotation (Placement(transformation(extent={{48,40},{68,60}})));
equation
  connect(dp_in, ideSou.dp_in) annotation (Line(points={{0,120},{0,120},{0,92},{
          0,20},{0,8}}, color={0,0,127}));
  connect(pro1.TSet, THea_in)
    annotation (Line(points={{-59,-8},{-50,-8},{-50,-120}}, color={0,0,127}));
  connect(TCoo_in,pro2. TSet) annotation (Line(points={{50,-120},{50,-120},{50,
          -58},{50,8},{59,8}}, color={0,0,127}));
  connect(add.y, Q_flow_out)
    annotation (Line(points={{91,-50},{110,-50}}, color={0,0,127}));
connect(pro2.Q_flow, add.u1) annotation (Line(points={{81,8},{90,8},{90,-20},{
          60,-20},{60,-44},{68,-44}},color={0,0,127}));
connect(pro1.Q_flow, add.u2) annotation (Line(points={{-81,-8},{-90,-8},{-90,
          -56},{68,-56}},
                        color={0,0,127}));
  connect(ideSou.port_b, res.port_a)
    annotation (Line(points={{4,0},{20,0}}, color={0,127,255}));
  connect(realExpression.y, m_flow_out)
    annotation (Line(points={{69,50},{110,50}}, color={0,0,127}));
  connect(pro1.port_b, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(pro1.port_a, ideSou.port_a)
    annotation (Line(points={{-60,0},{-16,0}}, color={0,127,255}));
  connect(pro2.port_a, res.port_b)
    annotation (Line(points={{60,0},{40,0}}, color={0,127,255}));
  connect(pro2.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
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
end ActiveCoolProducer_Direct;
