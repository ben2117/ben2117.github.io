A problem I come accross reguarly is grouping entries in a table. This is a logical group for example group a products 
by model type and not an aggregate function so should not be confused with the group by method. partition by is an 
appropriate solution as shown below. 

```sql
declare @cartable table( make CHAR(50), model CHAR(50) , carYear char(4), carTrim char(200) )

insert into @cartable
values 
 ('BMW',        '3 Series',	    '1990',	'325i 2dr Convertible')
,('BMW',        '3 Series',	    '1990',	'325i 4dr Sedan')
,('BMW',        '3 Series',	    '1990',	'325iX 4dr Sedan AWD')
,('BMW',        '3 Series',	    '1990',	'325is 2dr Coupe')
,('BMW',        '3 Series',	    '1990',	'325i 2dr Coupe')
,('BMW',        '3 Series',	    '1990',	'325iX 2dr Coupe AWD')
,('BMW',        '3 Series',	    '1990',	'M3 2dr Coupe')
,('Ford',	    'F-150',	    '1995',	'Special 2dr Regular Cab 4WD SB (4.9L 6cyl naturally aspired 5M)')
,('Ford',	    'F-150',	    '1995',	'Special 2dr Regular Cab 4WD LB (4.9L 6cyl naturally aspired 5M)')
,('Ford',	    'F-150',	    '1995',	'Special 2dr Regular Cab LB (4.9L 6cyl naturally aspired 5M)')
,('Ford',	    'F-150',	    '1995',	'Special 2dr Regular Cab SB (4.9L 6cyl naturally aspired 5M)')
,('Ford',	    'F-150',	    '1995',	'Eddie Bauer 2dr Regular Cab 4WD SB (4.9L 6cyl naturally aspired 5M)')
,('Toyota',	    'Prius',	    '2018',	'One 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)')
,('Toyota',	    'Prius',	    '2018',	'Two 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)')
,('Toyota',	    'Prius',	    '2018',	'Two Eco 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)')
,('Toyota',	    'Prius',	    '2018',	'Three 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)')
,('Toyota',	    'Prius',	    '2018',	'Three Touring 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)')

select 
 dense_rank() over ( order by make, model ) as partitionid
, row_number() over ( partition by make, model order by carYear)
, *
from @cartable

```

|partitionid||make|model|carYear|carTrim|
|-----------||----|-----|-------|-------|
|2|3|Ford                                              |F-150                                             |1995|Special 2dr Regular Cab LB (4.9L 6cyl naturally aspired 5M)                                                                                                                                             |
|2|4|Ford                                              |F-150                                             |1995|Special 2dr Regular Cab SB (4.9L 6cyl naturally aspired 5M)                                                                                                                                             |
|2|5|Ford                                              |F-150                                             |1995|Eddie Bauer 2dr Regular Cab 4WD SB (4.9L 6cyl naturally aspired 5M)                                                                                                                                     |
|3|1|Toyota                                            |Prius                                             |2018|One 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)                                                                                                                                                   |
|3|2|Toyota                                            |Prius                                             |2018|Two 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)                                                                                                                                                   |
|3|3|Toyota                                            |Prius                                             |2018|Two Eco 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)                                                                                                                                               |
|3|4|Toyota                                            |Prius                                             |2018|Three 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)                                                                                                                                                 |
|3|5|Toyota                                            |Prius                                             |2018|Three Touring 4dr Hatchback (1.8L 4cyl gas/electric hybrid CVT)                                                                                                                                         |
