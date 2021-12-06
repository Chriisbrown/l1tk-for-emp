LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;

USE work.hybrid_tools.ALL;
USE work.hybrid_config.ALL;
USE work.hybrid_data_types.ALL;
USE work.hybrid_data_formats.ALL;
USE work.kfout_config.ALL;

USE work.constants.ALL;
USE work.Types.ALL;

USE work.emp_data_types.ALL;


-- -------------------------------------------------------------------------
ENTITY BDT_module IS
  PORT(
    clk       : IN STD_LOGIC; -- The algorithm clock
    tq_din  : IN t_channelsKF( numNodesKF - 1 downto 0 );
    tq_dout : OUT t_channelsTQ( numNodesKF - 1 downto 0 )
  );
END BDT_module;
-- -------------------------------------------------------------------------

ARCHITECTURE rtl OF BDT_module IS

    SIGNAL out_vector : INTEGER_VECTOR ( numNodesKF - 1 DOWNTO 0 ) := (OTHERS => 0);


BEGIN

KFworkers : FOR i IN 0 TO numNodesKF-1 GENERATE
  SIGNAL input_features : txArray(0 to nFeatures-1) := (others => to_tx(0)); 
  SIGNAL input_valid : boolean := FALSE;

  SIGNAL ty_out : tyArray(0 to nClasses-1) := (others => to_ty(0));
  SIGNAL ty_vld : boolArray(0 to nClasses-1) := (others => False);

  BEGIN
  

  BDTentity : ENTITY work.BDTTop
  PORT MAP(
      clk => clk,
      X => input_features,
      X_vld => input_valid,
      y => ty_out,
      y_vld => ty_vld
  );

  PROCESS (clk)
  VARIABLE stub_counter : INTEGER := 0;
  BEGIN
    
    IF RISING_EDGE(clk) THEN
        stub_counter := 0;
        input_valid <= TO_BOOLEAN(tq_din( i ).track.valid);
        input_features( 0 ) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).track.inv2R))*8);
        input_features( 1 ) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).track.cot))*8);
        input_features( 2 ) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).track.zT))*8);
        input_features( 3 ) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).track.phiT))*8);
        FOR j IN 0 TO numLayers - 1 LOOP
            IF (tq_din( i ).stubs( j ).valid) THEN
              input_features( 4 + 5*stub_counter ) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).stubs( j ).r))*8);
              input_features( 4 + 5*stub_counter + 1) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).stubs( j ).phi))*8);
              input_features( 4 + 5*stub_counter + 2) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).stubs( j ).z))*8);
              input_features( 4 + 5*stub_counter + 3) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).stubs( j ).dPhi))*8);
              input_features( 4 + 5*stub_counter + 4) <= TO_TX(TO_INTEGER(SIGNED(tq_din( i ).stubs( j ).dZ))*8);
              stub_counter := stub_counter + 1;
            END IF;
        END LOOP;

    END IF;
  END PROCESS;

  tq_dout( i ).TQscore <= TO_INTEGER(ty_out( 0 ));
  tq_dout( i ).valid <= ty_vld( 0 );

END GENERATE;
-- ------------------------------------------------------------------------
END rtl;