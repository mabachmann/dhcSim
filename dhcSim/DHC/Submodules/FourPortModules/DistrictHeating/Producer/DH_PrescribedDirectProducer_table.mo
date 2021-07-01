within dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Producer;
model DH_PrescribedDirectProducer_table
  "Four port model of prescribed district heating producer using direct heat transfer and own pump module; power input from table"
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  /*extends 
    dhcSim.DHC.Submodules.FourPortModules.BaseClasses.SupplyReturnTemperatures;*/
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.ExternalProfiles(
      QFlow_table(final y=max(loadTable.y[1]*min(max(ProCtrl, 0), 1), 0.0)),
      final columns={2,3,4});

  /*Modelica.SIunits.Temperature TNetSup "Supply temperature of producer on primary side";*/

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";
  parameter Boolean use_TemperatureProfile=false "=true, to use temperature profile of supply temperature on net side provided by loadTable" annotation(Dialog(enable=not use_T_sup_in));

  // Temperature profile
  parameter Modelica.SIunits.Temperature TNetSupSet = 273.15 + 50 "Set supply temperature on primary side" annotation(Dialog(enable=not use_T_sup_in and not use_TemperatureProfile));

  //parameter Real ProfCtrl=1 "Control parameter for profile usage";

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
      if use_TemperatureProfile then
        T_sup_internal = max(loadTable.y[2],0.0);
      else
        T_sup_internal = TNetSupSet;
      end if;
    //else
    //    T_sup_internal = TSup_in;
    end if;

  connect(actPro.port_a, spl2[1].port_3)
    annotation (Line(points={{0,-10},{0,-10},{0,-50}}, color={0,127,255}));
  connect(actPro.port_b, spl1[1].port_3)
    annotation (Line(points={{0,10},{0,10},{0,50}}, color={0,127,255}));
  connect(QFlow_table.y, actPro.QLoad_in) annotation (Line(points={{-19,0},{-16,
          0},{-16,-4},{-8,-4}}, color={0,0,127}));
  connect(QFlow_table.y, Q_flow_out) annotation (Line(points={{-19,0},{-18,0},{-16,
          0},{-16,-30},{60,-30},{60,0},{110,0}}, color={0,0,127}));
  connect(actPro.dp_out, dp) annotation (Line(points={{7,11},{7,20},{40,20},{40,
          110}}, color={0,0,127}));
  connect(TSup_set.y, actPro.TSet_in) annotation (Line(points={{-19,20},{-16,20},
          {-16,4},{-8,4}}, color={0,0,127}));
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
end DH_PrescribedDirectProducer_table;
