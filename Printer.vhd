----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/03/05 21:42:29
-- Design Name: 
-- Module Name: Printer - Behavioral
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

entity Printer is
  Port (
      CLK : in STD_LOGIC; -- ʱ���ź�
      RESET : in STD_LOGIC; -- �����ź�
      TR : in STD_LOGIC; -- ���������ź�
      PD : in STD_LOGIC_VECTOR(7 downto 0); -- ��ӡ����
      RDY : buffer STD_LOGIC    -- ��ӡ��׼�����ź�
   );
end Printer;

architecture Behavioral of Printer is
    signal count:STD_LOGIC_VECTOR(7 downto 0):="00000000";
    signal en_print:STD_LOGIC := '0';
    signal slowCLK:STD_LOGIC := '0';
    
begin

   
    process(CLK)
        variable count:integer range 0 to 1:=0;  --һ���������������干ͬ����
    begin
     
      if CLK'event and CLK='1' then   --������
             if count =1 then
                 slowCLK<= not slowCLK;
                 count:=0;
            else
                 count := count + 1;
            end if;
        end if;
    end process;

    process(CLK, TR, RESET)
    begin
        if RESET'event and RESET = '1' then
            RDY <= '1';
        end if;
        if CLK'event and CLK = '0' then
            if TR = '1' then
                RDY <= '0';
                en_print <= '1';
            else
                RDY <= '1';
            end if;
            if en_print = '1' then
                if count = "00001001" then
                    RDY <= '1';
                    count <="00000000";
                    en_print <= '0';
                else
                    count <= count + 1;
                    RDY <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
