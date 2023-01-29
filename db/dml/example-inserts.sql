##################### TBL_COUNTRIES #####################

INSERT INTO TBL_COUNTRIES (CODE, NAME) VALUES ('AFG', 'Afghanistan');
INSERT INTO TBL_COUNTRIES (CODE, NAME) VALUES ('ALB', 'Albania');
INSERT INTO TBL_COUNTRIES (CODE, NAME) VALUES ('DZA', 'Algeria');


##################### TBL_LEADERS #####################

INSERT ALL 
INTO TBL_LEADERS (id, name, country_code, begin, end) VALUES (418,'Kohl', 'GFR', (TO_DATE('1982/10/1', 'yyyy/mm/dd')), (TO_DATE('1998/10/27', 'yyyy/mm/dd')));
INTO TBL_LEADERS (id, name, country_code, begin, end) VALUES (419,'Schroder', 'GFR', (TO_DATE('1998/10/27', 'yyyy/mm/dd')), (TO_DATE('2005/11/22', 'yyyy/mm/dd'))); 
INTO TBL_LEADERS (id, name, country_code, begin, end) VALUES (420,'Merkel', 'GFR', (TO_DATE('2005/11/22', 'yyyy/mm/dd')), (TO_DATE('2020/12/31', 'yyyy/mm/dd')));
SELECT * FROM dual;

##################### TBL_KEYWORDS #####################

insert all
    into TBL_KEYWORD values (0, 'WAR')
    into TBL_KEYWORD values (1, 'PEACE')
    into TBL_KEYWORD values (2, 'HOLIDAY')
select * from dual;


##################### TBL_QUERYDATA_COUNTRIES #####################

insert all
    into TBL_QUERYDATA_COUNTRIES values (12581556, 'DEU')
    into TBL_QUERYDATA_COUNTRIES values (12581557, 'DEU')
    into TBL_QUERYDATA_COUNTRIES values (12581558, 'DEU')
select * from dual;

##################### TBL_QUERYDATA_LEADERS #####################

insert all
    into TBL_QUERYDATA_LEADERS values (22191487, 420)
    into TBL_QUERYDATA_LEADERS values (11095564, 420)
    into TBL_QUERYDATA_LEADERS values (9589690, 420)
select * from dual;

##################### TBL_KEYWORD_QUERYDATA #####################

insert all
    into TBL_KEYWORD_QUERYDATA values (0, 1087857)
    into TBL_KEYWORD_QUERYDATA values (1, 1087857)
    into TBL_KEYWORD_QUERYDATA values (2, 1087857)
select * from dual;