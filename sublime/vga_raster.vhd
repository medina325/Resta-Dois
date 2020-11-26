library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity vga_raster is
  port (
    --reset : in std_logic;
    --clk   : in bit; --25Mhz
    reset : in bit;
    clk: in bit;
    SW_I, SW_F: in bit; -- resetar após jogada executada
    x,y: in bit_vector(2 downto 0); -- sw7 to sw4 controls yi/yf, sw3 to sw0 controls xi/xf
    d0, d1, d2, d3: out bit_vector(0 to 6);
    VGA_HS: OUT STD_LOGIC;     -- Active-Low Horizontal Sync
    VGA_VS: OUT STD_LOGIC;     -- Active-Low Vertical Sync
    VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0)
  );
end vga_raster;

architecture rtl of vga_raster is
  -- Video parameters
  constant HTOTAL       : integer :=  800;
  constant HSYNC        : integer :=  96;
  constant HBACK_PORCH  : integer :=  48;
  constant HACTIVE      : integer :=  640;
  constant HFRONT_PORCH : integer :=  16;
  constant VTOTAL       : integer :=  525;
  constant VSYNC        : integer :=  2;
  constant VBACK_PORCH  : integer :=  33;
  constant VACTIVE      : integer :=  480;
  constant VFRONT_PORCH : integer :=  10; 

  ------------------------------PARTE DOS QUADRADOS INICIO---------------------------------

  constant RECTANGLE_A_hi   : integer  := 273;
  constant RECTANGLE_A_hf   : integer  := 367;
  constant RECTANGLE_A_vi   : integer  := 0;
  constant RECTANGLE_A_vf   : integer  := 96;  

  constant RECTANGLE_B_hi   : integer  := 273;
  constant RECTANGLE_B_hf   : integer  := 367;
  constant RECTANGLE_B_vi   : integer  := 97;
  constant RECTANGLE_B_vf   : integer  := 192; 

  constant RECTANGLE_C_hi   : integer  := 80;
  constant RECTANGLE_C_hf   : integer  := 176;
  constant RECTANGLE_C_vi   : integer  := 193;
  constant RECTANGLE_C_vf   : integer  := 287; 

  constant RECTANGLE_D_hi   : integer  := 177;
  constant RECTANGLE_D_hf   : integer  := 272;
  constant RECTANGLE_D_vi   : integer  := 193;
  constant RECTANGLE_D_vf   : integer  := 287;

  constant RECTANGLE_E_hi   : integer  := 273;
  constant RECTANGLE_E_hf   : integer  := 367;
  constant RECTANGLE_E_vi   : integer  := 193;
  constant RECTANGLE_E_vf   : integer  := 287; 

  constant RECTANGLE_F_hi   : integer  := 368;
  constant RECTANGLE_F_hf   : integer  := 464;
  constant RECTANGLE_F_vi   : integer  := 193;
  constant RECTANGLE_F_vf   : integer  := 287; 

  constant RECTANGLE_G_hi   : integer  := 465;
  constant RECTANGLE_G_hf   : integer  := 560;
  constant RECTANGLE_G_vi   : integer  := 193;
  constant RECTANGLE_G_vf   : integer  := 287; 

  constant RECTANGLE_H_hi   : integer  := 273;
  constant RECTANGLE_H_hf   : integer  := 367;
  constant RECTANGLE_H_vi   : integer  := 289;
  constant RECTANGLE_H_vf   : integer  := 384; 

  constant RECTANGLE_I_hi   : integer  := 273;
  constant RECTANGLE_I_hf   : integer  := 367;
  constant RECTANGLE_I_vi   : integer  := 385;
  constant RECTANGLE_I_vf   : integer  := 480;  

  ------------------------------PARTE DOS QUADRADOS FIM------------------------------------ 
  -- Horizontal position (0-800)
  signal Hcount : std_logic_vector(9 downto 0);
   -- Vertical position (0-524)
  signal Vcount : std_logic_vector(9 downto 0);
  signal EndOfLine, EndOfField : std_logic;
  signal vga_hblank, vga_hsync,
           vga_vblank, vga_vsync : std_logic;  -- Sync. signals
  
  ------------------------------PARTE DOS QUADRADOS INICIO---------------------------------
  signal rectangle_A_h, rectangle_A_v, rectangle_A : std_logic;
  signal rectangle_B_h, rectangle_B_v, rectangle_B : std_logic;
  signal rectangle_C_h, rectangle_C_v, rectangle_C : std_logic;
  signal rectangle_D_h, rectangle_D_v, rectangle_D : std_logic;
  signal rectangle_E_h, rectangle_E_v, rectangle_E : std_logic;
  signal rectangle_F_h, rectangle_F_v, rectangle_F : std_logic;
  signal rectangle_G_h, rectangle_G_v, rectangle_G : std_logic;
  signal rectangle_H_h, rectangle_H_v, rectangle_H : std_logic;
  signal rectangle_I_h, rectangle_I_v, rectangle_I : std_logic;

  ------------------------------PARTE DOS QUADRADOS FIM------------------------------------ 
  type Elemento is range -1 to 1;

  type Matrix is ARRAY (0 to 4,0 to 4) of Elemento;

  type States is (I,N1A,N1B,N1C,N1D,
            N2A,N2B,N2C,N2D,
            N3A,N3B,N3C,N3D,N3E,N3F,N3G,N3H,
            N4A,N4B,N4C,N4D,N4E,N4F,N4G,N4H,
            N5A,N5B,N5C,N5D,
            N6A,N6B,N6C,N6D);
              
  signal est_atual, prox_est: States ;           --http://quitoart.blogspot.com/2017/07/vhdl-ps2-keyboard-hyperterminal.html  (teclado ps2d)

  signal xi, yi, xf, yf : natural := 2;
    
