within dhcSim.DHC.Submodules.CarnotMachines.Evaporator;
model Evaporator
  extends BaseClasses.Carnot(PEle(y=QCon_flow_out/COP));

  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{40,42},{60,62}})));
protected
  Modelica.Blocks.Sources.RealExpression QCon(y=Q_flow_abs)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  m_flow_calc = -Q_flow_abs*COP/(COP + 1)/min(hEva - hIn, -deltah);

  connect(gain.y, QEva_flow_out) annotation (Line(points={{61,52},{80,52},{80,-30},
          {110,-30}}, color={0,0,127}));
  connect(eva.Q_flow, gain.u)
    annotation (Line(points={{11,52},{38,52}}, color={0,0,127}));
  connect(QCon.y, QCon_flow_out)
    annotation (Line(points={{61,-90},{110,-90}}, color={0,0,127}));
  annotation (defaultComponentName="eva",Icon(graphics={Line(points={{0,-80},
          {0,-100},{0,-100}}, color={0,0,255})}));
end Evaporator;
