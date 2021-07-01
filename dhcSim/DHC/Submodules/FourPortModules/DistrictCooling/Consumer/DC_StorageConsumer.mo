within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer;
model DC_StorageConsumer
  "Four port model of district cooling consumer using storage tank"

  extends
    dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses.DC_StorageConsumer;

equation

 Q_flowTot = max(loadTable.y[1], 0.0);
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