begin


-- Circuito Sequencial
p0:process(clk,reset) is 
  begin
    if (reset = '0') then
          est_atual <= I;
      elsif (clk = '1' and clk'event) then
          est_atual <= prox_est;   
      end if;

end process;

--------------------------------------------CONTROLA xi xf yi yf------------------------------------

p2: process(x, y, est_atual) is  
  procedure display_xi_yi is
  begin
    if xi = 0 then
      d3 <= "0000001";
    elsif xi = 1 then
      d3 <= "1001111";
    elsif xi = 2 then
      d3 <= "0010010";
    elsif xi = 3 then
      d3 <= "0000110";
    elsif xi = 4 then
      d3 <= "1001100";        
    end if; 
    
    if yi = 0 then
      d2 <= "0000001";
    elsif yi = 1 then
      d2 <= "1001111";
    elsif yi = 2 then
      d2 <= "0010010";
    elsif yi = 3 then
      d2 <= "0000110";
    elsif yi = 4 then
      d2 <= "1001100";        
    end if; 
  end procedure display_xi_yi;

  procedure display_xf_yf is
  begin
    if xf = 0 then
      d1 <= "0000001";
    elsif xf = 1 then
      d1 <= "1001111";
    elsif xf = 2 then
      d1 <= "0010010";
    elsif xf = 3 then
      d1 <= "0000110";
    elsif xf = 4 then
      d1 <= "1001100";        
    end if; 
  
    if yf = 0 then
      d0 <= "0000001";
    elsif yf = 1 then
      d0 <= "1001111";
    elsif yf = 2 then
      d0 <= "0010010";
    elsif yf = 3 then
      d0 <= "0000110";
    elsif yf = 4 then
      d0 <= "1001100";        
    end if; 
  end procedure display_xf_yf;

  procedure displayDefeat is
  begin
    d3 <= "1110001";
    d2 <= "0000001";
    d1 <= "0100100";
    d0 <= "0110000";
  end procedure displayDefeat;
  
  procedure displayVictory is
  begin
    d3 <= "1100001";
    d2 <= "1000011";
    d1 <= "1111001";
    d0 <= "0001001";
  end procedure displayVictory;
    begin
      if (SW_I = '0') then
        if (x = "000") then
          xi <= 0;
        elsif (x = "001") then
          xi <= 1;
        elsif (x = "010") then
          xi <= 2;
        elsif (x = "011") then
          xi <= 3;
        elsif (x = "100") then
          xi <= 4;
        else
          xi <= 0;
        end if;

        if (y = "000") then
          yi <= 0;
        elsif (y = "001") then
          yi <= 1;
        elsif (y = "010") then
          yi <= 2;
        elsif (y = "011") then
          yi <= 3;
        elsif (y = "100") then
          yi <= 4;
        else
          yi <= 0;
        end if;
      

      elsif (SW_I = '1') then
        if (x = "000") then
          xf <= 0;
        elsif (x = "001") then
          xf <= 1;
        elsif (x = "010") then
          xf <= 2;
        elsif (x = "011") then
          xf <= 3;
        elsif (x = "100") then
          xf <= 4;
        else
          xf <= 0;
        end if;

        if (y = "000") then
          yf <= 0;
        elsif (y = "001") then
          yf <= 1;
        elsif (y = "010") then
          yf <= 2;
        elsif (y = "011") then
          yf <= 3;
        elsif (y = "100") then
          yf <= 4;
        else
          yf <= 0;
        end if;
      end if;

      if(est_atual = N4A) then
        displayDefeat;
      elsif(est_atual = N4C) then
        displayDefeat;
      elsif(est_atual = N4E) then
        displayDefeat;
      elsif(est_atual = N4G) then
        displayDefeat;
      elsif(est_atual = N6A) then
        displayVictory;
      elsif(est_atual = N6B) then
        displayVictory;
      elsif(est_atual = N6C) then
        displayVictory;
      elsif(est_atual = N6D) then
        displayVictory;
      else
        display_xi_yi;
        display_xf_yf;
      end if;
    
    end process;

-- Circuito Combinacional
    p1:process(est_atual, SW_I, SW_F, xi, yi, xf, yf) is      -- 0  1 2  3  4      ------------------------------------N1---------------------------------------
    --variable tabuleiro: Matrix := ((-1,-1,1,-1,-1),--0
    --                               (-1,-1,1,-1,-1),--1
    --                               ( 1, 1,0, 1, 1),--2
    --                               (-1,-1,1,-1,-1),--3
    --                               (-1,-1,1,-1,-1));--4

    begin
        case est_atual is 
            when I =>
                                  
                        -- 0  1 2  3  4       ------------------------------------N1---------------------------------------               
                --tabuleiro :=    ((-1,-1,1,-1,-1),--0
                --                 (-1,-1,1,-1,-1),--1
                --                 ( 1, 1,0, 1, 1),--2
                --                 (-1,-1,1,-1,-1),--3
                --                 (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 0 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N1A;
                    elsif xi = 4 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N1B;
                    elsif xi = 2 and yi= 0 and xf =2 and yf = 2 then
                        prox_est <= N1C;
                    elsif xi = 2 and yi = 4 and xf = 2 and yf = 2 then
                        prox_est <= N1D;
                    else
                        prox_est <= I; 
                    end if;
                else
                    prox_est <= I;
                end if;
                    
            when N1A =>
                                      -- 0  1 2  3  4       ------------------------------------N1---------------------------------------         
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 1,1, 1, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 3 and yi = 2 and xf = 1 and yf=2 then
                        prox_est <= N2A;
                    else
                        prox_est <= N1A;    
                    end if;
                else
                    prox_est <= N1A;
                end if;               
            
            when N1B =>
                                      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 1,1, 1, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 1 and yi= 2 and xf =3 and yf=2 then
                        prox_est <= N2B;
                    else
                        prox_est <= N1B;    
                    end if;
                else 
                    prox_est <= N1B;
                end if;               
            
            when N1C =>
                                      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 0,1, 1, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N2C;
                    else
                        prox_est <= N1C;
                    end if;               
                else
                    prox_est <= N1C;
                end if;

            when N1D =>
                                      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 1,1, 0, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 1 and xf = 2 and yf = 3 then
                        prox_est <= N2D;
                    else
                        prox_est <= N1D;    
                    end if;               
                else
                    prox_est <= N1D;
                end if;

            when N2A =>
                                      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------   
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 1,0, 1, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 0 and xf = 2 and yf = 2 then
                        prox_est <= N3A;
                    elsif xi = 2 and yi = 4 and xf = 2 and yf = 2 then
                        prox_est <= N3B;
                    else
                        prox_est <= N2A;            
                    end if; 
                else
                    prox_est <= N2A;
                end if;

            when N2B =>
                                      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 1,0, 1, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 0 and xf = 2 and yf = 2 then
                        prox_est <= N3C;
                    elsif xi = 2 and yi = 4 and xf = 2 and yf = 2 then
                        prox_est <= N3D;
                    else
                        prox_est <= N2B;            
                    end if;
                else
                    prox_est <= N2B;
                end if;

            when N2C =>
                                      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------   
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 1,0, 0, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then 
                    if xi = 0 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N3E;
                    elsif xi= 4 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N3F;
                    else
                        prox_est <= N2C;            
                    end if;
                else
                    prox_est <= N2C;
                end if;

            when N2D =>
                                      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 0,0, 1, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then 
                    if xi = 0 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N3G;
                    elsif xi= 4 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N3H;
                    else
                        prox_est <= N2D;            
                    end if;
                else
                    prox_est <= N2D;
                end if;

           when N3A =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------  
                --tabuleiro := ((-1,-1,0,-1,-1), --0
                --              (-1,-1,1,-1,-1), --1
                --              ( 0, 0,1, 1, 1), --2
                --              (-1,-1,0,-1,-1), --3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then 
                    if xi = 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N4A; -- GAME OVER1
                    elsif xi= 1 and yi = 2 and xf = 3 and yf = 2 then
                        prox_est <= N4B;
                    else
                        prox_est <= N3A;            
                    end if;
                else
                    prox_est <= N3A;
                end if;

            when N3B =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 1,1, 0, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 1 and xf = 2 and yf = 3 then
                        prox_est <= N4C;--GAME OVER2
                    elsif xi= 1 and yi = 2 and xf = 3 and yf = 2 then
                        prox_est <= N4D;
                    else
                        prox_est <= N3B;            
                    end if;
                else
                    prox_est <= N3B;
                end if;

            when N3C =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 0,1, 1, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N4E; -- GAME OVER3
                    elsif xi= 3 and yi = 2 and xf = 1 and yf = 2 then
                        prox_est <= N4F;
                    else
                        prox_est <= N3C;            
                    end if;
                else
                    prox_est <= N3C;
                end if;

            when N3D =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 1,1, 0, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then 
                    if xi = 2 and yi = 1 and xf = 2 and yf = 3 then
                        prox_est <= N4G; -- GAME OVER4
                    elsif xi= 3 and yi = 2 and xf = 1 and yf = 2 then
                        prox_est <= N4H;
                    else
                        prox_est <= N3D;            
                    end if;
                else
                    prox_est <= N3D;
                end if;

            when N3E =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 1,1, 0, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi =3 and yi=2 and xf =1 and yf=2 then
                        prox_est <= N4A;--GAME OVER5
                    elsif xi=2 and yi=1 and xf =2 and yf=3 then
                        prox_est <= N4B;
                    else
                        prox_est <= N3E;            
                    end if;
                else
                    prox_est <= N3E;
                end if;

            when N3F =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 1,1, 0, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 1 and yi = 2 and xf = 3 and yf = 2 then
                        prox_est <= N4E; --GAME OVER6
                    elsif xi= 2 and yi = 1 and xf = 2 and yf = 3 then
                        prox_est <= N4F;        
                    else
                        prox_est <= N3F;
                    end if;
                else
                    prox_est <= N3F;
                end if;

            when N3G =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 0,1, 1, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 3 and yi = 2 and xf = 1 and yf = 2 then
                        prox_est <= N4C;--GAME OVER7
                    elsif xi= 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N4D;        
                    else
                        prox_est <= N3G;
                    end if;
                else
                    prox_est <= N3G;
                end if;

            when N3H =>
                                      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 0,1, 1, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 1 and yi = 2 and xf = 3 and yf = 2 then
                        prox_est <= N4G; --GAME OVER8
                    elsif xi= 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N4H;        
                    else
                        prox_est <= N3H;
                    end if;
                else
                    prox_est <= N3H;
                end if;

           when N4A =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 1,0, 0, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                prox_est <= N4A;
            when N4B =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 0,0, 1, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 4 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N5A;
                    elsif xi= 2 and yi = 4 and xf = 2 and yf = 2 then
                        prox_est <= N5B;        
                    else
                        prox_est <= N4B;
                    end if;
                else
                    prox_est <= N4B;
                end if;

            when N4C =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 0,0, 1, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                prox_est <= N4C;
            when N4D =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 1,0, 0, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 0 and xf = 2 and yf = 2 then
                        prox_est <= N5B;
                    elsif xi= 4 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N5C;        
                    else
                        prox_est <= N4D;
                    end if;
                else
                    prox_est <= N4D;
                end if;

            when N4E =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 1,0, 0, 1),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                prox_est <= N4E;
            when N4F =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 0,0, 1, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 0 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N5A;
                    elsif xi= 2 and yi = 4 and xf = 2 and yf = 2 then
                        prox_est <= N5D;        
                    else
                        prox_est <= N4F;
                    end if;
                else
                    prox_est <= N4F;
                end if;

            when N4G =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 0,0, 1, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                prox_est <= N4G;
            when N4H =>
                                      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 1, 1,0, 0, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 0 and yi = 2 and xf = 2 and yf = 2 then
                        prox_est <= N5C;
                    elsif xi= 2 and yi = 0 and xf = 2 and yf = 2 then
                        prox_est <= N5D;
                    else
                        prox_est <= N4H;
                    end if; 
                else
                    prox_est <= N4H;
                end if;

            when N5A =>
                                      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 0,1, 1, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 3 and xf = 2 and yf = 1 then
                        prox_est <= N6A; --GANHOU
                    else
                        prox_est <= N5A;
                    end if;
                else
                    prox_est <= N5A;
                end if;

            when N5B =>
                                      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 0,1, 0, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 3 and yi = 2 and xf = 1 and yf = 2 then
                        prox_est <= N6B; --GANHOU
                    else
                        prox_est <= N5B;
                    end if;
                else
                    prox_est <= N5B;
                end if;

            when N5C =>
                                      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 1,1, 0, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 2 and yi = 1 and xf = 2 and yf = 3 then
                        prox_est <= N6C; --GANHOU
                    else
                        prox_est <= N5C;
                    end if;
                else
                    prox_est <= N5C;
                end if;

            when N5D =>
                                      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 0,1, 0, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                if (SW_I = '1' and SW_F = '1') then
                    if xi = 1 and yi = 3 and xf = 3 and yf = 2 then
                        prox_est <= N6D; --GANHOU
                    else
                        prox_est <= N5D;
                    end if;
                else
                    prox_est <= N5D;
                end if;

            when N6A =>
                                      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 1,0, 0, 1),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                prox_est <= N6A;
            when N6B =>
                                      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,1,-1,-1),--1
                --              ( 0, 0,0, 0, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,1,-1,-1));--4
                prox_est <= N6B;
            when N6C =>
                                      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
                --tabuleiro := ((-1,-1,0,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 1, 0,0, 1, 0),--2
                --              (-1,-1,0,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                prox_est <= N6C;
            when N6D =>
                                      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------    
                --tabuleiro := ((-1,-1,1,-1,-1),--0
                --              (-1,-1,0,-1,-1),--1
                --              ( 0, 0,0, 0, 0),--2
                --              (-1,-1,1,-1,-1),--3
                --              (-1,-1,0,-1,-1));--4
                prox_est <= N6D;
                
        end case;
    
    end process;

HCounter : process (clk, reset)
begin
  if reset = '0' then
    Hcount <= (others => '0');
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      Hcount <= (others => '0');
    else
      Hcount <= Hcount + 1;
    end if;
  end if;
end process HCounter;

EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';

VCounter: process (clk, reset)
begin
  if reset = '0' then
    Vcount <= (others => '0');
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if EndOfField = '1' then
         Vcount <= (others => '0');
      else
         Vcount <= Vcount + 1;
      end if;
    end if;
  end if;
end process VCounter;

EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';
 
HSyncGen : process (clk, reset)
begin
  if reset = '0' then
    vga_hsync <= '1';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      vga_hsync <= '1';
    elsif Hcount = HSYNC - 1 then
      vga_hsync <= '0';
    end if;
  end if;
end process HSyncGen;

HBlankGen : process (clk, reset)
begin
  if reset = '0' then
    vga_hblank <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH then
      vga_hblank <= '0';
    elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
      vga_hblank <= '1';
    end if;
  end if;
end process HBlankGen;

VSyncGen : process (clk, reset)
begin
  if reset = '0' then
    vga_vsync <= '1';
  elsif clk'event and clk = '1' then
    if EndOfLine ='1' then
      if EndOfField = '1' then
        vga_vsync <= '1';
      elsif Vcount = VSYNC - 1 then
        vga_vsync <= '0';
      end if;
    end if;
  end if;
end process VSyncGen;

VBlankGen : process (clk, reset)
begin
  if reset = '0' then
    vga_vblank <= '1';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 then
        vga_vblank <= '0';
      elsif Vcount = VSYNC + VBACK_PORCH + VACTIVE - 1 then
        vga_vblank <= '1';
      end if;
    end if;
  end if;
end process VBlankGen;



------------------------------PARTE DOS QUADRADOS INICIO---------------------------------
             --------------------------PARTE HORIZONTAL------------------------------------

Rectangle_A_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_A_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_A_hi then
      rectangle_A_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_A_hf then
      rectangle_A_h <= '0';
    end if;
  end if;
end process Rectangle_A_HGen;

Rectangle_B_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_B_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_B_hi then
      rectangle_B_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_B_hf then
      rectangle_B_h <= '0';
    end if;
  end if;
end process Rectangle_B_HGen;

Rectangle_C_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_C_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_C_hi then
      rectangle_C_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_C_hf then
      rectangle_C_h <= '0';
    end if;
  end if;
end process Rectangle_C_HGen;

Rectangle_D_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_D_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_D_hi then
      rectangle_D_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_D_hf then
      rectangle_D_h <= '0';
    end if;
  end if;
end process Rectangle_D_HGen;

Rectangle_E_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_E_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_E_hi then
      rectangle_E_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_E_hf then
      rectangle_E_h <= '0';
    end if;
  end if;
end process Rectangle_E_HGen;

Rectangle_F_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_F_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_F_hi then
      rectangle_F_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_F_hf then
      rectangle_F_h <= '0';
    end if;
  end if;
end process Rectangle_F_HGen;

Rectangle_G_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_G_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_G_hi then
      rectangle_G_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_G_hf then
      rectangle_G_h <= '0';
    end if;
  end if;
end process Rectangle_G_HGen;

Rectangle_H_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_H_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_H_hi then
      rectangle_H_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_H_hf then
      rectangle_H_h <= '0';
    end if;
  end if;
end process Rectangle_H_HGen;

Rectangle_I_HGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_I_h <= '1';
  elsif clk'event and clk = '1' then
    if Hcount = HSYNC + HBACK_PORCH + RECTANGLE_I_hi then
      rectangle_I_h <= '1';
    elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_I_hf then
      rectangle_I_h <= '0';
    end if;
  end if;
end process Rectangle_I_HGen;

             --------------------------PARTE VERTICAL-------------------------------------
Rectangle_A_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_A_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_A_vi then
        rectangle_A_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_A_vf then
        rectangle_A_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_A_VGen; 

Rectangle_B_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_B_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_B_vi then
        rectangle_B_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_B_vf then
        rectangle_B_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_B_VGen; 

Rectangle_C_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_C_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_C_vi then
        rectangle_C_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_C_vf then
        rectangle_C_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_C_VGen; 

Rectangle_D_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_D_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_D_vi then
        rectangle_D_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_D_vf then
        rectangle_D_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_D_VGen; 

Rectangle_E_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_E_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_E_vi then
        rectangle_E_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_E_vf then
        rectangle_E_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_E_VGen; 

Rectangle_F_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_F_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_F_vi then
        rectangle_F_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_F_vf then
        rectangle_F_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_F_VGen; 

Rectangle_G_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_G_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_G_vi then
        rectangle_G_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_G_vf then
        rectangle_G_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_G_VGen; 

Rectangle_H_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_H_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_H_vi then
        rectangle_H_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_H_vf then
        rectangle_H_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_H_VGen; 

Rectangle_I_VGen : process (clk, reset)
begin
  if reset = '0' then
    rectangle_I_v <= '0';
  elsif clk'event and clk = '1' then
    if EndOfLine = '1' then
      if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_I_vi then
        rectangle_I_v <= '1';
      elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_I_vf then
        rectangle_I_v <= '0';
      end if;
    end if;
  end if;
end process Rectangle_I_VGen; 


------------------------------PARTE DOS QUADRADOS FIM------------------------------------
rectangle_A <= rectangle_A_h and rectangle_A_v;
rectangle_B <= rectangle_B_h and rectangle_B_v;
rectangle_C <= rectangle_C_h and rectangle_C_v;
rectangle_D <= rectangle_D_h and rectangle_D_v;
rectangle_E <= rectangle_E_h and rectangle_E_v;
rectangle_F <= rectangle_F_h and rectangle_F_v;
rectangle_G <= rectangle_G_h and rectangle_G_v;
rectangle_H <= rectangle_H_h and rectangle_H_v;
rectangle_I <= rectangle_I_h and rectangle_I_v;



VideoOut: process (clk, est_atual, reset)
begin
  if reset = '0' then
    VGA_R <= "0000";
    VGA_G <= "0000";
    VGA_B <= "0000";
  elsif clk'event and clk = '1' then
   
    -----------------------------------------------INICIO PARTE DOS QUADRADOS----------------------------
    if rectangle_A = '1' then
      if (est_atual = I or est_atual = N1B or est_atual = N1C or est_atual = N1D or est_atual = N2C or 
         est_atual = N2D or est_atual = N3C or est_atual = N3D or est_atual = N3F or 
         est_atual = N3H or est_atual = N4E or est_atual = N4F or est_atual = N4G or est_atual = N4H or 
         est_atual = N5D or est_atual = N6D) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
     else
       VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
     end if;  
    elsif rectangle_B = '1' then
      if (est_atual = I or est_atual = N1B or est_atual = N1C or est_atual = N1D or est_atual = N2A or 
          est_atual = N2C or est_atual = N2D or est_atual = N3A or est_atual = N3B or est_atual = N3F or 
          est_atual = N3H or est_atual = N4A or est_atual = N4C or est_atual = N4F or est_atual = N4H or 
          est_atual = N5D or est_atual = N6B) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
       else
         VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;
    elsif rectangle_C = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1B or est_atual = N1D or est_atual = N2A or 
          est_atual = N2B or est_atual = N2D or est_atual = N3B or est_atual = N3D or est_atual = N3G or 
          est_atual = N3H or est_atual = N4C or est_atual = N4D or est_atual = N4G or est_atual = N4H or 
          est_atual = N5C or est_atual = N6C) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
     else
       VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;  
    elsif rectangle_D = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1B or est_atual = N1D or est_atual = N2A or 
          est_atual = N2B or est_atual = N2C or est_atual = N3B or est_atual = N3D or est_atual = N3E or 
          est_atual = N3F or est_atual = N4A or est_atual = N4D or est_atual = N4E or est_atual = N4H or 
          est_atual = N5C or est_atual = N6A) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
       else
         VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;
    elsif rectangle_E = '1' then
      if (est_atual = N1A or est_atual = N1B or est_atual = N1C or est_atual = N1D or est_atual = N3A or 
          est_atual = N3B or est_atual = N3C or est_atual = N3D or est_atual = N3E or est_atual = N3F or 
          est_atual = N3G or est_atual = N3H or est_atual = N5A or est_atual = N5B or est_atual = N5C or 
          est_atual = N5D) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
     else
       VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;  
    elsif rectangle_F = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1B or est_atual = N1C or est_atual = N2A or 
          est_atual = N2B or est_atual = N2D or est_atual = N3A or est_atual = N3C or est_atual = N3G or 
          est_atual = N3H or est_atual = N4B or est_atual = N4C or est_atual = N4F or est_atual = N4G or 
          est_atual = N5A or est_atual = N6C) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
       else
         VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;
    elsif rectangle_G = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1B or est_atual = N1C or est_atual = N2A or 
          est_atual = N2B or est_atual = N2C or est_atual = N3A or est_atual = N3C or est_atual = N3E or 
          est_atual = N3F or est_atual = N4A or est_atual = N4B or est_atual = N4E or est_atual = N4F or 
          est_atual = N5A or est_atual = N6A) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
     else
       VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;  
    elsif rectangle_H = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1C or est_atual = N1D or est_atual = N2B or 
          est_atual = N2C or est_atual = N2D or est_atual = N3C or est_atual = N3D or est_atual = N3E or 
          est_atual = N3G or est_atual = N4B or est_atual = N4D or est_atual = N4E or est_atual = N4G or 
          est_atual = N5B or est_atual = N6D) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
       else
         VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;
    elsif rectangle_I = '1' then
      if (est_atual = I or est_atual = N1A or est_atual = N1C or est_atual = N1D or est_atual = N2A or 
          est_atual = N2C or est_atual = N2D or est_atual = N3A or est_atual = N3B or est_atual = N3E or 
          est_atual = N3G or est_atual = N4A or est_atual = N4B or est_atual = N4C or est_atual = N4D or 
          est_atual = N5B or est_atual = N6B) then
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "1111";
     else
       VGA_R <= "0000";
         VGA_G <= "0000";
         VGA_B <= "0000";
      end if;  
    
     
     -----------------------------------------------FIM PARTE DOS QUADRADOS-------------------------------------
    elsif vga_hblank = '0' and vga_vblank ='0' then
      VGA_R <= "1111";
      VGA_G <= "1111";
      VGA_B <= "1111";
    else
      VGA_R <= "0000";
      VGA_G <= "0000";
      VGA_B <= "0000";
    end if;
  end if;
end process VideoOut;

VGA_HS <= not vga_hsync;
VGA_VS <= not vga_vsync;

end rtl;