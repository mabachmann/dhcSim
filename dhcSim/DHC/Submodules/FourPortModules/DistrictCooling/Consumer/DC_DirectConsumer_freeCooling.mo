within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer;
model DC_DirectConsumer_freeCooling
  "Four port model of district cooling consumer with continous demand and free cooling capacity."
  extends
    dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses.DC_DirectConsumer;

  parameter Modelica.SIunits.Temperature T_lim_upper = 273.15 + 10 "Upper temperature limit";
  parameter Modelica.SIunits.Temperature T_lim_lower = 273.15 + 5 "Lower temperature limit";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_freeCool_max = 1000 "Maximum free cooling heat flow rate";

  Modelica.SIunits.HeatFlowRate Q_flow_freeCool "Free cooling heat flow rate";
  Modelica.SIunits.HeatFlowRate Q_flow_conv "Conventiional cooling hat flow rate";

  Modelica.Blocks.Interfaces.RealInput T_Amb_in
    "Ambient temperature input signal "
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=T_lim_lower,
    final uHigh=T_lim_upper,
    final pre_y_start=true)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_freeCooling_out annotation (
      Placement(transformation(extent={{100,74},{120,94}}), iconTransformation(
          extent={{100,74},{120,94}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_freeCool)
    annotation (Placement(transformation(extent={{50,74},{70,94}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_conv_out annotation (Placement(
        transformation(extent={{100,-96},{120,-76}}), iconTransformation(extent=
           {{100,-96},{120,-76}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=Q_flow_conv)
    annotation (Placement(transformation(extent={{40,-96},{60,-76}})));
equation

  // Q_flowTot = loadTable.y[1];
  Q_flowTot = Q_flow_conv;

  if hys.y == false then
    Q_flow_freeCool = min(Q_flow_freeCool_max, loadTable.y[1]);
    Q_flow_conv = max(0, loadTable.y[1] - Q_flow_freeCool);
  else
    Q_flow_freeCool = 0;
    Q_flow_conv = loadTable.y[1];
  end if;

  connect(T_Amb_in,hys. u) annotation (Line(points={{-120,0},{-94,0},{-94,-30},{
          -82,-30}}, color={0,0,127}));
  connect(realExpression.y, Q_flow_freeCooling_out) annotation (Line(points={{71,84},
          {110,84}},                       color={0,0,127}));
  connect(realExpression1.y, Q_flow_conv_out)
    annotation (Line(points={{61,-86},{110,-86}}, color={0,0,127}));
end DC_DirectConsumer_freeCooling;
