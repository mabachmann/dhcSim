within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Producer;
model DC_PassiveDirectProducer
  "Four port model of PassiveCoolProducer_Direct. Unlimited large cool producer using direct heat transfer"
  extends BaseClasses.BaseModule(                final nSpl1=1, final nSpl2=1);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;

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

  Modelica.SIunits.Temperature TSupInt "Internal calculated supply temperature if producer";
  Modelica.SIunits.Temperature TRetInt "Internal calculated return temperature if consumer";
  Modelica.SIunits.HeatFlowRate Q_flowTot "Total heat flow rate; <0=cool producer, >0=cool consumer";

  dhcSim.DHC.Submodules.TwoPortModules.PassiveCoolProducer_Direct pasPro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final T_start=T_start_1,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final m_flow_small=m_flow_small,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final dp_nominal=dp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,2})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression TSup_set(y(unit="K") = TSupInt)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Blocks.Sources.RealExpression TRet_set(y(unit="K") = TRetInt)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

protected
  Modelica.SIunits.Temperature T_in_1 = Medium.temperature(
    state=Medium.setState_phX(
      p=spl1[1].port_3.p,
      h=spl1[1].port_3.h_outflow,
      X=spl1[1].port_3.Xi_outflow)) "Inlet temperature";

  Modelica.SIunits.Temperature T_in_2 = Medium.temperature(
    state=Medium.setState_phX(
      p=spl2[1].port_3.p,
      h=spl2[1].port_3.h_outflow,
      X=spl2[1].port_3.Xi_outflow)) "Inlet temperature";

  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";

equation

   Q_flowTot =pasPro.Q_flow_out;

  if retTempType == dhcSim.Fluid.Types.FeedingTemperaturePro.dTFix then
     TSupInt = T_in_2 - deltaT;
     TRetInt = T_in_1 + deltaT;
   else
     TSupInt = TNetSupSet;
     TRetInt = TNetRetSet;
   end if;

  connect(pasPro.port_b, spl1[1].port_3)
    annotation (Line(points={{0,12},{0,50}},        color={0,127,255}));
  connect(spl2[1].port_3,pasPro. port_a)
    annotation (Line(points={{0,-50},{0,-8}},  color={0,127,255}));
  connect(pasPro.Q_flow_out, Q_flow_out) annotation (Line(points={{5,13},{5,20},
          {80,20},{80,0},{110,0}}, color={0,0,127}));
  connect(TRet_set.y,pasPro. THea_in) annotation (Line(points={{-29,-20},{-24,-20},
          {-24,-2},{-8,-2}}, color={0,0,127}));
  connect(TSup_set.y,pasPro. TCoo_in) annotation (Line(points={{-29,20},{-24,20},
          {-24,6},{-8,6}}, color={0,0,127}));
  annotation (defaultComponentName="ActPro", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Rectangle(
          extent={{-25,-6},{25,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
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
          textString="PP"),
        Rectangle(
          extent={{-98,70},{102,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}));
end DC_PassiveDirectProducer;
