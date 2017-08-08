CREATE PROCEDURE `PopulateDateDimension` (BeginDate DATETIME, EndDate DATETIME)
BEGIN
DECLARE LastDayOfMon CHAR(1);

 
 DECLARE FiscalYearMonthsOffset INT;

 
 DECLARE DateCounter DATETIME;    
 DECLARE FiscalCounter DATETIME;  

 SET FiscalYearMonthsOffset = 3;

 
 SET DateCounter = BeginDate;

 WHILE DateCounter <= EndDate DO
 
            SET FiscalCounter = DATE_ADD(DateCounter, INTERVAL FiscalYearMonthsOffset MONTH);

 
            IF MONTH(DateCounter) = MONTH(DATE_ADD(DateCounter, INTERVAL 1 DAY)) THEN
               SET LastDayOfMon = 'N';
            ELSE
               SET LastDayOfMon = 'Y';
   END IF;

 
            INSERT  INTO `Date`
       (dateKey
       ,fullDate
       ,dateName
       ,dateNameUS
       ,dateNameEU
       ,dayOfweek
       ,dayNameOfWeek
       ,dayOfMonth
       ,dayOfYear
       ,weekdayWeekend
       ,weekOfYear
       ,monthName
       ,monthOfYear
       ,isLastDayOfMonth
       ,calendarQuarter
       ,calendarYear
       ,calendarYearMonth
       ,calendarYearQtr
       ,fiscalMonthOfYear
       ,fiscalQuarter
       ,fiscalYear
       ,fiscalYearMonth
       ,fiscalYearQtr)
            VALUES  (
                      ( YEAR(DateCounter) * 10000 ) + ( MONTH(DateCounter)
                                                         * 100 )
                      + DAY(DateCounter)  
                    , DateCounter 
                    , CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'/',DATE_FORMAT(DateCounter,'%m'),'/',DATE_FORMAT(DateCounter,'%d')) 
                    , CONCAT(DATE_FORMAT(DateCounter,'%m'),'/',DATE_FORMAT(DateCounter,'%d'),'/',CAST(YEAR(DateCounter) AS CHAR(4)))
                    , CONCAT(DATE_FORMAT(DateCounter,'%d'),'/',DATE_FORMAT(DateCounter,'%m'),'/',CAST(YEAR(DateCounter) AS CHAR(4)))
                    , DAYOFWEEK(DateCounter) 
                    , DAYNAME(DateCounter) 
                    , DAYOFMONTH(DateCounter) 
                    , DAYOFYEAR(DateCounter) 
                    , CASE DAYNAME(DateCounter)
                        WHEN 'Saturday' THEN 'Weekend'
                        WHEN 'Sunday' THEN 'Weekend'
                        ELSE 'Weekday'
                      END 
                    , WEEKOFYEAR(DateCounter) 
                    , MONTHNAME(DateCounter) 
                    , MONTH(DateCounter) 
                    , LastDayOfMon 
                    , QUARTER(DateCounter) 
                    , YEAR(DateCounter) 
                    , CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'-',DATE_FORMAT(DateCounter,'%m'))
                    , CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'Q',QUARTER(DateCounter))
                    , MONTH(FiscalCounter) 
                    , QUARTER(FiscalCounter) 
                    , YEAR(FiscalCounter) 
                    , CONCAT(CAST(YEAR(FiscalCounter) AS CHAR(4)),'-',DATE_FORMAT(FiscalCounter,'%m')) 
                    , CONCAT(CAST(YEAR(FiscalCounter) AS CHAR(4)),'Q',QUARTER(FiscalCounter)) 
                    );

            
            SET DateCounter = DATE_ADD(DateCounter, INTERVAL 1 DAY);
      END WHILE;

END
