library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity division_circuit is
    Port (clk: in std_logic;
          clr: in std_logic;
          x1, x2: in std_logic_vector(31 downto 0); 
          op_id_div: in std_logic_vector(3 downto 0);  
          clr_c_div: in std_logic;    
          ld_d_div: in std_logic;     
          sub_div: in std_logic;      
          ld_d2_div: in std_logic;     
          right_shift_d2_div: in std_logic;    
          left_shift_q_div: in std_logic;     
          y: out std_logic_vector(63 downto 0); 
          flags: out std_logic_vector(6 downto 0);
          dn: out std_logic);
end division_circuit;

architecture Behavioral of division_circuit is
    component adder_64bits is
        Port (x1, x2: in std_logic_vector(63 downto 0);
              sub: in std_logic;
              cout: out std_logic;
              y: out std_logic_vector(63 downto 0));
    end component;

    component register_n_bits is
        Generic (N : integer := 32);
        Port (data_in : in std_logic_vector(n - 1 downto 0);
              left : in std_logic;
              right : in std_logic;
              load : in std_logic;
              clr : in std_logic;
              serial_in : in std_logic;
              clk : in std_logic;
              data_out : out std_logic_vector(n - 1 downto 0));    
    end component;

    signal dividend, divisor : std_logic_vector(63 downto 0);
    signal sum_out : std_logic_vector(63 downto 0);
    signal ext_x1, ext_x2 : std_logic_vector(63 downto 0);
    signal q : std_logic_vector(31 downto 0);
    signal cout : std_logic;
    signal q0_internal : std_logic;
    signal serial_in_q : std_logic;
    signal carry_flag, aux_carry_flag, overflow_flag, zero_flag, parity_flag, sign_flag, div_by_zero_flag : std_logic;
    
begin
    ext_x1 <= x"00000000" & x1;
    ext_x2 <= x2 & x"00000000";
    

    serial_in_q <= not sum_out(63) when sub_div = '1' else '0';
    

    d_register: register_n_bits 
        generic map (N => 64) 
        port map (
            data_in => ext_x1,
            left => '0', 
            right => '0', 
            load => ld_d_div, 
            clr => clr, 
            serial_in => '0', 
            clk => clk, 
            data_out => dividend
        );
    

    d2_register: register_n_bits 
        generic map (N => 64) 
        port map (
            data_in => ext_x2,
            left => '0', 
            right => right_shift_d2_div,
            load => ld_d2_div, 
            clr => clr, 
            serial_in => '0', 
            clk => clk, 
            data_out => divisor
        );
    

    q_register: register_n_bits 
        generic map (N => 32) 
        port map (
            data_in => x"00000000",
            left => left_shift_q_div, 
            right => '0', 
            load => '0', 
            clr => clr_c_div, 
            serial_in => serial_in_q,
            clk => clk, 
            data_out => q
        );
    

    adder: adder_64bits 
        port map (
            x1 => dividend,
            x2 => divisor,
            sub => sub_div,
            cout => cout,
            y => sum_out
        );

  
    process(clk, clr)
    begin
        if clr = '1' then
            q0_internal <= '0';
        elsif rising_edge(clk) then
            if sub_div = '1' then
         
                q0_internal <= not sum_out(63);
            end if;
        end if;
    end process;

 
    dn <= sum_out(63);
    y <= q & dividend(31 downto 0);

  
    carry_flag <= cout;
    aux_carry_flag <= '0';
    parity_flag <= q(0);
    sign_flag <= q(31);
    overflow_flag <= '0';
    zero_flag <= '1' when q = x"00000000" else '0';
    div_by_zero_flag <= '1' when x2 = x"00000000" else '0';

    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & div_by_zero_flag & aux_carry_flag & carry_flag;

end Behavioral;