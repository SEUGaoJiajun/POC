----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/03/05 21:39:57
-- Design Name: 
-- Module Name: POC - Behavioral
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

entity POC is    
  Port (
      CS : in STD_LOGIC;                        
      ADDRESS : in STD_LOGIC_VECTOR(2 downto 0);  
      DATAIN : in STD_LOGIC_VECTOR(7 downto 0);   
      RW : in STD_LOGIC;                         
      CLK : in STD_LOGIC;    
      RESET : in STD_LOGIC;  
      RDY : in STD_LOGIC;    
      DATAOUT : buffer STD_LOGIC_VECTOR(7 downto 0); 
      IRQ : buffer STD_LOGIC;   
      TR : buffer STD_LOGIC;    
      PD : buffer STD_LOGIC_VECTOR(7 downto 0) 
  );
end POC;
architecture Behavioral of POC is
    signal SR : STD_LOGIC_VECTOR(7 downto 0) := "00000000";  -- 状态寄存器
    signal BR : STD_LOGIC_VECTOR(7 downto 0) := "00000000";  -- 缓冲寄存器
begin
    process(CLK, RESET, CS)
    begin
        if RESET'event and RESET = '1' then
            SR <= "00000000";    
            BR <= "00000000";
            DATAOUT <= "00000000";
            IRQ <= '1';
            TR <= '0';
            PD <= "00000000";
        end if;
        if CS = '1'then
            if CLK'event and CLK = '1' then
                IRQ <= '1';  
                TR <= '0';   
                if ADDRESS = "0000000000000000" and RW = '1' then  -- 写SR
                    SR <= DATAIN;
                end if;
                if ADDRESS = "0000000000000000" and RW = '0' then  -- 读SR
                    DATAOUT <= SR;
                end if;
                if ADDRESS = "0000000000000001" and RW = '1' then  -- 写BR
                    BR <= DATAIN;
                    SR(7) <= '0';  -- 置SR7为0，代表POC在处理数据
                    DATAOUT <= SR;
                end if;
                if ADDRESS = "0000000000000001" and RW = '0' then  -- 读BR
                    DATAOUT <= BR;
                end if;
                if SR(7) = '0' then    -- 向打印机传数据
                    if RDY = '1' then  -- 打印机是否准备好
                        PD <= BR;      -- 传数据
                        TR <= '1';     -- 脉冲产生
                        SR(7) <= '1';  -- POC准备好
                        DATAOUT <= SR;
                    end if;
                end if;
                if RDY = '0' then
                    TR <= '0';
                end if;
                if SR(7) = '1' and SR(0) = '1' then  -- 第一位和最后一位均为1产生中断信号
                    IRQ <= '0';
                end if;
            end if;
            
--            if CLK'event and CLK = '0' then
--                if RDY = '0' then
--                    TR <= '0';
--                end if;
--            end if;
            
        end if;
    end process;
    

end Behavioral;

