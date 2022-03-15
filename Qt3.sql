-- Qt 3.1
-- compradores de 01/2020, UF = CE
-- tem que ter ID pessoa, Nome Pessoa, Data Ref de Venda, Valor de Venda
SELECT 
	*
FROM (	
	SELECT
		`fv`.`ID_PESSOA` as `ID da Pessoa`,
		`ps`.`NM_PESSOA` as `Nome da Pessoa`,
		`dt`.`DT_REF` as `Data Ref Venda`,
		`fv`.`VL_VENDA`	as `Valor de Venda`
	FROM (
		SELECT
			`ID_VENDA`,
			`ID_PESSOA`,
			`VL_VENDA`,
			`ID_TEMPO`,
			`ID_LOJA`
		FROM `f_Vendas`
	) `fv`
	JOIN (
		SELECT `ID_LOJA` FROM `d_Loja` WHERE `DS_UF` = 'CE'
		) `dl` ON `fv`.`ID_LOJA` = `dl`.`ID_LOJA`
	JOIN (
		SELECT 
			`ID_TEMPO`, `NU_MES`, `NU_ANO`, `DT_RED`
		FROM `d_Tempo`
		WHERE `NU_MES` = 1 AND `NU_ANO` = 2020
		) `dt` ON `fv`.`ID_TEMPO` = `dt`.`ID_TEMPO`
	JOIN (
		SELECT `ID_PESSOA`, `NM_PESSOA` FROM `d_Pessoas`
		) `ps` ON `fv`.`ID_PESSOA` = `ps`.`ID_PESSOA`
) `qr`
ORDER BY `qr`.`Data Red Venda` DESC

-- Qt 3.2
-- Qtd de compras em Março por pessoa
-- ID da pessoa, Qtd de compras

SELECT
	`qr`.`ID_PESSOA` AS `ID da Pessoa`,
	COUNT(`qr`.`ID_VENDA`) AS `Qtd de Compras`
FROM (
	SELECT
		`fv`.`ID_PESSOA`,
		`fv`.`ID_VENDA`
	FROM (
		SELECT 
			`ID_VENDA`,
			`ID_PESSOA`
		FROM `f_Vendas`
		) `fv`
	JOIN (
		SELECT 
			`ID_TEMPO`, `NU_MES`, `NU_ANO`
		FROM `d_Tempo`
		WHERE `NU_MES` = 3 AND `NU_ANO` = 2020
		) `dt` ON `fv`.`ID_TEMPO` = `dt`.`ID_TEMPO`
	JOIN (
		SELECT `ID_PESSOA`, `NM_PESSOA` FROM `d_Pessoas`
		) `ps` ON `fv`.`ID_PESSOA` = `ps`.`ID_PESSOA`
) `qr`
GROUP BY `qr`.`ID_PESSOA`
ORDER BY `Qtd de Compras` DESC

-- Qt 3.3
-- clientes que não compraram em 03/2020
SELECT
	`fv`.`ID_PESSOA`
FROM (
	SELECT 
		`ID_VENDA`,
		`ID_PESSOA`
	FROM `f_Vendas`
	) `fv`
JOIN (
	SELECT 
		`ID_TEMPO`, `NU_MES`, `NU_ANO`
	FROM `d_Tempo`
	WHERE `NU_MES` = 3 AND `NU_ANO` = 2020
	) `dt` ON `fv`.`ID_TEMPO` = `dt`.`ID_TEMPO`
LEFT JOIN (
	SELECT `ID_PESSOA`, `NM_PESSOA` FROM `d_Pessoas`
	) `ps` ON `fv`.`ID_PESSOA` = `ps`.`ID_PESSOA`
WHERE `ps`.`ID_PESSOA` IS NULL

-- Qt 3.4
-- última compra por cliente.
SELECT 
	`qr`.`ID_PESSOA` AS `ID da Pessoa`,
	MAX(`qr`.`DT_REF`) AS `Data Ultima Compra`
FROM (	
	SELECT
		`fv`.`ID_PESSOA`,
		`dt`.`DT_REF`
	FROM (
		SELECT
			`ID_VENDA`,
			`ID_PESSOA`,
			`ID_TEMPO`
		FROM `f_Vendas`
	) `fv`
	JOIN (
		SELECT 
			`ID_TEMPO`, `DT_RED`
		FROM `d_Tempo`
		) `dt` ON `fv`.`ID_TEMPO` = `dt`.`ID_TEMPO`
) `qr`
GROUP BY `qr`.`ID_PESSOA`