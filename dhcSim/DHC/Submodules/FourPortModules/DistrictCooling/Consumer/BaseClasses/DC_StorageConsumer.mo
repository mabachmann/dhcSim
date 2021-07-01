within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses;
partial model DC_StorageConsumer
  "Four port model of district cooling consumer using storage tank - base class."
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends .dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);
  extends .dhcSim.DHC.Submodules.FourPortModules.BaseClasses.ExternalProfiles(
      QFlow_table(final y=Q_flowTot), final columns={2});

 // Storage Parameters
 parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 //Control parameter
 parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

 parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

 Modelica.SIunits.HeatFlowRate Q_flowTot "Total heat flow rate; <0=cool producer, >0=cool consumer";

  dhcSim.DHC.Submodules.TwoPortModules.CoolConsumer_Storage_mFlow actCon(
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final deltaM=deltaM,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final T_start=T_start_1,
    final p_start=p_start_1,
    final massDynamics=energyDynamics,
    final X_start=X_start_1,
    final C_start=C_start_1,
    final C_nominal=C_nominal_1,
    final VSt=VSt,
    final THigh=THigh,
    final TLow=TLow,
    final m_flow_small=m_flow_small) annotation (Placement(transformation(
        extent={{15,15},{-15,-15}},
        rotation=90,
        origin={1,1})));

//protected

  Modelica.SIunits.Temperature T_in = Medium.temperature(
    state=Medium.setState_phX(
      p=spl1[1].port_3.p,
      h=spl1[1].port_3.h_outflow,
      X=spl1[1].port_3.Xi_outflow)) "inlet temperature";

public
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out(unit="W") annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={
            {100,10},{120,30}})));
equation
  connect(actCon.port_a, spl1[1].port_3)
    annotation (Line(points={{1,16},{0,16},{0,50}}, color={0,127,255}));
  connect(actCon.port_b, spl2[1].port_3)
    annotation (Line(points={{1,-14},{0,-30},{0,-50}}, color={0,127,255}));
  connect(QFlow_table.y, actCon.QLoad_in) annotation (Line(points={{-19,0},{-14,
          0},{-14,7},{-11,7}},color={0,0,127}));
  connect(actCon.dp_out, dp_out) annotation (Line(points={{13,-15.5},{13,-30},{48,
          -30},{48,20},{110,20}}, color={0,0,127}));
  connect(actCon.Q_flow_out, Q_flow_out)
    annotation (Line(points={{-9.5,-15.5},{-9.5,-26},{-10,-26},{-10,-34},{52,-34},
          {52,-20},{110,-20}},                             color={0,0,127}));
  annotation (defaultComponentName="colCon", Icon(graphics={
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
          textString="StC"),
        Rectangle(
          extent={{-100,70},{100,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DC_StorageConsumer;
