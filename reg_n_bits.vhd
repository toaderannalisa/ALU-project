library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_n_bits is
    Generic (N : integer := 32);
    Port (data_in : in std_logic_vector(n - 1 downto 0);      
          left : in std_logic;                                  
          right : in std_logic;                              
          load : in std_logic;                                 
          clr : in std_logic;                                  
          serial_in : in std_logic;                             
          clk : in std_logic;
          data_out : out std_logic_vector(n - 1 downto 0));    
end register_n_bits;


architecture Behavioral of register_n_bits is

signal temp: std_logic_vector(n - 1 downto 0) := (others => '0');

begin

register_proc: process(clk)
begin
    if rising_edge(clk) then
        if clr = '1' then
            temp <= (others => '0');
        elsif load = '1' then
            temp <= data_in;
        elsif left = '1' then
            temp <= temp(n - 2 downto 0) & serial_in;
        elsif right = '1' then
            temp <= serial_in & temp(n - 1 downto 1);
        end if;
    end if;
end process;

data_out <= temp;

end Behavioral;