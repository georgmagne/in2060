library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

  -- Denne kildekoden har lagt inn 2 skrivefeil.
  -- Skriv koden selv, og kommenter feilene der du finner dem.

entity MAC is
    generic (width: integer := 8);
    port(
        clk, reset  : in STD_LOGIC; -- Første feil, mangler semikolon
        MLS_select  : in STD_LOGIC;
        Rn, Rm, Ra  : in STD_LOGIC_VECTOR(width-1 downto 0);
        Rd          : out STD_LOGIC_VECTOR(width-1 downto 0)
    );
    end;

architecture behavioral of MAC is
    signal buffMLS                    : STD_LOGIC;
    signal mul1, mul2, add1, buffRa 	: UNSIGNED(width-1 downto 0);
    signal add2, sum, sub		        : UNSIGNED(width*2-1 downto 0);
    signal buffProd 		                : UNSIGNED(width*2-1 downto 0);

    begin
      process(clk, reset, MLS_select)

      begin
        if reset = '1' then
          Rd <= (others => '0'); -- asynkron reset.
          buffProd <= (others => '0');
          buffRa <= (others => '0');

      elsif rising_edge(clk) then                     -- Skjer på klokkeflanken.
        buffProd <= UNSIGNED(mul1*mul2);
        buffRa <= UNSIGNED(Ra);

        buffMLS <= MLS_select;

        if buffMLS = '1' then
          Rd <= STD_LOGIC_VECTOR(sub(width-1 downto 0));

        elsif buffMLS = '1' then
          Rd <= STD_LOGIC_VECTOR(sum(width-1 downto 0)); -- Ta vare på LSB. -- Andre feil, sum var sm.
        end if;
      end if;

    end process;

    -- Concurrent statements
    -- Skjer utenfor prosess, uavhening av klokkeflanker.

    mul1 <= UNSIGNED(Rn);
    mul2 <= UNSIGNED(Rm);
    add1 <= buffRa; -- Endrer add1 til å være den buffrete verdien til ra
    add2 <= buffProd; -- Endrer add2 til å være den buffrete verdien til produktet Rn*Rm
    sum <= add1 + add2;
    sub <= add1 - add2;

  end architecture;
