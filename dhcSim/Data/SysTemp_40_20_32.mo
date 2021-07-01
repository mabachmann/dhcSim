within dhcSim.Data;
record SysTemp_40_20_32 =
                       dhcSim.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 32,
    TRoo=273.15 + 32,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 40,
    TRet_nominal=273.15 + 20,
    m=1.3) "System temperatures 40/20/32";
