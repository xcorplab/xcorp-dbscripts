ALTER TABLE CidadeTestePK ADD [seq1] [bigint]
GO

UPDATE CidadeTestePK SET seq1 = IdCidade
GO

ALTER TABLE CidadeTestePK DROP COLUMN [seq1]
GO