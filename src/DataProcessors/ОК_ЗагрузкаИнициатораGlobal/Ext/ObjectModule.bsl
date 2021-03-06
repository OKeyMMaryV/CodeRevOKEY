//2012-01-31

// Параметры соединения с SQL
Перем Адрес;
Перем ПользовательSQL;
Перем ПарольSQL;
Перем БазаДанных;
Перем ПодключеноКБазе Экспорт ;
Перем мТаймаут;   

// объекты для подключения к базе
Перем СоединениеАДО, ЗапросАДО; 

Перем ВыводитьСообщения Экспорт;

//Проверка наличия групп в регистре, если их нет, то добавляются
Процедура НастройкиИмпортаПоУмолчанию() Экспорт

	Запрос = Новый Запрос;
		
	Запрос.Текст = "ВЫБРАТЬ
	|	""ЗагрузкаИнициаторовGlobal"" КАК Группа,
	|	""Сервер"" КАК ИмяНастройки,
	|	""port-s1"" КАК Значение
	|ПОМЕСТИТЬ ВТ_ПроверяемыеНастройки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ЗагрузкаИнициаторовGlobal"",
	|	""Логин"",
	|	""wg_user""
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ЗагрузкаИнициаторовGlobal"",
	|	""Пароль"",
	|	""P@ssw0rd""
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ЗагрузкаИнициаторовGlobal"",
	|	""База"",
	|	""OkeyDB_ExportFromKadr""
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Группа,
	|	ИмяНастройки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПроверяемыеНастройки.Группа,
	|	ВТ_ПроверяемыеНастройки.ИмяНастройки,
	|	ВТ_ПроверяемыеНастройки.Значение
	|ИЗ
	|	ВТ_ПроверяемыеНастройки КАК ВТ_ПроверяемыеНастройки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|		ПО ВТ_ПроверяемыеНастройки.Группа = бит_ок_НастройкиМеханизмаИмпортаДанных.Группа
	|			И ВТ_ПроверяемыеНастройки.ИмяНастройки = бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки ЕСТЬ NULL ";
	
	ТЗНастройки = Запрос.Выполнить().Выгрузить();
	
	НачатьТранзакцию();
	Для Каждого СтрокаНастроек из ТЗНастройки Цикл 
		ДобавляемаяНастройка				= РегистрыСведений.бит_ок_НастройкиМеханизмаИмпортаДанных.СоздатьМенеджерЗаписи();
		ДобавляемаяНастройка.Группа			= СтрокаНастроек.Группа;
		ДобавляемаяНастройка.ИмяНастройки	= СтрокаНастроек.ИмяНастройки;
		ДобавляемаяНастройка.Значение		= СтрокаНастроек.Значение;
		ДобавляемаяНастройка.Записать(Истина);
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Функция ОбновитьНастройкиИмпорта() Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа КАК Группа,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки КАК ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа = ""ЗагрузкаИнициаторовGlobal""";
	
	ТЗРезультат 		= Запрос.Выполнить().Выгрузить();
	
	Отказ				= Ложь;
	Сообщение			= "";
	СтрокаТЗ			= ТЗРезультат.Найти("Сервер");
	Если СтрокаТЗ = Неопределено Тогда  
		Отказ			= Истина;
		Сообщение		= Сообщение + "
		|Не указан параметр Сервер подключения";
	Иначе
		Адрес			= СтрокаТЗ.Значение;
	КонецЕсли;
	
	СтрокаТЗ			= ТЗРезультат.Найти("Логин");
	Если СтрокаТЗ = Неопределено Тогда  
		Отказ			= Истина;
		Сообщение		= Сообщение + "
		|Не указан параметр Логин подключения";
	Иначе
		ПользовательSQL	= СтрокаТЗ.Значение;
	КонецЕсли;
	СтрокаТЗ			= ТЗРезультат.Найти("Пароль");
	ПарольSQL			= СтрокаТЗ.Значение;
	Если СтрокаТЗ = Неопределено Тогда  
		Отказ			= Истина;
		Сообщение		= Сообщение + "
		|Не указан параметр Пароль подключения";
	Иначе	
		СтрокаТЗ		= ТЗРезультат.Найти("База");
	КонецЕсли;
	
	Если СтрокаТЗ = Неопределено Тогда  
		Отказ			= Истина;
		Сообщение		= Сообщение + "
		|Не указан параметр База подключения";
	Иначе
		БазаДанных		= СтрокаТЗ.Значение;	
	КонецЕсли;
	
	Если Отказ Тогда 
		ВыводСтатусаСообщения(,Сообщение);
	КонецЕсли;	
	
	Возврат Отказ;
КонецФункции

Процедура ЗагрузитьИзGlobal(Проверять=Истина) Экспорт 
	
	Если Не ПодключениеКБазе() Тогда
		Возврат;
	КонецЕсли;
	
	ЗапросАДО.CommandText = " SELECT 
	|Persons.FullName,
	|Persons.PID,	
	|Persons.Email,	
	|Persons.UserLogin,	
	|Functions.FunctionName,	
	|Titles.Title,
	|Man.FullName as ManFullName 		
	|FROM dbo.Persons
	|LEFT Join dbo.Functions
	|on Persons.FunctionID = Functions.ID	
	|LEFT Join dbo.Titles
	|on Persons.JobTitleID = Titles.ID	
	|LEFT Join dbo.Persons as Man
	|on Persons.PID = Man.ID	
	//|	where Persons.Email = '" + EmailПоиска + "'";
	//ОК Довбешка Т. деперсонификации почты
	|	where Persons.UserLogin = '" + EmailПоиска + "'";
	//ОК
	
	//Выполнение запроса
	Выборка = ЗапросАДО.Execute(); 
	
	Если Не Выборка.EOF() Тогда

		Наименование		= Выборка.Fields("FullName").Value;
		Идентификатор		= Выборка.Fields("PID").Value;
		Руководитель		= Выборка.Fields("ManFullName").Value;
		Отдел				= Выборка.Fields("FunctionName").Value;
		Email				= Выборка.Fields("Email").Value;
		Должность			= Выборка.Fields("Title").Value;
		DomainName			= Выборка.Fields("UserLogin").Value;
	Иначе 
		//ВыводСтатусаСообщения(,"E-mail не найден");
	    //ОК Довбешка Т. деперсонификации почты
		ВыводСтатусаСообщения(,"Доменное имя не найдено");
	    //ОК
	КонецЕсли;	
	
	Если Проверять Тогда 
		//Проверим Есть ли уже инициатор с таким Email
		НайтиПоEmail();
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьЭлементСправочника() Экспорт

	Если не ЗначениеЗаполнено(Email) Тогда 
		ВыводСтатусаСообщения(,"Поля не заполнены");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Элемент) Тогда 
		СохраняемыйЭлемент = Элемент.ПолучитьОбъект();
	Иначе 
		СохраняемыйЭлемент = Справочники.бит_БК_Инициаторы.СоздатьЭлемент();
	КонецЕсли;
	
	СохраняемыйЭлемент.Наименование			= Наименование;
	СохраняемыйЭлемент.Идентификатор		= Идентификатор;
	СохраняемыйЭлемент.Руководитель			= Руководитель;
	СохраняемыйЭлемент.Отдел				= Отдел;
	СохраняемыйЭлемент.Email				= Email;
	СохраняемыйЭлемент.Должность			= Должность;
	СохраняемыйЭлемент.Телефон				= Телефон;
	СохраняемыйЭлемент.DomainName			= DomainName;
	СохраняемыйЭлемент.Статус				= Статус;
	СохраняемыйЭлемент.Пользователь			= Пользователь;
	СохраняемыйЭлемент.МожетСоздаватьЗаявки	= МожетСоздаватьЗаявки; 
	
	СохраняемыйЭлемент.Записать();
	Элемент									= СохраняемыйЭлемент.Ссылка;
КонецПроцедуры

Процедура НайтиПоEmail() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_БК_Инициаторы.Ссылка
	|ИЗ
	|	Справочник.бит_БК_Инициаторы КАК бит_БК_Инициаторы
	|ГДЕ
	//|	бит_БК_Инициаторы.Email = &Email";
	//ОК Довбешка Т. деперсонификации почты
	|	бит_БК_Инициаторы.DomainName = &Email";
	//ОК
	
	Запрос.УстановитьПараметр("Email", EmailПоиска);
	
	ТЗРезультат = Запрос.Выполнить().Выгрузить();
	
	Если ТЗРезультат.Количество() > 1 Тогда 
		Элемент = ТЗРезультат[0].Ссылка;
	ИначеЕсли ТЗРезультат.Количество() = 1 Тогда 
		Элемент = ТЗРезультат[0].Ссылка;
		//ВыводСтатусаСообщения(,"Найден инициатор с заданным Email и помещен в реквизит ""Элемент справочника""");
		//ОК Довбешка Т. деперсонификации почты
		ВыводСтатусаСообщения(,"Найден инициатор с заданным доменным именем и помещен в реквизит ""Элемент справочника""");
		//ОК
	Иначе 
		Элемент = Справочники.бит_БК_Инициаторы.ПустаяСсылка();
	КонецЕсли; 
	

