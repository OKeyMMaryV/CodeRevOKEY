////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция УстановитьСоединение(Организация, ОписаниеОшибкиПодключения = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
		
	Результат = Истина;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
	Организация_ОкейЛоджистикс = бит_БК_Общий.ПолучитьЗначениеНастройкиМеханизмаИмпортаДанных("Организации", "Организация Лоджистикс");
	ИнтеграцияКонтрагентовИДоговоровВключена_МДМ = ок_ВыгрузкаВАксапту.ИнтеграцияКонтрагентовИДоговоровВключена_МДМ();
	Если Организация = Организация_ОкейЛоджистикс 
		И ИнтеграцияКонтрагентовИДоговоровВключена_МДМ Тогда
		ВнешнийИсточникиДанных = ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTAЛоджистикс;
	Иначе
		ВнешнийИсточникиДанных = ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA;
	КонецЕсли; 
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-01-29 (#3202)
	пСоединениеУстановлено = Ложь;
	Попытка
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-29 (#3202)
	    //ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
		//ПараметрыСоединения = ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA.ПолучитьОбщиеПараметрыСоединения();
		ПараметрыСоединения = ВнешнийИсточникиДанных.ПолучитьОбщиеПараметрыСоединения();
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
		ДанныеПараметровСоединения = ПолучитьПараметрыСоединения(Организация);
		ПараметрыСоединения.АутентификацияСтандартная = Истина;
		ПараметрыСоединения.ИмяПользователя = ДанныеПараметровСоединения.ИмяПользователя;
		ПараметрыСоединения.Пароль = ДанныеПараметровСоединения.Пароль;
		ПараметрыСоединения.СтрокаСоединения = ДанныеПараметровСоединения.СтрокаСоединения;
		ПараметрыСоединения.СУБД = ДанныеПараметровСоединения.СУБД;
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
		//ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA.УстановитьОбщиеПараметрыСоединения(ПараметрыСоединения);
		ВнешнийИсточникиДанных.УстановитьОбщиеПараметрыСоединения(ПараметрыСоединения);
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-01-29 (#3202)
		пСоединениеУстановлено = Истина;
	Исключение		
		пСоединениеУстановлено = Ложь;
	КонецПопытки;
	
	Если Не пСоединениеУстановлено Тогда 
		Попытка
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
			//ПараметрыСоединения = ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA.ПолучитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
			ПараметрыСоединения = ВнешнийИсточникиДанных.ПолучитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
			ДанныеПараметровСоединения = ПолучитьПараметрыСоединения(Организация);
			ПараметрыСоединения.АутентификацияСтандартная = Истина;
			ПараметрыСоединения.ИмяПользователя = ДанныеПараметровСоединения.ИмяПользователя;
			ПараметрыСоединения.Пароль = ДанныеПараметровСоединения.Пароль;
			ПараметрыСоединения.СтрокаСоединения = ДанныеПараметровСоединения.СтрокаСоединения;
			ПараметрыСоединения.СУБД = ДанныеПараметровСоединения.СУБД;
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
			//ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA.УстановитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя,ПараметрыСоединения);
			ВнешнийИсточникиДанных.УстановитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя,ПараметрыСоединения);
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
			пСоединениеУстановлено = Истина;
		Исключение
			пСоединениеУстановлено = Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Если Не пСоединениеУстановлено Тогда 
		Возврат Ложь;
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-29 (#3202)
	
	Попытка
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-05-21 (#МДМ)
		//ВнешниеИсточникиДанных.СБ_БанковскиеВыпискиAXAPTA.УстановитьСоединение();		
		ВнешнийИсточникиДанных.УстановитьСоединение();		
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-05-21 (#МДМ)
	Исключение
		
		ОписаниеОшибкиПодключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Результат = Ложь;
		
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Функция СоединениеКИсточникуСредствамиSQL(Организация) Экспорт
	
	ПараметрыСоединения = ПолучитьПараметрыСоединения(Организация);
	
	СтрокаСоединения = "driver={SQL Server};server="
					 + ПараметрыСоединения.Сервер
					 + ";uid="
					 + ПараметрыСоединения.ИмяПользователя
					 + ";pwd="
					 + ПараметрыСоединения.Пароль
					 + ";Database="
					 + ПараметрыСоединения.База; 
					 
	Соединение = Новый COMОбъект("ADODB.Connection"); 
	Соединение.Open(СтрокаСоединения); 
		
	Возврат Соединение;
	
КонецФункции 

Функция ОбъектЗапросSQL(Соединение) Экспорт 
	
	ОбъектЗапрос = Новый COMОбъект("ADODB.Command");
	ОбъектЗапрос.ActiveConnection = Соединение; 

	Возврат ОбъектЗапрос;
	
КонецФункции 

Функция ПолучитьПараметрыСоединения(Организация) Экспорт 
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИмяПользователя");
	Результат.Вставить("Пароль");
	Результат.Вставить("Сервер");
	Результат.Вставить("База");
	Результат.Вставить("СтрокаСоединения");
	Результат.Вставить("СУБД", "MSSQLServer");
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа = &Группа";
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Группа", ИмяГруппыХраненияНастроек(Организация));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ИмяНастройки = "ИмяПользователя" Тогда
			Результат.ИмяПользователя = Выборка.Значение;	
		ИначеЕсли Выборка.ИмяНастройки = "Пароль" Тогда
			Результат.Пароль = Выборка.Значение;	
		ИначеЕсли Выборка.ИмяНастройки = "Сервер" Тогда
			Результат.Сервер = Выборка.Значение;	
		ИначеЕсли Выборка.ИмяНастройки = "База" Тогда
			Результат.База = Выборка.Значение;	
		ИначеЕсли Выборка.ИмяНастройки = "СтрокаСоединения" Тогда
			Результат.СтрокаСоединения = Выборка.Значение;	
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции 

Функция ИмяГруппыХраненияНастроек(Организация) Экспорт 
	
	ПредопределенныеОрганизации = ПредопределенныеОрганизации();
	
	Если Организация = ПредопределенныеОрганизации["Организация ОКЕЙ"] Тогда
		Возврат "ПараметрыСоединенияAXAPTA_Окей";	
	ИначеЕсли Организация = ПредопределенныеОрганизации["Организация Лоджистикс"] Тогда
		Возврат "ПараметрыСоединенияAXAPTA_Окей_Лоджистик";	
	Иначе
		Возврат "";
	КонецЕсли; 
	
КонецФункции 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредопределенныеОрганизации()

	ПредопределенныеОрганизации = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа = &Группа";
	Запрос.УстановитьПараметр("Группа", "Организации");

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ПредопределенныеОрганизации;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ПредопределенныеОрганизации.Вставить(Выборка.ИмяНастройки, Выборка.Значение);
	КонецЦикла; 
	
	Возврат ПредопределенныеОрганизации;
	
КонецФункции // ()
