time=time or {}
time.more=1
time.less=-1
time.equal=0
time.eudst={}
time.eundst={}

local function Nilto0(date)
	date=date or {}
	date.Year=date.Year or 0
	date.Month=date.Month or 0
	date.Day=date.Day or 0
	date.Hour=date.Hour or 0
	date.Minute=date.Minute or 0
	date.Second=date.Second or 0
	return date
	end

function time.daysinamonth(Year,Month)
	while Month<=0 do
		Month = Month + 12
		Year = Year - 1
		end
	Year = Year + math.floor((Month-1) / 12)
	Month = math.mod(Month-1, 12)+1
	if Month==1 then return 31
	elseif (Month==2) and time.IsLeap(Year) then return 29
	elseif Month==2 then return 28
	elseif Month==3 then return 31
	elseif Month==4 then return 30
	elseif Month==5 then return 31
	elseif Month==6 then return 30
	elseif Month==7 then return 31
	elseif Month==8 then return 31
	elseif Month==9 then return 30
	elseif Month==10 then return 31
	elseif Month==11 then return 30
	elseif Month==12 then return 31
	end
end

time.DateToStr=function(date,datesep)
	datesep=datesep or '/'
	return string.format("%.2d%s%.2d%s%.4d",date.Day,datesep,date.Month,datesep,date.Year)
	end

time.TimeToStr=function(date,timesep)
	timesep=timesep or ':'
	return string.format("%.2d%s%.2d%s%.2d",date.Hour,timesep,date.Minute,timesep,date.Second)
	end

time.DateTimeToStr=function(date,datesep,timesep,datetimesep)
	datetimesep = datetimesep or ' '
	return time.DateToStr(date,datesep)..datetimesep..time.TimeToStr(date,timesep)
	end
	
function time.PrintDate(date)
	print(string.format("%.2d/%.2d/%.4d %.2d:%.2d",date.Day,date.Month,date.Year,date.Hour,date.Minute))
	end

function time.IsLeap(Year)
--see if a year is a leap year
if (math.band(Year,3))~=0 then return false
	end
if math.mod(Year, 100)==0 then
	if math.mod(Year, 400)==0 then return true 
		else return false
		end
	else return true
	end
end

function time.GetDay(date)
	--find the day of a date
	local MonthCodes={0,3,3,6,1,4,6,2,5,0,3,5}
	local dayno
	dayno=math.mod(date.Year, 100);
    dayno=dayno+math.floor(dayno / 4)+MonthCodes[date.Month]+date.Day;
	dayno=dayno-math.mod(math.floor(date.Year/100),4)*2;
	if time.IsLeap(date.Year) and ((date.Month==1)or(date.Month==2)) then dayno=dayno-1 end
    dayno=math.mod(dayno, 7);
	if dayno<0 then dayno=-dayno;end;
	if dayno==0 then dayno=7;end;
	dayno=dayno-1
	return dayno;
	end

--get current time
local curtime=os.date("!*t")
if (curtime.month>=4)and(curtime.month<=10) then
   time.eudst.Year=curtime.year+1;
   time.eundst.Year=curtime.year;
   else
	time.eudst.Year=curtime.year;
	time.eundst.Year=curtime.year+1;
    end
--dst starts on last sunday in march and ends on last sunday in october
time.eudst.Month=3;
time.eudst.Day=31;
time.eundst.Month=10;
time.eundst.Day=31;
time.eudst.Day=time.eudst.Day-time.GetDay(time.eudst);
time.eundst.Day=time.eundst.Day-time.GetDay(time.eundst);
time.eundst.Hour=2;
time.eundst.Minute=0;
time.eundst.Second=0;
time.eudst.Hour=2;
time.eudst.Minute=0;
time.eudst.Second=0;

time.comp = function (date1,date2)
	if date1.Year<date2.Year then return time.less;end
	if date1.Year>date2.Year then return time.more;end
	if date1.Month<date2.Month then return time.less;end
	if date1.Month>date2.Month then return time.more;end
	if date1.Day<date2.Day then return time.less;end
	if date1.Day>date2.Day then return time.more;end
	if date1.Hour<date2.Hour then return time.less;end
	if date1.Hour>date2.Hour then return time.more;end
	if date1.Minute<date2.Minute then return time.less;end
	if date1.Minute>date2.Minute then return time.more;end
	if date1.Second<date2.Second then return time.less;end
	if date1.Second>date2.Second then return time.more;end
	return time.equal
	end

