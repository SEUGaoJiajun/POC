----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/03/05 21:43:28
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is  --高层，三件例化
  Port (
      CLK : in STD_LOGIC;    
      MODE : in STD_LOGIC; 
      RESET : in STD_LOGIC;  
      CS : in STD_LOGIC     
   );
end Top;

architecture Behavioral of Top is

    component Processor is    -- 处理器组件
      Port (
            CLK : in STD_LOGIC;    
            DATAIN : buffer STD_LOGIC_VECTOR(7 downto 0);  
            DATAOUT : in STD_LOGIC_VECTOR(7 downto 0); 
            IRQ : in STD_LOGIC; 
            MODE : in STD_LOGIC; 
            RESET : in STD_LOGIC;  
            ADDRESS : buffer STD_LOGIC_VECTOR(15 downto 0); 
            RW : buffer STD_LOGIC 
       );
    end component;
    
    component POC is    -- POC组件
      Port (
          CS : in STD_LOGIC;                        
          ADDRESS : in STD_LOGIC_VECTOR(2 downto 0);  
          DATAIN : in STD_LOGIC_VECTOR(7 downto 0);  
          DATAOUT : buffer STD_LOGIC_VECTOR(7 downto 0);  
          RW : in STD_LOGIC;                         
          CLK : in STD_LOGIC;    
          RESET : in STD_LOGIC;  
          RDY : in STD_LOGIC;    
          IRQ : buffer STD_LOGIC;   
          TR : buffer STD_LOGIC;    
          PD : buffer STD_LOGIC_VECTOR(7 downto 0) 
      );
    end component;
    
    component Printer is    -- 打印机组件
      Port (
          CLK : in STD_LOGIC; 
          RESET : in STD_LOGIC; 
          TR : in STD_LOGIC; 
          PD : in STD_LOGIC_VECTOR(7 downto 0); 
          RDY : buffer STD_LOGIC    
       );
    end component;
    
    signal ADDRESS : STD_LOGIC_VECTOR(15 downto 0); 
    signal DATAIN : STD_LOGIC_VECTOR(7 downto 0);   
    signal DATAOUT : STD_LOGIC_VECTOR(7 downto 0);  
    signal RW : STD_LOGIC;                        
    signal IRQ : STD_LOGIC;                       
    signal RDY : STD_LOGIC;                      
    signal TR : STD_LOGIC;                        
    signal PD : STD_LOGIC_VECTOR(7 downto 0);    
    
begin

    comProcessor : Processor port map (CLK, DATAIN, DATAOUT, IRQ, MODE, RESET, ADDRESS, RW);
    
    comPOC : POC port map (CS, ADDRESS(2 downto 0), DATAIN, DATAOUT, RW, CLK, RESET, RDY, IRQ, TR, PD);  --实际上只利用ADDRESS后三位
    
    comPrinter : Printer port map (CLK, RESET, TR, PD, RDY);
    
end Behavioral;
