create view VW_FRAGE_1 as
    select c.CODE, c.name, count(*) as anzahl
    from TBL_QUERYDATA_COUNTRIES qc
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    group by c.CODE, c.NAME
    order by anzahl desc;


create view VW_FRAGE_2 as
    select c.CODE, c.NAME, count(*) as anzahl
    from VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    group by c.CODE, c.NAME
    order by anzahl desc;

create view VW_FRAGE_3 as
    select t.CODE, t.NAME, (o.anzahl - t.anzahl) as differenz
    from VW_FRAGE_1 o
    inner join VW_FRAGE_2 t on o.CODE = t.CODE
    order by differenz desc;

create view VW_FRAGE_4 as
    select c.name, extract(MONTH from q.QUERYTIME) as monat, count(*) as anzahl
    from VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    inner join AOLDATA.QUERYDATA q on q.ID = qc.QUERY_ID
    group by c.NAME, extract(MONTH from q.QUERYTIME)
    order by name, monat;

create view VW_FRAGE_11 as
    select c.name, extract(MONTH from q.QUERYTIME) as monat, extract(DAY from q.QUERYTIME) as tag, count(*) as anzahl
    from VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    inner join AOLDATA.QUERYDATA q on q.ID = qc.QUERY_ID
    group by c.NAME, extract(MONTH from q.QUERYTIME), extract(DAY from q.QUERYTIME)
    order by name, monat;

create view VW_FRAGE_5_0 as
    select l.name, c.name as staat, l.COUNT as anzahl
    from VW_TOP_LEADERS_WHOLE_WORDS l
    inner join TBL_COUNTRIES c on l.COUNTRY_CODE = c.CODE
    order by count desc;

create view VW_FRAGE_5 as
    select * from VW_FRAGE_5_0 where ROWNUM <= 30;

create view VW_FRAGE_6 as
    select c.name, kc.anzahl
    from VW_KEYWORDS_COUNTRIES kc
    inner join TBL_COUNTRIES c on c.CODE = kc.COUNTRY_CODE
    inner join TBL_KEYWORD k on k.ID = kc.KEYWORD_ID
    where k.WORD = 'PEACE'
    order by kc.ANZAHL desc;

create view VW_FRAGE_7_0 as
    select c.name, kc.anzahl
    from VW_KEYWORDS_COUNTRIES kc
    inner join TBL_COUNTRIES c on c.CODE = kc.COUNTRY_CODE
    inner join TBL_KEYWORD k on k.ID = kc.KEYWORD_ID
    where k.WORD = 'WAR'
    order by kc.ANZAHL desc;

create view VW_FRAGE_7_1 as
    select *
    from VW_FRAGE_7_0
    where ROWNUM <=30;

create view VW_FRAGE_7_2 as
    select 'Andere' as name, sum(anzahl) as anzahl
    from VW_FRAGE_7_0
    where name not in (select name from VW_FRAGE_7_1);

create view VW_FRAGE_7 as
    select 'Gesamt' as Name, count(*) as anzahl
    from VW_QUERYDATA_KEYWORDS_WHOLE_WORDS kc
    inner join TBL_KEYWORD k on k.ID = kc.KEYWORD_ID
    where k.WORD = 'WAR'
    union all
    select * from VW_FRAGE_7_1
    union all
    select * from VW_FRAGE_7_2;

create view VW_FRAGE_8 as
    select k.WORD, c.name ,extract(MONTH from q.QUERYTIME) as monat, count(*) as anzahl
    from VW_QUERYDATA_KEYWORDS_WHOLE_WORDS kq
    inner join AOLDATA.QUERYDATA q on kq.QUERY_ID = q.ID
    inner join VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc on q.ID = qc.QUERY_ID
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    inner join TBL_KEYWORD k on k.ID = kq.KEYWORD_ID
    where k.WORD = 'WAR'
    group by k.WORD, c.name, extract(MONTH from q.QUERYTIME)
    having extract(MONTH from q.QUERYTIME) > 2
    order by k.WORD, c.name, monat;

create view VW_FRAGE_12 as
    select k.WORD, c.name, extract(MONTH from q.QUERYTIME) as monat, extract(DAY from q.QUERYTIME) as tag, count(*) as anzahl
    from VW_QUERYDATA_KEYWORDS_WHOLE_WORDS kq
    inner join AOLDATA.QUERYDATA q on kq.QUERY_ID = q.ID
    inner join VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc on q.ID = qc.QUERY_ID
    inner join TBL_COUNTRIES c on c.CODE = qc.COUNTRY_CODE
    inner join TBL_KEYWORD k on k.ID = kq.KEYWORD_ID
    where k.WORD = 'WAR'
    group by k.WORD, c.name, extract(MONTH from q.QUERYTIME), extract(DAY from q.QUERYTIME)
    having extract(MONTH from q.QUERYTIME) > 2
    order by k.WORD, c.name, monat;

create view VW_FRAGE_9_1 as
    select  c.name, ANONID, COUNT(*) as anzahl
    from VW_QUERYDATA_COUNTRIES_WHOLE_WORDS t
    inner join AOLDATA.QUERYDATA q on t.QUERY_ID = q.ID
    inner join TBL_COUNTRIES c on t.COUNTRY_CODE = c.CODE
    group by c.name, ANONID
    order by anzahl desc;

create view VW_FRAGE_9 as
    select *
    from VW_FRAGE_9_1
    where ROWNUM <= 20;


create view VW_FRAGE_10_1 as
    select l.name, COUNT(*) as anzahl, ANONID
    from VW_QUERYDATA_LEADERS_WHOLE_WORDS t
    inner join AOLDATA.QUERYDATA q on t.QUERY_ID = q.ID
    inner join TBL_LEADERS l on l.id = t.LEADER_ID
    group by l.name, ANONID
    order by anzahl desc;

create view VW_FRAGE_10 as
    select *
    from VW_FRAGE_10_1
    where ROWNUM <= 20;