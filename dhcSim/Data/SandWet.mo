within dhcSim.Data;
record SandWet =
    Buildings.HeatTransfer.Data.Soil.Generic (
    k=1.4,
    d=2050,
    c=927) "Soil parameters of wet sand"
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datSoi");
