library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga_raster_resta_dois is
port (clk: in bit;
    reset : in bit;
    SW_I_S, SW_F_S: in bit; -- resetar após jogada executada
    X_S, Y_S: in bit_vector(2 downto 0); -- sw7 to sw4 controls yi/yf, sw3 to sw0 controls xi/xf
    --VGA_CLK: out bit; --,    -- Dot clock to DAC

   D0_S, D1_S, D2_S, D3_S: out bit_vector(0 to 6);
    VGA_HS: OUT STD_LOGIC;    -- Active-Low Horizontal Sync
    VGA_VS: OUT STD_LOGIC; --,     -- Active-Low Vertical Sync
    --VGA_BLANK, -- Active-Low DAC blanking control
    --VGA_SYNC : out std_logic; -- Active-Low DAC Sync on Green
    VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0)

);
      


end entity;

architecture algorithmic of vga_raster_resta_dois is
signal vga_h, vga_v: STD_LOGIC; --, vga_bl, vga_sy: std_logic;
signal vga_red, vga_green, vga_blue: std_logic_vector(3 downto 0);
signal vga_clock, clk25: bit;
signal d0, d1, d2, d3: bit_vector(0 to 6);

begin
  p0: process (clk) is
  variable contador: natural range 0 to 2:=0;
  variable clk_aux: bit;
  begin
    if clk='1' then
     contador:=contador+1;
    if (contador=1) then
      contador:=0;
      clk_aux:=not clk_aux;
      clk25<=clk_aux;
     end if; 
   end if;  
    
  end process;
  
     e0: entity work.vga_raster
                 port map(reset, clk25, SW_I_S, SW_F_S, 
                          X_S, Y_S, 
                          d0, d1, d2, d3,
                          vga_h, vga_v, vga_red, vga_green, vga_blue);

D0_S<=d0;
D1_S<=d1;
D2_S<=d2;
D3_S<=d3;                     
VGA_HS<=vga_h;
VGA_VS<=vga_v;
VGA_R<=vga_red;     
VGA_G<=vga_green;
VGA_B<=vga_blue;
end architecture;   