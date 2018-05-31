--Name:counter vhdl&verilog coding
--Source:www.fpga4fun.com/Counters1.html

--Binary counter
--1.0 the fast and efficient
---------------vhdl---------------
signal counter:  std_logic_vector(31 downto 0);
process(clk,reset_n)
begin
  if reset_n = '0' then
    counter <= ( others => '0');
  elsif sys_clk'event and sys_clk = '1' then
    counter <= counter + 1;
  end if;
end process;
-----------------------------------
---------------verilog---------------
reg [31:0] counter;
always @(posedge sys_clk) counter <= counter + 1;
-----------------------------------
--end of 1.0

-2.0
--without initial value, simulation tool will refuse to work or synthesis tool set the initial value on their own.
---------------verilog---------------
reg [31:0] counter = 0;
always @(posedge sys_clk) counter <= counter + 1;
-----------------------------------
--end of 2.0

--3.0
--requirement: start with special value and has enable and direction control.
--flip-flops inside and FPGA always start at 0, so the you could think the counter initial value should HAS TO be 0.
--But by putting some well_placed inverts in the logic, any starting value is possible.
--NOTE: Inverters are free in an FPGA, so there is no drawback.
---------------verilog---------------
reg [9:0] counter = 10d'd300;
wire cnt_enable;
wire cnt_direction;
always @(posedge sys_clk)
  if (cnt_enable)
    counter <= cnt_direction ? counter + 2 :counter - 1;
---------------------------------------
---------------VHDL---------------
signal counter: std_logic_vector(9 downto 0);
signal cnt_enable: std_logic;
signal cnt_direction: std_logic;
process(sys_clk, reset_n)
begin
  if reset_n = '0' then
    counter <= std_logic_vector(300);
  elsif sys_clk'event and sys_clk ='1' then
     if cnt_enable = '1' then
       case (cnt_direction) is
       when '1' =>
         counter <= counter + 1;
       when '0' => d
         counter <= counter - 1;
       end case;
     else
       counter <= counter;
     end if;
  end if;
end process;

--4.0 counter tick
--tick signal that is assert once very 1024 clock. Need a 10 bits counter and logic to generate the tick.
-------------verilog----------------
reg [9:0] cnt = '0';
always @(posedge clk) counter <= counter + 1;
wire tick = ( counter == 1023);
-------------------------------------
--drawback: this create a big chunk of logic (10 bit AND gate here).
--alternate way is to relay on the carry chain that FPGAd is using behind the scene.
--we just need a bit of arm twisting to convince the FPGA to provide the info.
-----------------verilog--------------
reg [31:0] cnt = 0;
wire [32:0] cnt_next = cnt + 1;
always @(posedge sys_clk ) cnt <= cnt_next[31:0];
wire tick = cnt_next[32];
---------------------------------------
-----------------vhdl------------------
signal cnt: std_logic_vector(31 downto 0);
signal cnt_next: std_logic_vector(32 downto 0);
process(sys_clk, reset_n)
begin
  if reset_n = '0' then
    cnt <= ( others <= '0');
    cnt_next <= ( others <= '0');
  elsif sys_clk'event and sys_clk = '1' then
    cnt_next <= std_logic_vector(unsigned(cnt) + 1);
    cnt <= cnt_next(31 downto 0);
  end if;
end process;
--------------------or-----------------
signal cnt: std_logic_vector(31 downto 0);
process(sys_clk, reset_n)
variable cnt_next: std_logic_vector(32 downto 0);
begin
  if reset_n = '0' then
    cnt <= ( others <= '0');
    cnt_next := ( others <= '0');
  elsif sys_clk'event and sys_clk = '1' then
    cnt_next := std_logic_vector(unsigned(cnt) + 1);
    cnt <= cnt_next(31 downto 0);
  end if;
end process;
