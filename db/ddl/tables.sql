##################### TBL_COUNTRIES #####################

create table TBL_COUNTRIES(
    code VARCHAR2(3) not null primary key,
    name VARCHAR2(100) not null,
);


##################### TBL_LEADERS #####################

create table TBL_LEADERS (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) not null,
    country_code VARCHAR2(3) not null,
    begin date,
    end date
);

alter table TBL_LEADERS add constraint FK_LEADERS_COUNTRIES foreign key (COUNTRY_CODE) references TBL_COUNTRIES (CODE);


##################### TBL_KEYWORDS #####################

create table TBL_KEYWORD (
    id number primary key,
    word varchar2(100)
);


##################### TBL_QUERYDATA_COUNTRIES #####################

create table TBL_QUERYDATA_COUNTRIES (
    query_id int not null,
    country_code varchar2(3) not null,
    constraint PK_QUERYDATA_COUNTRIES primary key (query_id, country_code)
);

alter table TBL_QUERYDATA_COUNTRIES add constraint FK_COUNTRIES_QD_COUNTRIES foreign key (COUNTRY_CODE) references TBL_COUNTRIES (CODE);

-- Funktioniert nicht wegen mangelnder Berechtigungen
alter table TBL_QUERYDATA_COUNTRIES add constraint FK_QUERYDATA_QD_COUNTRIES foreign key (QUERY_ID) references AOLDATA.QUERYDATA (ID);


##################### TBL_QUERYDATA_LEADERS #####################

create table TBL_QUERYDATA_LEADERS (
    query_id NUMBER not null,
    leader_id NUMBER not null,
    constraint PK_QUERYDATA_LEADERS primary key (query_id, leader_id)
);

alter table TBL_QUERYDATA_LEADERS add constraint FK_LEADERS_QD_LEADERS foreign key (LEADER_ID) references TBL_LEADERS (ID);

--Funktioniert nicht wegen mangelnder Berechtigungen
alter table TBL_QUERYDATA_LEADERS add constraint FK_QUERYDATA_QD_LEADERS foreign key (QUERY_ID) references AOLDATA.QUERYDATA (ID);

##################### TBL_KEYWORD_QUERYDATA #####################

create table TBL_KEYWORD_QUERYDATA (
    keyword_id number,
    query_id number,
    constraint PK_KEY_QD primary key (keyword_id, query_id)
);

alter table TBL_KEYWORD_QUERYDATA add constraint FK_KEYWORDS_QD_KEYWORDS foreign key (KEYWORD_ID) references TBL_KEYWORD (ID);

--Funktioniert nicht wegen mangelnder Berechtigungen
alter table TBL_KEYWORD_QUERYDATA add constraint FK_QUERYDATA_QD_KEYWORDS foreign key (QUERY_ID) references AOLDATA.QUERYDATA (ID);



