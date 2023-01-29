##################### VIEWS #####################

create view VW_TOP_20_COUNTRIES_BY_NUMBER_OF_SEARCHES AS
    select *
    from (select country_code, count(*) as count
          from TBL_QUERYDATA_COUNTRIES
          group by country_code
          order by count desc)
    where ROWNUM <= 20;

create view VW_TOP_20_COUNTRIES_BY_NUMBER_OF_SEARCHES_WHOLE_WORDS AS
    select *
    from (select country_code, count(*) as count
          from VW_QUERYDATA_COUNTRIES_WHOLE_WORDS
          group by country_code
          order by count desc)
    where ROWNUM <= 20;


create view VW_QUERYDATA_COUNTRIES_WHOLE_WORDS as
    select query_id, country_code, query
    from TBL_QUERYDATA_COUNTRIES cq
    inner join (select upper(query) as query, id from AOLDATA.QUERYDATA) q on q.id = cq.QUERY_ID
    inner join (select upper(name) as name, code from TBL_COUNTRIES) c on cq.COUNTRY_CODE = c.CODE
    where 1 = 1
    and (
        (q.query like ('% ' || c.name)) or
        (q.query like (c.name||' %')) or
        (q.query like ('% '|| c.name|| ' %')) or
        (q.query = c.name)
        );


create view VW_QUERYDATA_KEYWORDS_WHOLE_WORDS as
    select query_id, keyword_id, query
    from TBL_KEYWORD_QUERYDATA qk
    inner join (select upper(query) as query, id from AOLDATA.QUERYDATA) q on q.id = qk.QUERY_ID
    inner join (select upper(word) as word, id from TBL_KEYWORD) k on qk.KEYWORD_ID = k.ID
    where 1 = 1
    and (
        (q.query like ('% ' || k.word)) or
        (q.query like (k.word||' %')) or
        (q.query like ('% '|| k.word|| ' %')) or
        (q.query = k.word)
        );

create view VW_KEYWORDS_COUNTRIES as
    select kq.KEYWORD_ID, country_code, count(*) as anzahl
    from VW_QUERYDATA_KEYWORDS_WHOLE_WORDS kq
    inner join AOLDATA.QUERYDATA q on kq.QUERY_ID = q.ID
    inner join VW_QUERYDATA_COUNTRIES_WHOLE_WORDS qc on q.ID = qc.QUERY_ID
    group by kq.KEYWORD_ID, COUNTRY_CODE
    order by KEYWORD_ID, COUNTRY_CODE;

create view VW_LEADERS_2006 as
    select * from TBL_LEADERS l
    where 1=1
    and EXTRACT(YEAR FROM BEGIN) <= 2006
    and EXTRACT(YEAR FROM END) >= 2006;


create view VW_QUERYDATA_LEADERS_WHOLE_WORDS as
    select query_id, leader_id, name, query
    from TBL_QUERYDATA_LEADERS ql
    inner join (select upper(query) as query, id from AOLDATA.QUERYDATA) q on q.id = ql.QUERY_ID
    inner join (select upper(name) as name, id from TBL_LEADERS) l on ql.leader_id = l.id
    where 1 = 1
    and (
        (q.query like ('% ' || l.name)) or
        (q.query like (l.name||' %')) or
        (q.query like ('% '|| l.name|| ' %')) or
        (q.query = l.name)
        );


create view VW_TOP_LEADERS as
select lq.leader_id, l.name, count(*) as count
from TBL_QUERYDATA_LEADERS lq
inner join TBL_LEADERS l on lq.leader_id = l.id
group by lq.leader_id, l.name
order by count desc;

create view VW_TOP_LEADERS_WHOLE_WORDS as;
select lq.leader_id, l.name, count(*) as count, c.NAME
from VW_QUERYDATA_LEADERS_WHOLE_WORDS lq
inner join TBL_LEADERS l on lq.leader_id = l.id
inner join TBL_ISO_COW_MAPPING m on m.COW = l.COUNTRY_CODE
inner join TBL_COUNTRIES c on m.ISO = c.CODE
group by lq.leader_id, l.name, c.name
order by count desc;


create view VW_TOP_LEADERS_WHOLE_WORDS as
select lq.leader_id, l.name, count(*) as count, l.country_code
from VW_QUERYDATA_LEADERS_WHOLE_WORDS lq
inner join TBL_LEADERS l on lq.leader_id = l.id
group by lq.leader_id, l.name, l.country_code
order by count desc;
