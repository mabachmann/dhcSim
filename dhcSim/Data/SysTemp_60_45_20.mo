within dhcSim.Data;
record SysTemp_60_45_20 =
                       dhcSim.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 20,
    TRoo=273.15 + 20,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 60,
    TRet_nominal=273.15 + 45,
    m=1.3) "System temperatures 60/45/20";
