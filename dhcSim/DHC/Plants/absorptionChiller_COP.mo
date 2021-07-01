within dhcSim.DHC.Plants;
model absorptionChiller_COP

    import SI = Modelica.SIunits;

    parameter SI.HeatFlowRate Q_flow_eva_nominal "Nominal heat flow rate of evaporator";
    parameter Real COP_nominal "Nominal thermal COP (Cooling load / heating load)";

    SI.HeatFlowRate Q_flow_con "Heat flow rate of condenser";
    SI.HeatFlowRate Q_flow_eva "Heat flow rate of evaporator";
    SI.HeatFlowRate Q_flow_hea "Heat flow rate of heater";

  Modelica.Blocks.Interfaces.RealInput Q_flow_eva_in "Usable cooling heat flow"
     annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_con_expr(y=Q_flow_con)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_eva_expr(y=Q_flow_eva)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_con_out
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_eva_out
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_hea_out
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_hea_expr(y=Q_flow_hea)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation

  Q_flow_eva = abs(Q_flow_eva_in);

  Q_flow_hea = Q_flow_eva/COP_nominal;

  Q_flow_con = Q_flow_eva + Q_flow_hea;

  connect(Q_flow_eva_expr.y, Q_flow_eva_out) annotation (Line(points={{61,80},{84,
          80},{84,80},{110,80}}, color={0,0,127}));
  connect(Q_flow_con_expr.y, Q_flow_con_out) annotation (Line(points={{61,40},{82,
          40},{82,40},{110,40}}, color={0,0,127}));
  connect(Q_flow_hea_expr.y, Q_flow_hea_out)
    annotation (Line(points={{61,0},{82,0},{82,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-62,92},{62,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={155,217,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,78},{0,-16}},
          color={255,255,255},
          thickness=0.5),
        Line(
          points={{0,47},{0,-47}},
          color={255,255,255},
          thickness=0.5,
          origin={0,29},
          rotation=90),
        Line(
          points={{32,62},{-30,-2}},
          color={255,255,255},
          thickness=0.5),
        Line(
          points={{31,32},{-31,-32}},
          color={255,255,255},
          thickness=0.5,
          origin={-1,30},
          rotation=90),
        Text(
          extent={{-106,-40},{108,-126}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={155,217,255},
          fillPattern=FillPattern.Solid,
          textString="absorption
chiller
")}),                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end absorptionChiller_COP;
