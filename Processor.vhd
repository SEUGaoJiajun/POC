----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/03/05 21:31:02
-- Design Name: 
-- Module Name: Processor - Behavioral
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

entity Processor is
  Port (
          CLK : in STD_LOGIC;    
          DATAOUT : in STD_LOGIC_VECTOR(7 downto 0); 
          IRQ : in STD_LOGIC; 
          MODE : in STD_LOGIC; 
          RESET : in STD_LOGIC;  
          ADDRESS : buffer STD_LOGIC_VECTOR(15 downto 0); 
          DATAIN : buffer STD_LOGIC_VECTOR(7 downto 0);  
          RW : buffer STD_LOGIC 
   );
end Processor;

architecture Behavioral of Processor is
    signal data : std_logic_vector(7 downto 0) := "00000000";  --要传的数据，此例依次增一检验
    signal askflag : std_logic :='0';  --轮询下写数据flag
    signal irqflag : std_logic :='0';  --中断下写数据flag
begin
    process(CLK, RESET, MODE, IRQ)
    begin
        if RESET'event and RESET = '1'then
            ADDRESS <= "0000000000000000"; 
            DATAIN <= "00000000";
            RW <= '0';
            if MODE = '0' then -- 轮询
                ADDRESS <= "0000000000000000"; 
                DATAIN <= "10000000";  --中断位禁用
                RW <= '1';  
            end if;
            if MODE = '1' then -- 中断
                ADDRESS <= "0000000000000000"; 
                DATAIN <= "10000001";  --中断位使能
                RW <= '1';  
            end if;
        end if;
        

        if MODE = '1' then     --中断不依赖时钟，1次操作增1次，保序
            if IRQ = '1' then  
                irqflag<='1';

            else  
                if irqflag='1' then
                    ADDRESS <= "0000000000000001";  
                    RW <= '1';  
                    DATAIN <= data;  
                    data <= data + 1;
                    irqflag<='0';
                end if;          
        end if;
        
        end if;
 
        
        if CLK'event and CLK = '1' then     --轮询依赖时钟
            ADDRESS <= "0000000000000000";  
            RW <= '0';         
            if MODE = '0' then  
--                 irqflag<='1';
                if DATAOUT = "10000000" and askflag='0' then -- POC向Processor报告可写
                    ADDRESS <= "0000000000000001";  
                    RW <= '1';  
                    DATAIN <= data; 
                    askflag <='1';
                end if;
                
                if DATAOUT = "10000000" and askflag='1' then -- 第二次不允许
                    ADDRESS <= "0000000000000001";  
                    RW <= '1';  
                    DATAIN <= data;  
                end if;
                
                 if DATAOUT = "00000000" and askflag='1' then -- POC向Processor报告不可写
                     data<=data+1;
                     askflag<='0';
                end if;
                
--            else  
--               if irqflag='1' then
--                   ADDRESSESSESS <= "0000000000000001";  
--                   RW <= '1';  
--                   DATAIN <= data;  -- 对POC写数据
--                   data <= data + 1;
--                   irqflag<='0';
--                end if;

                
            end if;
            
         end if;
        
    end process;

end Behavioral;

