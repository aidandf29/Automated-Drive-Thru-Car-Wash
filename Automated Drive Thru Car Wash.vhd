-- This is a VHDL code by A4 Team
-- Automated Drive Thru Car Wash
-- A4
-- Bagus Nur Huda
-- Muh. Aidan Daffa
-- Muhammad Ilham Maulana
-- Tedi Setiawan

-- pada project Automated Drive Thru Car Wash akan diklasifikasikan menjadi 2 jenis mobil, yaitu besar dan kecil
-- harga untuk mobil besar adalah sebesar 40 koin
-- harga untuk kecil besar adalah sebesar 30 koin
-- jika memiliki member, maka akan terdapat pelayanan tambahan berupa isiBan


library ieee;											-- Deklarasi standart library IEEE
use ieee.std_logic_1164.all;

entity carwash_entity is								-- Deklarasi Port yang digunakan dalam proyek Automated Drive Thru Car Wash
    port(													-- Dengan nama Entity "carwash_entity"
        --Input											-- Berikut adalah port input yang digunakan pada proyek Automated Drive Thru Car Wash
        member, intUkuran, CLR, CLK	: IN STD_LOGIC;			-- Terdapat 4 input yang bertipe STD_LOGIC	
		koin : IN STD_LOGIC_VECTOR (1 downto 0);			-- Terdapat 1 input yang bertipe STD_LOGIC_VECTOR (0 = 00 , 10 = 01, 20 = 10, 50 = 11)
        --Output										-- Berikut adalah port output yang digunakan pada proyek Automated Drive Thru Car Wash
		MesinCuci, isiBan	: OUT STD_LOGIC;				-- Terdapat 2 input yang bertipe STD_LOGIC	
		Kembalian	: OUT STD_LOGIC_VECTOR (2 downto 0)			-- untuk output MesinCuci dan isiBan 1 = TRUE (dilaksanakan), 0 = false (tidak dilaksanakan)
        );													-- Terdapat 1 input yang bertipe STD_LOGIC_VECTOR 
end entity;														-- untuk output Kembalian (0 = 000 , 10 = 001, 20 = 010, 30 = 011, 40 = 100)


architecture carwash_architecture of carwash_entity is	-- Berikut adalah architecture dari entity carwash_entity

	type ST is (S0, S1, S2, S3, S4);					-- Deklarasi state yang akan digunakan dalan project ini yaitu 5
	type ukuran is (kecil, besar);						-- Deklarasi dari ukuran yang akan diklasifikasikan menjadi kecil dan besar
	signal PS,NS : ST;									-- Signal PS dan NS hanya bisa diisi oleh type ST
	signal mobil : ukuran;								-- Signal Mobil hanya bisa diisi oleh type ukuran

begin

SyncProc: process(CLK,NS,CLR)							-- Synchronous Process dengan CLK, NS, CLR sebagai parameternya
	begin
		if (CLR = '1') then PS <= S0;					-- Saat CLR bernilai 1 maka akan PS (Presens State) akan kembali ke state awal (S0) {fungsi Reset}
		elsif (rising_edge(CLK)) then PS <= NS;			-- Saat CLK High, PS akan bernilai NS
		end if;
	end process SyncProc;								-- Synchronous Process selesai

