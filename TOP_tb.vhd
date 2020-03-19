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
          CLK : in STD_LOGIC;    -- ����ʱ���ź�
          MODE : in STD_LOGIC; -- ������ʽѡ���ź�
          RESET : in STD_LOGIC;  -- ���ù�����ʽ�ź�
          CS : in STD_LOGIC     -- Ƭѡ�ź�
       );
    end component;
    
    signal CLK : STD_LOGIC := '0';
    signal MODE : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal CS : STD_LOGIC := '0';
    constant CLK_period :time   := 1 ms; --����ʱ������

begin
    uut : Top port map (CLK, MODE, RESET, CS);
    
    process  --ʱ���źŲ���
    begin 
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    process  --���������ź�
    begin
        CS <= '0';
        MODE <= '0';  --��ѡ��ѯ��ʽ
        RESET <= '0';
        
        wait for 2*CLK_period;
        RESET <= '1';
        CS <= '1';
        wait for 2*CLK_period;
        RESET <= '0';
        
        wait for 200*CLK_period;
        
        MODE <= '1';  --�Ļ��жϷ�ʽ 
        wait for 2*CLK_period;
        RESET <= '1';   --RESET��MODE�仯֮��
        wait for 2*CLK_period;
        RESET <= '0';
        
        wait for 200*CLK_period;
        
        wait;
    end process;

end Behavioral;

