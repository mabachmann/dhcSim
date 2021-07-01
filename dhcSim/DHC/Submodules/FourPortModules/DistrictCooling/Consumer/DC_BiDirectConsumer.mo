within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer;
model DC_BiDirectConsumer
  "Four port model of district cooling consumer and producer with direct connection."

  extends
    dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses.DC_BiDirectConsumer;

equation

  Q_flowTot = max(loadTable.y[1], 0.0) - y_Pro*Q_flow_nominal_pro;

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
