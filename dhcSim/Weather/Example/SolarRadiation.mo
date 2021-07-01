within dhcSim.Weather.Example;
model SolarRadiation
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Length L=1 "Length of cuboid";
  parameter Modelica.SIunits.Length B=1 "Width of cuboid";
  parameter Modelica.SIunits.Height H=1 "Height of cuboid";
  final parameter Modelica.SIunits.Volume V=L*B*H "Volume of cuboid";
  parameter Modelica.SIunits.SpecificHeatCapacity cp=1.005
    "Specific heat capacity of air";
  parameter Modelica.SIunits.Density rho=1.2041 "Density of air at 20 °C";
  CombinedWeather weatherModel annotation (Placement(transformation(extent={{-80,-4},{-60,16}})));
  Adaptors.RadCondAdapt west(A=H*L) annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Adaptors.RadCondAdapt south(A=H*B) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Adaptors.RadCondAdapt east(A=H*L) annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Adaptors.RadCondAdapt north(A=H*B) annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Adaptors.RadCondAdapt roof(A=L*B) annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor thermalCapacity(C=V*rho*cp)
    "Thermal capacity of air cuboid"                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,10})));
  Modelica.Blocks.Sources.Constant const(k=273.15) annotation (Placement(transformation(extent={{-80,66},
            {-60,86}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-40,60},
            {-20,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature ambientTemperature
    "Ambient temperature"                                                                              annotation (Placement(transformation(extent={{0,60},{
            20,80}})));
equation
  connect(weatherModel.oc_total_rad[1], west.ic_total_rad1) annotation (Line(
      points={{-60,8.2},{-20,8.2},{-20,-80},{0,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(weatherModel.oc_total_rad[2], south.ic_total_rad1) annotation (Line(
      points={{-60,8.6},{-20,8.6},{-20,-50},{0,-50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(weatherModel.oc_total_rad[3], east.ic_total_rad1) annotation (Line(
      points={{-60,9},{-20,9},{-20,-20},{0,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(weatherModel.oc_total_rad[4], north.ic_total_rad1) annotation (Line(
      points={{-60,9.4},{-20,9.4},{-20,10},{0,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(weatherModel.oc_total_rad[5], roof.ic_total_rad1) annotation (Line(
      points={{-60,9.8},{-20,9.8},{-20,40},{0,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(east.port, thermalCapacity.port) annotation (Line(
      points={{20,-20},{40,-20},{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(north.port, thermalCapacity.port) annotation (Line(
      points={{20,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.port, thermalCapacity.port) annotation (Line(
      points={{20,40},{40,40},{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(south.port, thermalCapacity.port) annotation (Line(
      points={{20,-50},{40,-50},{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(west.port, thermalCapacity.port) annotation (Line(
      points={{20,-80},{40,-80},{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add.y, ambientTemperature.T) annotation (Line(
      points={{-19,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weatherModel.TempOut, add.u2) annotation (Line(
      points={{-60,3},{-52,3},{-52,64},{-42,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, add.u1) annotation (Line(
      points={{-59,76},{-42,76}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=31536000),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{-80,-60},{-60,-66},{-60,-46},{-80,-40},{-80,-60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-46},{-32,-40},{-32,-60},{-60,-66},{-60,-46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-46},{-60,-64}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="S"),
        Polygon(
          points={{-80,-40},{-50,-34},{-32,-40},{-60,-46},{-80,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,-37},{-44,-43}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="roof"),
        Line(
          points={{-90,-42},{-80,-52}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-94,-36},{-90,-42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="H"),
        Text(
          extent={{-56,-46},{-36,-64}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="E"),
        Line(
          points={{-50,-64},{-40,-70}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-38,-68},{-34,-74}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="L"),
        Line(
          points={{-68,-64},{-74,-68}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-78,-66},{-74,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="B")}));
end SolarRadiation;
