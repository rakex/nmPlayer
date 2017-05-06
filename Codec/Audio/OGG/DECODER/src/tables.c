//*@@@+++@@@@******************************************************************
//
// VisualOn voPlayer
// Copyright (C) VisualOn SoftWare Co., Ltd. All rights reserved.
//
//*@@@---@@@@******************************************************************
/*************************************************************************

Copyright(c) 2003-2009 VisualOn SoftWare Co., Ltd.

Module Name:

    tables.c

Abstract:

    OGG tables definition. 

	Normalized modified discrete cosine transform power of two length transform only [64 <= n ]

Author:

    Witten Wen 10-October-2009

Revision History:

*************************************************************************/

#include "macros.h"

/* {sin(2*i*PI/4096), cos(2*i*PI/4096)}, with i = 0 to 512 */
LOOKUP_T sincos_lookup0[1026] = 
{
    X(         0),	X(2147483647),	X(   3294197),	X(2147481121),	
    X(   6588387),	X(2147473542),	X(   9882561),	X(2147460908),	
    X(  13176712),	X(2147443222),	X(  16470832),	X(2147420483),	
    X(  19764913),	X(2147392690),	X(  23058947),	X(2147359845),	
    X(  26352928),	X(2147321946),	X(  29646846),	X(2147278995),	
    X(  32940695),	X(2147230991),	X(  36234466),	X(2147177934),	
    X(  39528151),	X(2147119825),	X(  42821744),	X(2147056664),	
    X(  46115236),	X(2146988450),	X(  49408620),	X(2146915184),	
    X(  52701887),	X(2146836866),	X(  55995030),	X(2146753497),	
    X(  59288042),	X(2146665076),	X(  62580914),	X(2146571603),	
    X(  65873638),	X(2146473080),	X(  69166208),	X(2146369505),	
    X(  72458615),	X(2146260881),	X(  75750851),	X(2146147205),	
    X(  79042909),	X(2146028480),	X(  82334782),	X(2145904705),	
    X(  85626460),	X(2145775880),	X(  88917937),	X(2145642006),	
    X(  92209205),	X(2145503083),	X(  95500255),	X(2145359112),	
    X(  98791081),	X(2145210092),	X( 102081675),	X(2145056025),	
    X( 105372028),	X(2144896910),	X( 108662134),	X(2144732748),	
    X( 111951983),	X(2144563539),	X( 115241570),	X(2144389283),	
    X( 118530885),	X(2144209982),	X( 121819921),	X(2144025635),	
    X( 125108670),	X(2143836244),	X( 128397125),	X(2143641807),	
    X( 131685278),	X(2143442326),	X( 134973122),	X(2143237802),	
    X( 138260647),	X(2143028234),	X( 141547847),	X(2142813624),	
    X( 144834714),	X(2142593971),	X( 148121241),	X(2142369276),	
    X( 151407418),	X(2142139541),	X( 154693240),	X(2141904764),	
    X( 157978697),	X(2141664948),	X( 161263783),	X(2141420092),	
    X( 164548489),	X(2141170197),	X( 167832808),	X(2140915264),	
    X( 171116733),	X(2140655293),	X( 174400254),	X(2140390284),	
    X( 177683365),	X(2140120240),	X( 180966058),	X(2139845159),	
    X( 184248325),	X(2139565043),	X( 187530159),	X(2139279892),	
    X( 190811551),	X(2138989708),	X( 194092495),	X(2138694490),	
    X( 197372981),	X(2138394240),	X( 200653003),	X(2138088958),	
    X( 203932553),	X(2137778644),	X( 207211624),	X(2137463301),	
    X( 210490206),	X(2137142927),	X( 213768293),	X(2136817525),	
    X( 217045878),	X(2136487095),	X( 220322951),	X(2136151637),	
    X( 223599506),	X(2135811153),	X( 226875535),	X(2135465642),	
    X( 230151030),	X(2135115107),	X( 233425984),	X(2134759548),	
    X( 236700388),	X(2134398966),	X( 239974235),	X(2134033361),	
    X( 243247518),	X(2133662734),	X( 246520228),	X(2133287087),	
    X( 249792358),	X(2132906420),	X( 253063900),	X(2132520734),	
    X( 256334847),	X(2132130030),	X( 259605191),	X(2131734309),	
    X( 262874923),	X(2131333572),	X( 266144038),	X(2130927819),	
    X( 269412525),	X(2130517052),	X( 272680379),	X(2130101272),	
    X( 275947592),	X(2129680480),	X( 279214155),	X(2129254676),	
    X( 282480061),	X(2128823862),	X( 285745302),	X(2128388038),	
    X( 289009871),	X(2127947206),	X( 292273760),	X(2127501367),	
    X( 295536961),	X(2127050522),	X( 298799466),	X(2126594672),	
    X( 302061269),	X(2126133817),	X( 305322361),	X(2125667960),	
    X( 308582734),	X(2125197100),	X( 311842381),	X(2124721240),	
    X( 315101295),	X(2124240380),	X( 318359466),	X(2123754522),	
    X( 321616889),	X(2123263666),	X( 324873555),	X(2122767814),	
    X( 328129457),	X(2122266967),	X( 331384586),	X(2121761126),	
    X( 334638936),	X(2121250292),	X( 337892498),	X(2120734467),	
    X( 341145265),	X(2120213651),	X( 344397230),	X(2119687847),	
    X( 347648383),	X(2119157054),	X( 350898719),	X(2118621275),	
    X( 354148230),	X(2118080511),	X( 357396906),	X(2117534762),	
    X( 360644742),	X(2116984031),	X( 363891730),	X(2116428319),	
    X( 367137861),	X(2115867626),	X( 370383128),	X(2115301954),	
    X( 373627523),	X(2114731305),	X( 376871039),	X(2114155680),	
    X( 380113669),	X(2113575080),	X( 383355404),	X(2112989506),	
    X( 386596237),	X(2112398960),	X( 389836160),	X(2111803444),	
    X( 393075166),	X(2111202959),	X( 396313247),	X(2110597505),	
    X( 399550396),	X(2109987085),	X( 402786604),	X(2109371700),	
    X( 406021865),	X(2108751352),	X( 409256170),	X(2108126041),	
    X( 412489512),	X(2107495770),	X( 415721883),	X(2106860540),	
    X( 418953276),	X(2106220352),	X( 422183684),	X(2105575208),	
    X( 425413098),	X(2104925109),	X( 428641511),	X(2104270057),	
    X( 431868915),	X(2103610054),	X( 435095303),	X(2102945101),	
    X( 438320667),	X(2102275199),	X( 441545000),	X(2101600350),	
    X( 444768294),	X(2100920556),	X( 447990541),	X(2100235819),	
    X( 451211734),	X(2099546139),	X( 454431865),	X(2098851519),	
    X( 457650927),	X(2098151960),	X( 460868912),	X(2097447464),	
    X( 464085813),	X(2096738032),	X( 467301622),	X(2096023667),	
    X( 470516330),	X(2095304370),	X( 473729932),	X(2094580142),	
    X( 476942419),	X(2093850985),	X( 480153784),	X(2093116901),	
    X( 483364019),	X(2092377892),	X( 486573117),	X(2091633960),	
    X( 489781069),	X(2090885105),	X( 492987869),	X(2090131331),	
    X( 496193509),	X(2089372638),	X( 499397982),	X(2088609029),	
    X( 502601279),	X(2087840505),	X( 505803394),	X(2087067068),	
    X( 509004318),	X(2086288720),	X( 512204045),	X(2085505463),	
    X( 515402566),	X(2084717298),	X( 518599875),	X(2083924228),	
    X( 521795963),	X(2083126254),	X( 524990824),	X(2082323379),	
    X( 528184449),	X(2081515603),	X( 531376831),	X(2080702930),	
    X( 534567963),	X(2079885360),	X( 537757837),	X(2079062896),	
    X( 540946445),	X(2078235540),	X( 544133781),	X(2077403294),	
    X( 547319836),	X(2076566160),	X( 550504604),	X(2075724139),	
    X( 553688076),	X(2074877233),	X( 556870245),	X(2074025446),	
    X( 560051104),	X(2073168777),	X( 563230645),	X(2072307231),	
    X( 566408860),	X(2071440808),	X( 569585743),	X(2070569511),	
    X( 572761285),	X(2069693342),	X( 575935480),	X(2068812302),	
    X( 579108320),	X(2067926394),	X( 582279796),	X(2067035621),	
    X( 585449903),	X(2066139983),	X( 588618632),	X(2065239484),	
    X( 591785976),	X(2064334124),	X( 594951927),	X(2063423908),	
    X( 598116479),	X(2062508835),	X( 601279623),	X(2061588910),	
    X( 604441352),	X(2060664133),	X( 607601658),	X(2059734508),	
    X( 610760536),	X(2058800036),	X( 613917975),	X(2057860719),	
    X( 617073971),	X(2056916560),	X( 620228514),	X(2055967560),	
    X( 623381598),	X(2055013723),	X( 626533215),	X(2054055050),	
    X( 629683357),	X(2053091544),	X( 632832018),	X(2052123207),	
    X( 635979190),	X(2051150040),	X( 639124865),	X(2050172048),	
    X( 642269036),	X(2049189231),	X( 645411696),	X(2048201592),	
    X( 648552838),	X(2047209133),	X( 651692453),	X(2046211857),	
    X( 654830535),	X(2045209767),	X( 657967075),	X(2044202863),	
    X( 661102068),	X(2043191150),	X( 664235505),	X(2042174628),	
    X( 667367379),	X(2041153301),	X( 670497682),	X(2040127172),	
    X( 673626408),	X(2039096241),	X( 676753549),	X(2038060512),	
    X( 679879097),	X(2037019988),	X( 683003045),	X(2035974670),	
    X( 686125387),	X(2034924562),	X( 689246113),	X(2033869665),	
    X( 692365218),	X(2032809982),	X( 695482694),	X(2031745516),	
    X( 698598533),	X(2030676269),	X( 701712728),	X(2029602243),	
    X( 704825272),	X(2028523442),	X( 707936158),	X(2027439867),	
    X( 711045377),	X(2026351522),	X( 714152924),	X(2025258408),	
    X( 717258790),	X(2024160529),	X( 720362968),	X(2023057887),	
    X( 723465451),	X(2021950484),	X( 726566232),	X(2020838323),	
    X( 729665303),	X(2019721407),	X( 732762657),	X(2018599739),	
    X( 735858287),	X(2017473321),	X( 738952186),	X(2016342155),	
    X( 742044345),	X(2015206245),	X( 745134758),	X(2014065592),	
    X( 748223418),	X(2012920201),	X( 751310318),	X(2011770073),	
    X( 754395449),	X(2010615210),	X( 757478806),	X(2009455617),	
    X( 760560380),	X(2008291295),	X( 763640164),	X(2007122248),	
    X( 766718151),	X(2005948478),	X( 769794334),	X(2004769987),	
    X( 772868706),	X(2003586779),	X( 775941259),	X(2002398857),	
    X( 779011986),	X(2001206222),	X( 782080880),	X(2000008879),	
    X( 785147934),	X(1998806829),	X( 788213141),	X(1997600076),	
    X( 791276492),	X(1996388622),	X( 794337982),	X(1995172471),	
    X( 797397602),	X(1993951625),	X( 800455346),	X(1992726087),	
    X( 803511207),	X(1991495860),	X( 806565177),	X(1990260946),	
    X( 809617249),	X(1989021350),	X( 812667415),	X(1987777073),	
    X( 815715670),	X(1986528118),	X( 818762005),	X(1985274489),	
    X( 821806413),	X(1984016189),	X( 824848888),	X(1982753220),	
    X( 827889422),	X(1981485585),	X( 830928007),	X(1980213288),	
    X( 833964638),	X(1978936331),	X( 836999305),	X(1977654717),	
    X( 840032004),	X(1976368450),	X( 843062726),	X(1975077532),	
    X( 846091463),	X(1973781967),	X( 849118210),	X(1972481757),	
    X( 852142959),	X(1971176906),	X( 855165703),	X(1969867417),	
    X( 858186435),	X(1968553292),	X( 861205147),	X(1967234535),	
    X( 864221832),	X(1965911148),	X( 867236484),	X(1964583136),	
    X( 870249095),	X(1963250501),	X( 873259659),	X(1961913246),	
    X( 876268167),	X(1960571375),	X( 879274614),	X(1959224890),	
    X( 882278992),	X(1957873796),	X( 885281293),	X(1956518093),	
    X( 888281512),	X(1955157788),	X( 891279640),	X(1953792881),	
    X( 894275671),	X(1952423377),	X( 897269597),	X(1951049279),	
    X( 900261413),	X(1949670589),	X( 903251110),	X(1948287312),	
    X( 906238681),	X(1946899451),	X( 909224120),	X(1945507008),	
    X( 912207419),	X(1944109987),	X( 915188572),	X(1942708392),	
    X( 918167572),	X(1941302225),	X( 921144411),	X(1939891490),	
    X( 924119082),	X(1938476190),	X( 927091579),	X(1937056329),	
    X( 930061894),	X(1935631910),	X( 933030021),	X(1934202936),	
    X( 935995952),	X(1932769411),	X( 938959681),	X(1931331338),	
    X( 941921200),	X(1929888720),	X( 944880503),	X(1928441561),	
    X( 947837582),	X(1926989864),	X( 950792431),	X(1925533633),	
    X( 953745043),	X(1924072871),	X( 956695411),	X(1922607581),	
    X( 959643527),	X(1921137767),	X( 962589385),	X(1919663432),	
    X( 965532978),	X(1918184581),	X( 968474300),	X(1916701216),	
    X( 971413342),	X(1915213340),	X( 974350098),	X(1913720958),	
    X( 977284562),	X(1912224073),	X( 980216726),	X(1910722688),	
    X( 983146583),	X(1909216806),	X( 986074127),	X(1907706433),	
    X( 988999351),	X(1906191570),	X( 991922248),	X(1904672222),	
    X( 994842810),	X(1903148392),	X( 997761031),	X(1901620084),	
    X(1000676905),	X(1900087301),	X(1003590424),	X(1898550047),	
    X(1006501581),	X(1897008325),	X(1009410370),	X(1895462140),	
    X(1012316784),	X(1893911494),	X(1015220816),	X(1892356392),	
    X(1018122458),	X(1890796837),	X(1021021705),	X(1889232832),	
    X(1023918550),	X(1887664383),	X(1026812985),	X(1886091491),	
    X(1029705004),	X(1884514161),	X(1032594600),	X(1882932397),	
    X(1035481766),	X(1881346202),	X(1038366495),	X(1879755580),	
    X(1041248781),	X(1878160535),	X(1044128617),	X(1876561070),	
    X(1047005996),	X(1874957189),	X(1049880912),	X(1873348897),	
    X(1052753357),	X(1871736196),	X(1055623324),	X(1870119091),	
    X(1058490808),	X(1868497586),	X(1061355801),	X(1866871683),	
    X(1064218296),	X(1865241388),	X(1067078288),	X(1863606704),	
    X(1069935768),	X(1861967634),	X(1072790730),	X(1860324183),	
    X(1075643169),	X(1858676355),	X(1078493076),	X(1857024153),	
    X(1081340445),	X(1855367581),	X(1084185270),	X(1853706643),	
    X(1087027544),	X(1852041343),	X(1089867259),	X(1850371686),	
    X(1092704411),	X(1848697674),	X(1095538991),	X(1847019312),	
    X(1098370993),	X(1845336604),	X(1101200410),	X(1843649553),	
    X(1104027237),	X(1841958164),	X(1106851465),	X(1840262441),	
    X(1109673089),	X(1838562388),	X(1112492101),	X(1836858008),	
    X(1115308496),	X(1835149306),	X(1118122267),	X(1833436286),	
    X(1120933406),	X(1831718951),	X(1123741908),	X(1829997307),	
    X(1126547765),	X(1828271356),	X(1129350972),	X(1826541103),	
    X(1132151521),	X(1824806552),	X(1134949406),	X(1823067707),	
    X(1137744621),	X(1821324572),	X(1140537158),	X(1819577151),	
    X(1143327011),	X(1817825449),	X(1146114174),	X(1816069469),	
    X(1148898640),	X(1814309216),	X(1151680403),	X(1812544694),	
    X(1154459456),	X(1810775906),	X(1157235792),	X(1809002858),	
    X(1160009405),	X(1807225553),	X(1162780288),	X(1805443995),	
    X(1165548435),	X(1803658189),	X(1168313840),	X(1801868139),	
    X(1171076495),	X(1800073849),	X(1173836395),	X(1798275323),	
    X(1176593533),	X(1796472565),	X(1179347902),	X(1794665580),	
    X(1182099496),	X(1792854372),	X(1184848308),	X(1791038946),	
    X(1187594332),	X(1789219305),	X(1190337562),	X(1787395453),	
    X(1193077991),	X(1785567396),	X(1195815612),	X(1783735137),	
    X(1198550419),	X(1781898681),	X(1201282407),	X(1780058032),	
    X(1204011567),	X(1778213194),	X(1206737894),	X(1776364172),	
    X(1209461382),	X(1774510970),	X(1212182024),	X(1772653593),	
    X(1214899813),	X(1770792044),	X(1217614743),	X(1768926328),	
    X(1220326809),	X(1767056450),	X(1223036002),	X(1765182414),	
    X(1225742318),	X(1763304224),	X(1228445750),	X(1761421885),	
    X(1231146291),	X(1759535401),	X(1233843935),	X(1757644777),	
    X(1236538675),	X(1755750017),	X(1239230506),	X(1753851126),	
    X(1241919421),	X(1751948107),	X(1244605414),	X(1750040966),	
    X(1247288478),	X(1748129707),	X(1249968606),	X(1746214334),	
    X(1252645794),	X(1744294853),	X(1255320034),	X(1742371267),	
    X(1257991320),	X(1740443581),	X(1260659646),	X(1738511799),	
    X(1263325005),	X(1736575927),	X(1265987392),	X(1734635968),	
    X(1268646800),	X(1732691928),	X(1271303222),	X(1730743810),	
    X(1273956653),	X(1728791620),	X(1276607086),	X(1726835361),	
    X(1279254516),	X(1724875040),	X(1281898935),	X(1722910659),	
    X(1284540337),	X(1720942225),	X(1287178717),	X(1718969740),	
    X(1289814068),	X(1716993211),	X(1292446384),	X(1715012642),	
    X(1295075659),	X(1713028037),	X(1297701886),	X(1711039401),	
    X(1300325060),	X(1709046739),	X(1302945174),	X(1707050055),	
    X(1305562222),	X(1705049355),	X(1308176198),	X(1703044642),	
    X(1310787095),	X(1701035922),	X(1313394909),	X(1699023199),	
    X(1315999631),	X(1697006479),	X(1318601257),	X(1694985765),	
    X(1321199781),	X(1692961062),	X(1323795195),	X(1690932376),	
    X(1326387494),	X(1688899711),	X(1328976672),	X(1686863072),	
    X(1331562723),	X(1684822463),	X(1334145641),	X(1682777890),	
    X(1336725419),	X(1680729357),	X(1339302052),	X(1678676870),	
    X(1341875533),	X(1676620432),	X(1344445857),	X(1674560049),	
    X(1347013017),	X(1672495725),	X(1349577007),	X(1670427466),	
    X(1352137822),	X(1668355276),	X(1354695455),	X(1666279161),	
    X(1357249901),	X(1664199124),	X(1359801152),	X(1662115172),	
    X(1362349204),	X(1660027308),	X(1364894050),	X(1657935539),	
    X(1367435685),	X(1655839867),	X(1369974101),	X(1653740300),	
    X(1372509294),	X(1651636841),	X(1375041258),	X(1649529496),	
    X(1377569986),	X(1647418269),	X(1380095472),	X(1645303166),	
    X(1382617710),	X(1643184191),	X(1385136696),	X(1641061349),	
    X(1387652422),	X(1638934646),	X(1390164882),	X(1636804087),	
    X(1392674072),	X(1634669676),	X(1395179984),	X(1632531418),	
    X(1397682613),	X(1630389319),	X(1400181954),	X(1628243383),	
    X(1402678000),	X(1626093616),	X(1405170745),	X(1623940023),	
    X(1407660183),	X(1621782608),	X(1410146309),	X(1619621377),	
    X(1412629117),	X(1617456335),	X(1415108601),	X(1615287487),	
    X(1417584755),	X(1613114838),	X(1420057574),	X(1610938393),	
    X(1422527051),	X(1608758157),	X(1424993180),	X(1606574136),	
    X(1427455956),	X(1604386335),	X(1429915374),	X(1602194758),	
    X(1432371426),	X(1599999411),	X(1434824109),	X(1597800299),	
    X(1437273414),	X(1595597428),	X(1439719338),	X(1593390801),	
    X(1442161874),	X(1591180426),	X(1444601017),	X(1588966306),	
    X(1447036760),	X(1586748447),	X(1449469098),	X(1584526854),	
    X(1451898025),	X(1582301533),	X(1454323536),	X(1580072489),	
    X(1456745625),	X(1577839726),	X(1459164286),	X(1575603251),	
    X(1461579514),	X(1573363068),	X(1463991302),	X(1571119183),	
    X(1466399645),	X(1568871601),	X(1468804538),	X(1566620327),	
    X(1471205974),	X(1564365367),	X(1473603949),	X(1562106725),	
    X(1475998456),	X(1559844408),	X(1478389489),	X(1557578421),	
    X(1480777044),	X(1555308768),	X(1483161115),	X(1553035455),	
    X(1485541696),	X(1550758488),	X(1487918781),	X(1548477872),	
    X(1490292364),	X(1546193612),	X(1492662441),	X(1543905714),	
    X(1495029006),	X(1541614183),	X(1497392053),	X(1539319024),	
    X(1499751576),	X(1537020244),	X(1502107570),	X(1534717846),	
    X(1504460029),	X(1532411837),	X(1506808949),	X(1530102222),	
    X(1509154322),	X(1527789007),	X(1511496145),	X(1525472197),	
    X(1513834411),	X(1523151797),	X(1516169114),	X(1520827813),	
    X(1518500250),	X(1518500250),	
};

  /* {sin((2*i+1)*PI/4096), cos((2*i+1)*PI/4096)}, with i = 0 to 511 */
