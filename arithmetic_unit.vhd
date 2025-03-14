library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity arithmetic_unit is
    Port (
        x1, x2: in std_logic_vector(31 downto 0);   
        op_id_arithm: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(31 downto 0);          
        flags: out std_logic_vector(6 downto 0)
    );         
end arithmetic_unit;

architecture Structural of arithmetic_unit is
    component full_adder_1bit is
        Port(
            a, b, cin: in std_logic;
            result, cout: out std_logic
        );
    end component;

    component mux_2_1 is
        Port (
            x0, x1, sel: in std_logic;
            y: out std_logic
        );
    end component;

    component or_gate is
        Port (
            a, b: in std_logic;
            res: out std_logic
        );          
    end component;

    component not_gate is
        Port (
            a: in std_logic;
            res: out std_logic
        );
    end component;


    signal mux_x1, mux_x2: std_logic_vector(31 downto 0) := x"00000000";
    signal inv_x1, inv_x2: std_logic_vector(31 downto 0) := x"00000000";
    signal result_sig: std_logic_vector(31 downto 0) := x"00000000";
    signal carry_sig: std_logic_vector(31 downto 0) := x"00000000";
    signal operand_x2: std_logic_vector(31 downto 0) := x"00000000";
    
 
    signal sel_sub, sel_neg, sel_inc, sel_dec: std_logic := '0';
    signal sel_op: std_logic := '0';  
    signal sel_cin: std_logic := '0';
    
    
    constant ONE: std_logic_vector(31 downto 0) := x"00000001";
    constant ZERO: std_logic_vector(31 downto 0) := x"00000000";
    
    
    signal sign_flag, overflow_flag, parity_flag, zero_flag: std_logic := '0';
    signal div_by_zero_flag, aux_carry_flag, carry_flag, borrow_flag: std_logic := '0';
    signal ovf, ovf_add, ovf_sub: std_logic := '0';
    
begin
 
    process(op_id_arithm)
    begin
      
        sel_sub <= '0';
        sel_neg <= '0';
        sel_inc <= '0';
        sel_dec <= '0';
        
        case op_id_arithm is
            when "0101" =>  -- ADD
                sel_sub <= '0';
                sel_neg <= '0';
                sel_inc <= '0';
                sel_dec <= '0';
            when "0110" =>  -- SUB
                sel_sub <= '1';
                sel_neg <= '0';
                sel_inc <= '0';
                sel_dec <= '0';
            when "0111" =>  -- INC
                sel_sub <= '0';
                sel_neg <= '0';
                sel_inc <= '1';
                sel_dec <= '0';
            when "1000" =>  -- DEC
                sel_sub <= '0';
                sel_neg <= '0';
                sel_inc <= '0';
                sel_dec <= '1';
            when "1001" =>  -- NEG
                sel_sub <= '0';
                sel_neg <= '1';
                sel_inc <= '0';
                sel_dec <= '0';
            when others =>
                sel_sub <= '0';
                sel_neg <= '0';
                sel_inc <= '0';
                sel_dec <= '0';
        end case;
    end process;


    sel_op <= sel_sub or sel_dec;
    sel_cin <= sel_sub or sel_dec or sel_neg;


    operand_x2 <= ONE when (sel_inc = '1' or sel_dec = '1') else
                  ZERO when sel_neg = '1' else
                  x2;
    
    full_arithmetic_unit: for i in 0 to 31 generate
        block0: if i = 0 generate
            not1: not_gate port map(x1(i), inv_x1(i));    
            not2: not_gate port map(operand_x2(i), inv_x2(i));    
            
            mux_sub: mux_2_1 port map(
                x0 => operand_x2(i),
                x1 => inv_x2(i),
                sel => sel_op,
                y => mux_x2(i)
            );
            
            mux_neg: mux_2_1 port map(
                x0 => x1(i),
                x1 => inv_x1(i),
                sel => sel_neg,
                y => mux_x1(i)
            );
            
            adder: full_adder_1bit port map(
                a => mux_x1(i),
                b => mux_x2(i),
                cin => sel_cin,
                result => result_sig(i),
                cout => carry_sig(i)
            );
        end generate block0;
        
        other_blocks: if i > 0 generate
            not1: not_gate port map(x1(i), inv_x1(i));    
            not2: not_gate port map(operand_x2(i), inv_x2(i));    
            
            mux_sub: mux_2_1 port map(
                x0 => operand_x2(i),
                x1 => inv_x2(i),
                sel => sel_op,
                y => mux_x2(i)
            );
            
            mux_neg: mux_2_1 port map(
                x0 => x1(i),
                x1 => inv_x1(i),
                sel => sel_neg,
                y => mux_x1(i)
            );
            
            adder: full_adder_1bit port map(
                a => mux_x1(i),
                b => mux_x2(i),
                cin => carry_sig(i - 1),
                result => result_sig(i),
                cout => carry_sig(i)
            );
        end generate other_blocks; 
    end generate full_arithmetic_unit;

   
    sign_flag <= result_sig(31);
    
    ovf_add <= (x1(31) and operand_x2(31) and (not result_sig(31))) or 
               ((not x1(31)) and (not operand_x2(31)) and result_sig(31));
    ovf_sub <= (x1(31) and (not operand_x2(31)) and (not result_sig(31))) or 
               ((not x1(31)) and operand_x2(31) and result_sig(31));
    ovf <= ovf_add when sel_op = '0' else ovf_sub;
    overflow_flag <= '0' when sel_neg = '1' else ovf;
    
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
    aux_carry_flag <= carry_sig(3);
    
    borrow_flag_proc: process(x1, operand_x2) 
    begin
        if signed(x1) < signed(operand_x2) then
            borrow_flag <= '1';
        else
            borrow_flag <= '0';
        end if;
    end process;
    
    carry_flag <= carry_sig(31) when sel_op = '0' else borrow_flag;
    
    y <= result_sig;
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & 
             div_by_zero_flag & aux_carry_flag & carry_flag;
             
end Structural;