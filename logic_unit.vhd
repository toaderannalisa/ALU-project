library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
    Port (clk: in std_logic;
    x1, x2: in std_logic_vector(31 downto 0);       
    id_op: in std_logic_vector(3 downto 0);    
    left, right: in std_logic;       
    y: out std_logic_vector(31 downto 0);
    flags: out std_logic_vector(6 downto 0));
end logic_unit;

architecture Structural of logic_unit is

    component logic_and is
        Port (x0, x1: in std_logic_vector(31 downto 0);
              y: out std_logic_vector(31 downto 0));
    end component;
    
    component logic_or is
        Port (x0, x1: in std_logic_vector(31 downto 0);
              y: out std_logic_vector(31 downto 0));
    end component;
    
    component logic_not is
        Port (x: in std_logic_vector(31 downto 0);
              y: out std_logic_vector(31 downto 0));
    end component;
    
    component left_rotation_circuit is
        Port (clk: in std_logic;
              x: in std_logic_vector(31 downto 0);
              left: in std_logic;
              y: out std_logic_vector(31 downto 0));
    end component;
    
    component right_rotation_circuit is
        Port (clk: in std_logic;
              x: in std_logic_vector(31 downto 0);
              right: in std_logic;
              y: out std_logic_vector(31 downto 0));
    end component;
    
 
    signal and_out, or_out, not_out, left_rot_out, right_rot_out: std_logic_vector(31 downto 0);
    signal result_sig: std_logic_vector(31 downto 0) := x"00000000";
    signal sign_flag, overflow_flag, parity_flag, zero_flag, div_by_zero_flag, aux_carry_flag, carry_flag: std_logic := '0';

begin
 
    and_comp: logic_and port map(
        x0 => x1,
        x1 => x2,
        y => and_out
    );
    
    or_comp: logic_or port map(
        x0 => x1,
        x1 => x2,
        y => or_out
    );
    
    not_comp: logic_not port map(
        x => x1,
        y => not_out
    );
    
    left_rot: left_rotation_circuit port map(
        clk => clk,
        x => x1,
        left => left,
        y => left_rot_out
    );
    
    right_rot: right_rotation_circuit port map(
        clk => clk,
        x => x1,
        right => right,
        y => right_rot_out
    );


    process(clk, id_op, and_out, or_out, not_out, left_rot_out, right_rot_out)
    begin
        case id_op is
            when "0110" =>  -- AND 
                result_sig <= and_out;
                
            when "0111" =>  -- OR
                result_sig <= or_out;
                
            when "1000" =>  -- NOT
                result_sig <= not_out;
                
            when "1001" =>  -- ROL
                result_sig <= left_rot_out;
                
            when "1010" =>  -- ROR
                result_sig <= right_rot_out;
                
            when others =>
                result_sig <= (others => '0');
        end case;
    end process;
   

    sign_flag <= result_sig(31);
    overflow_flag <= '0';
    parity_flag <= result_sig(0);
    
    zero_flag_proc: process(result_sig) 
    begin
        case result_sig is
            when x"00000000" =>
                zero_flag <= '1';
            when others =>
                zero_flag <= '0';
        end case;
    end process;
    
    div_by_zero_flag <= '0';
    aux_carry_flag <= '0';
    carry_flag <= '0';

    y <= result_sig;
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & div_by_zero_flag & aux_carry_flag & carry_flag;
    
end Structural;