within dhcSim.DHC.Submodules.TwoPortModules;
model PrescribedCoolProducer
  "Two port model of district cooling prescribed producer"
  extends BaseClasses.BaseParticipant(redeclare
      Buildings.Fluid.HeatExchangers.SensibleCooler_T heaCoo(final T_start=T_start,
        final energyDynamics=energyDynamics));
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

  connect(set_TSet.y, heaCoo.TSet) annotation (Line(points={{-59,-30},{-50,-30},
          {-50,-8},{-42,-8}}, color={0,0,127}));
  connect(heaCoo.Q_flow, Q_flow_out) annotation (Line(points={{-19,-8},{20,-8},
          {20,-50},{110,-50}}, color={0,0,127}));
  connect(heaCoo.Q_flow, add.u1) annotation (Line(points={{-19,-8},{20,-8},{20,-64},
          {58,-64}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,6},{100,-6}},
          lineColor={217,67,180},
          pattern=LinePattern.None,
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-6},{0,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end PrescribedCoolProducer;
