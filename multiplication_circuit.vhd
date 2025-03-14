library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplication_circuit is
    Port (
        clk: in std_logic;
        clr: in std_logic;  
        x1, x2: in std_logic_vector(31 downto 0);
        clr_res_mul: in std_logic;  
        ld_res_mul: in std_logic;   
        ld_m_mul: in std_logic;    
        ld_d_mul: in std_logic;   
        right_shift_m_mul: in std_logic;   
        left_shift_d_mul: in std_logic;     
        op_id_mul: in std_logic_vector(3 downto 0); 
        y: out std_logic_vector(63 downto 0);
        i0: out std_logic; 
        flags: out std_logic_vector(6 downto 0)
    );
end multiplication_circuit;

architecture Structural of multiplication_circuit is

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

signal res: std_logic_vector(63 downto 0) := (others => '0');
signal ext_x1: std_logic_vector(63 downto 0) := (others => '0');
signal multiplicand: std_logic_vector(63 downto 0) := (others => '0');
signal multiplier: std_logic_vector(31 downto 0) := (others => '0');
signal sum: std_logic_vector(63 downto 0) := (others => '0');
signal cout: std_logic := '0';
signal carry_flag, aux_carry_flag, overflow_flag, zero_flag, parity_flag, sign_flag, div_by_zero_flag: std_logic := '0';

begin
  
    res_register: register_n_bits generic map (N => 64) port map (data_in => sum, left => '0', right => '0', load => ld_res_mul, 
    clr => clr_res_mul, serial_in => '0', clk => clk, data_out => res);
    ext_x1 <= x"00000000" & x1;
    multiplicand_register: register_n_bits generic map (N => 64) port map (data_in => ext_x1, left => left_shift_d_mul, right => '0', 
    load => ld_d_mul, clr => clr, serial_in => '0', clk => clk, data_out => multiplicand);
    multiplier_register: register_n_bits generic map (N => 32) port map (data_in => x2, left => '0', right => right_shift_m_mul, 
    load => ld_m_mul, clr => clr, serial_in => '0', clk => clk, data_out => multiplier);
    adder: adder_64bits port map (x1 => res, x2 => multiplicand, sub => '0', cout => cout, y => sum);
    i0 <= multiplier(0);
    

    overflow_flag_proc: process (res)
    begin
        if res(63 downto 32) = x"00000000" then
            overflow_flag <= '0';
        else
            overflow_flag <= '1';
        end if;
    end process overflow_flag_proc;
    
    carry_flag <= '0';
    aux_carry_flag <= '0';
    parity_flag <= res(0);
    sign_flag <= x1(31) xor x2(31);
    div_by_zero_flag <= '0';
            
    zero_flag_proc: process (res)
    begin
        if res = x"0000000000000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process zero_flag_proc;
    
    y <= res;
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & div_by_zero_flag & aux_carry_flag & carry_flag;

end Structural;
