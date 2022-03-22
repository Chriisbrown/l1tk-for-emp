library ieee;
use ieee.std_logic_1164.all;
use work.hybrid_config.all;
use work.hybrid_data_types.all;
use work.kfin_data_types.all;

entity kfin_format is
port (
  clk: in std_logic;
  format_din: in t_channelR;
  format_dout: out t_channelZHT
);
end;

architecture rtl of kfin_format is

signal track_din: t_channelR := nulll;
signal track_dout: t_trackZHT := nulll;
component format_track
port (
  clk: in std_logic;
  track_din: in t_channelR;
  track_dout: out t_trackZHT
);
end component;

signal stub_track: t_trackR := nulll;
component format_stub
port (
  clk: in std_logic;
  stub_track: in t_trackR;
  stub_din: in t_stubR;
  stub_dout: out t_stubZHT
);
end component;

begin

track_din <= format_din;
format_dout.track <= track_dout;

stub_track <= format_din.track;

c: format_track port map ( clk, track_din, track_dout );

g: for k in 0 to numLayers - 1 generate

signal stub_din: t_stubR := nulll;
signal stub_dout: t_stubZHT := nulll;

begin

stub_din <= format_din.stubs( k );
format_dout.stubs( k ) <= stub_dout;

c: format_stub port map ( clk, stub_track, stub_din, stub_dout );

end generate;

end;


library ieee;
use ieee.std_logic_1164.all;
use work.hybrid_data_types.all;
use work.kfin_data_types.all;

entity format_track is
port (
  clk: in std_logic;
  track_din: in t_channelR;
  track_dout: out t_trackZHT
);
end;

architecture rtl of format_track is

function conv( c: t_channelR ) return t_trackZHT is
  variable t: t_trackR := c.track;
  variable res: t_trackZHT := ( t.reset, t.valid, ( others => '0' ), t.sector, t.phiT, t.inv2R, t.zT, t.cot );
begin
  for k in c.stubs'range loop
    res.maybe( k ) := c.stubs( k ).maybe;
  end loop;
  return res;
end function;

-- step 1

signal din: t_trackZHT := nulll;
signal sr: t_tracksZHT( 4 downto 2 ) := ( others => nulll );

-- step 4

signal dout: t_trackZHT := nulll;

begin

-- step 1
din <= conv( track_din );

-- step 4
track_dout <= dout;

process ( clk ) is
begin
if rising_edge( clk ) then

  -- step 1

  sr <= sr( sr'high - 1 downto sr'low ) & din;

  -- step 4

  dout <= sr( 4 );

end if;
end process;

end;


library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.hybrid_tools.all;
use work.hybrid_config.all;
use work.hybrid_data_types.all;
use work.hybrid_data_formats.all;
use work.kfin_data_types.all;
use work.kfin_data_formats.all;

entity format_stub is
port (
  clk: in std_logic;
  stub_track: in t_trackR;
  stub_din: in t_stubR;
  stub_dout: out t_stubZHT
);
end;

architecture rtl of format_stub is

attribute ram_style: string;
type t_word is
record
  reset: std_logic;
  valid: std_logic;
  r    : std_logic_vector( widthZHTr   - 1 downto 0 );
  phi  : std_logic_vector( widthZHTphi - 1 downto 0 );
  z    : std_logic_vector( widthZHTz   - 1 downto 0 );
end record;
type t_sr is array ( natural range <> ) of t_word;
function nulll return t_word is begin return ( '0', '0', others => ( others => '0' ) ); end function;
type t_dZs is array ( natural range <> ) of std_logic_vector( widthZHTdZ - 1 downto 0 );
function f_index( track: t_trackR; stub: t_stubR ) return std_logic_vector is
begin
  if track.sector( widthLSectorEta - 1 ) = '1' then
    return stub.barrel & stub.ps & stub.tilt & track.sector( widthLSectorEta - 1 - 1 downto 0 ) & track.cot;
  end if;
  return stub.barrel & stub.ps & stub.tilt & not track.sector( widthLSectorEta - 1 - 1 downto 0 ) & not track.cot;
end function;

-- step 1

signal din: t_word := nulll;
signal sr: t_sr( 4 downto 2 ) := ( others => nulll );
signal dsp: t_dspF := ( others => ( others => '0' ) );
signal pitchOverR: std_logic_vector( widthPitchOverR - 1 downto 0 ) := ( others => '0' );
signal indexLength: std_logic_vector( widthIndexLength - 1 downto 0 ) := ( others => '0' );
signal indexPitchOverR: std_logic_vector( widthIndexPitchOverR - 1 downto 0 ) := ( others => '0' );
signal lengths: std_logic_vector( widthLengthZ + widthLengthR - 1 downto 0 ) := ( others => '0' );
signal ramLengths: t_ramLengths := ramLengths;
signal ramPitchOverRs: t_ramPitchOverRs := ramPitchOverRs;
attribute ram_style of ramLengths, ramPitchOverRs: signal is "block";

-- step 2

signal lengthZ: std_logic_vector( widthLengthZ - 1 downto 0 ) := ( others => '0' );
signal lengthR: std_logic_vector( widthLengthR - 1 downto 0 ) := ( others => '0' );
signal dZs: t_dZs( 4 downto 3 ) := ( others => ( others => '0' ) );

-- step 4

signal dout: t_stubZHT := nulll;

begin

--step 1
din <= ( stub_din.reset, stub_din.valid, stub_din.r, stub_din.phi, stub_din.z );
indexLength <= f_index( stub_track, stub_din );
indexPitchOverR <= stub_din.ps & stub_din.r( r_Fr );

-- step 2
lengthZ <= lengths( widthLengthZ + widthLengthR - 1 downto widthLengthR );
lengthR <= lengths(                widthLengthR - 1 downto            0 );

--step 4
stub_dout <= dout;

process ( clk ) is
begin
if rising_edge( clk ) then

  -- step 1

  sr <= sr( sr'high - 1 downto sr'low ) & din;
  
  lengths <= ramLengths( uint( indexLength ) );
  pitchOverR <= ramPitchOverRs( uint( indexPitchOverR ) );
  dsp.b0 <= '0' & abs( stub_track.inv2R ) & '1';

  -- step 2

  dZs <= dZs( dZs'high - 1 downto dZs'low ) & lengthZ;
  dsp.b1 <= dsp.b0;
  dsp.a <= '0' & lengthR & '1';
  dsp.d <= stds( scattering / baseZHTr, widthLengthR ) & '1';
  dsp.c <= pitchOverR & "10";

  -- step 3

  dsp.p <= ( dsp.a + dsp.d ) * dsp.b1 + dsp.c;

  -- step 4

  dout <= nulll;
  if sr( 4 ).reset = '1' then
    dout.reset <= '1';
  elsif  sr( 4 ).valid = '1' then
    dout.valid <= '1';
    dout.r <= sr( 4 ).r;
    dout.phi <= sr( 4 ).phi;
    dout.z <= sr( 4 ).z;
    dout.dPhi <= incr( dsp.p( r_FdPhi ) );
    dout.dz <= dZs( 4 );
  end if;

end if;
end process;

end;