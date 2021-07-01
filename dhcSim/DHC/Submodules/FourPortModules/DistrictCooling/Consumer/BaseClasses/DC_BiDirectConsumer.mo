within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses;
partial model DC_BiDirectConsumer
  "Four port model of district cooling consumer and producer with direct connection - base class."
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

  Modelica.SIunits.HeatFlowRate Q_flowTot "Total heat flow rate; <0=cool producer, >0=cool consumer";
  Modelica.SIunits.Temperature TSupInt "Internal calculated supply temperature if producer";
  Modelica.SIunits.Temperature TRetInt "Internal calculated return temperature if consumer";

protected
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";

  parameter Modelica.SIunits.TemperatureDifference dT_nominal = Q_flow_nominal/(m_flow_nominal*cp_default)  "Nominal temperature difference";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_pro = Q_flow_nominal_pro/(cp_default*dT_nominal)  "Nominal mass flow rate of producer";

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

public
  dhcSim.DHC.Submodules.TwoPortModules.CoolBiDirektional_Direct conPro(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final deltaM=deltaM,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final tau=tau,
    final linearizeFlowResistance=linearizeFlowResistance,
    final T_start=T_start_1,
    final m_flow_small=m_flow_small) annotation (Placement(transformation(
        extent={{16,16},{-16,-16}},
        rotation=270,
        origin={0,0})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out(unit="W") annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{100,10},
            {120,30}})));
  Modelica.Blocks.Interfaces.RealInput y_Pro( min=0, max=1)
    "Input signal of internal producer y=0..1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression TReturn(final y=TRetInt)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Modelica.Blocks.Sources.RealExpression TSupply(y=TSupInt)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation

  if supTempType == dhcSim.Fluid.Types.FeedingTemperaturePro.dTFix then
     TSupInt = T_in_2 - deltaT;
   else
     TSupInt = TNetSupSet;
   end if;

  if retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.m_flow_const then
     TRetInt = abs(max(Q_flowTot,0))/(m_flow_nominal*cp_default) + T_in_1;
  elseif retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.dTFix then
     TRetInt = T_in_1 + deltaT;
  elseif retTempType == dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger then
    TRetInt = dhcSim.DHC.Submodules.TwoPortModules.Interfaces.T1OutHX(
      QFlow_nominal=Q_flow_nominal,
      QFlow=Q_flowTot,
      cp=cp_default,
      T1In_nominal=TNetIn_nominal,
      T1Out_nominal=TNetOut_nominal,
      T2In_nominal=TBuiIn_nominal,
      T2Out_nominal=TBuiOut_nominal,
      T1In=T_in_1,
      T2Out=TBuiOut_nominal,
      FlagHeatCon=false);
   else
     TRetInt = TNetRetSet;
   end if;

  connect(conPro.Q_flow_out, Q_flow_out) annotation (Line(points={{9.6,17.6},{9.6,
          20},{28,20},{28,-20},{110,-20}},
                                       color={0,0,127}));
  connect(conPro.dp_out, dp_out)
    annotation (Line(points={{-9.6,17.6},{-9.6,30},{32,30},{32,20},{110,20}},
                                                        color={0,0,127}));
  connect(QFlow_table.y, conPro.QLoad_in) annotation (Line(points={{-19,0},{-4,0},
          {-4,-2.22045e-15},{12.8,-2.22045e-15}}, color={0,0,127}));
  connect(conPro.port_b, spl1[1].port_3) annotation (Line(points={{2.88658e-15,16},
          {0,16},{0,50}}, color={0,127,255}));
  connect(conPro.port_a, spl2[1].port_3) annotation (Line(points={{-3.10862e-15,
          -16},{-3.10862e-15,-30},{0,-30},{0,-50}}, color={0,127,255}));
  connect(TSupply.y, conPro.TSup_in) annotation (Line(points={{-19,20},{-12.8,20},
          {-12.8,6.4}}, color={0,0,127}));
  connect(TReturn.y, conPro.TRet_in) annotation (Line(points={{-19,-20},{-12.8,-20},
          {-12.8,-6.4}}, color={0,0,127}));
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
          textString="BiDiC"),
        Rectangle(
          extent={{-100,70},{100,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DC_BiDirectConsumer;
