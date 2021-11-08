library ieee;
use ieee.std_logic_1164.all;

use work.tfp_config.all;
use work.tfp_data_formats.all;
use work.emp_data_types.all;


package tfp_data_types is

constant widthDTCr    : natural := work.tfp_data_formats.widthDTCr;
constant widthDTCphi  : natural := work.tfp_data_formats.widthDTCphi;
constant widthDTCz    : natural := work.tfp_data_formats.widthDTCz;
constant widthTFPphi0 : natural := work.tfp_data_formats.widthTFPphi0;
constant widthTFPinv2R: natural := work.tfp_data_formats.widthTFPinv2R;
constant widthTFPcot  : natural := work.tfp_data_formats.widthTFPcot;
constant widthTFPz0   : natural := work.tfp_data_formats.widthTFPz0;

type t_stubDTC is
record
    reset   : std_logic;
    valid   : std_logic;
    phis    : std_logic_vector( widthDTCphis  - 1 downto 0 );
    etaMin  : std_logic_vector( widthDTCeta   - 1 downto 0 );
    etaMax  : std_logic_vector( widthDTCeta   - 1 downto 0 );
    layer   : std_logic_vector( widthDTClayer - 1 downto 0 );
    r       : std_logic_vector( widthDTCr     - 1 downto 0 );
    phi     : std_logic_vector( widthDTCphi   - 1 downto 0 );
    z       : std_logic_vector( widthDTCz     - 1 downto 0 );
    inv2RMin: std_logic_vector( widthDTCinv2R - 1 downto 0 );
    inv2RMax: std_logic_vector( widthDTCinv2R - 1 downto 0 );
end record;
type t_stubsDTC is array ( natural range <> ) of t_stubDTC;
function nulll return t_stubDTC;

type t_stubGP is
record
    reset   : std_logic;
    valid   : std_logic;
    layer   : std_logic_vector( widthGPlayer - 1 downto 0 );
    r       : std_logic_vector( widthGPr     - 1 downto 0 );
    phi     : std_logic_vector( widthGPphi   - 1 downto 0 );
    z       : std_logic_vector( widthGPz     - 1 downto 0 );
    inv2RMin: std_logic_vector( widthGPinv2R - 1 downto 0 );
    inv2RMax: std_logic_vector( widthGPinv2R - 1 downto 0 );
end record;
type t_stubsGP is array ( natural range <> ) of t_stubGP;
function nulll return t_stubGP;

type t_stubHT is
record
    reset : std_logic;
    valid : std_logic;
    sector: std_logic_vector( widthHTsector - 1 downto 0 );
    phiT  : std_logic_vector( widthHTphiT   - 1 downto 0 );
    layer : std_logic_vector( widthHTlayer  - 1 downto 0 );
    r     : std_logic_vector( widthHTr      - 1 downto 0 );
    phi   : std_logic_vector( widthHTphi    - 1 downto 0 );
    z     : std_logic_vector( widthHTz      - 1 downto 0 );
end record;
type t_stubsHT is array ( natural range <> ) of t_stubHT;
function nulll return t_stubHT;

type t_stubMHT is
record
    reset : std_logic;
    valid : std_logic;
    newTrk: std_logic;
    sector: std_logic_vector( widthMHTsector - 1 downto 0 );
    phiT  : std_logic_vector( widthMHTphiT   - 1 downto 0 );
    inv2R : std_logic_vector( widthMHTinv2R  - 1 downto 0 );
    layer : std_logic_vector( widthMHTlayer  - 1 downto 0 );
    r     : std_logic_vector( widthMHTr      - 1 downto 0 );
    phi   : std_logic_vector( widthMHTphi    - 1 downto 0 );
    z     : std_logic_vector( widthMHTz      - 1 downto 0 );
end record;
type t_stubsMHT is array ( natural range <> ) of t_stubMHT;
function nulll return t_stubMHT;

