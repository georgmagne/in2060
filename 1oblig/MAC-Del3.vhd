library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

  -- Denne kildekoden har lagt inn 2 skrivefeil.
  -- Skriv koden selv, og kommenter feilene der du finner dem.
  -- Del 4

entity MAC is
    generic (width: integer := 8);
    port(
        clk, reset                     : in STD_LOGIC;
        MLS_select                     : in STD_LOGIC;
        Rn, Rm, Ra                     : in STD_LOGIC_VECTOR(width-1 downto 0);
        Rd                             : out STD_LOGIC_VECTOR(width-1 downto 0)
    );
    end;

architecture behavioral of MAC is
    signal buffMLS                     : STD_LOGIC;
    signal mul1, mul2, add1, buffRa 	 : UNSIGNED(width-1 downto 0);
    signal add2, sum, sub, buffProd    : UNSIGNED(width*2-1 downto 0);

    begin
      process(clk, reset)

      begin
        if reset = '1' then  -- Skjer når reset er høy.
          Rd <= (others => '0');          -- asynkron reset.
          buffProd <= (others => '0');
          buffRa <= (others => '0');
          buffMLS <= '0';                -- Buffer for MLS_select




      elsif rising_edge(clk) then          -- Skjer på klokkeflanken.
        buffProd <= add2;
        buffRa <= add1;

        buffMLS <= MLS_select;          -- Buffer for MLS_select.

        if buffMLS = '1' then -- Når MLS_select er høy:  (Rn*Rm) - Ra
          Rd <= STD_LOGIC_VECTOR(sub(width-1 downto 0)); -- Tar vare på de 8 LSBene til buffSub og setter Rd lik disse.

        elsif buffMLS = '0' then -- Når MLS_select er lav:  (Rn*Rm) + Ra
          Rd <= STD_LOGIC_VECTOR(sum(width-1 downto 0)); -- Tar vare på de 8 LSBene til buffSum og setter Rd lik disse.
        end if;

      end if;

    end process;

    -- Concurrent statements
    -- Skjer utenfor prosess, uavhening av klokkeflanker.

    mul1 <= UNSIGNED(Rn);
    mul2 <= UNSIGNED(Rm);
    add1 <= UNSIGNED(Ra);
    add2 <= mul1*mul2;
    sum <= buffRa + buffProd; -- Endrer sum til å bruke bufferene ikke inputene direkte.
    sub <= buffRa - buffProd; -- Endrer sub til å bruke bufferene ikke inputene direkte.

  end architecture;