LOOKUP_T sincos_lookup1[1024] = 
{
	X(   1647099),	X(2147483016),	X(   4941294),	X(2147477963),	
    X(   8235476),	X(2147467857),	X(  11529640),	X(2147452697),	
    X(  14823776),	X(2147432484),	X(  18117878),	X(2147407218),	
    X(  21411936),	X(2147376899),	X(  24705945),	X(2147341527),	
    X(  27999895),	X(2147301102),	X(  31293780),	X(2147255625),	
    X(  34587590),	X(2147205094),	X(  37881320),	X(2147149511),	
    X(  41174960),	X(2147088876),	X(  44468503),	X(2147023188),	
    X(  47761942),	X(2146952448),	X(  51055268),	X(2146876656),	
    X(  54348475),	X(2146795813),	X(  57641553),	X(2146709917),	
    X(  60934496),	X(2146618971),	X(  64227295),	X(2146522973),	
    X(  67519943),	X(2146421924),	X(  70812432),	X(2146315824),	
    X(  74104755),	X(2146204674),	X(  77396903),	X(2146088474),	
    X(  80688869),	X(2145967224),	X(  83980645),	X(2145840924),	
    X(  87272224),	X(2145709574),	X(  90563597),	X(2145573176),	
    X(  93854758),	X(2145431729),	X(  97145697),	X(2145285233),	
    X( 100436408),	X(2145133690),	X( 103726882),	X(2144977098),	
    X( 107017112),	X(2144815460),	X( 110307091),	X(2144648774),	
    X( 113596810),	X(2144477042),	X( 116886262),	X(2144300264),	
    X( 120175438),	X(2144118439),	X( 123464332),	X(2143931570),	
    X( 126752935),	X(2143739656),	X( 130041240),	X(2143542697),	
    X( 133329239),	X(2143340694),	X( 136616925),	X(2143133648),	
    X( 139904288),	X(2142921559),	X( 143191323),	X(2142704427),	
    X( 146478021),	X(2142482254),	X( 149764374),	X(2142255039),	
    X( 153050374),	X(2142022783),	X( 156336015),	X(2141785486),	
    X( 159621287),	X(2141543150),	X( 162906184),	X(2141295774),	
    X( 166190698),	X(2141043360),	X( 169474820),	X(2140785908),	
    X( 172758544),	X(2140523418),	X( 176041861),	X(2140255892),	
    X( 179324764),	X(2139983329),	X( 182607245),	X(2139705730),	
    X( 185889297),	X(2139423097),	X( 189170911),	X(2139135429),	
    X( 192452080),	X(2138842728),	X( 195732795),	X(2138544994),	
    X( 199013051),	X(2138242228),	X( 202292838),	X(2137934430),	
    X( 205572149),	X(2137621601),	X( 208850976),	X(2137303743),	
    X( 212129312),	X(2136980855),	X( 215407149),	X(2136652938),	
    X( 218684479),	X(2136319994),	X( 221961294),	X(2135982023),	
    X( 225237587),	X(2135639026),	X( 228513350),	X(2135291003),	
    X( 231788575),	X(2134937956),	X( 235063255),	X(2134579885),	
    X( 238337382),	X(2134216791),	X( 241610947),	X(2133848675),	
    X( 244883945),	X(2133475538),	X( 248156366),	X(2133097381),	
    X( 251428203),	X(2132714204),	X( 254699448),	X(2132326009),	
    X( 257970095),	X(2131932796),	X( 261240134),	X(2131534567),	
    X( 264509558),	X(2131131322),	X( 267778360),	X(2130723062),	
    X( 271046532),	X(2130309789),	X( 274314066),	X(2129891502),	
    X( 277580955),	X(2129468204),	X( 280847190),	X(2129039895),	
    X( 284112765),	X(2128606576),	X( 287377671),	X(2128168248),	
    X( 290641901),	X(2127724913),	X( 293905447),	X(2127276570),	
    X( 297168301),	X(2126823222),	X( 300430456),	X(2126364870),	
    X( 303691904),	X(2125901514),	X( 306952638),	X(2125433155),	
    X( 310212649),	X(2124959795),	X( 313471930),	X(2124481435),	
    X( 316730474),	X(2123998076),	X( 319988272),	X(2123509718),	
    X( 323245317),	X(2123016364),	X( 326501602),	X(2122518015),	
    X( 329757119),	X(2122014670),	X( 333011859),	X(2121506333),	
    X( 336265816),	X(2120993003),	X( 339518981),	X(2120474683),	
    X( 342771348),	X(2119951372),	X( 346022908),	X(2119423074),	
    X( 349273654),	X(2118889788),	X( 352523578),	X(2118351516),	
    X( 355772673),	X(2117808259),	X( 359020930),	X(2117260020),	
    X( 362268343),	X(2116706797),	X( 365514903),	X(2116148595),	
    X( 368760603),	X(2115585412),	X( 372005435),	X(2115017252),	
    X( 375249392),	X(2114444114),	X( 378492466),	X(2113866001),	
    X( 381734649),	X(2113282914),	X( 384975934),	X(2112694855),	
    X( 388216313),	X(2112101824),	X( 391455778),	X(2111503822),	
    X( 394694323),	X(2110900853),	X( 397931939),	X(2110292916),	
    X( 401168618),	X(2109680013),	X( 404404353),	X(2109062146),	
    X( 407639137),	X(2108439317),	X( 410872962),	X(2107811526),	
    X( 414105819),	X(2107178775),	X( 417337703),	X(2106541065),	
    X( 420568604),	X(2105898399),	X( 423798515),	X(2105250778),	
    X( 427027430),	X(2104598202),	X( 430255339),	X(2103940674),	
    X( 433482236),	X(2103278196),	X( 436708113),	X(2102610768),	
    X( 439932963),	X(2101938393),	X( 443156777),	X(2101261071),	
    X( 446379549),	X(2100578805),	X( 449601270),	X(2099891596),	
    X( 452821933),	X(2099199446),	X( 456041530),	X(2098502357),	
    X( 459260055),	X(2097800329),	X( 462477499),	X(2097093365),	
    X( 465693854),	X(2096381466),	X( 468909114),	X(2095664635),	
    X( 472123270),	X(2094942872),	X( 475336316),	X(2094216179),	
    X( 478548243),	X(2093484559),	X( 481759043),	X(2092748012),	
    X( 484968710),	X(2092006541),	X( 488177236),	X(2091260147),	
    X( 491384614),	X(2090508833),	X( 494590835),	X(2089752599),	
    X( 497795892),	X(2088991448),	X( 500999778),	X(2088225381),	
    X( 504202485),	X(2087454400),	X( 507404005),	X(2086678508),	
    X( 510604332),	X(2085897705),	X( 513803457),	X(2085111994),	
    X( 517001373),	X(2084321376),	X( 520198072),	X(2083525854),	
    X( 523393547),	X(2082725429),	X( 526587791),	X(2081920103),	
    X( 529780796),	X(2081109879),	X( 532972554),	X(2080294757),	
    X( 536163058),	X(2079474740),	X( 539352300),	X(2078649830),	
    X( 542540273),	X(2077820028),	X( 545726969),	X(2076985338),	
    X( 548912382),	X(2076145760),	X( 552096502),	X(2075301296),	
    X( 555279324),	X(2074451950),	X( 558460839),	X(2073597721),	
    X( 561641039),	X(2072738614),	X( 564819919),	X(2071874629),	
    X( 567997469),	X(2071005769),	X( 571173682),	X(2070132035),	
    X( 574348552),	X(2069253430),	X( 577522070),	X(2068369957),	
    X( 580694229),	X(2067481616),	X( 583865021),	X(2066588410),	
    X( 587034440),	X(2065690341),	X( 590202477),	X(2064787411),	
    X( 593369126),	X(2063879623),	X( 596534378),	X(2062966978),	
    X( 599698227),	X(2062049479),	X( 602860664),	X(2061127128),	
    X( 606021683),	X(2060199927),	X( 609181276),	X(2059267877),	
    X( 612339436),	X(2058330983),	X( 615496154),	X(2057389244),	
    X( 618651424),	X(2056442665),	X( 621805239),	X(2055491246),	
    X( 624957590),	X(2054534991),	X( 628108471),	X(2053573901),	
    X( 631257873),	X(2052607979),	X( 634405791),	X(2051637227),	
    X( 637552215),	X(2050661647),	X( 640697139),	X(2049681242),	
    X( 643840556),	X(2048696014),	X( 646982457),	X(2047705965),	
    X( 650122837),	X(2046711097),	X( 653261686),	X(2045711414),	
    X( 656398998),	X(2044706916),	X( 659534766),	X(2043697608),	
    X( 662668981),	X(2042683490),	X( 665801638),	X(2041664565),	
    X( 668932727),	X(2040640837),	X( 672062243),	X(2039612306),	
    X( 675190177),	X(2038578976),	X( 678316522),	X(2037540850),	
    X( 681441272),	X(2036497928),	X( 684564417),	X(2035450215),	
    X( 687685952),	X(2034397712),	X( 690805869),	X(2033340422),	
    X( 693924160),	X(2032278347),	X( 697040818),	X(2031211490),	
    X( 700155836),	X(2030139853),	X( 703269207),	X(2029063439),	
    X( 706380923),	X(2027982251),	X( 709490976),	X(2026896291),	
    X( 712599360),	X(2025805561),	X( 715706067),	X(2024710064),	
    X( 718811090),	X(2023609803),	X( 721914422),	X(2022504780),	
    X( 725016055),	X(2021394998),	X( 728115982),	X(2020280460),	
    X( 731214195),	X(2019161167),	X( 734310688),	X(2018037123),	
    X( 737405453),	X(2016908331),	X( 740498483),	X(2015774793),	
    X( 743589770),	X(2014636511),	X( 746679308),	X(2013493489),	
    X( 749767089),	X(2012345729),	X( 752853105),	X(2011193233),	
    X( 755937350),	X(2010036005),	X( 759019816),	X(2008874047),	
    X( 762100496),	X(2007707362),	X( 765179382),	X(2006535953),	
    X( 768256469),	X(2005359822),	X( 771331747),	X(2004178973),	
    X( 774405210),	X(2002993407),	X( 777476851),	X(2001803128),	
    X( 780546663),	X(2000608139),	X( 783614638),	X(1999408442),	
    X( 786680769),	X(1998204040),	X( 789745049),	X(1996994937),	
    X( 792807470),	X(1995781134),	X( 795868026),	X(1994562635),	
    X( 798926709),	X(1993339442),	X( 801983513),	X(1992111559),	
    X( 805038429),	X(1990878989),	X( 808091450),	X(1989641733),	
    X( 811142571),	X(1988399796),	X( 814191782),	X(1987153180),	
    X( 817239078),	X(1985901888),	X( 820284450),	X(1984645923),	
    X( 823327893),	X(1983385288),	X( 826369398),	X(1982119985),	
    X( 829408958),	X(1980850019),	X( 832446567),	X(1979575392),	
    X( 835482217),	X(1978296106),	X( 838515901),	X(1977012165),	
    X( 841547612),	X(1975723572),	X( 844577343),	X(1974430331),	
    X( 847605086),	X(1973132443),	X( 850630835),	X(1971829912),	
    X( 853654582),	X(1970522741),	X( 856676321),	X(1969210933),	
    X( 859696043),	X(1967894492),	X( 862713743),	X(1966573420),	
    X( 865729413),	X(1965247720),	X( 868743045),	X(1963917396),	
    X( 871754633),	X(1962582451),	X( 874764170),	X(1961242888),	
    X( 877771649),	X(1959898709),	X( 880777062),	X(1958549919),	
    X( 883780402),	X(1957196520),	X( 886781663),	X(1955838516),	
    X( 889780838),	X(1954475909),	X( 892777918),	X(1953108703),	
    X( 895772898),	X(1951736902),	X( 898765769),	X(1950360508),	
    X( 901756526),	X(1948979524),	X( 904745161),	X(1947593954),	
    X( 907731667),	X(1946203802),	X( 910716038),	X(1944809070),	
    X( 913698265),	X(1943409761),	X( 916678342),	X(1942005880),	
    X( 919656262),	X(1940597428),	X( 922632018),	X(1939184411),	
    X( 925605603),	X(1937766830),	X( 928577010),	X(1936344689),	
    X( 931546231),	X(1934917992),	X( 934513261),	X(1933486742),	
    X( 937478092),	X(1932050943),	X( 940440717),	X(1930610597),	
    X( 943401129),	X(1929165708),	X( 946359321),	X(1927716279),	
    X( 949315286),	X(1926262315),	X( 952269017),	X(1924803818),	
    X( 955220508),	X(1923340791),	X( 958169751),	X(1921873239),	
    X( 961116739),	X(1920401165),	X( 964061465),	X(1918924571),	
    X( 967003923),	X(1917443462),	X( 969944106),	X(1915957841),	
    X( 972882006),	X(1914467712),	X( 975817617),	X(1912973078),	
    X( 978750932),	X(1911473942),	X( 981681943),	X(1909970309),	
    X( 984610645),	X(1908462181),	X( 987537030),	X(1906949562),	
    X( 990461091),	X(1905432457),	X( 993382821),	X(1903910867),	
    X( 996302214),	X(1902384797),	X( 999219262),	X(1900854251),	
    X(1002133959),	X(1899319232),	X(1005046298),	X(1897779744),	
    X(1007956272),	X(1896235790),	X(1010863875),	X(1894687374),	
    X(1013769098),	X(1893134500),	X(1016671936),	X(1891577171),	
    X(1019572382),	X(1890015391),	X(1022470428),	X(1888449163),	
    X(1025366069),	X(1886878492),	X(1028259297),	X(1885303381),	
    X(1031150105),	X(1883723833),	X(1034038487),	X(1882139853),	
    X(1036924436),	X(1880551444),	X(1039807944),	X(1878958610),	
    X(1042689006),	X(1877361354),	X(1045567615),	X(1875759681),	
    X(1048443763),	X(1874153594),	X(1051317443),	X(1872543097),	
    X(1054188651),	X(1870928194),	X(1057057377),	X(1869308888),	
    X(1059923616),	X(1867685184),	X(1062787361),	X(1866057085),	
    X(1065648605),	X(1864424594),	X(1068507342),	X(1862787717),	
    X(1071363564),	X(1861146456),	X(1074217266),	X(1859500816),	
    X(1077068439),	X(1857850800),	X(1079917078),	X(1856196413),	
    X(1082763176),	X(1854537657),	X(1085606726),	X(1852874538),	
    X(1088447722),	X(1851207059),	X(1091286156),	X(1849535224),	
    X(1094122023),	X(1847859036),	X(1096955314),	X(1846178501),	
    X(1099786025),	X(1844493621),	X(1102614148),	X(1842804401),	
    X(1105439676),	X(1841110844),	X(1108262603),	X(1839412956),	
    X(1111082922),	X(1837710739),	X(1113900627),	X(1836004197),	
    X(1116715710),	X(1834293336),	X(1119528166),	X(1832578158),	
    X(1122337987),	X(1830858668),	X(1125145168),	X(1829134869),	
    X(1127949701),	X(1827406767),	X(1130751579),	X(1825674364),	
    X(1133550797),	X(1823937666),	X(1136347348),	X(1822196675),	
    X(1139141224),	X(1820451397),	X(1141932420),	X(1818701835),	
    X(1144720929),	X(1816947994),	X(1147506745),	X(1815189877),	
    X(1150289860),	X(1813427489),	X(1153070269),	X(1811660833),	
    X(1155847964),	X(1809889915),	X(1158622939),	X(1808114737),	
    X(1161395188),	X(1806335305),	X(1164164704),	X(1804551623),	
    X(1166931481),	X(1802763694),	X(1169695512),	X(1800971523),	
    X(1172456790),	X(1799175115),	X(1175215310),	X(1797374472),	
    X(1177971064),	X(1795569601),	X(1180724046),	X(1793760504),	
    X(1183474250),	X(1791947186),	X(1186221669),	X(1790129652),	
    X(1188966297),	X(1788307905),	X(1191708127),	X(1786481950),	
    X(1194447153),	X(1784651792),	X(1197183368),	X(1782817434),	
    X(1199916766),	X(1780978881),	X(1202647340),	X(1779136137),	
    X(1205375085),	X(1777289206),	X(1208099993),	X(1775438094),	
    X(1210822059),	X(1773582803),	X(1213541275),	X(1771723340),	
    X(1216257636),	X(1769859707),	X(1218971135),	X(1767991909),	
    X(1221681765),	X(1766119952),	X(1224389521),	X(1764243838),	
    X(1227094395),	X(1762363573),	X(1229796382),	X(1760479161),	
    X(1232495475),	X(1758590607),	X(1235191668),	X(1756697914),	
    X(1237884955),	X(1754801087),	X(1240575329),	X(1752900132),	
    X(1243262783),	X(1750995052),	X(1245947312),	X(1749085851),	
    X(1248628909),	X(1747172535),	X(1251307568),	X(1745255107),	
    X(1253983283),	X(1743333573),	X(1256656047),	X(1741407936),	
    X(1259325853),	X(1739478202),	X(1261992697),	X(1737544374),	
    X(1264656571),	X(1735606458),	X(1267317469),	X(1733664458),	
    X(1269975384),	X(1731718378),	X(1272630312),	X(1729768224),	
    X(1275282245),	X(1727813999),	X(1277931177),	X(1725855708),	
    X(1280577102),	X(1723893357),	X(1283220013),	X(1721926948),	
    X(1285859905),	X(1719956488),	X(1288496772),	X(1717981981),	
    X(1291130606),	X(1716003431),	X(1293761402),	X(1714020844),	
    X(1296389154),	X(1712034223),	X(1299013855),	X(1710043573),	
    X(1301635500),	X(1708048900),	X(1304254082),	X(1706050207),	
    X(1306869594),	X(1704047500),	X(1309482032),	X(1702040783),	
    X(1312091388),	X(1700030061),	X(1314697657),	X(1698015339),	
    X(1317300832),	X(1695996621),	X(1319900907),	X(1693973912),	
    X(1322497877),	X(1691947217),	X(1325091734),	X(1689916541),	
    X(1327682474),	X(1687881888),	X(1330270089),	X(1685843263),	
    X(1332854574),	X(1683800672),	X(1335435923),	X(1681754118),	
    X(1338014129),	X(1679703608),	X(1340589187),	X(1677649144),	
    X(1343161090),	X(1675590733),	X(1345729833),	X(1673528379),	
    X(1348295409),	X(1671462087),	X(1350857812),	X(1669391862),	
    X(1353417037),	X(1667317709),	X(1355973077),	X(1665239632),	
    X(1358525926),	X(1663157637),	X(1361075579),	X(1661071729),	
    X(1363622028),	X(1658981911),	X(1366165269),	X(1656888190),	
    X(1368705296),	X(1654790570),	X(1371242101),	X(1652689057),	
    X(1373775680),	X(1650583654),	X(1376306026),	X(1648474367),	
    X(1378833134),	X(1646361202),	X(1381356997),	X(1644244162),	
    X(1383877610),	X(1642123253),	X(1386394966),	X(1639998480),	
    X(1388909060),	X(1637869848),	X(1391419886),	X(1635737362),	
    X(1393927438),	X(1633601027),	X(1396431709),	X(1631460848),	
    X(1398932695),	X(1629316830),	X(1401430389),	X(1627168978),	
    X(1403924785),	X(1625017297),	X(1406415878),	X(1622861793),	
    X(1408903661),	X(1620702469),	X(1411388129),	X(1618539332),	
    X(1413869275),	X(1616372386),	X(1416347095),	X(1614201637),	
    X(1418821582),	X(1612027089),	X(1421292730),	X(1609848749),	
    X(1423760534),	X(1607666620),	X(1426224988),	X(1605480708),	
    X(1428686085),	X(1603291018),	X(1431143821),	X(1601097555),	
    X(1433598189),	X(1598900325),	X(1436049184),	X(1596699333),	
    X(1438496799),	X(1594494583),	X(1440941030),	X(1592286082),	
    X(1443381870),	X(1590073833),	X(1445819314),	X(1587857843),	
    X(1448253355),	X(1585638117),	X(1450683988),	X(1583414660),	
    X(1453111208),	X(1581187476),	X(1455535009),	X(1578956572),	
    X(1457955385),	X(1576721952),	X(1460372329),	X(1574483623),	
    X(1462785838),	X(1572241588),	X(1465195904),	X(1569995854),	
    X(1467602523),	X(1567746425),	X(1470005688),	X(1565493307),	
    X(1472405394),	X(1563236506),	X(1474801636),	X(1560976026),	
    X(1477194407),	X(1558711873),	X(1479583702),	X(1556444052),	
    X(1481969516),	X(1554172569),	X(1484351842),	X(1551897428),	
    X(1486730675),	X(1549618636),	X(1489106011),	X(1547336197),	
    X(1491477842),	X(1545050118),	X(1493846163),	X(1542760402),	
    X(1496210969),	X(1540467057),	X(1498572255),	X(1538170087),	
    X(1500930014),	X(1535869497),	X(1503284242),	X(1533565293),	
    X(1505634932),	X(1531257480),	X(1507982079),	X(1528946064),	
    X(1510325678),	X(1526631051),	X(1512665723),	X(1524312445),	
    X(1515002208),	X(1521990252),	X(1517335128),	X(1519664478),	
};