КонецПроцедуры


/////////////////////////////////////
// Процедуры для соединения с SQL
/////////////////////////////////////

Функция ПодключениеКБазе() Экспорт
	
	Если ПодключеноКБазе Тогда
		Возврат Истина;
	КонецЕсли;
	// соединение с базой
	СоединениеАДО = СоздатьСоединениеАДО(); 
	Если СоединениеАДО = Неопределено Тогда 
		ВыводСтатусаСообщения(,"Не удалось СоздатьСоединениеАДО"); 
		Возврат Ложь; 
	КонецЕсли; 
	ЗапросАДО = СоздатьЗапросАДО(); 
	Если ЗапросАДО = Неопределено Тогда 
		ВыводСтатусаСообщения(,"Не удалось СоздатьЗапросАДО"); 
		Возврат Ложь; 
	КонецЕсли; 
	Если Не ПодключитьсяАДОкБД() Тогда 
		ВыводСтатусаСообщения(,"Не удалось ПодключитьсяАДОкБД"); 
		Возврат Ложь; 
	КонецЕсли; 
	
	ПодключеноКБазе = Истина;
	Возврат Истина;
	
КонецФункции

//Создать объект ADODB.Connection 
//Возврат: 
//   OLE - объект соединение или Неопределено 
Функция СоздатьСоединениеАДО() Экспорт 
	Попытка 
		СоединениеАДО = Новый COMОбъект("ADODB.Connection"); 
	Исключение 
		ВыводСтатусаСообщения(,"Не удалось создать объект ""ADODB.Connection"""); 
		Возврат Неопределено; 
	КонецПопытки; 
	Возврат СоединениеАДО; 
