within dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Consumer;
model DC_BiDirectConsumer
  "Multi port model of district cooling consumer with continous demand and bi directional flow."
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal heat flow rate"
                                                                                 annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_pro "Nominal heat flow rate of intetrnal cool producer"
                                                                                                                annotation(Dialog(group = "Nominal condition"));
  parameter dhcSim.Fluid.Types.FeedingTemperaturePro supTempType=dhcSim.Fluid.Types.FeedingTemperaturePro.fixed
    "Define how supply temperature is caclulated if producer";
  parameter dhcSim.Fluid.Types.FeedingTemperatureCon retTempType=dhcSim.Fluid.Types.FeedingTemperatureCon.fixed
    "Define how return temperature is caclulated if consumer";

  // Return Temperatur
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
  "Return temperature if supTempType=fixed" annotation(Dialog(enable=
          supTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.fixed));
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
  "Return temperature if retTempType=fixed" annotation(Dialog(enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.fixed));
  parameter Modelica.SIunits.TemperatureDifference deltaT=5 "Temperature difference between inlet and outlet if supTempType or retTempType = dTFix "
    annotation(Dialog(enable=supTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.dTFix
           or retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.dTFix));

  parameter Modelica.SIunits.Temperature TNetIn_nominal=Medium.T_default "Nominal Temperature of inflow at network side"
                                                                                                                        annotation(Dialog(group = "Nominal condition", enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger));
  parameter Modelica.SIunits.Temperature TNetOut_nominal=Medium.T_default "Nominal Temperature of outflow at network side"
                                                                                                                          annotation(Dialog(group = "Nominal condition", enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger));
  parameter Modelica.SIunits.Temperature TBuiIn_nominal=Medium.T_default "Nominal Temperature of inflow at building side"
                                                                                                                         annotation(Dialog(group = "Nominal condition", enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger));
  parameter Modelica.SIunits.Temperature TBuiOut_nominal=Medium.T_default "Nominal Temperature of outflow at building side"
                                                                                                                           annotation(Dialog(group = "Nominal condition", enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger));

  // Table
  final parameter String tableName="table" "Table name" annotation (Dialog(group="Table data"));
  parameter String fileName="NoName" "File name" annotation (
      Dialog(
      group="Table data",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,50},{120,70}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-76})));
  dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.DC_BiDirectConsumer
    conPro(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final tableName=tableName,
    final fileName=fileName,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
    final show_T=show_T,
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
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final TNetRetSet=TNetRetSet,
    final deltaT=deltaT,
    final linearizeFlowResistance=linearizeFlowResistance,
    final m_flow_small=m_flow_small,
    final supTempType=supTempType,
    final retTempType=retTempType,
    final TNetSupSet=TNetSupSet,
    final Q_flow_nominal=Q_flow_nominal,
    final Q_flow_nominal_pro=Q_flow_nominal_pro,
    final TNetIn_nominal=TNetIn_nominal,
    final TNetOut_nominal=TNetOut_nominal,
    final TBuiIn_nominal=TBuiIn_nominal,
    final TBuiOut_nominal=TBuiOut_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out annotation (Placement(
        transformation(extent={{100,80},{120,100}}), iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=270,
        origin={-70,-76})));

  Modelica.Blocks.Interfaces.RealInput y_Pro(min=0, max=1)
    "Input signal of internal producer y=0..1"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
equation
  connect(conPro.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}},
                            color={0,127,255}));
  connect(conPro.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}},
                             color={0,127,255}));
  connect(conPro.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}},
                       color={0,127,255}));
  connect(conPro.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}},
                          color={0,127,255}));

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  connect(y_Pro, conPro.y_Pro) annotation (Line(points={{0,120},{0,68},{-26,68},
          {-26,0},{-12,0}}, color={0,0,127}));
  connect(conPro.Q_flow_out, Q_flow_out) annotation (Line(points={{11,-2},{30,-2},
          {30,60},{110,60}}, color={0,0,127}));
  connect(conPro.dp_out, dp_out) annotation (Line(points={{11,2},{24,2},{24,90},
          {110,90}}, color={0,0,127}));
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
          extent={{-33,-6},{33,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid,
          origin={-2.66454e-15,37},
          rotation=90),
        Rectangle(
          extent={{-35,6},{35,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={1.77636e-15,-31},
          rotation=90),
        Rectangle(
          extent={{-50,44},{50,-36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{-50,38},{50,-42}},
          lineColor={0,0,0},
          textString="BiDiC"),
        Text(
          extent={{-150,-136},{150,-96}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DC_BiDirectConsumer;
