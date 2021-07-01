within dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Consumer;
model DH_DirectHeatConsumer
  "Four port model of district heating consumer model."
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.ExternalProfiles(
      QFlow_table(final y=max(loadTable.y[1]*ProfCtrl, 0.0)), final columns={2});

  extends
    dhcSim.DHC.Submodules.FourPortModules.BaseClasses.SupplyReturnTemperatures;

  Modelica.SIunits.Temperature TRetInt "Internal calculated return temperature of consumer on grid side";

  // Heating curve
  parameter Boolean use_HeatingCurve=false "=true, to use heating curve";
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
    "Return temperature if use_HeatingCurve=false"
                                                  annotation(Dialog(enable=not use_HeatingCurve));
  parameter Modelica.SIunits.Temperature TGradHX = 5 "Graedigkeit of internal heat exchanger if use_HeatingCurve=true"
                                                                                                                      annotation(Dialog(enable= use_HeatingCurve));

  // Other
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance" annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Real ProfCtrl = 1 "Control parameter for profile usage";
  parameter Modelica.SIunits.MassFlowRate m_flow_min = 0.02 * m_flow_nominal "Minimum mass flow rate of consumer";

  TwoPortModules.Cooler actCon(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    final use_Q_flow_in=true,
    final from_dp=from_dp,
    final deltaM=deltaM,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final use_TSet_in=true,
    final tau=tau,
    final linearizeFlowResistance=linearizeFlowResistance,
    final T_start=T_start_1,
    final fixedGradient=false,
    final m_flow_small=m_flow_small,
    m_flow_min=m_flow_min)           annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,0})));
protected
  Modelica.Blocks.Sources.RealExpression TReturn(final y=TRetInt)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
public
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out(unit="W") annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={
            {100,10},{120,30}})));
equation
   if use_HeatingCurve==true then
     TRetInt = hotWatRes.TRet + TGradHX;
   else
     TRetInt = TNetRetSet;
   end if;

  connect(actCon.port_a, spl1[1].port_3)
    annotation (Line(points={{0,10},{0,10},{0,50}}, color={0,127,255}));
  connect(actCon.port_b, spl2[1].port_3)
    annotation (Line(points={{0,-10},{0,-30},{0,-50}}, color={0,127,255}));
  connect(QFlow_table.y, actCon.QLoad_in) annotation (Line(points={{-19,0},{-14,
          0},{-14,4},{-8,4}}, color={0,0,127}));
  connect(actCon.Q_flow_out, Q_flow_out) annotation (Line(points={{-5,-11},{-5,
          -20},{80,-20},{80,-20},{110,-20}}, color={0,0,127}));
  connect(actCon.dp_out, dp_out) annotation (Line(points={{7,-11},{7,-14},{60,
          -14},{60,20},{110,20}}, color={0,0,127}));
  connect(TReturn.y, actCon.TSet_in) annotation (Line(points={{-19,-20},{-14,-20},
          {-14,-4},{-8,-4}}, color={0,0,127}));
  annotation (defaultComponentName="actCon", Icon(graphics={
        Rectangle(
          extent={{-25,-6},{25,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,25},
          rotation=90),
        Rectangle(
          extent={{-25,6},{25,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,-25},
          rotation=90),
        Rectangle(
          extent={{-50,40},{50,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{-50,40},{50,-40}},
          lineColor={0,0,0},
          textString="AC")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DH_DirectHeatConsumer;
