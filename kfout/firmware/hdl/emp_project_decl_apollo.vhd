library ieee;
use ieee.std_logic_1164.ALL;
library work;

use work.emp_framework_decl.all;
use work.emp_device_types.all;


package emp_project_decl is


constant PAYLOAD_REV: std_logic_vector(31 downto 0) := X"CAFEBABE";

constant LB_ADDR_WIDTH  : integer := 10;

constant CLOCK_AUX_DIV     : clock_divisor_array_t := (18, 9, 4);
constant CLOCK_COMMON_RATIO: integer               := 36;
constant CLOCK_RATIO       : integer               :=  9;

constant PAYLOAD_LATENCY: integer := 33;

-- mgt -> chk -> buf -> fmt -> (algo) -> (fmt) -> buf -> chk -> mgt -> clk -> altclk
constant REGION_CONF : region_conf_array_t := (
  0  => (no_mgt, buf, no_fmt, buf, no_mgt), --kDummyRegion, -- not used in apollo  -224 A, reserved: util-0 / c2c
  1  => (gty25, buf, no_fmt, buf, gty25),    --225 B, clk from 225 B
  2  => (gty25, buf, no_fmt, buf, gty25),    --226 C, clk from 227 D
  3  => (gty25, buf, no_fmt, buf, gty25),    --227 D, clk from 227 D
  4  => (no_mgt, buf, no_fmt, buf, no_mgt), --  --228 E, reserved: tcds2
  5  => (gty25, buf, no_fmt, buf, gty25),    --229 F, clk from 230 G
  6  => (gty25, buf, no_fmt, buf, gty25),    --230 G, clk from 230 G
  7  => (gty25, buf, no_fmt, buf, gty25),    --231 H, clk from 230 G
  8  => (gty25, buf, no_fmt, buf, gty25),    --232 I, clk from 232 I
  9  => (gty25, buf, no_fmt, buf, gty25),    --233 J, clk from 232 I    
  ------cross
  10  => (gty25, buf, no_fmt, buf, gty25),   --133 S, clk from 132 R
  11  => (gty25, buf, no_fmt, buf, gty25),   --132 R, clk from 132 R
  12  => (gty25, buf, no_fmt, buf, gty25),   --131 Q, clk from 132 R
  13  => (gty25, buf, no_fmt, buf, gty25),   --130 P, clk from 130 P
  14 => (no_mgt, buf, no_fmt, buf, no_mgt), --kDummyRegion -- not used in apollo  --129 O,
  15  => (gty25, buf, no_fmt, buf, gty25),   --128 N, clk from 128 N
  16  => (gty25, buf, no_fmt, buf, gty25),   --127 M, clk from 128 N
  17  => (gty25, buf, no_fmt, buf, gty25),   --126 L, clk from 126 L
  --18 => (no_mgt, buf, no_fmt, buf, no_mgt), --kDummyRegion -- service             --125 K, reserved: util-1
  others => kDummyRegion
);



end;
