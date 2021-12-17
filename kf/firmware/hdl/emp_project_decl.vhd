library ieee;
use ieee.std_logic_1164.ALL;

use work.emp_framework_decl.all;
use work.emp_device_types.all;


package emp_project_decl is


constant PAYLOAD_REV: std_logic_vector(31 downto 0) := X"12345678";

--constant LHC_BUNCH_COUNT: integer := 3564;
constant LB_ADDR_WIDTH  : integer := 10;

--constant CLOCK_COMMON_RATIO: integer             := 36;
--constant CLOCK_RATIO       : integer             :=  9;
--constant CLOCK_AUX_RATIO   : clock_divisor_array_t := (2, 4, 6);

constant CLOCK_AUX_DIV     : clock_divisor_array_t := (18, 9, 4);
constant CLOCK_COMMON_RATIO: integer               := 36;
constant CLOCK_RATIO       : integer               :=  9;

constant PAYLOAD_LATENCY: integer := 1 + 7 * ( 5 + 16 - 1 ) + 7 + 2 - 3 + 1 + 13 + 5 + 2 - 6;

-- mgt -> chk -> buf -> fmt -> (algo) -> (fmt) -> buf -> chk -> mgt -> clk -> altclk
constant REGION_CONF : region_conf_array_t := (
  0  => kDummyRegion, -- service
  1  => (gty25, buf, no_fmt, buf, gty25),
  2  => (gty25, buf, no_fmt, buf, gty25),
  3  => (gty25, buf, no_fmt, buf, gty25),
  4  => kDummyRegion, -- tcds
  5  => (gty25, buf, no_fmt, buf, gty25),
  6  => (gty25, buf, no_fmt, buf, gty25),
  7  => (gty25, buf, no_fmt, buf, gty25),
  8  => (gty25, buf, no_fmt, buf, gty25),
  9  => (gty25, buf, no_fmt, buf, gty25),
  ------cross
  10  => (gty25, buf, no_fmt, buf, gty25),
  11  => (gty25, buf, no_fmt, buf, gty25),
  12  => (gty25, buf, no_fmt, buf, gty25),
  13  => (gty25, buf, no_fmt, buf, gty25),
  14 => kDummyRegion, -- not used in apollo
  15  => (gty25, buf, no_fmt, buf, gty25),
  16  => (gty25, buf, no_fmt, buf, gty25),
  17  => (gty25, buf, no_fmt, buf, gty25),
  others => kDummyRegion
);


end;
