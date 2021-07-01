within dhcSim.DHC.Plants;
model compressionChiller
    replaceable package Refrigerant = Modelica.Media.R134a.R134a_ph
    "Refrigerant in the component" annotation (choicesAllMatching=true);

    import SI = Modelica.SIunits;

    parameter SI.HeatFlowRate Q_flow_eva_nominal "Nominal heat flow rate of evaporator";
    parameter SI.Temperature T_eva = 273.15 + 5 "Temperature of evaporizer";
    parameter SI.Temperature T_conOut = 273.15+35 "Temperature of condenser outlet (typically supercooled)";
    parameter SI.TemperatureDifference dT_con = 5 "Temperature difference between condenser outlet and condensing temperature";

    parameter Real eff_curve[:, :] = [0.15, 0.5; 1, 0.75]
    "Table of part load efficiency curve"
    annotation ();
    parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));

    SI.HeatFlowRate Q_flow_con "Heat flow rate of condenser";
    SI.HeatFlowRate Q_flow_eva "Heat flow rate of evaporator";
    SI.Power P_el "Electrical power demand";
    SI.MassFlowRate m_flow_rfr "Mass flow rate of refrigerant";
    Real parLoa "Part load factor of refrigerator";
    Real eta_cmpr "Efficiency of compressor";
    SI.SpecificEnthalpy h_2 "Specific enthalpy of refrigerant at compressor outlet";

    final parameter SI.Temperature T_con = T_conOut + dT_con "Condenser temperature";
    final parameter Refrigerant.ThermodynamicState state_1 = Refrigerant.setState_Tx(T=T_eva, x=1) "State at evaporator outlet";
    final parameter SI.Pressure p_eva = Refrigerant.pressure(state_1) "Pressure of evaporator (low pressure level)";
    final parameter SI.Pressure p_con = Refrigerant.pressure(Refrigerant.setState_Tx(T=T_con, x=0)) "Pressure of condenser (high pressure level)";
    final parameter SI.SpecificEnthalpy h_1 = Refrigerant.specificEnthalpy(state_1) "Specific enthalpy of refrigerant at evaporator outlet";
    final parameter Refrigerant.ThermodynamicState state_2_rev = Refrigerant.setState_ps(p=p_con, s=Refrigerant.specificEntropy(state_1)) "Ideal state at compressor outlet";
    final parameter SI.SpecificEnthalpy h_2_rev = Refrigerant.specificEnthalpy(state_2_rev) "Specific ideal enthalpy of refrigerant at compressor outlet";
    final parameter Refrigerant.ThermodynamicState state_3 = Refrigerant.setState_pT(p=p_con, T=T_conOut) "State at condenser outlet";
    final parameter SI.SpecificEnthalpy h_3 = Refrigerant.specificEnthalpy(state_3) "Specific enthalpy of refrigerant at condenser outlet";
    final parameter Refrigerant.ThermodynamicState state_4 = Refrigerant.setState_ph(p=p_eva, h=h_3) "State at throttle outlet";
    final parameter SI.SpecificEnthalpy h_4 = Refrigerant.specificEnthalpy(state_4) "Specific enthalpy of refrigerant at throttle outlet";

  Modelica.Blocks.Interfaces.RealInput Q_flow_eva_in "Usable cooling heat flow"
     annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(
    final tableOnFile=false,
    final columns={2},
    final table=eff_curve,
    final smoothness=smoothness)
    annotation (Placement(transformation(extent={{0,-16},{20,4}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-40,-16},{-20,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_eva_nominal)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_con_expr(y=Q_flow_con)
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_eva_expr(y=Q_flow_eva)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Sources.RealExpression P_el_expr(y=P_el)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_con_out
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_eva_out
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput eta_cmpr_out
    annotation (Placement(transformation(extent={{100,-20},{120,0}}),
        iconTransformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_out
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
   Q_flow_eva = Q_flow_eva_in;
   Q_flow_con + Q_flow_eva + P_el = 0;
   Q_flow_eva = m_flow_rfr * (h_1 - h_4);
   P_el = m_flow_rfr * (h_2 - h_1);
   parLoa = Q_flow_eva / Q_flow_eva_nominal;
   eta_cmpr = combiTable1D.y[1];
   h_2 = h_1 + (h_2_rev - h_1) / eta_cmpr;

  connect(realExpression.y, division.u2)
    annotation (Line(points={{-59,-40},{-52,-40},{-52,-12},{-42,-12}},
                                                   color={0,0,127}));
  connect(division.y, combiTable1D.u[1])
    annotation (Line(points={{-19,-6},{-2,-6}},   color={0,0,127}));
  connect(combiTable1D.y[1], eta_cmpr_out) annotation (Line(points={{21,-6},{32,
          -6},{32,-10},{110,-10}},
                               color={0,0,127}));
  connect(P_el_expr.y, P_el_out)
    annotation (Line(points={{61,20},{110,20}}, color={0,0,127}));
  connect(Q_flow_eva_expr.y, Q_flow_eva_out)
    annotation (Line(points={{61,40},{86,40},{86,50},{110,50}},
                                                color={0,0,127}));
  connect(Q_flow_con_expr.y, Q_flow_con_out)
    annotation (Line(points={{61,60},{86,60},{86,80},{110,80}},
                                                color={0,0,127}));
  connect(Q_flow_eva_in, abs1.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(abs1.y, division.u1)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
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
          textString="compression
chiller
")}),                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end compressionChiller;
