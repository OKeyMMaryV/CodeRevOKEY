//2012-05-28

// Параметры соединения с SQL
Перем Адрес;
Перем Пользователь;
Перем Пароль;
Перем БазаДанных;
Перем ПодключеноКБазе;
Перем мТаймаут;

//Перем Организация;
Перем Граница;
Перем мПоставщики;
Перем мПокупатели;
Перем ПорцияТранзакции;
Перем РБСтрокаСоединения;
Перем РБАдресСервера;

// объекты для подключения к базе
Перем СоединениеАДО, ЗапросАДО; 

Перем ТЗДокументы;

Процедура ВыполнитьОбработку() Экспорт

	ПолучитьВаучеры();
	
	Если ПолучитьОбъектыАксапты() Тогда 
		СопоставлениеАналитики();
		ЗаписатьИзменения();
	КонецЕсли;

КонецПроцедуры

Процедура ПолучитьВаучеры() Экспорт 
	
	ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Выбор списка ваучеров");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка КАК Ссылка,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.Ваучер,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.НомерСтроки,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СчетДт,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СчетКт,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Сумма,
	               |	""                    "" КАК ВаучерАкс,
	               |	ЗНАЧЕНИЕ(Справочник.ОбъектыСтроительства.ПустаяСсылка) КАК Аналитика1С
	               |ИЗ
	               |	Документ.бит_ок_ОперацияАксапты.ОборотыАксапты КАК бит_ок_ОперацияАксаптыОборотыАксапты
	               |ГДЕ
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.ТипДокумента = &ТипДокумента
	               |	И (бит_ок_ОперацияАксаптыОборотыАксапты.СчетДт = ""91.02""
	               |			ИЛИ бит_ок_ОперацияАксаптыОборотыАксапты.СчетКт = ""91.02"")
	               |	И (бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт1 = &НеСопоставлено
	               |			ИЛИ бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт1 = &НеСопоставлено)
				   |
				   //ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-26 (#ПроектИнтеграцияАксапта12)
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.Ваучер,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.НомерСтроки,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СчетДт,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаДт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СчетКт,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.СубконтоАксаптаКт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт1,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт2,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт3,
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Сумма,
	               |	""                    "",
	               |	ЗНАЧЕНИЕ(Справочник.ОбъектыСтроительства.ПустаяСсылка)
	               |ИЗ
	               |	Документ.бит_ок_ОперацияАксапты12.ОборотыАксапты КАК бит_ок_ОперацияАксаптыОборотыАксапты
	               |ГДЕ
	               |	бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И бит_ок_ОперацияАксаптыОборотыАксапты.Ссылка.ТипДокумента = &ТипДокумента
	               |	И (бит_ок_ОперацияАксаптыОборотыАксапты.СчетДт = ""91.02""
	               |			ИЛИ бит_ок_ОперацияАксаптыОборотыАксапты.СчетКт = ""91.02"")
	               |	И (бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СДт1 = &НеСопоставлено
	               |			ИЛИ бит_ок_ОперацияАксаптыОборотыАксапты.Субконто1СКт1 = &НеСопоставлено)
	               |
				   //ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-26 (#ПроектИнтеграцияАксапта12)
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка
	               |АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ТипДокумента", Справочники.бит_ок_ТипыОперацийАксапты.НайтиПоКоду("210"));
	Запрос.УстановитьПараметр("НеСопоставлено", Справочники.ОбъектыСтроительства.НайтиПоКоду("000000805"));
	
	ТЗДокументы = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

