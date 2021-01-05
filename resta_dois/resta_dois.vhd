entity resta_dois is
port(
	push_buttonI, push_buttonF: in bit; -- resetar após jogada executada
	xi, yi, xf, yf: in natural; -- variar de 0 a 4
	sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0: in bit; -- sw7 to sw4 controls yi/yf, sw3 to sw0 controls xi/xf
	clk: in bit;
	reset : in bit;
	win_lose: out bit);
end entity;

architecture behaviour of resta_dois is
	type Elemento is range -1 to 1;

	type Matrix is ARRAY (0 to 4,0 to 4) of Elemento;

	type States is (I,N1A,N1B,N1C,N1D,
					  N2A,N2B,N2C,N2D,
					  N3A,N3B,N3C,N3D,N3E,N3F,N3G,N3H,
					  N4A,N4B,N4C,N4D,N4E,N4F,N4G,N4H,
					  N5A,N5B,N5C,N5D,
					  N6A,N6B,N6C,N6D);
							
	signal est_atual, prox_est: States ;	--http://quitoart.blogspot.com/2017/07/vhdl-ps2-keyboard-hyperterminal.html  (teclado ps2d)

	signal xi_aux, yi_aux, xf_aux, yf_aux : natural;
		
	procedure displayVictory is
	variable d0, d1, d2, d3: bit_vector(0 to 6);
	begin
		d0 := "1110001";
		d1 := "0000001";
		d2 := "0100100";
		d3 := "0110000";
	end procedure displayVictory;
	
	procedure displayDefeat is
	variable d0, d1, d2, d3: bit_vector(0 to 6);
	begin
		d0 := "1100001";
		d1 := "1000011";
		d2 := "1111001";
		d3 := "0001001";
	end procedure displayDefeat;

	--------------------------------------------CONTROLA xi xf yi yf------------------------------------
	procedure display_xyi is
	variable d0,d1: bit_vector(0 to 6);
	begin
		if xi_aux = 0 then
			d0 := "1100001";
		elsif xi_aux = 1 then
			d0 := "1100001";
		elsif xi_aux = 2 then
			d0 := "1100001";
		elsif xi_aux = 3 then
			d0 := "1100001";
		elsif xi_aux = 4 then
			d0 := "1100001";				
		end if;	
		
		if yi_aux = 0 then
			d1 := "1100001";
		elsif yi_aux = 1 then
			d1 := "1100001";
		elsif yi_aux = 2 then
			d1 := "1100001";
		elsif yi_aux = 3 then
			d1 := "1100001";
		elsif yi_aux = 4 then
			d1 := "1100001";				
		end if;	
	end procedure display_xyi;

	procedure display_xyf is
	variable d2,d3: bit_vector(0 to 6);
	begin
		if xf_aux = 0 then
			d2 := "1100001";
		elsif xf_aux = 1 then
			d2 := "1100001";
		elsif xf_aux = 2 then
			d2 := "1100001";
		elsif xf_aux = 3 then
			d2 := "1100001";
		elsif xf_aux = 4 then
			d2 := "1100001";				
		end if;	
	
		if yf_aux = 0 then
			d3 := "1100001";
		elsif yf_aux = 1 then
			d3 := "1100001";
		elsif yf_aux = 2 then
			d3 := "1100001";
		elsif yf_aux = 3 then
			d3 := "1100001";
		elsif yf_aux = 4 then
			d3 := "1100001";				
		end if;	
	end procedure display_xyf;		
	---------------------------------------------------------------------------------------------------
