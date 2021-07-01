within dhcSim.DHC.Submodules.FourPortModules.DistrictHeating.Producer;
model DH_PassiveDirectProducer
  "Four port model of unlimited district heating producer using direct heat transfer and no own pump module. Bidirectional flow possible."
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  //extends
  //  dhcSim.DHC.Submodules.FourPortModules.BaseClasses.SupplyReturnTemperatures;

  parameter Boolean use_T_sup_in=true "=true, supply temperature regarding input signal";
  parameter Modelica.SIunits.Temperature TNetSupSet=Medium.T_default
    "Supply temperature" annotation(Dialog(enable=not use_T_sup_in));
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
    "Return temperature"
                        annotation(Dialog);

  dhcSim.DHC.Submodules.TwoPortModules.PassiveProducer pasPro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final T_start=T_start_1,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau,
    final m_flow_small=m_flow_small) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression TSup_set(y(unit="K") = T_sup_internal)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Blocks.Sources.RealExpression TRet_set(y(unit="K") = TNetRetSet)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

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

  connect(pasPro.port_b, spl1[1].port_3)
    annotation (Line(points={{0,10},{0,10},{0,50}}, color={0,127,255}));
  connect(spl2[1].port_3,pasPro. port_a)
    annotation (Line(points={{0,-50},{0,-10}}, color={0,127,255}));
  connect(TRet_set.y,pasPro. TCoo_in) annotation (Line(points={{-29,-20},{-20,
          -20},{-20,-4},{-8,-4}},
                             color={0,0,127}));
  connect(TSup_set.y,pasPro. THea_in) annotation (Line(points={{-29,20},{-20,20},
          {-20,4},{-8,4}}, color={0,0,127}));
  connect(pasPro.Q_flow_out, Q_flow_out) annotation (Line(points={{5,11},{5,20},
          {60,20},{60,0},{110,0}}, color={0,0,127}));
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
end DH_PassiveDirectProducer;