Функция ПолучитьОбъектыАксапты() Экспорт
	
	ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Получение данных аксапты",, Истина);
	
	Если ТЗДокументы.количество() = 0 Тогда 
		Сообщение	= "Нет подходящих документов";
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
		СделатьЗаписьЖР(Сообщение);
		Возврат Ложь; 
	КонецЕсли;
	
	ТЗВаучеры	= ТЗДокументы.Скопировать(,"Ваучер");
	ТЗВаучеры.Свернуть("Ваучер"); 
	
	СписокВаучеров	= "'";
	
	Для Каждого СтрокаТЗ из ТЗВаучеры Цикл 
		СписокВаучеров	= СписокВаучеров + СтрокаТЗ.Ваучер + "', '";
	КонецЦикла;
	СписокВаучеров	= Лев(СписокВаучеров,СтрДлина(СписокВаучеров) - 3);
	
	ЗаполнитьНастройки();
	
	СоединениеАДО = СоздатьСоединениеАДО(); 
	Если СоединениеАДО = Неопределено Тогда 
		Сообщение	= "Не удалось СоздатьСоединениеАДО";
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
		СделатьЗаписьЖР(Сообщение);
		Возврат Ложь; 
	КонецЕсли; 
	ЗапросАДО = СоздатьЗапросАДО(); 
	Если ЗапросАДО = Неопределено Тогда 
		Сообщение	= "Не удалось СоздатьЗапросАДО";
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
		СделатьЗаписьЖР(Сообщение);
		Возврат Ложь; 
	КонецЕсли; 
	Если Не ПодключитьсяАДОкБД(СоединениеАДО, ЗапросАДО) Тогда 
		Сообщение	= "Не удалось ПодключитьсяАДОкБД";
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
		СделатьЗаписьЖР(Сообщение);
		Возврат Ложь; 
	КонецЕсли;
	
	ЗапросАДО.CommandText = "SELECT j.LEDGERVOUCHER
	|	, j.INVOICEDATE
	|	, l.DIMENSION
	|FROM        [VENDINVOICEJOUR] j (NOLOCK)
	|INNER JOIN INVENTLOCATION l (NOLOCK)
	|      ON    l.DATAAREAID = j.DATAAREAID
	|      AND   l.INVENTLOCATIONID = j.INVENTLOCATIONID
	|WHERE       j.DATAAREAID = 'dat'
	|      AND   j.INVOICEDATE >= '20120401'
	|      AND   j.LEDGERVOUCHER IN
	|(" + СписокВаучеров + ")
	|";
	
	//Выполнение запроса
	Попытка
		Выборка = ЗапросАДО.Execute(); 
	Исключение
		Сообщение	= "Не удалось выполнить Запрос:
		|" + ЗапросАДО.CommandText;
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
		СделатьЗаписьЖР(Сообщение);
		Возврат Ложь;
	КонецПопытки;
		
	Отбор = Новый Структура("Ваучер");
	
	Пока Не Выборка.EOF() Цикл 
		Отбор.Ваучер			= Выборка.Fields("LEDGERVOUCHER").Value;
		НайденныеСтроки = ТЗДокументы.НайтиСтроки(Отбор);
		Для Каждого СтрокаВаучер из НайденныеСтроки Цикл 
			СтрокаВаучер.ВаучерАкс	= Выборка.Fields("DIMENSION").Value;
		КонецЦикла;
		Выборка.MoveNext(); 
	КонецЦикла;	
	
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьНастройки()
	
	Запрос = Новый Запрос;
	
	//Проверка наличия групп в регистре, если их нет, то добавляются
	
	Запрос.Текст = "ВЫБРАТЬ
	|	""ПараметрыЗагрузкиАксапты"" КАК Группа,
	|	""Начало Периода"" КАК ИмяНастройки,
	|	ДАТАВРЕМЯ(2011, 1, 1) КАК Значение
	|ПОМЕСТИТЬ ВТ_ПроверяемыеНастройки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ПараметрыЗагрузкиАксапты"",
	|	""Конец Периода"",
	|	ДАТАВРЕМЯ(2011, 12, 31)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ПараметрыЗагрузкиАксапты"",
	|	""Порция"",
	|	""5000""
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""НастройкиРабочейБазы"",
	|	""РБСтрокаСоединения"",
	|	""Srvr=""""1c8-app1"""";Ref=""""EIS"""";""
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""НастройкиРабочейБазы"",
	|	""РБАдресСервера"",
	|	""New-sql""
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
		
	// Параметры подключения и почтовые параметры
	Запрос.Текст = "ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа В (&Группы)";
	
	Группы	= Новый Массив;
	Группы.Добавить("ПараметрыСоединенияSQL");
	Группы.Добавить("ПочтовыеПараметры");
	Группы.Добавить("Организации");
	Группы.Добавить("Предопределенные группы");
	Группы.Добавить("ПараметрыЗагрузкиАксапты");
	Группы.Добавить("НастройкиРабочейБазы");
	Запрос.УстановитьПараметр("Группы", Группы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ИмяНастройки = "ИмяПользователя" Тогда
			Пользователь = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Пароль" Тогда
			Пароль = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "АдресСервера" Тогда
			Адрес = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "БазаДанных" Тогда
			БазаДанных = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "ПутьСохраненияОтчетовОбОшибках" Тогда
			мПутьСохраненияОтчетовОбОшибках = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Таймаут" Тогда
			мТаймаут = Выборка.Значение;
			
			//Почтовые параметры
		ИначеЕсли Выборка.ИмяНастройки = "СерверSMTP" Тогда
			мСерверSMTP = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "ПортSMTP" Тогда
			мПортSMTP = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "ПользовательSMTP" Тогда
			мПользовательSMTP = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "ПарольSMTP" Тогда
			мПарольSMTP = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Отправитель" Тогда
			мОтправитель = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Кому" Тогда
			мКому = Выборка.Значение;
			//ИначеЕсли Выборка.ИмяНастройки = "Аутентификация" Тогда
			//	мАутентификация = Выборка.Значение;
			
			// Организации
		ИначеЕсли Выборка.ИмяНастройки = "Организация ОКЕЙ" Тогда
			Организация = Выборка.Значение;
			
			// Предопределенные группы
		ИначеЕсли Выборка.ИмяНастройки = "Группа контрагентов Поставщики" Тогда
			мПоставщики = Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Группа контрагентов Покупатели" Тогда
			мПокупатели = Выборка.Значение;
			
			// Параметры загрузки из аксапты
		ИначеЕсли Выборка.ИмяНастройки = "Порция" Тогда
			Порция 		= Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Конец Периода" Тогда
			КонПериода 	= Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "Начало Периода" Тогда
			НачПериода 	= Выборка.Значение;
			
			//Парамеры рабочей базы 
		ИначеЕсли Выборка.ИмяНастройки = "РБСтрокаСоединения" Тогда
			РБСтрокаСоединения 	= Выборка.Значение;
		ИначеЕсли Выборка.ИмяНастройки = "РБАдресСервера" Тогда
			РБАдресСервера 	= Выборка.Значение;
			
		КонецЕсли;
	КонецЦикла;
	
	
	Запрос.Текст			= "ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа В(&СписокНастроек)";
	
	СписокНастроек			= Новый Массив;
	СписокНастроек.Добавить("ПараметрыЗагрузкиАксапты");
	Запрос.УстановитьПараметр("СписокНастроек", СписокНастроек);
	
	ТЗНастройки 			= Запрос.Выполнить().Выгрузить();
	
	Отказ					= Ложь;
	ОпределитьНастройку(ТЗНастройки, "Начало Периода", НачалоПериода);
	ОпределитьНастройку(ТЗНастройки, "Конец Периода", КонецПериода);
	
КонецПроцедуры

//Создать объект ADODB.Connection 
//Возврат: 
//   OLE - объект соединение или Неопределено 
Функция СоздатьСоединениеАДО()  
	Перем СоединениеАДО; 
	Попытка 
		СоединениеАДО = Новый COMОбъект("ADODB.Connection"); 
	Исключение 
		#Если Клиент Тогда 
			Сообщить("Не удалось создать объект ""ADODB.Connection""", СтатусСообщения.Важное); 
		#КонецЕсли 
		Возврат Неопределено; 
	КонецПопытки; 
	//СоединениеАДО.ConnectionTimeOut = 20; 
	//СоединениеАДО.ConnectionTimeOut = 600; 
	//СоединениеАДО.CommandTimeOut = 600; 
	//СоединениеАДО.CursorLocation       = 3; 
	Возврат СоединениеАДО; 
КонецФункции //СоздатьСоединениеАДО() 

//Создать объект ADODB.Command 
//Возврат: 
//   OLE - объект запрос или Неопределено 
Функция СоздатьЗапросАДО()  
	Перем ЗапросАДО; 
	Попытка 
		ЗапросАДО = Новый COMОбъект("ADODB.Command");
		ЗапросАДО.CommandTimeout = ?( (НЕ ЗначениеЗаполнено(мТаймаут)) ИЛИ мТаймаут=0, 600, мТаймаут);
	Исключение 
		#Если Клиент Тогда 
			Сообщить("Не удалось создать объект ""ADODB.Command""", СтатусСообщения.Важное); 
		#КонецЕсли 
		Возврат Неопределено; 
	КонецПопытки; 
	Возврат ЗапросАДО; 
КонецФункции //СоздатьЗапросАДО() 

//СоединениеАДО (OLE) - соединение 
//ЗапросАДО (OLE)      - запрос 
//Возврат: 
//   Булево - удачно, нет 
Функция ПодключитьсяАДОкБД(СоединениеАДО, ЗапросАДО)
	
	СтрокаСоединения = "driver={SQL Server};server="+Адрес+";uid="+Пользователь+";pwd="+Пароль+";Database="+БазаДанных; 
	//СтрокаСоединения = "driver=SQLOLEDB.1;server="+Адрес+";uid="+Пользователь+";pwd="+Пароль+";Database="+БазаДанных +";Connection Timeout=300"; 
	
	
	Попытка
		СоединениеАДО.ConnectionTimeOut = ?( (НЕ ЗначениеЗаполнено(мТаймаут)) ИЛИ мТаймаут=0, 600, мТаймаут);
		//СоединениеАДО.CommandTimeOut = 600;
		СоединениеАДО.Open(СтрокаСоединения); 
	Исключение 
		Сообщить("Не удалось установить соединение с базой данных", СтатусСообщения.Важное); 
		Возврат Ложь; 
	КонецПопытки; 
	
	ЗапросАДО.ActiveConnection = СоединениеАДО; 
	
	Возврат Истина; 
	
КонецФункции // ПодключитьсяАДОкБД()

Процедура СопоставлениеАналитики() Экспорт
	
	ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Сопоставление аналитики",, Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	бит_ок_СопоставлениеАналитики.КодАналитикиАксапты,
	|	бит_ок_СопоставлениеАналитики.Аналитика1С
	|ИЗ
	|	РегистрСведений.бит_ок_СопоставлениеАналитики КАК бит_ок_СопоставлениеАналитики
	|ГДЕ
	|	бит_ок_СопоставлениеАналитики.СчетАксапты = ""91""
	|	И бит_ок_СопоставлениеАналитики.КодАналитикиАксапты В(&КодАналитикиАксапты)";
	
	Запрос.УстановитьПараметр("КодАналитикиАксапты", ТЗДокументы.ВыгрузитьКолонку("ВаучерАкс"));
	
	ТЗРезультат = Запрос.Выполнить().Выгрузить();
	Отбор = Новый Структура("КодАналитикиАксапты");
	
	Для Каждого СтрокаДок из ТЗДокументы Цикл
		Отбор.КодАналитикиАксапты	= СтрокаДок.ВаучерАкс;
		НайденныеСтроки 			= ТЗРезультат.НайтиСтроки(Отбор);
		Для Каждого СтрокаВаучер из НайденныеСтроки Цикл 
			СтрокаДок.Аналитика1С	= СтрокаВаучер.Аналитика1С;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура ЗаписатьИзменения() Экспорт

	РазмерТранзакции		= 2000;
	СтрокТранзакции			= 1;
	ВсегоСтрок				= ТЗДокументы.Количество();
	Инд						= 1;
	НаборЗаписей			= РегистрыНакопления.бит_ок_ОборотыАксапты.СоздатьНаборЗаписей();
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-26 (#ПроектИнтеграцияАксапта12)
	НаборЗаписей12			= РегистрыНакопления.бит_ок_ОборотыАксапты12.СоздатьНаборЗаписей();
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-26 (#ПроектИнтеграцияАксапта12)
	
	НачатьТранзакцию();
	
	Для Каждого СтрокаДок из ТЗДокументы Цикл 
		
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Записывается строка " + Инд + " из " + ВсегоСтрок,, Истина);
		Инд					= Инд + 1;
		
		ДокОбъект			= СтрокаДок.Ссылка.ПолучитьОбъект();
		Если СтрокаДок.СчетДт = "91.02" Тогда 
			ДокОбъект.ОборотыАксапты[СтрокаДок.НомерСтроки - 1].Субконто1СДт1 = СтрокаДок.Аналитика1С;
		ИначеЕсли СтрокаДок.СчетКт = "91.02" Тогда 
			ДокОбъект.ОборотыАксапты[СтрокаДок.НомерСтроки - 1].Субконто1СКт1 = СтрокаДок.Аналитика1С;
		КонецЕсли;
		ДокОбъект.Записать();
		
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-26 (#ПроектИнтеграцияАксапта12)
		Если ТипЗнч(СтрокаДок.Ссылка) = Тип("ДокументСсылка.бит_ок_ОперацияАксапты12") Тогда
			
			НаборЗаписей12.Отбор.Регистратор.Значение	= СтрокаДок.Ссылка;
			НаборЗаписей12.Прочитать();
			Если НаборЗаписей12[СтрокаДок.НомерСтроки - 1].СчетДт = "91.02" Тогда 
				НаборЗаписей12[СтрокаДок.НомерСтроки - 1].Субконто1СДт1 = СтрокаДок.Аналитика1С;
			ИначеЕсли НаборЗаписей12[СтрокаДок.НомерСтроки - 1].СчетКт = "91.02" Тогда 
				НаборЗаписей12[СтрокаДок.НомерСтроки - 1].Субконто1СКт1 = СтрокаДок.Аналитика1С;
			КонецЕсли;
			НаборЗаписей12.Записать();
			
		Иначе
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-26 (#ПроектИнтеграцияАксапта12)
		
			НаборЗаписей.Отбор.Регистратор.Значение	= СтрокаДок.Ссылка;
			НаборЗаписей.Прочитать();
			Если НаборЗаписей[СтрокаДок.НомерСтроки - 1].СчетДт = "91.02" Тогда 
				НаборЗаписей[СтрокаДок.НомерСтроки - 1].Субконто1СДт1 = СтрокаДок.Аналитика1С;
			ИначеЕсли НаборЗаписей[СтрокаДок.НомерСтроки - 1].СчетКт = "91.02" Тогда 
				НаборЗаписей[СтрокаДок.НомерСтроки - 1].Субконто1СКт1 = СтрокаДок.Аналитика1С;
			КонецЕсли;
			НаборЗаписей.Записать();
			
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-26 (#ПроектИнтеграцияАксапта12)
		КонецЕсли;
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-26 (#ПроектИнтеграцияАксапта12)
		
		Если СтрокТранзакции >= РазмерТранзакции Тогда
			ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Фиксация транзакции");
			ЗафиксироватьТранзакцию();
			СтрокТранзакции	= 0;
			НачатьТранзакцию();
		КонецЕсли;
		СтрокТранзакции		= СтрокТранзакции + 1;
		
	КонецЦикла;
	
	Если ТранзакцияАктивна() Тогда 
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Фиксация транзакции");
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры

Процедура ОпределитьНастройку(ТЗНастройки, ИмяНастройки, Параметр)
	
	НайденнаяСтрока			= ТЗНастройки.Найти(ИмяНастройки);
	Если НайденнаяСтрока = Неопределено Тогда 
		Сообщение			= "В Настройках механизма импорта данных не найдена настройка " + ИмяНастройки;
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(, Сообщение);		
		СделатьЗаписьЖР(Сообщение);
		Отказ				= Истина;
	Иначе
		Параметр			= НайденнаяСтрока.Значение;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура СделатьЗаписьЖР(Сообщение)

	#Если Сервер Тогда
		ЗаписьЖурналаРегистрации("Объект в сторно закупок. Обработка" 
		,УровеньЖурналаРегистрации.Информация 
		,
		,
		,Сообщение);
	#КонецЕсли 

КонецПроцедуры

ЗаполнитьНастройки();