begin
	-- Circuito Sequencial
	p0:process(clk,reset) is 
	begin
		if (clk = '1') then -- falta verificar se eh de subida
			est_atual <= prox_est;
		elsif(reset = '1') then
			est_atual <= I;
		end if;

	end process;

	p2: process(sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0, push_buttonI) is
	
	begin
	 
    if(push_buttonI = '1') then
		if ( sw7 = '0' or sw6 = '0' or sw5 = '0' or sw4 = '0') then  ------------ DEcrementa ------------------------------
			xi_aux <= xi - 1;
		elsif ( sw7 = '1' or sw6 = '1' or sw5 = '1' or sw4 = '1') then-------------INCREMENTA-------------------------------
			xi_aux <= xi + 1;
		elsif ( sw3 = '0' or sw2 = '0' or sw1 = '0' or sw0 = '0') then------------ DEcrementa ------------------------------ 
			yi_aux <= yi - 1;
		elsif ( sw3 = '1' or sw2 = '1' or sw1 = '1' or sw0 = '1') then-------------INCREMENTA-------------------------------
			yi_aux <= yi + 1;	
		display_xyi;	
		end if;		
	elsif(push_buttonI = '0') then
		if( sw7 = '0' or sw6 = '0' or sw5 = '0' or sw4 = '0') then ------------ DEcrementa ------------------------------
			xf_aux <= xf - 1;		
		elsif( sw7 = '1' or sw6 = '1' or sw5 = '1' or sw4 = '1') then-------------INCREMENTA-------------------------------
			xf_aux <= xf + 1;
		elsif ( sw3 = '0' or sw2 = '0' or sw1 = '0' or sw0 = '0') then------------ DEcrementa ------------------------------		 
			yf_aux <= yf - 1;
		elsif ( sw3 = '1' or sw2 = '1' or sw1 = '1' or sw0 = '1') then-------------INCREMENTA------------------------------- 		 
			yf_aux <= yf + 1;
		display_xyi;
		display_xyf;	
		end if;		


	end if;
	
	end process;	
	
	-- Circuito Combinacional
	p1:process(est_atual, push_buttonI, push_buttonF) is      -- 0  1 2  3  4      ------------------------------------N1---------------------------------------
  	variable tabuleiro: Matrix := ((-1,-1,1,-1,-1),--0
								   (-1,-1,1,-1,-1),--1
								   ( 1, 1,0, 1, 1),--2
								   (-1,-1,1,-1,-1),--3
								   (-1,-1,1,-1,-1));--4

  	-- procedimento display7seg


	begin
		case est_atual is 
			when I =>      -- 0  1 2  3  4       ------------------------------------N1---------------------------------------
				tabuleiro :=    ((-1,-1,1,-1,-1),--0
							     (-1,-1,1,-1,-1),--1
							     ( 1, 1,0, 1, 1),--2
							     (-1,-1,1,-1,-1),--3
							     (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 0 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N1A;
					elsif xi_aux = 4 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
				   		prox_est <= N1B;
					elsif xi_aux = 2 and yi_aux= 0 and xf_aux =2 and yf_aux = 2 then
				   		prox_est <= N1B;
					elsif xi_aux = 2 and yi_aux = 4 and xf_aux = 2 and yf_aux = 2 then
				   		prox_est <= N1B;
				   	else
				   		prox_est <= I; 
					end if;
				else
					prox_est <= I;
				end if;
								  
			when N1A =>      -- 0  1 2  3  4       ------------------------------------N1---------------------------------------         
				tabuleiro := ((-1,-1,0,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 1, 1,1, 1, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 3 and yi_aux = 2 and xf_aux = 1 and yf_aux=2 then
						prox_est <= N2A;
					else
				   		prox_est <= N1A;	
					end if;
				else
					prox_est <= N1A;
				end if;			  	  
			
			when N1B =>      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 1,1, 1, 1),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 1 and yi_aux= 2 and xf_aux =3 and yf_aux=2 then
						prox_est <= N2B;
					else
				   		prox_est <= N1B;	
					end if;
				else 
					prox_est <= N1B;
				end if;				  
			
			when N1C =>      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 0, 0,1, 1, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N2C;
					else
				   		prox_est <= N1C;
					end if;				  
				else
					prox_est <= N1C;
				end if;

			when N1D =>      -- 0  1 2  3  4       ------------------------------------N1--------------------------------------- 
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 1,1, 0, 0),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 1 and xf_aux = 2 and yf_aux = 3 then
						prox_est <= N2D;
					else
				   		prox_est <= N1D;	
					end if;				  
				else
					prox_est <= N1D;
				end if;

			when N2A =>      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------   
				tabuleiro := ((-1,-1,0,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 1,0, 1, 1),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 0 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3A;
					elsif xi_aux = 2 and yi_aux = 4 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3B;
					else
				   		prox_est <= N2A;			
					end if;	
				else
					prox_est <= N2A;
				end if;

			when N2B =>      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 1, 1,0, 1, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 0 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3C;
					elsif xi_aux = 2 and yi_aux = 4 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3D;
					else
				   		prox_est <= N2B;			
					end if;
				else
					prox_est <= N2B;
				end if;

			when N2C =>      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------   
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 0, 1,0, 0, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then	
					if xi_aux = 0 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3E;
					elsif xi_aux= 4 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3F;
					else
				   		prox_est <= N2C;			
					end if;
				else
					prox_est <= N2C;
				end if;

			when N2D =>      -- 0  1 2  3  4       ------------------------------------N2---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 0,0, 1, 0),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then	
					if xi_aux = 0 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3G;
					elsif xi_aux= 4 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N3H;
					else
				   		prox_est <= N2D;			
					end if;
				else
					prox_est <= N2D;
				end if;

		   when N3A =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------  
				tabuleiro := ((-1,-1,0,-1,-1), --0
							  (-1,-1,1,-1,-1), --1
							  ( 0, 0,1, 1, 1), --2
							  (-1,-1,0,-1,-1), --3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then	
					if xi_aux = 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N4A; -- GAME OVER1
					elsif xi_aux= 1 and yi_aux = 2 and xf_aux = 3 and yf_aux = 2 then
						prox_est <= N4B;
					else
				   		prox_est <= N3A;			
					end if;
				else
					prox_est <= N3A;
				end if;

			when N3B =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 1,1, 0, 0),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 1 and xf_aux = 2 and yf_aux = 3 then
						prox_est <= N4C;--GAME OVER2
					elsif xi_aux= 1 and yi_aux = 2 and xf_aux = 3 and yf_aux = 2 then
						prox_est <= N4D;
					else
				   		prox_est <= N3B;			
					end if;
				else
					prox_est <= N3B;
				end if;

			when N3C =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 0, 0,1, 1, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N4E; -- GAME OVER3
					elsif xi_aux= 3 and yi_aux = 2 and xf_aux = 1 and yf_aux = 2 then
						prox_est <= N4F;
					else
				   		prox_est <= N3C;			
					end if;
				else
					prox_est <= N3C;
				end if;

			when N3D =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 1, 1,1, 0, 0),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then	
					if xi_aux = 2 and yi_aux = 1 and xf_aux = 2 and yf_aux = 3 then
						prox_est <= N4G; -- GAME OVER4
					elsif xi_aux= 3 and yi_aux = 2 and xf_aux = 1 and yf_aux = 2 then
						prox_est <= N4H;
					else
				   		prox_est <= N3D;			
					end if;
				else
					prox_est <= N3D;
				end if;

			when N3E =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 0, 1,1, 0, 1),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux =3 and yi_aux=2 and xf_aux =1 and yf_aux=2 then
						prox_est <= N4A;--GAME OVER5
					elsif xi_aux=2 and yi_aux=1 and xf_aux =2 and yf_aux=3 then
						prox_est <= N4B;
					else
				   		prox_est <= N3E;			
					end if;
				else
					prox_est <= N3E;
				end if;

			when N3F =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 0, 1,1, 0, 1),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 1 and yi_aux = 2 and xf_aux = 3 and yf_aux = 2 then
						prox_est <= N4E; --GAME OVER6
					elsif xi_aux= 2 and yi_aux = 1 and xf_aux = 2 and yf_aux = 3 then
						prox_est <= N4F;		
					else
				   		prox_est <= N3F;
					end if;
				else
					prox_est <= N3F;
				end if;

			when N3G =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
							  (-1,-1,0,-1,-1),--1
							  ( 1, 0,1, 1, 0),--2
							  (-1,-1,1,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 3 and yi_aux = 2 and xf_aux = 1 and yf_aux = 2 then
						prox_est <= N4C;--GAME OVER7
					elsif xi_aux= 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N4D;		
					else
				   		prox_est <= N3G;
					end if;
				else
					prox_est <= N3G;
				end if;

			when N3H =>      -- 0  1 2  3  4       ------------------------------------N3---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
							  (-1,-1,1,-1,-1),--1
							  ( 1, 0,1, 1, 0),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 1 and yi_aux = 2 and xf_aux = 3 and yf_aux = 2 then
						prox_est <= N4G; --GAME OVER8
					elsif xi_aux= 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N4H;		
					else
				   		prox_est <= N3H;
					end if;
				else
					prox_est <= N3H;
				end if;

		   when N4A =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
				   			  (-1,-1,1,-1,-1),--1
				   			  ( 0, 1,0, 0, 1),--2
				   			  (-1,-1,0,-1,-1),--3
				   			  (-1,-1,1,-1,-1));--4
				win_lose <= '0';
				displayDefeat;
			when N4B =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
				   			  (-1,-1,0,-1,-1),--1
				   			  ( 0, 0,0, 1, 1),--2
				   			  (-1,-1,1,-1,-1),--3
				   			  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 4 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5A; --GAME OVER8
					elsif xi_aux= 2 and yi_aux = 4 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5B;		
					else
				   		prox_est <= N4B;
					end if;
				else
					prox_est <= N4B;
				end if;

			when N4C =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
					   		  (-1,-1,1,-1,-1),--1
						   	  ( 1, 0,0, 1, 0),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				win_lose <= '0';
				displayDefeat;
			when N4D =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
		   					  (-1,-1,0,-1,-1),--1
			   				  ( 1, 1,0, 0, 0),--2
				   			  (-1,-1,1,-1,-1),--3
					   		  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 0 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5B; --GAME OVER8
					elsif xi_aux= 4 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5C;		
					else
				   		prox_est <= N4D;
					end if;
				else
					prox_est <= N4D;
				end if;

			when N4E =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
	   						  (-1,-1,0,-1,-1),--1
		   					  ( 0, 1,0, 0, 1),--2
			   				  (-1,-1,1,-1,-1),--3
				   			  (-1,-1,0,-1,-1));--4
				win_lose <= '0';
				displayDefeat;
			when N4F =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
					   		  (-1,-1,1,-1,-1),--1
						   	  ( 0, 0,0, 1, 1),--2
							  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 0 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5A; --GAME OVER8
					elsif xi_aux= 2 and yi_aux = 4 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5D;		
					else
				   		prox_est <= N4F;
					end if;
				else
					prox_est <= N4F;
				end if;

			when N4G =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
	   						  (-1,-1,0,-1,-1),--1
		   					  ( 1, 0,0, 1, 0),--2
			   				  (-1,-1,1,-1,-1),--3
				   			  (-1,-1,0,-1,-1));--4
				win_lose <= '0';
				displayDefeat;
			when N4H =>      -- 0  1 2  3  4       ------------------------------------N4---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
		   					  (-1,-1,1,-1,-1),--1
			   				  ( 1, 1,0, 0, 0),--2
				   			  (-1,-1,0,-1,-1),--3
					   		  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 0 and yi_aux = 2 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5C; --GAME OVER8
					elsif xi_aux= 2 and yi_aux = 0 and xf_aux = 2 and yf_aux = 2 then
						prox_est <= N5D;
					else
				   		prox_est <= N4H;
					end if;	
				else
					prox_est <= N4H;
				end if;

			when N5A =>      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
			   				  (-1,-1,0,-1,-1),--1
				   			  ( 0, 0,1, 1, 1),--2
					   		  (-1,-1,0,-1,-1),--3
						   	  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 3 and xf_aux = 2 and yf_aux = 1 then
						prox_est <= N6A; --GANHOU
					else
				   		prox_est <= N5A;
					end if;
				else
					prox_est <= N5A;
				end if;

			when N5B =>      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
		   					  (-1,-1,0,-1,-1),--1
			   				  ( 0, 0,1, 0, 0),--2
				   			  (-1,-1,1,-1,-1),--3
					   		  (-1,-1,1,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 3 and yi_aux = 2 and xf_aux = 1 and yf_aux = 2 then
						prox_est <= N6B; --GANHOU
					else
				   		prox_est <= N5B;
					end if;
				else
					prox_est <= N5B;
				end if;

			when N5C =>      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
				   			  (-1,-1,0,-1,-1),--1
					   		  ( 1, 1,1, 0, 0),--2
						   	  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 2 and yi_aux = 1 and xf_aux = 2 and yf_aux = 3 then
						prox_est <= N6C; --GANHOU
					else
				   		prox_est <= N5C;
					end if;
				else
					prox_est <= N5C;
				end if;

			when N5D =>      -- 0  1 2  3  4       ------------------------------------N5---------------------------------------
				tabuleiro := ((-1,-1,1,-1,-1),--0
				   			  (-1,-1,1,-1,-1),--1
					   		  ( 0, 0,1, 0, 0),--2
						   	  (-1,-1,0,-1,-1),--3
							  (-1,-1,0,-1,-1));--4
				if (push_buttonI = '0' nor push_buttonF = '0') then
					if xi_aux = 1 and yi_aux = 3 and xf_aux = 3 and yf_aux = 2 then
						prox_est <= N6D; --GANHOU
					else
				   		prox_est <= N5D;
					end if;
				else
					prox_est <= N5D;
				end if;

			when N6A =>      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
			   				  (-1,-1,0,-1,-1),--1
				   			  ( 0, 1,0, 0, 1),--2
					   		  (-1,-1,0,-1,-1),--3
						   	  (-1,-1,0,-1,-1));--4
				win_lose <= '1';
				displayVictory;
			when N6B =>      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
				   			  (-1,-1,1,-1,-1),--1
					   		  ( 0, 0,0, 0, 0),--2
						   	  (-1,-1,0,-1,-1),--3
							  (-1,-1,1,-1,-1));--4
				win_lose <= '1';
				displayVictory;
			when N6C =>      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------
				tabuleiro := ((-1,-1,0,-1,-1),--0
			   				  (-1,-1,0,-1,-1),--1
				   			  ( 1, 0,0, 1, 0),--2
					   		  (-1,-1,0,-1,-1),--3
						   	  (-1,-1,0,-1,-1));--4
				win_lose <= '1';
				displayVictory;
			when N6D =>      -- 0  1 2  3  4       ------------------------------------N6---------------------------------------	
				tabuleiro := ((-1,-1,1,-1,-1),--0
			   				  (-1,-1,0,-1,-1),--1
				   			  ( 0, 0,0, 0, 0),--2
					   		  (-1,-1,1,-1,-1),--3
						   	  (-1,-1,0,-1,-1));--4
				win_lose <= '1';
				displayVictory;
				
		end case;
	
	end process;
	
end behaviour;