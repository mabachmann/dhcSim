within dhcSim.DHC.Submodules.MultiPortModules.DistrictHeating.Consumer;
model DH_DirectConsumer "Multi port model of district heating consumer model."
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  replaceable parameter dhcSim.Data.SystemTemperatures sysTem(
    m=1.1,
    TRoo_nominal=293.15,
    TRoo=293.15,
    TAmb_nominal=258.15,
    TSup_nominal=343.15,
    TRet_nominal=323.15) annotation (
    Dialog(group="Nominal Conditions", enable=use_HeatingCurve),
    choicesAllMatching=true,
    Placement(transformation(extent={{-82,72},{-62,92}})));

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

    // Heating curve
  parameter Boolean use_HeatingCurve=false "=true, to use heating curve";
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
    "Return temperature on primary side"
                                        annotation(Dialog(enable=not use_HeatingCurve));
  parameter Modelica.SIunits.Temperature TGradHX = 5 "Graedigkeit of internal heat exchanger if use_HeatingCurve=true" annotation(Dialog(enable=use_HeatingCurve==true));

  //other
  final parameter Real ProfCtrl = 1 "Control parameter for profile usage";
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance";
  parameter Modelica.SIunits.MassFlowRate m_flow_min = 0.02 * m_flow_nominal "Minimum mass flow rate of consumer";



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
        rotation=90,
        origin={60,90})));
  FourPortModules.DistrictHeating.Consumer.DH_DirectHeatConsumer actCon(
    m_flow_small=m_flow_small,
    final sysTem=sysTem,
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final TGradHX=TGradHX,
    final tableName=tableName,
    final fileName=fileName,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
    final show_T=show_T,
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
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final use_HeatingCurve=use_HeatingCurve,
    final TNetRetSet=TNetRetSet,
    final ProfCtrl=1,
    m_flow_min=m_flow_min)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out annotation (Placement(
        transformation(extent={{100,80},{120,100}}), iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={-60,90})));
  Modelica.Blocks.Interfaces.RealInput TAmb_in if use_HeatingCurve
    annotation (Placement(transformation(extent={{-140,-76},{-100,-36}}),
        iconTransformation(extent={{-140,-76},{-100,-36}})));
  Modelica.Blocks.Sources.RealExpression TAmb_expr(y=TAmb_internal)
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
protected
    Modelica.Blocks.Interfaces.RealInput TAmb_internal(unit="K")
    "Needed to connect to conditional connector";
equation
  connect(actCon.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}},
                            color={0,127,255}));
  connect(actCon.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}},
                             color={0,127,255}));
  connect(actCon.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}},
                       color={0,127,255}));
  connect(actCon.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}},
                          color={0,127,255}));
  connect(TAmb_internal, TAmb_in);

    if not use_HeatingCurve then
      TAmb_internal = Medium.T_default;
    end if;

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  connect(actCon.Q_flow_out, Q_flow_out) annotation (Line(points={{11,-2},{60,
          -2},{60,60},{110,60}},  color={0,0,127}));
  connect(actCon.dp_out, dp_out) annotation (Line(points={{11,2},{56,2},{56,90},
          {110,90}}, color={0,0,127}));
  connect(TAmb_expr.y, actCon.TAmb_in)
    annotation (Line(points={{-31,-40},{-6,-40},{-6,-12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,54},{100,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
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
          fillColor={255,0,0},
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
          extent={{-50,38},{50,-42}},
          lineColor={0,0,0},
          textString="DiC"),
        Text(
          extent={{-152,-136},{148,-96}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DH_DirectConsumer;