time.IsEUDST = function (date)
	if (date.Month>=4)and(date.Month<=9) then return true;end
	if (date.Month>=11)and(date.Month<=2) then return true;end
	if (date.Month==3) then
		if date.Day<time.eudst.Day then return false
		elseif date.Day>time.eudst.Day then return true
		elseif date.Hour>=time.eudst.Hour then return true
		end
		return false;
		end
	if (date.Month==10) then
		if date.Day<time.eundst.Day then return true
		elseif date.Day>time.eundst.Day then return false
		elseif date.Hour>=time.eundst.Hour then return false
		end
		return true;
		end	
	end
	
time.GMT_BSTToUTC = function(date)
	if time.IsEUDST(date) then
		date.Hour = date.Hour - 1
		date = time.Fix(date)
		end
	return date
	end
	
time.CET_CESTToUTC = function(date)
	if time.IsEUDST(date) then
		date.Hour = date.Hour - 2
		date = time.Fix(date)
		else
			date.Hour = date.Hour - 1
			date = time.Fix(date)
			end
	return date
	end
	
time.Fix = function (date)
date.Second=tonumber(date.Second)
date.Minute=tonumber(date.Minute)
date.Hour=tonumber(date.Hour)
date.Day=tonumber(date.Day)
date.Month=tonumber(date.Month)
date.Year=tonumber(date.Year)
while date.Second>=60 do
      date.Minute=date.Minute+1;
      date.Second=date.Second-60;
      end;
while date.Second<0 do 
      date.Minute=date.Minute-1;
      date.Second=date.Second+60;
      end;

while date.Minute>=60 do
      date.Hour=date.Hour+1;
      date.Minute=date.Minute-60;
      end;
while date.Minute<0 do
      date.Hour=date.Hour-1;
      date.Minute=date.Minute+60;
      end;

while date.Hour>=24 do 
      date.Day=date.Day+1;
      date.Hour=date.Hour-24;
      end;
while date.Hour<0 do 
      date.Day=date.Day-1;
      date.Hour=date.Hour+24;
      end;
if (date.Year~=0) then
	while date.Day>time.daysinamonth(date.Year,date.Month) do
		date.Day=date.Day-time.daysinamonth(date.Year,date.Month);
		date.Month=date.Month+1;
		end;
	while date.Day<=0 do
		date.Month=date.Month-1;
		date.Day=date.Day+time.daysinamonth(date.Year,date.Month);
		end;

	while date.Month>12 do
		date.Month=date.Month-12;
		date.Year=date.Year+1;
		end;
	while date.Month<=0 do
		date.Month=date.Month+12;
		date.Year=date.Year-1;
		end;
	end
return date
end
	
time.StrToDate=function (str,datesep,timesep)
	datesep=datesep or '/'
	timesep=timesep or ':'
	local n=string.len(str)
	local i,tmp,c,ndate,ntime,indate
	local date={}
	tmp=""
	ndate=0
	ntime=0
	indate=true
	for i=1,n do
		c=string.sub(str,i,i)
		if (c==datesep)or(((c==" ")or(i==n))and indate and (tmp~="")) then
			if (i==n) then tmp=tmp..c end
			indate=true
			ndate=ndate+1
			if ndate==1 then date.Day=tonumber(tmp)
				elseif ndate==2 then date.Month=tonumber(tmp)
				elseif ndate==3 then date.Year=tonumber(tmp)
				else 
					print("Error parsing date: "..str)
					return(date)
				end
			tmp=""
			elseif (c==timesep) or (i==n) then
				if (i==n) then tmp=tmp..c end
				indate=false
				ntime=ntime+1
				if ntime==1 then date.Hour=tonumber(tmp)
					elseif ntime==2 then date.Minute=tonumber(tmp)
					elseif ntime==3 then date.Second=tonumber(tmp)
					else
						print("Error parsing date: "..str)
						return(date)
					end
				tmp=""
			else tmp=tmp..c
			end
		end
	return(date)
	end

time.Add=function (date1,date2)
	local date3={}
	date1=Nilto0(date1)
	date2=Nilto0(date2)
	date3.Year=date1.Year+date2.Year
	date3.Month=date1.Month+date2.Month
	date3.Day=date1.Day+date2.Day
	date3.Hour=date1.Hour+date2.Hour
	date3.Minute=date1.Minute+date2.Minute
	date3.Second=date1.Second+date2.Second
	date3=time.Fix(date3)
	return(date3)
	end	