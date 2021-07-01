within dhcSim.DHC.Submodules.FourPortModules.BaseClasses;
partial model SupplyReturnTemperatures

  replaceable parameter dhcSim.Data.SystemTemperatures sysTem annotation (
    Dialog(group="Nominal Conditions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-78,72},{-58,92}})));

  dhcSim.Controls.SetPoints.HotWaterTemperatureReset hotWatRes(
    final m=sysTem.m,
    final TRoo=sysTem.TRoo,
    final dTOutHeaBal=0,
    final TSup_nominal=sysTem.TSup_nominal,
    final TRet_nominal=sysTem.TRet_nominal,
    final TRoo_nominal=sysTem.TRoo_nominal,
    final TOut_nominal=sysTem.TAmb_nominal)
    annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  Modelica.Blocks.Interfaces.RealInput TAmb_in
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
equation
  connect(TAmb_in, hotWatRes.TOut) annotation (Line(points={{-60,-120},{-60,-80},
          {-90,-80},{-90,34},{-82,34}},           color={0,0,127}));
end SupplyReturnTemperatures;
