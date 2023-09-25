
go
declare @j nvarchar(max) = '{
	"id" : 1,
	"colore" : "verde",
	"animali" :  [
		{
			"nome" : "birillo",
			"specie" : "gatto"
		},
		{
			"nome" : "azzurro",
			"specie" : "pesce"
		}
	]
}'

 

-- idJson, colore, AnimaleNome, AnimaleSpecie

 

select @j, isjson(@j), 
	JSON_VALUE(@j, '$.colore' ) as Colore,
	JSON_QUERY(@j, '$.animali') as animali,
	Animali1Nome = JSON_VALUE(@j, '$.animali[0].nome')

 

SELECT *
FROM openjson(@j)

 



 

--create table its.JSON (
--	id int identity(1,1),
--	j varchar(max)
--)
;
go
 

alter table its.json
	alter column j nvarchar(max) not null

 

insert into its.json values
(@j)

 

-- JOIN

 

--create view its.animali as
SELECT 
	ID = JSON_VALUE(j, '$.id')
	,COLORE = JSON_VALUE(j, '$.colore')
	,ANIMALENOME = JSON_VALUE(A.value, '$.nome')
	,ANIMALESPECIE = JSON_VALUE(A.value, '$.specie')
FROM its.json
	cross apply OPENJSON(J, '$.animali') A
;
go
 

 

declare @j nvarchar(max)= '{
	"id" : 3,
	"colore" : "blu",
	"animali" :  [
		{
			"nome" : "spillo",
			"specie" : "criceto"
		},
		{
			"nome" : "azzurro",
			"specie" : "inseparabili"
		}
	]
}'

 

insert into its.JSON values (@j)

 

select * from its.animali

 

 

select * from its.json

 

update its.JSON 
set j = JSON_MODIFY(j , 'strict $.animali[1].specie' , 'pappagallo' )
where id = 3
;
go

--alter procedure its.sp_insertJson 
--@colore varchar(20),
--@animaleNome   varchar(20) = NULL,
--@animaleSpecie varchar(20) = NULL
--as
--IF (@colore is null)
--BEGIN
--    raiserror('Il parametro @colore non può essere NULL', -1, -1, 'sp_insertJson')
--END
--ELSE
--BEGIN    
--declare @id int = (select max(id) + 1 from its.JSON )
--    declare @j nvarchar(max), @jAnimali nvarchar(max)
--    set @jAnimali =
--         JSON_MODIFY(
--            JSON_MODIFY('{}', '$.nome', @animaleNome),
--            '$.specie',
--            @animaleSpecie
--            )    
--set @j = JSON_MODIFY('{}', '$.id', @id)
--set @j = JSON_MODIFY(
--                JSON_MODIFY(@j , '$.colore', @colore),
--                'append $.animali',
--                json_query(@jAnimali)
--                )
--insert into its.json values (@j)
--print 'registrazione json andata a buon fine

--per verifica:
--	SELECT TOP 100 *
--	FROM its.json
--	ORDER BY id desc'
--END
;
go

--exec its.sp_insertJson @colore='giallo',@animaleNome='pollo', @animaleSpecie='gatto'

alter procedure its.sp_insertJson 
@colore varchar(20)

as
IF (@colore is null)
BEGIN
    raiserror('Il parametro @colore non può essere NULL', -1, -1, 'sp_insertJson')
END
ELSE
BEGIN    
declare @id int = (select max(id) + 1 from its.JSON )
    declare @j nvarchar(max)
      
set @j = JSON_MODIFY('{}', '$.id', @id)
set @j = JSON_MODIFY(@j , '$.colore', @colore)

insert into its.json values (@j)

print 'registrazione json andata a buon fine

per verifica:
	SELECT TOP 100 *
	FROM its.json
	ORDER BY id desc'
END
;
go



