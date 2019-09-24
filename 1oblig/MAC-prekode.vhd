library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

  -- Denne kildekoden har lagt inn 2 skrivefeil.
  -- Skriv koden selv, og kommenter feilene der du finner dem.

entity MAC is
    generic (width: integer := 8);
    port(
        clk, reset  : in STD_LOGIC;
        MLS_select  : in STD_LOGIC;
        Rn, Rm, Ra  : in STD_LOGIC_VECTOR(width-1 downto 0);
        Rd          : out STD_LOGIC_VECTOR(width-1 downto 0)
    );
    end;

architecture behavioral of MAC is
    signal buffMLS, buffMLS2                    : STD_LOGIC;
    signal mul1, mul2, add1, buffRa 	: UNSIGNED(width-1 downto 0);
    signal add2, sum, sub             : UNSIGNED(width*2-1 downto 0);
    signal buffProd, buffSum, buffSub : UNSIGNED(width*2-1 downto 0);

    begin
      process(clk, reset)

      begin
        if reset = '1' then
          Rd <= (others => '0');          -- asynkron reset.
          buffProd <= (others => '0');
          buffRa <= (others => '0');
          buffMLS <= '0';
          buffSum <= (others => '0');
          buffSub <= (others => '0');


      elsif rising_edge(clk) then          -- Skjer på klokkeflanken.
        buffRa <= add1;
        buffProd <= add2;

        buffMLS2 <= buffMLS;
        buffMLS <= MLS_select;

        buffSum <= sum;
        buffSub <= sub;

        if buffMLS2 = '1' then
          Rd <= STD_LOGIC_VECTOR(buffSub(width-1 downto 0));

        elsif buffMLS2 = '0' then
          Rd <= STD_LOGIC_VECTOR(buffSum(width-1 downto 0)); -- Ta vare på LSB. -- Andre feil, sum var sm.
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
