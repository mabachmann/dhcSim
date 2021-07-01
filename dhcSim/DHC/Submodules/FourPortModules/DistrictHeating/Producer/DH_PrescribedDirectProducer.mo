within dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Producer;
model DH_PrescribedDirectProducer
  "Four port model of prescribed district heating producer using direct heat transfer and own pump module;"
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);

  //Modelica.SIunits.Temperature TNetSup "Supply temperature of producer on primary side";

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000 "Nominal heat flow rate of producer";

  // Temperature profile
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
    "Supply temperature" annotation(Dialog(enable=not use_T_sup_in));

  // Other
   parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance" annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  TwoPortModules.HeatProducer actPro(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    final use_Q_flow_in=true,
    final from_dp=from_dp,
    final deltaM=deltaM,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final tau=tau,
    final T_start=T_start_1,
    final fixedGradient=false,
    final linearizeFlowResistance=linearizeFlowResistance,
    final use_TSet_in=true,
    final m_flow_small=m_flow_small)                      annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,0})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out "Heat flow" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Modelica.Blocks.Interfaces.RealOutput dp "Pressure drop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,110})));

  Modelica.Blocks.Sources.RealExpression TSup_set(y(unit="K") = T_sup_internal)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Interfaces.RealInput ProCtrl
    "Control signal (0..1) for power control"  annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-20,-120})));
  Modelica.Blocks.Sources.RealExpression QFlow_exp(y = min(max(ProCtrl, 0), 1) * Q_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-14},{-20,6}})));
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

  connect(actPro.port_a, spl2[1].port_3)
    annotation (Line(points={{0,-10},{0,-10},{0,-50}}, color={0,127,255}));
  connect(actPro.port_b, spl1[1].port_3)
    annotation (Line(points={{0,10},{0,10},{0,50}}, color={0,127,255}));
  connect(actPro.dp_out, dp) annotation (Line(points={{7,11},{7,20},{40,20},{40,
          110}}, color={0,0,127}));
  connect(TSup_set.y, actPro.TSet_in) annotation (Line(points={{-19,20},{-16,20},
          {-16,4},{-8,4}}, color={0,0,127}));
  connect(QFlow_exp.y, actPro.QLoad_in)
    annotation (Line(points={{-19,-4},{-8,-4}}, color={0,0,127}));
  connect(actPro.Q_flow_out, Q_flow_out) annotation (Line(points={{-5,11},{-5,
          26},{40,26},{40,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="actPro", Icon(graphics={
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
          textString="AP")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DH_PrescribedDirectProducer;
