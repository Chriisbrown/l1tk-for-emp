LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;
USE IEEE.NUMERIC_STD.ALL;

library work;
USE work.emp_data_types.all;
USE work.DataType.ALL;
USE work.ArrayTypes.ALL;

-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
ENTITY GTT_link_decode IS
  PORT(
    clk          : IN STD_LOGIC; -- The algorithm clock
    linksIn      : IN ldata( 1 downto 0 );
    linksOut : OUT ldata( 1 downto 0 )
  );
END GTT_link_decode;
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
ARCHITECTURE rtl OF GTT_link_decode IS
  CONSTANT WordLength : INTEGER := 64;

  SIGNAL Output : Vector( 0 TO 1 ) := NullVector( 2 );

BEGIN
  g1 : FOR i IN 0 TO 1 GENERATE

  SIGNAL temp_framevalid1   : BOOLEAN := FALSE;
  SIGNAL temp_framevalid2   : BOOLEAN := FALSE;
  SIGNAL temp_framevalid3   : BOOLEAN := FALSE;

  SIGNAL track_words : STD_LOGIC_VECTOR(WordLength*2 - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL clockCounter : INTEGER := 1;

  BEGIN

    PROCESS( clk )
      
    BEGIN
      IF RISING_EDGE( clk ) THEN
          
          track_words(   WordLength - 1 DOWNTO   0)          <= linksIn( i ) .data( WordLength-1 DOWNTO 0 );
          track_words( 2*WordLength - 1 DOWNTO   WordLength) <= track_words(   WordLength - 1 DOWNTO 0 );

          temp_framevalid1 <= TRUE WHEN (linksIn( i ) .valid) = '1' ELSE FALSE;
          temp_framevalid2 <= temp_framevalid1;
          temp_framevalid3 <= temp_framevalid2;

          IF clockCounter = 2 THEN

            Output( i ) . ExtraMVA   <= UNSIGNED( track_words( WordLength + bitloc.ExtraMVAh   DOWNTO WordLength + bitloc.ExtraMVAl   ));
            Output( i ) . TQMVA      <= UNSIGNED( track_words( WordLength + bitloc.TQMVAh      DOWNTO WordLength + bitloc.TQMVAl      ));
            Output( i ) . Hitpattern <= UNSIGNED( track_words( WordLength + bitloc.Hitpatternh DOWNTO WordLength + bitloc.Hitpatternl ));
            Output( i ) . BendChi2   <= UNSIGNED( track_words( WordLength + bitloc.BendChi2h   DOWNTO WordLength + bitloc.BendChi2l   ));
            Output( i ) . D0         <=   SIGNED( track_words( WordLength + bitloc.D0h         DOWNTO WordLength + bitloc.D0l         ));

            Output( i ) . Chi2rz     <= UNSIGNED( track_words( WordLength + bitloc.Chi2rzh     DOWNTO WordLength + bitloc.Chi2rzl ));
            Output( i ) . z0         <=   SIGNED( track_words( WordLength + bitloc.Z0h         DOWNTO WordLength + bitloc.Z0l     ));
            Output( i ) . TanL       <=   SIGNED( track_words( WordLength + bitloc.TanLh       DOWNTO WordLength + bitloc.TanLl   ));

            Output( i ) . Chi2rphi   <= UNSIGNED( track_words( bitloc.Chi2rphih - WordLength  DOWNTO bitloc.Chi2rphil - WordLength  ));
            Output( i ) . Phi0       <=   SIGNED( track_words( bitloc.Phi0h - WordLength      DOWNTO bitloc.Phi0l - WordLength ));
            Output( i ) . InvR       <=   SIGNED( track_words( bitloc.InvRh - WordLength      DOWNTO bitloc.InvRl - WordLength  ));
            Output( i ) . TrackValid <= track_words( bitloc.TrackValidi - WordLength );
            
            Output( i ) .DataValid  <= TRUE WHEN ( track_words(bitloc.TrackValidi - WordLength)) = '1' ELSE FALSE;
            Output( i ) .FrameValid <= temp_framevalid1;
            clockCounter <= 3;
            
          
          ELSIF clockCounter = 3 THEN

            Output( i ) . ExtraMVA   <= UNSIGNED( track_words( WordLength + WordLength/2 + bitloc.ExtraMVAh   DOWNTO WordLength + WordLength/2 + bitloc.ExtraMVAl   ));
            Output( i ) . TQMVA      <= UNSIGNED( track_words( WordLength + WordLength/2 + bitloc.TQMVAh      DOWNTO WordLength + WordLength/2 + bitloc.TQMVAl      ));
            Output( i ) . Hitpattern <= UNSIGNED( track_words( WordLength + WordLength/2 + bitloc.Hitpatternh DOWNTO WordLength + WordLength/2 + bitloc.Hitpatternl ));
            Output( i ) . BendChi2   <= UNSIGNED( track_words( WordLength + WordLength/2 + bitloc.BendChi2h   DOWNTO WordLength + WordLength/2 + bitloc.BendChi2l   ));
            Output( i ) . D0         <=   SIGNED( track_words( WordLength + WordLength/2 + bitloc.D0h         DOWNTO WordLength + WordLength/2 + bitloc.D0l         ));

            Output( i ) . Chi2rz     <= UNSIGNED( track_words( bitloc.Chi2rzh - WordLength/2    DOWNTO bitloc.Chi2rzl - WordLength/2 ));
            Output( i ) . z0         <=   SIGNED( track_words( bitloc.Z0h  - WordLength/2       DOWNTO bitloc.Z0l - WordLength/2     ));
            Output( i ) . TanL       <=   SIGNED( track_words( bitloc.TanLh - WordLength/2      DOWNTO bitloc.TanLl - WordLength/2   ));

            Output( i ) . Chi2rphi   <= UNSIGNED( track_words( bitloc.Chi2rphih - WordLength/2     DOWNTO bitloc.Chi2rphil - WordLength/2 ));
            Output( i ) . Phi0       <=   SIGNED( track_words( bitloc.Phi0h - WordLength/2         DOWNTO bitloc.Phi0l - WordLength/2 ));
            Output( i ) . InvR       <=   SIGNED( track_words( bitloc.InvRh - WordLength/2         DOWNTO bitloc.InvRl - WordLength/2 ));
            Output( i ) . TrackValid  <=  track_words( bitloc.TrackValidi - WordLength/2   );

            Output( i ) . DataValid  <= TRUE WHEN ( track_words( bitloc.TrackValidi - WordLength/2 )) = '1' ELSE FALSE;
            Output( i ) . FrameValid <= temp_framevalid1;
            clockCounter <= 1;

          ELSE
            Output( i ) . DataValid  <= FALSE;
            Output( i ) . FrameValid <= temp_framevalid3;
            IF (linksIn( i ) .valid) = '1' OR temp_framevalid1 OR temp_framevalid2 THEN
              clockCounter <= clockCounter + 1;
            ELSE
              clockCounter <= 0;
            END IF;
          END IF;

      END IF;
    END PROCESS;


    PROCESS( clk )
    BEGIN
      IF RISING_EDGE(clk) THEN
      IF Output( i ).DataValid THEN
        linksOut(i).data( 11 DOWNTO 0) <= std_logic_vector(Output( i ).z0);
        linksOut(i).valid <= '1';
        linksOut(i).strobe <= '1';
      ELSE
        linksOut(i).data <= (OTHERS => '0');
        linksOut(i).valid <= '0';
        linksOut(i).strobe <= '1';
    END IF;
      END IF;
    END PROCESS;
  END GENERATE;
-- -------------------------------------------------------------------------

-----------------------------------------------------------------------

END rtl;
