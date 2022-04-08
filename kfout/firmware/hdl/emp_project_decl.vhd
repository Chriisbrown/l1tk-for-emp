-- emp_project_decl
--
-- Defines constants for the whole device

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.emp_framework_decl.all;
use work.emp_device_types.all;


package emp_project_decl is

  constant PAYLOAD_REV : std_logic_vector(31 downto 0) := X"CAFEBABE";

  -- Latency buffer size
  constant LB_ADDR_WIDTH   : integer := 10;

  -- Clock setup
  constant CLOCK_COMMON_RATIO : integer               := 36;
  constant CLOCK_RATIO        : integer               := 9;
  constant CLOCK_AUX_DIV      : clock_divisor_array_t := (18, 9, 4); -- Dividers of CLOCK_COMMON_RATIO * 40 MHz

  -- Only used by nullalgo   
  constant PAYLOAD_LATENCY : integer := 34;

  constant REGION_CONF : region_conf_array_t := (
    0      => (gth16, buf, no_fmt, buf, gth16),
    1      => (gth16, buf, no_fmt, buf, gth16),
    2      => (gth16, buf, no_fmt, buf, gth16),
    3      => (gth16, buf, no_fmt, buf, gth16),
    4      => (gth16, buf, no_fmt, buf, gth16),
    5      => (gth16, buf, no_fmt, buf, gth16),
    6      => (gth16, buf, no_fmt, buf, gth16),
    7      => (gth16, buf, no_fmt, buf, gth16),
    8      => (gth16, buf, no_fmt, buf, gth16),
    9      => (gth16, buf, no_fmt, buf, gth16),
    -- Cross-chip
    10     => (gty25, buf, no_fmt, buf, gty25),
    11     => (gty25, buf, no_fmt, buf, gty25),
    12     => (gty25, buf, no_fmt, buf, gty25),
    13     => (gty25, buf, no_fmt, buf, gty25),
    14     => (gty25, buf, no_fmt, buf, gty25),
    15     => (gty25, buf, no_fmt, buf, gty25),
    --16     => (gty25, buf, no_fmt, buf, gty25),
    --17     => (gty25, buf, no_fmt, buf, gty25),
    others => kDummyRegion
    );

end emp_project_decl;

--https://gitlab.cern.ch/p2-xware/software/emp-toolbox/-/blob/master/core/etc/emp/links/serenity_dc_ku15p_so1_v1.yml