CombProc: process(PS,koin,mobil,member,intUkuran)		-- Combinatorial Process dengan PS, koin, mobil, member, untUkuran sebagai parameternya
	begin
	MesinCuci <= '0';									-- Mengembalikan value MesinCuci, kembalian, isiBan menjadi 0 (mereset output)
	Kembalian <= "000";
	isiBan <= '0';
	
	case intUkuran is									-- Case statement untuk menentukan value dari ukuran mobil
	when '0' =>											-- Saat input intUkuran = 0, maka mobil akan diklasifikasikan menjadi kecil
		mobil <= kecil;
	when others =>										-- Saat input intUkuran = 1, maka mobil akan diklasifikasikan menjadi besar
		mobil <= besar;
	end case;

	case PS is											-- Case statement untuk menentukan PS, MesinCuci, isiBan, kembalian
	when S0 =>											-- Saat PS = S0
		MesinCuci <= '0';									-- maka MesinCuci tidak akan dilaksanakan
		if (koin = "11") then 								-- pada state ini jika diberi input koin = 11 (50) 
			if (mobil = kecil) then 							-- lalu jika kondisi signal  mobil = kecil
			NS <= S3;											-- NS = S3
			Kembalian <= "010";									-- Kembalian = 010 (20)
			elsif (mobil = besar) then							-- lalu jika kondisi signal  mobil = besar
			NS <= S4;											-- NS = S4
			Kembalian <= "001";									-- Kembalian = 001 (10)
			else Kembalian <= "000";
			end if;
		elsif (koin = "10") then NS <= S2;					-- pada state ini jika diberi input koin = 10 (20), NS = S2
		elsif (koin = "01") then NS <= S1;					-- pada state ini jika diberi input koin = 01 (10), NS = S1
		else NS <= S0;
		end if;
	when S1 =>											-- Saat PS = S1
		MesinCuci <= '0';									-- maka MesinCuci tidak akan dilaksanakan
		if (koin = "11") then 								-- pada state ini jika diberi input koin = 11 (50) 
			if (mobil = kecil) then 							-- lalu jika kondisi signal  mobil = kecil
			NS <= S3;											-- NS = S3
			Kembalian <= "011";									-- Kembalian = 011 (30)
			elsif (mobil = besar) then							-- lalu jika kondisi signal  mobil = besar
			NS <= S4;											-- NS = S4
			Kembalian <= "010";									-- Kembalian = 010 (20)
			else Kembalian <= "000";
			end if;
		elsif (koin = "10") then NS <= S3;					-- pada state ini jika diberi input koin = 10 (20), NS = S3
		elsif (koin = "01") then NS <= S2;					-- pada state ini jika diberi input koin = 01 (10), NS = S2
		else NS <= S1;
		end if;
	when S2 =>											-- Saat PS = S2
		MesinCuci <= '0';									-- maka MesinCuci tidak akan dilaksanakan
		if (koin = "11") then 								-- pada state ini jika diberi input koin = 11 (50)
			if (mobil = kecil) then 							-- lalu jika kondisi signal  mobil = kecil
			NS <= S3;											-- NS = S3
			Kembalian <= "100";									-- Kembalian = 100 (40)
			elsif (mobil = besar) then							-- lalu jika kondisi signal  mobil = besar
			NS <= S4;											-- NS = S4
			Kembalian <= "011";									-- Kembalian = 011 (30)
			else Kembalian <= "000";
			end if;
		elsif (koin = "10") then 							-- pada state ini jika diberi input koin = 10 (20)
			if (mobil = kecil) then								-- lalu jika kondisi signal  mobil = kecil
			NS <= S3;											-- NS = S3
			Kembalian <= "001";									-- Kembalian = 001 (10)
			elsif (mobil = besar) then							-- lalu jika kondisi signal  mobil = besar
			NS <= S4;											-- NS = S4
			Kembalian <= "000";									-- Kembalian = 000 (00)
			end if;
		elsif (koin = "01") then NS <= S3;					-- pada state ini jika diberi input koin = 10 (20)
		else NS <= S2;											
		end if;										
	when S3 =>											-- Saat PS = S3
		if (mobil = kecil) then								-- lalu jika kondisi signal  mobil = kecil
			MesinCuci <= '1';									-- maka MesinCuci akan dilaksanakan
			if (member = '1') then								-- jika member = 1
				isiBan <= '1';									-- maka isiBan akan dilaksanakan
			else isiBan <= '0';									-- selain 1, maka isiBan tidak akan dilaksanakan
			end if;
			NS <= S0;											-- Kembalian = 001 (40)
		elsif(mobil = besar) then							-- lalu jika kondisi signal  mobil = besar
			MesinCuci <= '0';									-- maka MesinCuci tidak akan dilaksanakan
			if (koin = "11") then								-- pada state ini jika diberi input koin = 11 (50) 
				NS <= S4;											-- NS = S4
				Kembalian <= "100";									-- Kembalian = 100 (40)
			elsif (koin = "10") then							-- pada state ini jika diberi input koin = 10 (20) 
				NS <= S4;											-- NS = S4
				Kembalian <= "001";									-- Kembalian = 001 (40)
			elsif (koin = "01") then							-- pada state ini jika diberi input koin = 01 (10) 
				NS <= S4;											-- NS = S4
				Kembalian <= "000";									-- Kembalian = 000 (00)
			else NS <= S3;
			end if;
		else NS <= S3;
		end if;
	when S4 =>											-- Saat PS = S4
		MesinCuci <= '1';									-- maka MesinCuci akan dilaksanakan
		if (member = '1') then								-- jika member = 1
			isiBan <= '1';										-- maka isiBan akan dilaksanakan
		else isiBan <= '0';										-- selain 1, maka isiBan tidak akan dilaksanakan
		end if;
		NS <= S0;												-- NS = S0
	when others =>										-- Saat PS = selain S0, S1, S2, S3, S4
		MesinCuci <= '0';									-- maka MesinCuci tidak akan dilaksanakan
		NS <= S0;											-- NS = S0
	end case;

	end process CombProc;							-- Combinatorial Process selesai

end architecture;