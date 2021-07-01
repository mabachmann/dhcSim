within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Producer;
model DC_ActiveStorageProducer
  "Four port module of ActiveCoolProducer_Storage. Prescribed maximum cooling power and hysteresis control of storage."
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends BaseClasses.BaseModule(final nSpl1=1, final nSpl2=1);
  // Producer Parameter
  parameter Modelica.SIunits.HeatFlowRate QProNominal = 1000 "Nominal producer cooling power";

 // Storage Parameters
  parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 // Control variables
  parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

  parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

  // Other
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation(Dialog(tab="Dynamics"));

  dhcSim.DHC.Submodules.TwoPortModules.ActiveCoolProducer_Storage actPro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final T_start=T_start_1,
    final energyDynamics=energyDynamics,
    final m_flow_small=m_flow_small,
    final p_start=p_start_1,
    final X_start=X_start_1,
    final C_start=C_start_1,
    final C_nominal=C_nominal_1,
    final mSenFac=mSenFac,
    final QProNominal=QProNominal,
    final VSt=VSt,
    final THigh=THigh,
    final TLow=TLow,
    final massDynamics=massDynamics,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM) annotation (Placement(transformation(
        extent={{-17,-17},{17,17}},
        rotation=90,
        origin={1,3})));
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
      Placement(transformation(extent={{100,-40},{120,-20}}),iconTransformation(
          extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TStorage_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40}),  iconTransformation(extent={{100,20},{120,40}},
          rotation=0)));
equation
  connect(actPro.port_b, spl1[1].port_3)
    annotation (Line(points={{1,20},{1,32},{0,32},{0,50}},
                                                    color={0,127,255}));
  connect(spl2[1].port_3, actPro.port_a)
    annotation (Line(points={{0,-50},{0,-14},{1,-14}},
                                               color={0,127,255}));
  connect(dp_in, actPro.dp_in)
    annotation (Line(points={{60,-120},{60,3},{14.6,3}},
                                             color={0,0,127}));
  connect(actPro.Q_flow_out, Q_flow_out) annotation (Line(points={{14.6,21.7},{
          14.6,20},{80,20},{80,-30},{110,-30}},
                                   color={0,0,127}));
  connect(actPro.TStorage_out, TStorage_out)
    annotation (Line(points={{7.8,21.7},{7.8,40},{110,40}},
                                                      color={0,0,127}));
  annotation (defaultComponentName="actPro", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
          textString="AcStP"),
        Rectangle(
          extent={{-98,70},{102,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid)}));
end DC_ActiveStorageProducer;
