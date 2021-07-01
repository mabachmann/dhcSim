within dhcSim.DHC.Plants;
model absorptionChiller

    import SI = Modelica.SIunits;

    parameter SI.HeatFlowRate Q_flow_eva_nominal "Nominal heat flow rate of evaporator";
    parameter SI.Temperature T_eva = 273.15 + 5 "Temperature of evaporizer";
    parameter SI.Temperature T_con = 273.15 + 40 "Temperature of condenser";
    parameter Boolean use_T_Hea_input = false "Flag if heater temperature is signal";
    parameter SI.Temperature T_hea = 273.15 + 100 "Temperature of heater"
                                                                         annotation(Dialog(enable=use_T_Hea_input==false));

    parameter Real eff_curve[:, :] = [0.15, 0.5; 1, 0.75]
    "Table of part load efficiency curve"
    annotation ();
    parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));

    SI.HeatFlowRate Q_flow_con "Heat flow rate of condenser";
    SI.HeatFlowRate Q_flow_eva "Heat flow rate of evaporator";
    SI.HeatFlowRate Q_flow_hea "Heat flow rate of heater";
    SI.HeatFlowRate Q_flow_abs "Heat flow rate of absorber";

    Real parLoa "Part load factor of refrigerator";
    Real eta_carnot "Carnot efficiency";
    Real zeta_KC "Ideal heat coefficient";
    Real zeta_K "Real heat coefficient";

  Modelica.Blocks.Interfaces.RealInput Q_flow_eva_in "Usable cooling heat flow"
     annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(
    final tableOnFile=false,
    final columns={2},
    final table=eff_curve,
    final smoothness=smoothness)
    annotation (Placement(transformation(extent={{0,-16},{20,4}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-40,-16},{-20,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_eva_nominal)
    annotation (Placement(transformation(extent={{-82,-22},{-62,-2}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_con_expr(y=Q_flow_con)
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_eva_expr(y=Q_flow_eva)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_con_out
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_eva_out
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput zeta_KC_out
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_hea_out
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_hea_expr(y=Q_flow_hea)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_abs_expr(y=Q_flow_abs)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_abs_out
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression zeta_KC_expr(y=zeta_KC)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Interfaces.RealInput T_hea_in(unit="K") if use_T_Hea_input "Input temperature of heater"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

protected
    Modelica.Blocks.Interfaces.RealInput T_hea_internal(unit="K")
    "Needed to connect to conditional connector";
equation
  Q_flow_eva = Q_flow_eva_in;
  parLoa = Q_flow_eva_in / Q_flow_eva_nominal;
  eta_carnot = combiTable1D.y[1];
  zeta_KC = T_eva/(T_con - T_eva) * (T_hea_internal - T_con) / T_hea_internal;
  Q_flow_hea = Q_flow_eva / zeta_K;
  Q_flow_eva + Q_flow_hea + Q_flow_abs + Q_flow_con = 0;
  Q_flow_con + Q_flow_abs - Q_flow_con * (1 + 1/zeta_K) = 0;
  zeta_K = eta_carnot * zeta_KC;

  connect(T_hea_internal, T_hea_in);
  if not use_T_Hea_input then
    T_hea_internal = T_hea;
  end if;

  connect(Q_flow_eva_in, division.u1) annotation (Line(points={{-120,40},{-82,40},
          {-82,0},{-42,0}},   color={0,0,127}));
  connect(realExpression.y, division.u2)
    annotation (Line(points={{-61,-12},{-42,-12}}, color={0,0,127}));
  connect(division.y, combiTable1D.u[1])
    annotation (Line(points={{-19,-6},{-2,-6}},   color={0,0,127}));
  connect(Q_flow_eva_expr.y, Q_flow_eva_out)
    annotation (Line(points={{61,40},{110,40}}, color={0,0,127}));
  connect(Q_flow_con_expr.y, Q_flow_con_out)
    annotation (Line(points={{61,60},{110,60}}, color={0,0,127}));
  connect(Q_flow_hea_expr.y, Q_flow_hea_out)
    annotation (Line(points={{61,20},{110,20}}, color={0,0,127}));
  connect(Q_flow_abs_expr.y, Q_flow_abs_out)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  connect(zeta_KC_expr.y, zeta_KC_out)
    annotation (Line(points={{61,-20},{110,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{102,-100}},
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
end absorptionChiller;