КонецФункции //СоздатьСоединениеАДО() 

//Создать объект ADODB.Command 
//Возврат: 
//   OLE - объект запрос или Неопределено 
Функция СоздатьЗапросАДО() Экспорт 
	Попытка 
		ЗапросАДО = Новый COMОбъект("ADODB.Command");
		ЗапросАДО.CommandTimeout = ?( (НЕ ЗначениеЗаполнено(мТаймаут)) ИЛИ мТаймаут=0, 600, мТаймаут);
	Исключение 
		ВыводСтатусаСообщения(,"Не удалось создать объект ""ADODB.Command"""); 
		Возврат Неопределено; 
	КонецПопытки; 
	Возврат ЗапросАДО; 
КонецФункции //СоздатьЗапросАДО() 

//СоединениеАДО (OLE) - соединение 
//ЗапросАДО (OLE)      - запрос 
//Возврат: 
//   Булево - удачно, нет 
Функция ПодключитьсяАДОкБД() Экспорт
	
	Если ОбновитьНастройкиИмпорта() Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаСоединения = "driver={SQL Server};server=" + Адрес + ";uid=" + ПользовательSQL + ";pwd=" + ПарольSQL + ";Database=" + БазаДанных;    
	
	Попытка
		СоединениеАДО.ConnectionTimeOut = ?( (НЕ ЗначениеЗаполнено(мТаймаут)) ИЛИ мТаймаут=0, 600, мТаймаут);
		СоединениеАДО.Open(СтрокаСоединения); 
	Исключение 
		ВыводСтатусаСообщения(,"Не удалось установить соединение с базой данных"); 
		Возврат Ложь; 
	КонецПопытки; 
	
	ЗапросАДО.ActiveConnection = СоединениеАДО; 
	
	Возврат Истина; 
	
