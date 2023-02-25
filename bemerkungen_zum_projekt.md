# Bemerkungen zum Datenbanken Projekt

**Github Projekt:** [https://github.com/tillpistiak/bht-db-public](https://github.com/tillpistiak/bht-db-public)

## Änderungen der Fragestellung zu Abgabe 2
Für Frage 4 sowie Frage 8 haben wir uns entschieden, die Anzahl der Suchanfragen auf Tagesebene anstatt auf Monatsebene darzustellen. Die Darstellung auf Monatsebene hatte mit gerade einmal 3 Datenpunkten pro Land ein eher uninteressantes Ergebnis zur Folge. <br>
Damit die Diagramme auch bei Darstellung auf Tagesebene einigermaßen übersichtlich bleiben, haben wir uns zudem entschieden, die betrachteten Länder auf die beiden jeweils meistgesuchten Länder für Frage 4, sowie das meistgesuchte Land für Frage 8 zu reduzieren.<br><br>
**Alte Frage 4 -** Wie häufig kommt jeder Staat jeweils im März, April und Mai in den Suchanfragen vor?<br>
**Neue Frage 4 -** Welche sind die 2 jeweils meistgesuchten Länder pro Tag zwischen dem 01.03.2006 und dem 31.05.2006?<br><br>
**Alte Frage 8 -** Welche Schwankungen gibt es auf Monatsebene bezüglich der Häufigkeit, mit der ein Land zusammen mit dem Begriff "war" gesucht wurde?<br>
**Neue Frage 8 -** Welches war für jeden Tag zwischen dem 01.03.2006 und dem 31.05.2006 das Land, welches am häufigsten zusammen mit dem Begriff "war" gesucht wurde?<br>

## Lessons Learned
### Lange Queryzeiten (217x3,5M Suchanfragen)
Aufgrund der Anzahl der vorhandenen Suchanfragen sowie Länder, ergaben sich teilweise extrem lange Queryzeiten. Diese konnten teilweise nicht bis zu Ende ausgeführt werden, da die Verbindung in vielen Fällen vorher abbrach.<br>
Um dieses Problem zu umgehen, haben wir einige Queries in einzelne "Teile" zerlegt und nacheinander ausgeführt. <br>
So haben wir bspw. das Befüllen der Tabelle `TBL_QUERYDATA_COUNTRIES` nach Anfangsbuchstaben der Länder in 26 Teile zerlegt und ausgeführt. 
<br><br>

### Verwendung unterschiedlicher Countrycodes
**Problem:** Der Datensatz der politischen Führer verwendet COW Country Codes, während die World Bank
ISO3 Codes verwendet.<br>
**Lösung:**
1. cow2iso Datensatz in eigene Tabelle importieren (TBL_ISO_COW_MAPPING)
2. Alle Einträge aus TBL_ISO_COW_MAPPING entfernen, bei denen ISO = null oder COW = null
3. Alle Länder aus TBL_COUNTRIES entfernen, deren Code nicht in TBL_ISO_COW_MAPPING.ISO
enthalten ist
4. Alle politischen Führer aus TBL_LEADERS entfernen, deren Country-Code nicht in
TBL_ISO_COW_MAPPING.COW enthalten ist
5. Country-Code von TBL_LEADERS mit Hilfe von TBL_ISO_COW_MAPPING von COW auf ISO
aktualisieren
6. Alle Einträge aus TBL_LEADERS entfernen, deren Country-Code nicht in TBL_COUNTRIES
enthalten ist
7. Fremdschlüsselbeziehung von TBL_LEADERS.COUNTRY_CODE auf TBL_COUNTRIES.CODE
anlegen


### Langsame Zugriffszeiten auf die DB 
**Problem:** <br>
Aufgrund der großen Datenmenge sowie der langsamen Verbindung zum Datenbankserver in der Hochschule, ist die durchschnittliche Antwortzeit für den Aufruf einer Query trotz Optimierungen immer noch relativ groß. Das Aufrufen der Diagramme im Webbrowser dauert dementsprechend lange.<br>
**Lösung:**<br>
Zur Umgehung dieses Problems haben wir einen Parameter `USE_DB` per Umgebungsvariable in das Skript vom Backend Service eingeführt, über welchen entschieden werden kann, ob die tatsächliche Datenbank oder ein lokaler Cache in Form von JSON Dateien zur Bereitstellung der Daten verwendet werden soll. <br>
Erfolgt der Zugriff über die Datenbank, so werden die lokalen Cache Files aktualisiert. <br>
Die Bereitstellungszeiten der Diagramme konnten so drastisch reduziert werden.


### Verwendung von Ländernamen als Teil anderer Wörter
**Problem:** <br>
Viele Ländernamen kommen häufig als Teil anderer, teilweise völlig unabhängiger, Suchbegriffe vor. Beispielsweise kommt **"Oman"** sehr häufig als Teil des Wortes **"Woman"** vor. <br>
**Lösung:**<br>
Mit Hilfe des `LIKE` Schlüsselwortes sowie des `%` Operators können die Suchanfragen auf nur diejenigen eingeschränkt werden, welche den gesuchten Begriff als ganzes Wort enthalten. Die daraus resultierenden Unterschiede können im Diagramm zu Frage 3 betrachtet werden.<br>
**Beispiel:**<br>
```sql
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
```


<div style="page-break-after: always"></div>

## Ausblick
* Synonyme/ Abkürzungen für Länder hinzufügen (z.B. USA)
  * Einige Länder kämen höchstwahrscheinlich deutlich häufiger in den Suchanfragen vor, wenn bspw. deren Abkürzungen ebenfalls in die Suche einbezogen würde. 
* Indizierung der Tabellen
  * Das Anlegen von Indices für bestimmte Spalten der angelegten Tabellen könnte die Performance der Queries u.U. deutlich steigern.
* Caching verbessern (nachladen im Hintergrund) 
  * Das Aktualisieren der lokalen Cache Files erfolgt momentan nur, wenn der Parameter `USE_DB` manuell auf `true` gesetzt wird. In diesem Fall wird der Cache allerdings nicht mehr für die Bereitstellung der Daten für die Diagramme verwendet. 
  * In der Zukunft wäre eine Lösung denkbar, bei der die Daten initial aus dem Cache geladen werden. Im Hintergrund werden die Cache Files durch einen Zugriff auf die tatsächliche Datenbank regelmäßig aktualisiert. Auf diese Weise blieben die Ladezeiten für die Diagramme gering, deren Aktualität wäre gleichzeitg aber auch sichergestellt.
* Ländernamen Fixen
  * Einige Länder sind mit sehr ungünstigen Namen in der Datenbank der Weltbank gespeichert. Das führt dazu, dass diese Länder in keiner oder nur vereinzelten Suchanfragen vorkommen. Zu diesen Ländern gehören unter Anderem: 
    * Ägypten ("Egypt, Arab Rep.")
    * Kongo ("Congo, Dem. Rep.")
    * Jemen ("Yemen, Rep.")
    * Venezuela ("Venezuela, RB")
  * Um dieses Problem zu lösen, müssen die Namen der Länder durch besser geeignete ersetzt werden ("Egypt"). Danach kann die Tabelle `TBL_QUERYDATA_COUNTRIES` erneut für das entsprechende Land gefüllt werden.
  * Bei Umsetzung der Abfrage mit Hilfe von Abkürzungen sollte dieses Problem ebenfalls gelöst werden. 


## Andere Probleme
* Einige Namen von Staatsoberhäuptern kommen allgemein sehr häufig vor. Die Anzahl der Suchanfragen nach diesen haben daher nur begrenzte Aussagekraft.
* Das gleiche gilt u.a. für Georgien (Georgia) welches zugleich ein US-Bundesstaat ist und daher sehr häufig im Vergleich zu anderen Ländern gesucht wurde. Als Lösung könnte man zusätzlich zum Ländernamen nach Begriffen wie "country" suchen, dies würde die Anzahl der Ergebnisse allerdings stark reduzieren.
* Am 17.05 gibt es deutlich weniger Suchergebnisse als an allen anderen Tagen des Zeitraums. Für eine Darstellung der täglichen Suchanfragen im Liniendiagramm müsste dieser Tag bspw. ausgeklammert werden, da sonst ein völlig falsches Bild entstünde.
