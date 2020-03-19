----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/03/05 21:45:07
-- Design Name: 
-- Module Name: TOP_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TOP_tb is
--  Port ( );
end TOP_tb;

architecture Behavioral of TOP_tb is
    component Top is
      Port (
          CLK : in STD_LOGIC;    -- 输入时钟信号
          MODE : in STD_LOGIC; -- 工作方式选择信号
          RESET : in STD_LOGIC;  -- 重置工作方式信号
          CS : in STD_LOGIC     -- 片选信号
       );
    end component;
    
    signal CLK : STD_LOGIC := '0';
    signal MODE : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal CS : STD_LOGIC := '0';
    constant CLK_period :time   := 1 ms; --定义时钟周期

begin
    uut : Top port map (CLK, MODE, RESET, CS);
    
    process  --时钟信号产生
    begin 
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process  --产生测试信号
    begin
        CS <= '0';
        MODE <= '0';  --首选轮询方式
        RESET <= '0';
        
        wait for 2*CLK_period;
        RESET <= '1';
        CS <= '1';
        wait for 2*CLK_period;
        RESET <= '0';
        
        wait for 200*CLK_period;
        
        MODE <= '1';  --改换中断方式 
        wait for 2*CLK_period;
        RESET <= '1';   --RESET在MODE变化之后
        wait for 2*CLK_period;
        RESET <= '0';
        
        wait for 200*CLK_period;
        
        wait;
    end process;

end Behavioral;

