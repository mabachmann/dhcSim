within dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Producer;
model DH_ActiveDirectProducer
  "Four port model of unlimited large producer using direct heat transfer and own pump module"
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
    "Supply temperature" annotation(Dialog(enable=not use_T_sup_in));
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
    "Return temperature";

  dhcSim.DHC.Submodules.TwoPortModules.ActiveHeatProducer actPro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final T_start=T_start_1,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final m_flow_small=m_flow_small,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));
  Modelica.Blocks.Interfaces.RealInput dp_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,10},{120,30}}),  iconTransformation(
          extent={{100,10},{120,30}})));
  Modelica.Blocks.Sources.RealExpression TSup_set(y(unit="K") = T_sup_internal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,14})));
  Modelica.Blocks.Sources.RealExpression TRet_set(y(unit="K") = TNetRetSet)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-16})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare final replaceable
      package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-28})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_out(unit="kg/s") annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),iconTransformation(
          extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealInput TSup_in if  use_T_sup_in annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));

protected
    Modelica.Blocks.Interfaces.RealInput T_sup_internal(unit="K")
    "Needed to connect to conditional connector";

equation
  connect(T_sup_internal, TSup_in);
    if not use_T_sup_in then
      T_sup_internal = TNetSupSet;
    end if;
  connect(dp_in, actPro.dp_in)
    annotation (Line(points={{60,-120},{60,-8.88178e-16},{8,-8.88178e-16}},
                                             color={0,0,127}));
  connect(spl2[1].port_3, senMasFlo.port_a)
    annotation (Line(points={{0,-50},{0,-38}}, color={0,127,255}));
  connect(senMasFlo.m_flow, m_flow_out) annotation (Line(points={{-11,-28},{40,
          -28},{40,-20},{110,-20}},                    color={0,0,127}));
  connect(spl1[1].port_3, actPro.port_b)
    annotation (Line(points={{0,50},{0,10}}, color={0,127,255}));
  connect(actPro.port_a, senMasFlo.port_b)
    annotation (Line(points={{0,-10},{0,-18}}, color={0,127,255}));
  connect(TRet_set.y, actPro.TCoo_in) annotation (Line(points={{-19,-16},{-14,
          -16},{-14,-4},{-8,-4}}, color={0,0,127}));
  connect(TSup_set.y, actPro.THea_in) annotation (Line(points={{-19,14},{-14,14},
          {-14,4},{-8,4}}, color={0,0,127}));
  connect(actPro.Q_flow_out, Q_flow_out)
    annotation (Line(points={{5,11},{5,20},{110,20}}, color={0,0,127}));
  annotation (defaultComponentName="ActPro", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
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
          textString="PP")}));
end DH_ActiveDirectProducer;
