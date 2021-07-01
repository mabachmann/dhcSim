within dhcSim.DHC.Submodules.MultiPortModules.DistrictHeating.Producer;
model DH_PassiveDirectProducer
  "Multi  port model of unlimited district heating producer using direct heat transfer and no own pump module. Bidirectional flow possible."
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
    "Supply temperature on primary side" annotation(Dialog(enable=not use_T_sup_in));
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
    "Return temperature on primary side"
                                        annotation(Dialog);

  FourPortModules.DistrictHeating.Producer.DH_PassiveDirectProducer pasPro(
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
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,70},{120,90}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,90})));
  Modelica.Blocks.Interfaces.RealInput TSup_in(unit="K") if use_T_sup_in
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Sources.RealExpression TSup_expr(y=TSup_internal)
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
protected
    Modelica.Blocks.Interfaces.RealInput TSup_internal(unit="K")
    "Needed to connect to conditional connector";
equation

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
  connect(pasPro.Q_flow_out, Q_flow_out) annotation (Line(points={{11,0},{30,0},
          {30,80},{110,80}}, color={0,0,127}));
  connect(TSup_expr.y, pasPro.TSup_in)
    annotation (Line(points={{-31,-40},{-6,-40},{-6,-12}}, color={0,0,127}));
  connect(TSup_internal, TSup_in);

    if not use_T_sup_in then
      TSup_internal = Medium.T_default;
    end if;

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
          textString="PaDP"),
        Text(
          extent={{-156,-106},{144,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DH_PassiveDirectProducer;
