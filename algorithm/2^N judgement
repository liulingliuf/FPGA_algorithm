问题：判断一个数a是否为2的整数幂.

思路1：当然是对于二进制数，这个问题可以转化为此std_logic_vector中是否仅有一个1的问题，通过计数判断的方式
缺点：这样做逻辑比较复杂，延时也较长，


思路2：a&（a - 1）， 

process(sys_clk, reset_n)
  if reset_n = '0' then
     result_sig <= '0'
  elseif sys_clk'event and sys_clk = '1' then
     if ( a_signal & std_logic_vector( unsigned(a) - 1 )) then 
       result_sig <= false;
     else
       result_sig <= true;
     end if;
   end if;
end process;


例：01 000 000 &（01 000 000 - 00 000 001），如果该数仅有一个1，那么结果为0，如果不为1个1，那么结果为1，这样仅需要一个减法和求与逻辑即可解决这个问题，2拍足够完成。
