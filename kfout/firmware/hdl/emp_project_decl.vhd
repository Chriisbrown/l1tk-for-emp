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

constant PAYLOAD_LATENCY: integer := 34;

-- mgt -> chk -> buf -> fmt -> (algo) -> (fmt) -> buf -> chk -> mgt -> clk -> altclk
constant REGION_CONF : region_conf_array_t := (
  0 => ( gth16, buf,    no_fmt, buf,    gth16 ),
  1 => ( gth16, buf,    no_fmt, no_buf, gth16 ),
 others => kDummyRegion
);



end;