type t_stubSF is
record
    reset : std_logic;
    valid : std_logic;
    r     : std_logic_vector( widthSFr    - 1 downto 0 );
    phi   : std_logic_vector( widthSFphi  - 1 downto 0 );
    z     : std_logic_vector( widthSFz    - 1 downto 0 );
    dPhi  : std_logic_vector( widthSFdPhi - 1 downto 0 );
    dZ    : std_logic_vector( widthSFdZ   - 1 downto 0 );
end record;
type t_stubsSF is array ( natural range <> ) of t_stubSF;
function nulll return t_stubSF;

type t_trackSF is
record
    reset : std_logic;
    valid : std_logic;
    maybe : std_logic_vector( widthSFhits   - 1 downto 0 );
    sector: std_logic_vector( widthSFsector - 1 downto 0 );
    phiT  : std_logic_vector( widthSFphiT   - 1 downto 0 );
    inv2R : std_logic_vector( widthSFinv2R  - 1 downto 0 );
    zT    : std_logic_vector( widthSFzT     - 1 downto 0 );
    cot   : std_logic_vector( widthSFcot    - 1 downto 0 );
end record;
type t_tracksSF is array ( natural range <> ) of t_trackSF;
function nulll return t_trackSF;

type t_channelSF is
record
    track: t_trackSF;
    stubs: t_stubsSF(numLayers - 1 downto 0);
end record;
type t_channelsSF is array ( natural range <> ) of t_channelSF;
function nulll return t_channelSF;

type t_stubKF is
record
    reset : std_logic;
    valid : std_logic;
    r     : std_logic_vector( widthKFr    - 1 downto 0 );
    phi   : std_logic_vector( widthKFphi  - 1 downto 0 );
    z     : std_logic_vector( widthKFz    - 1 downto 0 );
    dPhi  : std_logic_vector( widthKFdPhi - 1 downto 0 );
    dZ    : std_logic_vector( widthKFdZ   - 1 downto 0 );
end record;
type t_stubsKF is array ( natural range <> ) of t_stubKF;
function nulll return t_stubKF;

type t_trackKF is
record
    reset : std_logic;
    valid : std_logic;
    match : std_logic;
    sector: std_logic_vector( widthKFsector - 1 downto 0 );
    phiT  : std_logic_vector( widthKFphiT   - 1 downto 0 );
    inv2R : std_logic_vector( widthKFinv2R  - 1 downto 0 );
    cot   : std_logic_vector( widthKFcot    - 1 downto 0 );
    zT    : std_logic_vector( widthKFzT     - 1 downto 0 );
end record;
type t_tracksKF is array ( natural range <> ) of t_trackKF;
function nulll return t_trackKF;

type t_channelKF is
record
    track: t_trackKF;
    stubs: t_stubsKF(numLayers - 1 downto 0);
end record;
type t_channelsKF is array ( natural range <> ) of t_channelKF;
function nulll return t_channelKF;

type t_trackDR is
record
    reset: std_logic;
    valid: std_logic;
    phi0 : std_logic_vector( widthTFPphi0  - 1 downto 0 );
    inv2R: std_logic_vector( widthTFPinv2R - 1 downto 0 );
    cot  : std_logic_vector( widthTFPcot   - 1 downto 0 );
    z0   : std_logic_vector( widthTFPz0    - 1 downto 0 );
end record;
type t_tracksDR is array ( natural range <> ) of t_trackDR;
function nulll return t_trackDR;

type t_channelTQ is
record
    TQscore: INTEGER;
    valid: boolean;
end record;
type t_channelsTQ is array ( natural range <> ) of t_channelTQ;
function nulll return t_channelTQ;

subtype t_frame is std_logic_vector( LWORD_WIDTH - 1 downto 0 );
type t_frames is array ( natural range <> ) of t_frame;

end;


package body tfp_data_types is

function nulll return t_stubDTC is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_stubGP  is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_stubHT  is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_stubMHT is begin return ( '0', '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_stubSF  is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_trackSF is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_stubKF  is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_trackKF is begin return ( '0', '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_trackDR is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_channelSF is begin return ( nulll, ( others => nulll ) ); end function;
function nulll return t_channelKF is begin return ( nulll, ( others => nulll ) ); end function;
function nulll return t_channelTQ is begin return ( 0, FALSE ); end function;


end;
