#counter vhdl&verilog coding<br>
----------------------------
--Binary counter<br>
--Source:www.fpga4fun.com/Counters1.html<br>
##1.0 the fast and efficient<br>
----------------------------------
---------------vhdl---------------
signal counter:  std_logic_vector(31 downto 0);<br>
process(clk,reset_n)<br>
begin<br>
  if reset_n = '0' then<br>
    counter <= ( others => '0');<br>
  elsif sys_clk'event and sys_clk = '1' then<br>
    counter <= counter + 1;<br>
  end if;<br>
end process;<br>

---------------verilog---------------<br>
reg [31:0] counter;<br>
always @(posedge sys_clk) counter <= counter + 1;<br>
-----------------------------------<br>
--end of 1.0<br>

##--2.0<br>
------------------------------------
--without initial value, simulation tool will refuse to work or synthesis tool set the initial value on their own.<br>
---------------verilog---------------<br>
reg [31:0] counter = 0;<br>
always @(posedge sys_clk) counter <= counter + 1;<br>
-----------------------------------<br>
--end of 2.0<br>

##--3.0<br>
--------------------------------------
--requirement: start with special value and has enable and direction control.<br>
--flip-flops inside and FPGA always start at 0, so the you could think the counter initial value should HAS TO be 0.<br>
--But by putting some well_placed inverts in the logic, any starting value is possible.<br>
--NOTE: Inverters are free in an FPGA, so there is no drawback.<br>
---------------verilog---------------<br>
reg [9:0] counter = 10d'd300;<br>
wire cnt_enable;<br>
wire cnt_direction;<br>
always @(posedge sys_clk)<br>
  if (cnt_enable)<br>
    counter <= cnt_direction ? counter + 2 :counter - 1;<br>

---------------VHDL---------------<br>
signal counter: std_logic_vector(9 downto 0);<br>
signal cnt_enable: std_logic;<br>
signal cnt_direction: std_logic;<br>
process(sys_clk, reset_n)<br>
begin<br>
  if reset_n = '0' then<br>
    counter <= std_logic_vector(300);<br>
  elsif sys_clk'event and sys_clk ='1' then<br>
     if cnt_enable = '1' then<br>
       case (cnt_direction) is<br>
       when '1' =><br>
         counter <= counter + 1;<br>
       when '0' => d<br>
         counter <= counter - 1;<br>
       end case;<br>
     else<br>
       counter <= counter;<br>
     end if;<br>
  end if;<br>
end process;<br>

##--4.0 counter tick<br>
--------------------------------------
--tick signal that is assert once very 1024 clock. Need a 10 bits counter and logic to generate the tick.<br>
-------------verilog----------------<br>
reg [9:0] cnt = '0';<br>
always @(posedge clk) counter <= counter + 1;<br>
wire tick = ( counter == 1023);<br>

--drawback: this create a big chunk of logic (10 bit AND gate here).<br>
--alternate way is to relay on the carry chain that FPGAd is using behind the scene.<br>
--we just need a bit of arm twisting to convince the FPGA to provide the info.<br>

-----------------verilog--------------<br>
reg [31:0] cnt = 0;<br>
wire [32:0] cnt_next = cnt + 1;<br>
always @(posedge sys_clk ) cnt <= cnt_next[31:0];<br>
wire tick = cnt_next[32];<br>

/-----------------vhdl------------------<br>
signal cnt: std_logic_vector(31 downto 0);<br>
signal cnt_next: std_logic_vector(32 downto 0);<br>
process(sys_clk, reset_n)<br>
begin<br>
  if reset_n = '0' then<br>
    cnt <= ( others <= '0');<br>
    cnt_next <= ( others <= '0');<br>
  elsif sys_clk'event and sys_clk = '1' then<br>
    cnt_next <= std_logic_vector(unsigned(cnt) + 1);<br>
    cnt <= cnt_next(31 downto 0);<br>
  end if;<br>
end process;<br>

--------------------or-----------------<br>
signal cnt: std_logic_vector(31 downto 0);<br>
process(sys_clk, reset_n)<br>
variable cnt_next: std_logic_vector(32 downto 0);<br>
begin<br>
  if reset_n = '0' then<br>
    cnt <= ( others <= '0');<br>
    cnt_next := ( others <= '0');<br>
  elsif sys_clk'event and sys_clk = '1' then<br>
    cnt_next := std_logic_vector(unsigned(cnt) + 1);<br>
    cnt <= cnt_next(31 downto 0);<br>
  end if;<br>
end process;<br>







