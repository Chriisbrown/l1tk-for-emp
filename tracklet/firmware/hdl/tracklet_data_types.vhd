library ieee;
use ieee.std_logic_1164.all;
use work.tracklet_config.all;
use work.hybrid_data_types.all;
use work.hybrid_data_formats.all;
use work.hybrid_config.all;
use work.hybrid_tools.all;
use work.tf_pkg.all;


package tracklet_data_types is

type t_nents is array ( natural range <> ) of std_logic_vector( widthNent - 1 downto 0 );
function conv( hls: t_arr_7b   ) return t_nents;
function conv( hls: t_arr_8_5b ) return t_nents;

type t_write is
record
  reset: std_logic;
  start: std_logic;
  valid: std_logic;
  addr : std_logic_vector( widthAddr - 1 downto 0 );
  data : std_logic_vector( widthData - 1 downto 0 );
end record;
type t_writes is array ( natural range <> ) of t_write;
function nulll return t_write;

type t_read is
record
  start: std_logic;
  valid: std_logic;
  addr : std_logic_vector( widthAddr - 1 downto 0 );
end record;
type t_reads is array ( natural range <> ) of t_read;
function nulll return t_read;

type t_data is
record
  reset: std_logic;
  start: std_logic;
  valid: std_logic;
  nents: t_nents( 0 to numNent - 1 );
  data : std_logic_vector( widthData - 1 downto 0 );
end record;
type t_datas is array ( natural range <> ) of t_data;
function nulll return t_data;

type t_mem is ( tf_mem, tf_mem_bin );

type t_config_memory is
record
  name     : t_mem;
  widthAddr: natural;
  widthNent: natural;
  RAM_WIDTH: natural;
  NUM_PAGES: natural;
end record;
type t_config_memories is array ( natural range <> ) of t_config_memory;

function conv( datas: t_datas ) return t_candTracklet;

function f_map( reads: t_reads ) return t_reads;
function f_map( datas: t_datas( numMemories - 1 downto 0 ) ) return t_datas;


end;


package body tracklet_data_types is

function nulll return t_write is begin return ( '0', '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_read  is begin return ( '0', '0', others => ( others => '0' ) ); end function;
function nulll return t_data  is begin return ( '0', '0', '0', (others => ( others => '0' ) ), ( others => '0' ) ); end function;

function conv( hls: t_arr_7b ) return t_nents is
  variable nents: t_nents( hls'range );
begin
  for k in hls'range loop
    nents( k )( 7 - 1 downto 0 ) := hls( k );
  end loop;
  return nents;
end function;

function conv( hls: t_arr_8_5b ) return t_nents is
  variable nents: t_nents( 0 to hls'length * t_arr8_5b'length - 1 );
begin
  for k in hls'range loop
    for l in t_arr8_5b'range loop
      nents( k * t_arr8_5b'length + l )( 5 - 1 downto 0 ) := hls( k )( l );
    end loop;
  end loop;
  return nents;
end function;

function conv( datas: t_datas ) return t_candTracklet is
  variable c: t_candTracklet := nulll;
  variable s: t_stubTracklet := nulll;
  variable b: std_logic_vector( 46 - 1 downto 0 );
  variable t: std_logic_vector( 84 - 1 downto 0 );
begin
  t := datas( 0 ).data( t'range );
  c.track.valid    := t( 1 + widthTrackletSeedType + widthTrackletInv2R + widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot - 1 );
  c.track.seedtype := t(     widthTrackletSeedType + widthTrackletInv2R + widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot - 1 downto widthTrackletInv2R + widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot );
  c.track.inv2R    := t(                             widthTrackletInv2R + widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot - 1 downto                      widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot );
  c.track.phi0     := t(                                                  widthTrackletPhi0 + widthTrackletZ0 + widthTrackletCot - 1 downto                                          widthTrackletZ0 + widthTrackletCot );
  c.track.z0       := t(                                                                      widthTrackletZ0 + widthTrackletCot - 1 downto                                                            widthTrackletCot );
  c.track.cot      := t(                                                                                        widthTrackletCot - 1 downto                                                                           0 );
  for k in 0 to numStubsTracklet - 1 loop
    b := datas( 1 + k ).data( b'range );
    s.valid   := b( 1 + widthTrackletTrackId + widthTrackletStubId + widthTrackletR + widthTrackletPhi + widthTrackletZ - 1 );
    s.trackId := b(     widthTrackletTrackId + widthTrackletStubId + widthTrackletR + widthTrackletPhi + widthTrackletZ - 1 downto widthTrackletStubId + widthTrackletR + widthTrackletPhi + widthTrackletZ );
    s.stubId  := b(                            widthTrackletStubId + widthTrackletR + widthTrackletPhi + widthTrackletZ - 1 downto                       widthTrackletR + widthTrackletPhi + widthTrackletZ );
    s.r       := b(                                                  widthTrackletR + widthTrackletPhi + widthTrackletZ - 1 downto                                        widthTrackletPhi + widthTrackletZ );
    s.phi     := b(                                                                   widthTrackletPhi + widthTrackletZ - 1 downto                                                           widthTrackletZ );
    s.z       := b(                                                                                      widthTrackletZ - 1 downto                                                                        0 );
    c.stubs( k ) := s;
  end loop;
  return c;
end function;

function f_map( reads: t_reads ) return t_reads is
  variable rout: t_reads( reads'range ) := ( others => nulll );
begin
  for k in reads'range loop rout( k ) := reads( reverseMapping( k ) ); end loop; return rout;
end function;

function f_map( datas: t_datas( numMemories - 1 downto 0 ) ) return t_datas is
  variable dout: t_datas( datas'range ) := ( others => nulll );
begin
  for k in datas'range loop
    dout( k ) := datas( mapping( k ) );
  end loop;
  return dout;
end function;


end;