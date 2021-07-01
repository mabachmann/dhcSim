within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses;
partial model DC_DirectConsumer
  "Four port model of district cooling consumer with continous demand - base class."
  extends .dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  extends .dhcSim.DHC.Submodules.FourPortModules.BaseClasses.ExternalProfiles(
      QFlow_table(final y=Q_flowTot), final columns={2});
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal heat flow rate"
                                                                                 annotation(Dialog(group = "Nominal condition"));

  // Return Temperatur
  parameter dhcSim.Fluid.Types.FeedingTemperatureCon retTempType=dhcSim.Fluid.Types.FeedingTemperatureCon.fixed
    "Define how return temperature is caclulated";
  parameter Modelica.SIunits.Temperature TNetRetSet=Medium.T_default
  "Return temperature if retTempType=fixed" annotation(Dialog(enable=
          retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.fixed));
  parameter Modelica.SIunits.TemperatureDifference deltaT=5 "Temperature difference between inlet and outlet if retTempType = dTFix "
    annotation(Dialog(enable=retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.dTFix));

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

  // Other
  //parameter Real ProfCtrl=1 "Control parameter for profile usage";

  Modelica.SIunits.Temperature TRetInt "Internal calculated return temperature of consumer on grid side";
  Modelica.SIunits.HeatFlowRate Q_flowTot "Total heat flow rate; <0=cool producer, >0=cool consumer";

  dhcSim.DHC.Submodules.TwoPortModules.CoolConsumer_Direct actCon(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    final use_Q_flow_in=true,
    final from_dp=from_dp,
    final deltaM=deltaM,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final use_TSet_in=true,
    final tau=tau,
    final linearizeFlowResistance=linearizeFlowResistance,
    final T_start=T_start_1,
    final fixedGradient=false,
    final m_flow_small=m_flow_small) annotation (Placement(transformation(
        extent={{14,14},{-14,-14}},
        rotation=90,
        origin={0,0})));

protected
  Modelica.Blocks.Sources.RealExpression TReturn(final y=TRetInt)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Modelica.SIunits.Temperature T_in = Medium.temperature(
    state=Medium.setState_phX(
      p=spl1[1].port_3.p,
      h=spl1[1].port_3.h_outflow,
      X=spl1[1].port_3.Xi_outflow)) "inlet temperature";

  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";

public
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out(unit="W") annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={
            {100,10},{120,30}})));
equation

  if retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.m_flow_const then
     TRetInt = abs(max(Q_flowTot,0))/(m_flow_nominal*cp_default) + T_in;
  elseif retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.dTFix then
     TRetInt = T_in + deltaT;
  elseif retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger then
    TRetInt = dhcSim.DHC.Submodules.TwoPortModules.Interfaces.T1OutHX(
      QFlow_nominal=Q_flow_nominal,
      QFlow=Q_flowTot,
      cp=cp_default,
      T1In_nominal=TNetIn_nominal,
      T1Out_nominal=TNetOut_nominal,
      T2In_nominal=TBuiIn_nominal,
      T2Out_nominal=TBuiOut_nominal,
      T1In=min(T_in, TBuiOut_nominal - 0.5),
      T2Out=TBuiOut_nominal,
      FlagHeatCon=false);
/*  elseif retTempType == dhcSimSep.Fluid.Types.FeedingTemperatureCon.heatExchanger then
     TRetInt = dhcSimSep.DHC.Submodules.TwoPortModules.Interfaces.T1OutHX(
      QFlow_nominal=Q_flow_nominal,
      QFlow=Q_flow_out,
      cp=cp_default,
      T1In_nominal=TNetIn_nominal,
      T1Out_nominal=TNetOut_nominal,
      T2In_nominal=TBuiIn_nominal,
      T2Out_nominal=TBuiOut_nominal,
      T1In=T_in,
      T2Out=TBuiOut_nominal,
      FlagHeatCon=false);*/
   else
     TRetInt = TNetRetSet;
   end if;

  connect(actCon.port_a, spl1[1].port_3)
    annotation (Line(points={{-8.88178e-16,14},{0,14},{0,50}},
                                                    color={0,127,255}));
  connect(actCon.port_b, spl2[1].port_3)
    annotation (Line(points={{-2.66454e-15,-14},{0,-30},{0,-50}},
                                                       color={0,127,255}));
  connect(QFlow_table.y, actCon.QLoad_in) annotation (Line(points={{-19,0},{-14,
          0},{-14,5.6},{-11.2,5.6}},
                              color={0,0,127}));
  connect(actCon.dp_out, dp_out) annotation (Line(points={{9.8,-15.4},{9.8,-14},
          {60,-14},{60,20},{110,20}},
                                  color={0,0,127}));
  connect(TReturn.y, actCon.TSet_in) annotation (Line(points={{-19,-20},{-14,
          -20},{-14,-5.6},{-11.2,-5.6}},
                             color={0,0,127}));
  connect(actCon.Q_flow_out, Q_flow_out)
    annotation (Line(points={{-7,-15.4},{-7,-20},{110,-20}},
                                                           color={0,0,127}));
  annotation (defaultComponentName="actCon", Icon(graphics={
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
          textString="AC"),
        Rectangle(
          extent={{-100,70},{100,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DC_DirectConsumer;
