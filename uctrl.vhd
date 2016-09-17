----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:59 09/17/2016 
-- Design Name: 
-- Module Name:    uctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uctrl is
    Port ( 
			  reset: in std_logic;
			  clk : in  STD_LOGIC;
           do_nop : in  STD_LOGIC;
           do_sta : in  STD_LOGIC;
           do_lda : in  STD_LOGIC;
           do_add : in  STD_LOGIC;
           do_or : in  STD_LOGIC;
           do_and : in  STD_LOGIC;
           do_not : in  STD_LOGIC;
           do_jmp : in  STD_LOGIC;
           do_jn : in  STD_LOGIC;
           do_jz : in  STD_LOGIC;
           do_mul : in  STD_LOGIC;
           do_inc : in  STD_LOGIC;
           do_hlt : in  STD_LOGIC;
           sinal_N : in  STD_LOGIC;
           sinal_Z : in  STD_LOGIC;
			  cargaAC: out std_logic;
			  selUAL: out std_logic_vector (2 downto 0);
			  cargaPC: out std_logic;
			  incrementaPC: out std_logic;
			  cargaNZ: out std_logic;
			  sel: out std_logic;
			  cargaRI: out std_logic;
			  cargaREM: out std_logic;
			  do_read: out std_logic;
			  do_write: out std_logic;
			  cargaRDM: out std_logic
			  );
end uctrl;

architecture Behavioral of uctrl is

type t_state is (fetch1,fetch2,fetch3,fetch4,sta1,lda1,add1,or1,and1,not1,jmp1,jn1,jz1,mul1,inc1,hlt1);
signal estado: t_state;
signal out_decoder: std_logic_vector(12 downto 0);
signal saidas: std_logic_vector(12 downto 0);

begin

out_decoder<= do_nop & do_sta & do_lda & do_add & do_or & do_and & do_not & do_jmp & do_jn & do_jz & do_mul & do_inc & do_hlt;
-- Legenda----------------------------------------------------------------------------------------------------------------
--		  |  12	 |11downto9|    8    |      7       |    6    |  5  |     4   |     3    |    2    |     1    |    0
saidas<=cargaAC &  selUAL & cargaPC & incrementaPC & cargaNZ & sel & cargaRI & cargaREM & do_read & do_write & cargaRDM;

process(clk, reset)
begin
	if(reset='1')then
		estado<=fetch1;
	elsif(rising_edge(clk))then
		case estado is
			when fetch1 => estado<=fetch2;
			when fetch2 => estado<=fetch3;
			when fetch3 => estado<=fetch4;
			when fetch4 =>
				case out_decoder is
					when 1 =>		estado<=hlt1;
					when 2 =>		estado<=inc1;
					when 4 =>		estado<=mul1;
					when 8 =>		estado<=jz1;
					when 16 =>		estado<=jn1;
					when 32 =>		estado<=jmp1;
					when 64 =>		estado<=not1;
					when 128 =>		estado<=and1;
					when 256 =>		estado<=or1;
					when 512 =>		estado<=add1;
					when 1024 =>	estado<=lda1;
					when 2048 =>	estado<=sta1;
					when 4096 =>	estado<=fetch1;				
					when others => estado<=estado;
				end case;
			when others =>
		end case;
	end if;
end process;
process(estado)
begin
--AVISO: feio adiante!
	case estado is
		when fetch1 =>	saida<=(3=>'1',others=>'0'); --liga cargaREM
		when fetch2 =>	saida<=(2=>'1',others=>'0'); --liga do_read
		when fetch3 =>	saida<=(0=>'1',others=>'0'); --liga cargaRDM
		when fetch4 =>	saida<=(4=>'1',others=>'0'); --liga cargaRI
		when others => cargaAC<='0'; cargaPC<='0'; incrementaPC<='0'; cargaNZ<='0'; 
							cargaRI<='0'; cargaREM<='0'; do_read<='0'; do_write<='0'; cargaRDM<='0';
	end case;
end process;

end Behavioral;
