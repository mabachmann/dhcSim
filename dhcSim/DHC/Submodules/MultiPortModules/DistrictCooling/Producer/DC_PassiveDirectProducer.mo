within dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Producer;
model DC_PassiveDirectProducer
  "Multi port module of PassiveProducerMulti"
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

  // Return Temperatur
  parameter dhcSim.Fluid.Types.FeedingTemperaturePro retTempType=dhcSim.Fluid.Types.FeedingTemperaturePro.fixed
    "Define how return temperature is caclulated";
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
  "Return temperature if TempType=fixed" annotation(Dialog(enable=retTempType
           == dhcSim.Fluid.Types.FeedingTemperaturePro.fixed));
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
  "Return temperature if TempType=fixed" annotation(Dialog(enable=retTempType
           == dhcSim.Fluid.Types.FeedingTemperaturePro.fixed));
  parameter Modelica.SIunits.TemperatureDifference deltaT=5 "Temperature difference between inlet and outlet if retTempType = dTFix "
    annotation(Dialog(enable=retTempType == dhcSim.Fluid.Types.FeedingTemperaturePro.dTFix));

  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance";

  dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Producer.DC_PassiveDirectProducer
    pasPro(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final deltaM=deltaM,
    final TNetSupSet=TNetSupSet,
    final TNetRetSet=TNetRetSet,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final p_start_1=p_start[iLev1],
    final T_start_1=T_start[iLev1],
    final X_start_1=X_start[iLev1, :],
    final C_start_1=C_start[iLev1, :],
    final C_nominal_1=C_nominal[iLev1, :],
    final p_start_2=p_start[iLev2],
    final T_start_2=T_start[iLev2],
    final X_start_2=X_start[iLev2, :],
    final C_start_2=C_start[iLev2, :],
    final C_nominal_2=C_nominal[iLev2, :],
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final deltaT=deltaT,
    final retTempType=retTempType)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,70},{120,90}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,90})));

equation

  connect(pasPro.Q_flow_out, Q_flow_out) annotation (Line(points={{11,0},{26,0},
          {26,80},{110,80}}, color={0,0,127}));
  connect(pasPro.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}},
                            color={0,127,255}));
  connect(pasPro.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}},
                             color={0,127,255}));
  connect(pasPro.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}},
                       color={0,127,255}));
  connect(pasPro.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}},
                          color={0,127,255}));

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,54},{100,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-46},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-25,-6},{25,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid,
          origin={0,29},
          rotation=90),
        Rectangle(
          extent={{-25,6},{25,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,-21},
          rotation=90),
        Rectangle(
          extent={{-50,44},{50,-36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{-48,6},{52,-74}},
          lineColor={0,0,0},
          textString="PDP
"),     Text(
          extent={{-152,-106},{148,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DC_PassiveDirectProducer;
