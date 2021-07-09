-- This is a TESTBENCH VHDL code by A4 Team
-- TESTBENCH of Automated Drive Thru Car Wash
-- A4
-- Bagus Nurhuda
-- Muh. Aidan Daffa
-- Muhammad Ilham Maulana
-- Tedi Setiawan

--Library
library ieee;										-- Deklarasi standart library IEEE
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Entity
entity carwash_ent_tb is
end entity;

--Architecture
architecture carwash_arch_tb of carwash_ent_tb is
	component carwash_entity is						-- Deklarasi Port yang digunakan dalam proyek Automated Drive Thru Car Wash
	port(
        --Input pada
        member, intUkuran, CLR, CLK	: IN STD_LOGIC;
		koin : IN STD_LOGIC_VECTOR (1 downto 0);
        --Output
		MesinCuci, isiBan	: OUT STD_LOGIC;
		Kembalian	: OUT STD_LOGIC_VECTOR (2 downto 0)		
     );	
	end component;
	
	signal member, intUkuran, CLR, CLK, MesinCuci, isiBan : STD_LOGIC;
	signal koin : STD_LOGIC_VECTOR (1 downto 0);
	signal Kembalian	: STD_LOGIC_VECTOR (2 downto 0)	;
	signal i : integer := 0;         
	
begin
	-- menghubungkan signal testbench dengan Automated Drive Thru Car Wash port (port mapping)
	UUT : carwash_entity port map(member,intUkuran,CLR,CLK,koin,MesinCuci,isiBan,Kembalian);
	
tb1:process 

	--mengatur clock dan jumlah clock maksumum
	constant T:time:= 20 ns;
	constant max_clk : integer := 4;
	--membuat suatu tipe data yang berjenis array yang berisikan array juga di dalamnya
	type intkoin is array (0 to 3) of STD_LOGIC_VECTOR (1 downto 0);
	type cek_kembalian is array (0 to 4) of STD_LOGIC_VECTOR (2 downto 0);
	--membuat look up table
	constant stream_koin : intkoin := ( 0=>"01", 1=>"01", 2=>"10", 3=>"11");
	constant stream_mobil : STD_LOGIC_VECTOR(0 to 3) := "0010";
	constant stream_opt : STD_LOGIC_VECTOR(0 to 4) := "00011";
	constant stream_kembalian : cek_kembalian := ( 0=>"000", 1=>"000", 2=>"000", 3=>"000", 4=>"010");
	constant stream_isiBan : std_logic_vector(0 to 4) := ("00011");
	
	begin
	CLK <='0';				-- mengeset CLK menjadi 0
	CLR <='0';				-- mengeset CLR menjadi 0
	
	wait for T/2;			-- setelah 10ns
	CLK <='1';				-- maka clock akan naik menjadi 1
	wait for T/2;			-- setelah 10ns
	
	
	if(i < max_clk) then i <= i+1;			-- membatasi looping sebanyak max_clk, yaitu 4
		if (i > 1) then member <= '1';		-- jika i > 1, maka member = 1. karena pada percobaan setelah 1, adalah percobaan dengan member = 1
		end if;
		intUkuran <= stream_mobil(i);		--memasukkan nilai yang ada di dalam look up table stream_mobil ke dalam intUkuran sesuai iterasi
		koin <= stream_koin(i);				--memasukkan nilai yang ada di dalam look up table stream_koin ke dalam koin sesuai iterasi
		else wait;
	end if;
	
	-- statement untuk menyesuaikan kondisi pada parameter yang dibandingkan
	assert((MesinCuci = stream_opt(i)) and (Kembalian = stream_kembalian(i)) and (isiBan = stream_isiBan(i)))
	
	--severity ini berfungsi untuk menyampaikan suatu kondisi dimana jika ada parameter pada rangkaian yang tidak sesuai dengan seharusnya.
	-- jika ada yang tidak sesuai maka akan terdapat feedback atau report berupa :
	report "testbench projek fail pada loop ke-" & integer'image(i) severity error;
	end process;
end architecture;