КонецФункции // ПодключитьсяАДОкБД()

/////////////////////////////////////
// Служебные
/////////////////////////////////////

Процедура ВыводСтатусаСообщения(Статус = Неопределено, Сообщение = Неопределено, ПроверятьПрерывение = Ложь) Экспорт 
	
	Если Не ВыводитьСообщения Тогда 
		Возврат;
	КонецЕсли;
	
	//#Если Клиент Тогда
	//	Если Статус <> Неопределено Тогда 
	//		Состояние(Статус);
	//	КонецЕсли;
	//	
		Если Сообщение <> Неопределено Тогда 
			Сообщить(Сообщение);
		КонецЕсли;
	//	
	//	Если ПроверятьПрерывение Тогда 
	//		ОбработкаПрерыванияПользователя();
	//	КонецЕсли;
	//#КонецЕсли 
	
КонецПроцедуры

//ОК Калинин 150812
Процедура НайтиИзмененныеЗаписи() Экспорт
	Если Не ПодключениеКБазе() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДляОбновления.Очистить();
	ДанныеГлобал=ДанныеДляОбновления.ВыгрузитьКолонки();

	ЗапросАДО.CommandText =
	 " SELECT 
	|Persons.FullName,
	|Persons.PID,	
	|Persons.Email,	
	|Persons.UserLogin,	
	|Functions.FunctionName,	
	|Titles.Title,
	|Man.FullName as ManFullName 		
	|FROM dbo.Persons
	|LEFT Join dbo.Functions
	|on Persons.FunctionID = Functions.ID	
	|LEFT Join dbo.Titles
	|on Persons.JobTitleID = Titles.ID	
	|LEFT Join dbo.Persons as Man
	|on Persons.PID = Man.ID";
	//Выполнение запроса
	Выборка = ЗапросАДО.Execute();		
	Пока Не Выборка.EOF() Цикл 
		ДанныеГлобалНовСтрока=ДанныеГлобал.Добавить();  				
		ДанныеГлобалНовСтрока.Email=СокрлП(Выборка.Fields("Email").Value);
		ДанныеГлобалНовСтрока.FullName=СокрлП(Выборка.Fields("FullName").Value);
        ДанныеГлобалНовСтрока.UserLogin=СокрлП(Выборка.Fields("UserLogin").Value);
		ДанныеГлобалНовСтрока.FunctionName=СокрлП(Выборка.Fields("FunctionName").Value);
		ДанныеГлобалНовСтрока.Title=СокрлП(Выборка.Fields("Title").Value);
		ДанныеГлобалНовСтрока.ManFullName=СокрлП(Выборка.Fields("ManFullName").Value);	
	
		Выборка.MoveNext(); 
	КонецЦикла;
	
	Запрос=новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ	               
	               |	ТЗ_ДанныеГлобал.Email,
	               |	ТЗ_ДанныеГлобал.FullName,
	               |	ТЗ_ДанныеГлобал.UserLogin,
	               |	ТЗ_ДанныеГлобал.FunctionName,
	               |	ТЗ_ДанныеГлобал.Title,
	               |	ТЗ_ДанныеГлобал.ManFullName
	               |ПОМЕСТИТЬ ВТ_ДанныеГлобал
	               |ИЗ
	               |	&ДанныеГлобал КАК ТЗ_ДанныеГлобал";
	Запрос.УстановитьПараметр("ДанныеГлобал", ДанныеГлобал);
	Запрос.Выполнить();
	Запрос.Текст="ВЫБРАТЬ
	             |	СУММА(1) КАК Количество,
	             |	ВТ_ДанныеГлобал.FullName
	             |ПОМЕСТИТЬ Имена
	             |ИЗ
	             |	ВТ_ДанныеГлобал КАК ВТ_ДанныеГлобал
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ВТ_ДанныеГлобал.FullName
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	Имена.Количество,
	             |	Имена.FullName
	             |ПОМЕСТИТЬ Однофамильцы
	             |ИЗ
	             |	Имена КАК Имена
	             |ГДЕ
	             |	Имена.Количество > 1
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВТ_ДанныеГлобал.FullName КАК FullName,
	             |	ВТ_ДанныеГлобал.Email КАК Global_Email,
	             |	ВТ_ДанныеГлобал.FunctionName КАК Global_FunctionName,
	             |	ВТ_ДанныеГлобал.Title КАК Global_Title,
	             |	ВТ_ДанныеГлобал.ManFullName КАК Global_ManFullName,
	             |	ВТ_ДанныеГлобал.UserLogin КАК Global_UserLogin,
	             |	ВЫБОР
	             |		КОГДА бит_БК_Инициаторы.Email <> ВТ_ДанныеГлобал.Email
	             |			ТОГДА бит_БК_Инициаторы.Email + "" -> "" + ВТ_ДанныеГлобал.Email
	             |		ИНАЧЕ """"
	             |	КОНЕЦ КАК Email,
	             |	ВЫБОР
	             |		КОГДА бит_БК_Инициаторы.DomainName <> ВТ_ДанныеГлобал.UserLogin
	             |			ТОГДА бит_БК_Инициаторы.DomainName + "" -> "" + ВТ_ДанныеГлобал.UserLogin
	             |		ИНАЧЕ """"
	             |	КОНЕЦ КАК UserLogin,
	             |	ВЫБОР
	             |		КОГДА бит_БК_Инициаторы.Отдел <> ВТ_ДанныеГлобал.FunctionName
	             |			ТОГДА бит_БК_Инициаторы.Отдел + "" -> "" + ВТ_ДанныеГлобал.FunctionName
	             |		ИНАЧЕ """"
	             |	КОНЕЦ КАК FunctionName,
	             |	ВЫБОР
	             |		КОГДА бит_БК_Инициаторы.Должность <> ВТ_ДанныеГлобал.Title
	             |			ТОГДА бит_БК_Инициаторы.Должность + "" -> "" + ВТ_ДанныеГлобал.Title
	             |		ИНАЧЕ """"
	             |	КОНЕЦ КАК Title,
	             |	ВЫБОР
	             |		КОГДА бит_БК_Инициаторы.Руководитель <> ВТ_ДанныеГлобал.ManFullName
	             |			ТОГДА бит_БК_Инициаторы.Руководитель + "" -> "" + ВТ_ДанныеГлобал.ManFullName
	             |		ИНАЧЕ """"
	             |	КОНЕЦ КАК ManFullName,
	             |	бит_БК_Инициаторы.Ссылка КАК Элемент,
	             |	ВЫБОР
	             |		КОГДА ВТ_ДанныеГлобал.FullName В
	             |				(ВЫБРАТЬ
	             |					Однофамильцы.FullName
	             |				ИЗ
	             |					Однофамильцы)
	             |			ТОГДА ИСТИНА
	             |		ИНАЧЕ ЛОЖЬ
	             |	КОНЕЦ КАК ЕстьОднофамилец
	             |ИЗ
	             |	Справочник.бит_БК_Инициаторы КАК бит_БК_Инициаторы
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДанныеГлобал КАК ВТ_ДанныеГлобал
	             |		ПО (ВТ_ДанныеГлобал.Email <> бит_БК_Инициаторы.Email
	             |				ИЛИ ВТ_ДанныеГлобал.UserLogin <> бит_БК_Инициаторы.DomainName
	             |				ИЛИ ВТ_ДанныеГлобал.FunctionName <> бит_БК_Инициаторы.Отдел
	             |				ИЛИ ВТ_ДанныеГлобал.Title <> бит_БК_Инициаторы.Должность
	             |				ИЛИ ВТ_ДанныеГлобал.ManFullName <> бит_БК_Инициаторы.Руководитель)
	             |			И (ВТ_ДанныеГлобал.FullName = бит_БК_Инициаторы.Наименование)
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	FullName";
				 
	
	ДанныеДляОбновления.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	
//ОК Калинин 150812

ПодключеноКБазе		= Ложь;
ВыводитьСообщения	= Истина;
НастройкиИмпортаПоУмолчанию();

