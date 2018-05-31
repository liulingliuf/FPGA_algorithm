
-- 占空比为50%
signal clk_cnta : std_logic_vector(1 downto 0);  
signal clk_cntb : std_logic_vector(1 downto 0);  
signal clk_div : std_logic;  
  
process(clk,rst)  
begin  
if rst = '1' then  
clk_cnta <= "00";  
elsif rising_edge(clk) then  
if clk_cnta = "10" then  
clk_cnta <= "00";  
else  
clk_cnta <= clk_cnta + 1;  
end if;  
end if;  
end process;  
  
process(clk,rst)  
begin  
if rst = '1' then  
clk_cntb <= "00";  
elsif failing_edge(clk) then  
if clk_cntb = "10" then  
clk_cntb <= "00";  
else  
clk_cntb <= clk_cnta + 1;  
end if;  
end if;  
end process;  
clk_div <= '1' when clk_cnta = "00" and clk_cntb = "00" else  
<= '0';  

--占空比为非50%
<pre name="code" class="plain">signal clk_div : std_logic;  
signal clk_cnt : std_logic_vector(1 downto 0);  
process(clk,rst)  
begin  
if rst = '1' then  
clk_cnt <= "00";  
elsif rising_edge(clk) then  
if clk_cnt <= "10" then  
clk_cnt <= "00";  
else  
clk_cnt <= clk_cnt + 1;  
end if;  
end if;  
end process;  
clk_div <= "0" when clk_div = "10" else  
<= '1';  
