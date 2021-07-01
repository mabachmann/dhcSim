within dhcSim.DHC.Submodules.MultiPortModules.DistrictHeating.Producer;
model DH_PrescribedDirectProducer_table
  "Four port model of prescribed district heating producer using direct heat transfer and own pump module; power input from table"
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";

  // Table
  final parameter String tableName="table" "Table name" annotation (Dialog(group="Table data"));
  parameter String fileName=dhcSim.Utilities.getAbsolutePath(   "modelica://dhcSim/Resources/LoadProf/default/producerNom.txt") "File name" annotation (
      Dialog(
      group="Table data",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));

  // Temperature profile
  parameter Boolean use_TemperatureProfile=false "=true, to use temperature profile of supply temperature on net side provided by loadTable" annotation(Dialog(enable=not use_HeatingCurve));
  parameter Modelica.SIunits.Temperature TNetSupSet = 273.15 + 50 "Set supply temperature on primary side" annotation(Dialog(enable=not use_T_sup_in and not use_TemperatureProfile));

  // Power control
  parameter Boolean use_ProCtrl=true "=true, to use external power control signal";

  dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Producer.DH_PrescribedDirectProducer_table
    actPro(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
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
    final use_TemperatureProfile=use_TemperatureProfile,
    final TNetSupSet=TNetSupSet,
    final tableName=tableName,
    final fileName=fileName,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final use_T_sup_in=use_T_sup_in,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,36},{120,56}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,90})));
  Modelica.Blocks.Interfaces.RealOutput dp_out annotation (Placement(
        transformation(extent={{100,70},{120,90}}), iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={-10,90})));
  Modelica.Blocks.Interfaces.RealInput TSup_in if use_T_sup_in
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-120})));
  Modelica.Blocks.Sources.RealExpression TSup_expr(y=TSup_internal)
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
  Modelica.Blocks.Sources.RealExpression ProCtrl_expr(y=ProCtrl_internal)
    annotation (Placement(transformation(extent={{-52,-66},{-32,-46}})));
  Modelica.Blocks.Interfaces.RealInput ProCtrl_in if
                                                  use_ProCtrl
    "Input signal of producer control" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120})));
protected
    Modelica.Blocks.Interfaces.RealInput TSup_internal(unit="K")
    "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput ProCtrl_internal
    "Needed to connect to conditional connector";
equation
  connect(TSup_internal, TSup_in);
    if not use_T_sup_in then
      TSup_internal = TNetSupSet;
    end if;
  connect(ProCtrl_internal, ProCtrl_in);
  if not use_ProCtrl then
    ProCtrl_internal = 1;
  end if;
  connect(actPro.Q_flow_out, Q_flow_out)
    annotation (Line(points={{11,0},{26,0},{26,46},{110,46}}, color={0,0,127}));
  connect(actPro.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}},
                            color={0,127,255}));
  connect(actPro.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}},
                             color={0,127,255}));
  connect(actPro.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}},
                       color={0,127,255}));
  connect(actPro.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}},
                          color={0,127,255}));

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  connect(actPro.dp, dp_out)
    annotation (Line(points={{4,11},{4,80},{110,80}}, color={0,0,127}));
  connect(TSup_expr.y,actPro. TSup_in)
    annotation (Line(points={{-31,-40},{-6,-40},{-6,-12}}, color={0,0,127}));
  connect(ProCtrl_expr.y, actPro.ProCtrl)
    annotation (Line(points={{-31,-56},{-2,-56},{-2,-12}}, color={0,0,127}));
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
          extent={{-50,36},{50,-44}},
          lineColor={0,0,0},
          textString="PrDP"),
        Text(
          extent={{-154,-106},{146,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DH_PrescribedDirectProducer_table;
