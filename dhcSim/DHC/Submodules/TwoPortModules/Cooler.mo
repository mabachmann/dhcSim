within dhcSim.DHC.Submodules.TwoPortModules;
model Cooler "Two port model of a coolerTwo port model of a cooler including bypass mass flow rate"
  extends BaseClasses.BaseParticipant(redeclare
      Buildings.Fluid.HeatExchangers.SensibleCooler_T heaCoo(final T_start=T_start,
        final energyDynamics=energyDynamics));

  parameter Modelica.SIunits.MassFlowRate m_flow_min = 0.02 * m_flow_nominal "Minimum mass flow rate of consumer";

  Modelica.SIunits.MassFlowRate m_flow_bp "bypass mass flow rate";

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM,
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow=true,
    final m_flow_small=m_flow_small,
    final show_T=show_T)
    annotation (Placement(transformation(extent={{0,50},{20,30}})));
  Modelica.Blocks.Sources.RealExpression set_mFlow_bypass(final y=m_flow_bp)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={28,24})));
equation
  if not use_TSet_in then
    if fixedGradient then
      TSet_internal = TIn - TGrad;
    else
      TSet_internal = TSet;
    end if;
  end if;

  m_flow_max = -Q_flow_abs/min(hSet - hIn, -deltah);
  m_flow_calc = m_flow_max;

  if m_flow_calc < m_flow_min then
    m_flow_bp=m_flow_min-m_flow_calc;
  else
    m_flow_bp=0;
  end if;

  connect(set_TSet.y, heaCoo.TSet) annotation (Line(points={{-59,-30},{-50,-30},
          {-50,-8},{-42,-8}}, color={0,0,127}));
  connect(heaCoo.Q_flow, Q_flow_out) annotation (Line(points={{-19,-8},{20,-8},
          {20,-50},{110,-50}}, color={0,0,127}));
  connect(heaCoo.Q_flow, add.u1) annotation (Line(points={{-19,-8},{20,-8},{20,-64},
          {58,-64}}, color={0,0,127}));
  connect(port_a, heaCoo.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(port_a, res1.port_a) annotation (Line(points={{-100,0},{-78,0},{-78,40},
          {-40,40}}, color={0,127,255}));
  connect(res1.port_b, ideSou1.port_a)
    annotation (Line(points={{-20,40},{0,40}}, color={0,127,255}));
  connect(ideSou1.port_b, port_b) annotation (Line(points={{20,40},{84,40},{84,0},
          {100,0}}, color={0,127,255}));
  connect(set_mFlow_bypass.y, ideSou1.m_flow_in)
    annotation (Line(points={{17,24},{4,24},{4,32}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-6},{0,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end Cooler;
