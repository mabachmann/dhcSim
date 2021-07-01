within dhcSim.Data;
record SysTemp_35_30_20 =
                       dhcSim.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 20,
    TRoo=273.15 + 20,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 35,
    TRet_nominal=273.15 + 30,
    m=1.3) "System temperatures 35/30/20";
