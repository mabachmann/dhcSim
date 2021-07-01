within dhcSim.Data;
record SysTemp_75_65_20 =
                       dhcSim.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 20,
    TRoo=273.15 + 20,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 75,
    TRet_nominal=273.15 + 65,
    m=1.3) "System temperatures 75/65/20";
