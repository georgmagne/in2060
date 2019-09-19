library IEEE; 
  use IEEE.STD_LOGIC_1164.all;
--  use IEEE.numeric_std.all; -- Bruker ikke numeric_std i testbenk
  
entity MAC_testbenk is   -- "nothing" Bruker ikke IO ut av testbenk
  generic (width: integer := 8);
 end;

architecture sim of MAC_testbenk is
	
	component MAC
		port(
			clk, reset: in STD_LOGIC;
			MLS_select  : in STD_LOGIC;
			Rm, Rn, Ra  :  	in STD_LOGIC_VECTOR(width-1 downto 0);
			Rd          :   out STD_LOGIC_VECTOR(width-1 downto 0)
		);
	end component;

	signal 	tb_clk, tb_reset	:  	STD_LOGIC;
	signal 	tb_Rm, tb_Rn, tb_Ra :  	STD_LOGIC_VECTOR(width-1 downto 0);
	signal 	tb_Rd          		:   STD_LOGIC_VECTOR(width-1 downto 0);
	signal  tb_MLS_select    :   STD_LOGIC;
	begin
	
	DUT: MAC 
	--generic map(width := width);
	port map(
		clk => tb_clk,
		reset => tb_reset,
		Rm => tb_Rm,
		Rn => tb_Rn,
		Ra => tb_Ra,
		Rd => tb_Rd,
		MLS_select => tb_MLS_select
	);
	
	

	process   --–– lage klokke:
	begin
	   tb_clk <= '1';
	   wait for 100 ns; -- "wait" er ikke syntetiserbar, og brukes bare i testbenker. 
	   tb_clk <= '0';
	   wait for 100 ns;
	end process;

	process   -- merk at begge prosessene her kjøres samtidig, og på repeat... 
	begin
		wait for 231 ns;
		tb_reset <= '0';
		wait for 100 ns;
		tb_reset <= '1';
		tb_MLS_select <= '0'; -- Kjør MLA når MLS_select er lav ('0')
		tb_Rm <= "00001000"; -- 8
		tb_Rn <= "00000111"; -- 7
		tb_Ra <= "00000110"; -- 6
		wait for 200 ns;
		tb_reset <= '0';
		wait for 200 ns;
		tb_MLS_select <= '1'; -- Kjør MLS når MLS_select er høy ('1') fom del3
		wait for 200 ns;
		tb_Rm <= "00000101"; -- 5
		tb_Rn <= "00000100"; -- 4
		tb_Ra <= "00000011"; -- 3
		wait for 200 ns;
		tb_Rm <= "00000010"; -- 2
		tb_Rn <= "00000001"; -- 1
		tb_Ra <= "00000000"; -- 0
		wait for 400 ns;
	end process;
		
	end architecture;
      
