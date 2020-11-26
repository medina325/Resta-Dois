library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity testebench is ----------DO MEU PROJETOOO
end;

architecture mixed of testebench is
signal clk, reset, SW_I,SW_F:bit;
signal X_S,Y_S: bit_vector(2 downto 0);
signal D0_S, D1_S, D2_S, D3_S: bit_vector(0 to 6);
signal VGA_HS: STD_LOGIC;
signal VGA_VS:  STD_LOGIC;     
signal VGA_R, VGA_G, VGA_B : std_logic_vector(3 downto 0);
begin

m2:entity work.vga_raster(rtl)
     port map(clk,reset,SW_I,SW_F,X_S,Y_S,D0_S, D1_S, D2_S, D3_S, VGA_HS,VGA_VS, VGA_R, VGA_G, VGA_B);

p1: process is
type linha_tv is record
reset : bit;
    clk: bit;
    SW_I, SW_F: bit; 
    x,y: bit_vector(2 downto 0); 
    d0, d1, d2, d3: bit_vector(0 to 6);
    
end record;

type vet_linha_tv is array(0 to 16) of linha_tv;
                                      --clk  rs sw9 sw8 xi/xf yi/yf    D3         D2        D1       D0
constant tabela_verdade:vet_linha_tv:=(('1','1','0','0',"000","010","0000001","0010010","0000001","0000001"),
                                       ('0','1','0','0',"000","010","0000001","0010010","1101100","0000000"),
                                       ('1','1','1','0',"000","010","0000001","0010010","0000001","0010010"), 
                                       ('0','1','1','0',"010","010","0000001","0010010","0010010","0010010"), 
                                       ('1','1','1','1',"010","010","0000001","0010010","0010010","0010010"), --N1A

                                       ('0','1','0','0',"010","010","0000001","0010010","0010010","0010010"),
                                       ('1','1','1','0',"011","010","0000110","0010010","0000110","0010010"), 
                                       ('0','1','1','0',"001","010","0000001","0010010","1001111","0010010"), 
                                       ('1','1','1','1',"001","010","0000001","0010010","1001111","0010010"),--N2A
                                       
                                       ('0','1','0','0',"010","000","0000001","0010010","0010010","0010010"),
                                       ('1','1','1','0',"010","000","0000001","0010010","0010010","0010010"),
                                       ('0','1','1','0',"010","010","0000001","0010010","0010010","0010010"),
                                       ('1','1','1','1',"010","010","0000001","0010010","1001111","0010010"), --N3A

                                       ('0','1','0','0',"010","011","0000001","0010010","0010010","0010010"),
                                       ('1','1','1','0',"010","011","0000001","0010010","0010010","0010010"),
                                       ('0','1','1','0',"010","001","0000001","0010010","0010010","0010010"),
                                       ('1','1','1','1',"010","001","1110001","0000001","0100100","0110000"));

                                      -- ('0','0','1','0',"010","010","0000001","0010010","0010010","0010010"), 
                                       --*('1','0','1','1',"010","010","0000001","0010010","0010010","0010010")); --N4A LOSE             


begin
  for i in tabela_verdade'range loop
    clk<=tabela_verdade(i).clk;
    reset<=tabela_verdade(i).reset;
    SW_I<=tabela_verdade(i).SW_I;
    SW_F<=tabela_verdade(i).SW_F;
    X_S<=tabela_verdade(i).x;
    Y_S<=tabela_verdade(i).y;

    wait for 1ns;
    assert (D0_S=tabela_verdade(i).d0) report "Erro na saida de d0 avacalhadissom";  
    assert (D1_S=tabela_verdade(i).d1) report "Erro na saida de d0 avacalhadissom";  
    assert (D2_S=tabela_verdade(i).d2) report "Erro na saida de d0 avacalhadissom";  
    assert (D3_S=tabela_verdade(i).d3) report "Erro na saida de d0 avacalhadissom";  
  end loop;
  
  report "Fim dos testes";

end process;

end architecture;