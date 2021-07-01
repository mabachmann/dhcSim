within dhcSim.DHC.Submodules.CarnotMachines.Condenser;
model Condenser_dp "Condenser using external dp control"
  extends BaseClasses.Carnot_dp(    PEle(y=PEl));

protected
  Modelica.Blocks.Sources.RealExpression QEva(y=Q_flowEva)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  Q_flowEva = Q_flowCon - PEl;
  Q_flowCon = con.Q_flow;
  PEl = Q_flowEva/COP;

  connect(con.Q_flow, QCon_flow_out) annotation (Line(points={{11,52},{60,52},{
          60,-30},{110,-30}}, color={0,0,127}));
  connect(QEva.y, QEva_flow_out)
    annotation (Line(points={{61,-90},{110,-90}}, color={0,0,127}));
  annotation (defaultComponentName="con",Icon(graphics={Line(points={{0,-80},
          {0,-100},{0,-100}}, color={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end Condenser_dp;
