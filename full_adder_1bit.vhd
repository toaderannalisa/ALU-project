library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity full_adder_1bit is
  Port(a, b, cin: in std_logic;
  result, cout: out std_logic);
end full_adder_1bit;

architecture Structural of full_adder_1bit is


component and_gate is
  Port (a, b: in std_logic;
  res: out std_logic);          
end component;


component or_gate is
  Port (a, b: in std_logic;
  res: out std_logic);          
end component;


component xor_gate is
  Port (a, b: in std_logic;
  res: out std_logic);          
end component;



signal temp1, temp2, temp3, temp4, temp5: std_logic := '0'; 
begin

--  result = a xor b xor cin
xor1: xor_gate port map(a, b, temp1);
xor2: xor_gate port map(temp1, cin, result);

-- : cout = (a and b) or (a and cin) or (b and cin)
and1: and_gate port map(a, b, temp2);
and2: and_gate port map(a, cin, temp3);
and3: and_gate port map(b, cin, temp4);
or1: or_gate port map(temp2, temp3, temp5);
or2: or_gate port map(temp5, temp4, cout);

end Structural;