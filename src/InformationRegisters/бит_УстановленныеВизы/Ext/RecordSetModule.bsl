#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных
	
Перем мТаблицаИзменений; // Служит для передачи изменений между обработчиками.
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-27 (#3997) 
Перем мТаблицаИзмененийФизЛицЭД;
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-27 (#3997) 
 
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-02-10 (#3997)
	мТаблицаИзмененийФизЛицЭД = Новый ТаблицаЗначений;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-02-10 (#3997) 
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-09-20 (#3482)
	Если Количество() = 1 
	   И ЭтотОбъект[0].ФизическоеЛицо = ПредопределенноеЗначение("Справочник.бит_БК_Инициаторы.СБ_НеЗадан")
	   И Не ЗначениеЗаполнено(ЭтотОбъект[0].Решение)
	Тогда 
		//для единственной визы в алгоритме с инициатором "Не задан" устанавливаем решение Согласовано - в частности, 
		//если виза утверждающая, то документ по типовому алгоритму будет переведен в статус "Утвержден"
		ЭтотОбъект[0].Решение = ПредопределенноеЗначение("Справочник.бит_ВидыРешенийСогласования.Согласовано");
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-12-12 (#3574)
		ЭтотОбъект[0].ДатаУстановки = ТекущаяДата();
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-12-12 (#3574)
		
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-09-20 (#3482)
		
	Если ЭтотОбъект.Количество()>0 Тогда
		
		ТаблицаЗаписей = ЭтотОбъект.Выгрузить();
		
		Запрос = Новый Запрос;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-27 (#3997)
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-27 (#3997)
		Запрос.УстановитьПараметр("ТаблицаЗаписей",ТаблицаЗаписей);
		Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаЗаписей.Объект,
		|	ТаблицаЗаписей.Виза,
		|	ТаблицаЗаписей.ИД,
		|	ТаблицаЗаписей.Решение,
		|	ТаблицаЗаписей.Пользователь,
		|	ТаблицаЗаписей.Комментарий,
		|	ТаблицаЗаписей.ДатаКрайняя,
		|	ТаблицаЗаписей.ДатаУстановки,
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-27 (#3997)
		|	ТаблицаЗаписей.ФизическоеЛицо,
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-27 (#3997)
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-15 (#2873)
		|	ТаблицаЗаписей.ДобавленаВручную
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-15 (#2873)					   
		|ПОМЕСТИТЬ ТаблицаЗаписей
		|ИЗ
		|	&ТаблицаЗаписей КАК ТаблицаЗаписей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаЗаписей.Объект,
		|	ТаблицаЗаписей.Виза,
		|	ТаблицаЗаписей.ИД,
		|	ТаблицаЗаписей.Пользователь,
		|	ТаблицаЗаписей.Комментарий,
		|	ТаблицаЗаписей.ДатаКрайняя,
		|	ТаблицаЗаписей.ДатаУстановки,
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-15 (#2873)
		|	ТаблицаЗаписей.ДобавленаВручную,
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-15 (#2873)					   
		|	ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) КАК РешениеНачальное,
		|	ТаблицаЗаписей.Решение КАК РешениеКонечное
		|ИЗ
		|	ТаблицаЗаписей КАК ТаблицаЗаписей
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_УстановленныеВизы КАК ТаблицаДо
		|		ПО ТаблицаЗаписей.Объект = ТаблицаДо.Объект
		|			И ТаблицаЗаписей.ИД = ТаблицаДо.ИД
		|			И ТаблицаЗаписей.Виза = ТаблицаДо.Виза
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-15 (#2873)
		|            И ТаблицаЗаписей.ДобавленаВручную = ТаблицаДо.ДобавленаВручную
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-15 (#2873)					   
		|ГДЕ
		|	ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) <> ТаблицаЗаписей.Решение
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-27 (#3997)
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////		
		//|УНИЧТОЖИТЬ ТаблицаЗаписей";
		|";
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-27 (#3997)
		
		мТаблицаИзменений = Запрос.Выполнить().Выгрузить();		
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-27 (#3997)
		ОбъектСсылка = ЭтотОбъект[0].Объект;
		Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий")
			И Не ОбъектСсылка.Ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Новый") Тогда
				 
			Запрос.УстановитьПараметр("Объект", ОбъектСсылка);
			
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТаблицаДо.Объект КАК Объект,
			|	ТаблицаДо.Виза КАК Виза,
			|	ТаблицаДо.ИД КАК ИД,
			|	ТаблицаДо.Решение КАК Решение,
			|	ТаблицаДо.Пользователь КАК Пользователь,
			|	ТаблицаДо.ФизическоеЛицо КАК ФизическоеЛицо
			|ПОМЕСТИТЬ ТаблицаДо
			|ИЗ
			|	РегистрСведений.бит_УстановленныеВизы КАК ТаблицаДо
			|ГДЕ
			|	ТаблицаДо.Объект = &Объект
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЕСТЬNULL(ТаблицаЗаписей.Объект, ТаблицаДо.Объект) КАК Объект,
			|	ЕСТЬNULL(ТаблицаЗаписей.Виза, ТаблицаДо.Виза) КАК Виза,
			|	ЕСТЬNULL(ТаблицаЗаписей.ИД, ТаблицаДо.ИД) КАК ИД,
			|	ЕСТЬNULL(ТаблицаЗаписей.ДобавленаВручную, Ложь) КАК ДобавленаВручную,
			|	ТаблицаЗаписей.Пользователь КАК Пользователь,
			|	ТаблицаЗаписей.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ТаблицаЗаписей.Решение КАК Решение,
			|	ТаблицаДо.Пользователь КАК ПользовательДо,
			|	ТаблицаДо.ФизическоеЛицо КАК ФизическоеЛицоДо,
			|	ТаблицаДо.Решение КАК РешениеДо
			|ИЗ
			|	ТаблицаЗаписей КАК ТаблицаЗаписей
			|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаДо КАК ТаблицаДо
			|		ПО ТаблицаЗаписей.ИД = ТаблицаДо.ИД
			|			И ТаблицаЗаписей.Виза = ТаблицаДо.Виза
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ТаблицаЗаписей";
			мТаблицаИзмененийФизЛицЭД = Запрос.Выполнить().Выгрузить();
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-27 (#3997)
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4117)
		Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий") Тогда
			Для Каждого СтрокаРегистра Из ЭтотОбъект Цикл

				Если Не ЗначениеЗаполнено(СтрокаРегистра.Решение) 
					И СтрокаРегистра.ФизическоеЛицо = ПредопределенноеЗначение("Справочник.бит_БК_Инициаторы.СБ_НеЗадан") Тогда				
					СтрокаРегистра.Решение = ПредопределенноеЗначение("Справочник.бит_ВидыРешенийСогласования.Согласовано");
					СтрокаРегистра.ДатаУстановки	= ТекущаяДата();
					СтрокаРегистра.Комментарий		= "Инициатор <Не задан> установлен пользователем :" + бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
					СтрокаРегистра.Пользователь 	= ""; 
				КонецЕсли;
					
			КонецЦикла;		
		КонецЕсли;		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4117) 
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-08-16 (#2880)		
		ЭтоОчистка = мТаблицаИзменений.Количество() = 
		мТаблицаИзменений.Скопировать(Новый Структура("РешениеКонечное",ПредопределенноеЗначение("Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка"))).Количество() И
		(НЕ ДополнительныеСвойства.Свойство("ПерезаписатьПринудительно") ИЛИ НЕ ДополнительныеСвойства.ПерезаписатьПринудительно);
		
		Если ЭтоОчистка Тогда 					
			Возврат;
		КонецЕсли;						
		// Определим, какие визы доступны исходя из структуры алгоритма.
		ДатаУстановкиВизы = ТекущаяДата();
		ДатаКрайняя = ДатаУстановкиВизы + 2*86400;
		Алгоритм = Справочники.бит_уп_Алгоритмы.ПустаяСсылка();
		
		Для каждого СтрокаВизы Из ТаблицаЗаписей Цикл
			
			Если ЗначениеЗаполнено(СтрокаВизы.Алгоритм) Тогда
				
				Алгоритм = СтрокаВизы.Алгоритм;
				Прервать;
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		ТаблицаЗаписей.Колонки.Добавить("Реквизит4", Новый ОписаниеТипов("Строка"));
		ТаблицаЗаписей.ЗаполнитьЗначения("ИСТИНА"  , "Реквизит4");
		//1С-ИжТиСи, Кондратьев, 03.2020, обновление (
		ТаблицаЗаписей.Колонки.Добавить("ДоступностьВизы", Новый ОписаниеТипов("Булево"));
		ТаблицаЗаписей.ЗаполнитьЗначения("ИСТИНА"  , "ДоступностьВизы");
		//1С-ИжТиСи, Кондратьев, 03.2020, обновление )
		
		флВыполнятьПоэтапно = бит_уп_Сервер.ВыполнятьАлгоритмПоэтапно(Алгоритм);		
		
		Если НЕ ДополнительныеСвойства.Свойство("РанееПринятыеРешения") Тогда 
			
			РанееПринятыеРешения = ТаблицаЗаписей.Скопировать(,"ФизическоеЛицо,Решение,Пользователь");
			РанееПринятыеРешения.Свернуть("ФизическоеЛицо,Решение,Пользователь");
			ИндексРешений = РанееПринятыеРешения.Количество()-1;
			Пока ИндексРешений >=0 Цикл 
				Если Не ЗначениеЗаполнено(РанееПринятыеРешения[ИндексРешений].ФизическоеЛицо) ИЛИ
					Не ЗначениеЗаполнено(РанееПринятыеРешения[ИндексРешений].Решение) ИЛИ
					Не ЗначениеЗаполнено(РанееПринятыеРешения[ИндексРешений].Пользователь)
					Тогда 
					РанееПринятыеРешения.Удалить(ИндексРешений); 				
				КонецЕсли;
				ИндексРешений = ИндексРешений - 1;
			КонецЦикла;
		Иначе
			РанееПринятыеРешения = ДополнительныеСвойства.РанееПринятыеРешения;
		КонецЕсли;
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-10-25 (#2921)
		//ТаблицаЗаписей = ДополнитьТаблицуЗаписей(ТаблицаЗаписей, Алгоритм, ДатаУстановкиВизы, Отбор.Объект.Значение, РанееПринятыеРешения, флВыполнятьПоэтапно,Неопределено);
		//Заменено на:
		ТаблицаЗаписей = РегистрыСведений.бит_УстановленныеВизы.ДополнитьТаблицуЗаписей(ТаблицаЗаписей, Алгоритм, ДатаУстановкиВизы, Отбор.Объект.Значение, РанееПринятыеРешения, флВыполнятьПоэтапно,Неопределено);
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-10-25 (#2921)					
		Загрузить(ТаблицаЗаписей);
		
		//Актуализируем таблицу изменений
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТаблицаЗаписей",ТаблицаЗаписей);
		Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаЗаписей.Объект,
		|	ТаблицаЗаписей.Виза,
		|	ТаблицаЗаписей.ИД,
		|	ТаблицаЗаписей.Решение,
		|	ТаблицаЗаписей.Пользователь,
		|	ТаблицаЗаписей.Комментарий,
		|	ТаблицаЗаписей.ДатаКрайняя,		
		|	ТаблицаЗаписей.ДатаУстановки,
		|	ТаблицаЗаписей.ДобавленаВручную
		|ПОМЕСТИТЬ ТаблицаЗаписей
		|ИЗ
		|	&ТаблицаЗаписей КАК ТаблицаЗаписей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаЗаписей.Объект,
		|	ТаблицаЗаписей.Виза,
		|	ТаблицаЗаписей.ИД,
		|	ТаблицаЗаписей.Пользователь,
		|	ТаблицаЗаписей.Комментарий,
		|	ТаблицаЗаписей.ДатаКрайняя,
		|	ТаблицаЗаписей.ДатаУстановки,
		|	ТаблицаЗаписей.ДобавленаВручную,
		|	ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) КАК РешениеНачальное,
		|	ТаблицаЗаписей.Решение КАК РешениеКонечное
		|ИЗ
		|	ТаблицаЗаписей КАК ТаблицаЗаписей
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_УстановленныеВизы КАК ТаблицаДо
		|		ПО ТаблицаЗаписей.Объект = ТаблицаДо.Объект
		|			И ТаблицаЗаписей.ИД = ТаблицаДо.ИД
		|			И ТаблицаЗаписей.Виза = ТаблицаДо.Виза
		|			И ТаблицаЗаписей.ДобавленаВручную = ТаблицаДо.ДобавленаВручную		
		|ГДЕ
		|	ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) <> ТаблицаЗаписей.Решение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаЗаписей";
	
		мТаблицаИзменений = Запрос.Выполнить().Выгрузить();
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-08-16 (#2880)
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("бит_ИспользоватьМеханизмОповещений") Тогда
		ТаблицаОповещений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_фн_АктивныеОповещения");
	Иначе
		ТаблицаОповещений = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(мТаблицаИзменений) = Тип("ТаблицаЗначений") Тогда
		Для каждого СтрокаТаблицы ИЗ мТаблицаИзменений Цикл
			СохранитьИсторию(СтрокаТаблицы);
			Если Не ТаблицаОповещений = Неопределено Тогда
				ЗарегистрироватьСобытиеПринятоРешение(СтрокаТаблицы,ТаблицаОповещений);
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли; 
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-14 (#2873)
	//Если Не ТаблицаОповещений = Неопределено Тогда
	//	ЗарегистрироватьСобытиеДоступныеВизы(ТаблицаОповещений); 
	//КонецЕсли; 
	Если НЕ ДополнительныеСвойства.Свойство("бит_ОтключитьРегистрациюОповещений") ИЛИ 
		 НЕ ДополнительныеСвойства.бит_ОтключитьРегистрациюОповещений
		Тогда
		Если Не ТаблицаОповещений = Неопределено Тогда
			ЗарегистрироватьСобытиеДоступныеВизы(ТаблицаОповещений); 
		КонецЕсли;
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-14 (#2873)
	
	//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-26 (#3997) 
	//ок_ОбменСКонтрагентамиВнутренний.ОтразитьРезультатВизыСогласованияВходящегоЭлектронногоДокумента(ЭтотОбъект);
				
	Если (Не ДополнительныеСвойства.Свойство("ПерезаписатьПринудительно") ИЛИ НЕ ДополнительныеСвойства.ПерезаписатьПринудительно)
		И мТаблицаИзмененийФизЛицЭД.Количество() > 0 Тогда
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
		ОбъектВизирования = ЭтотОбъект.Отбор.Объект.Значение;
		ВизаИнициатор = ПредопределенноеЗначение("Справочник.бит_Визы.ок_Инициатор");
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054) 
		
		ШаблонСообщенияОтмена = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Шаблон замены или удаления согласующего лица входящего электронного документа");			
		Если Не ЗначениеЗаполнено(ШаблонСообщенияОтмена) Тогда
			ЗаписьЖурналаРегистрации("ЗаписьУстановленныхВиз",УровеньЖурналаРегистрации.Ошибка,,,"Не заполнена настройка: Согласование по почте/Шаблон замены или удаления согласующего лица входящего электронного документа");		
		КонецЕсли;
		
		ШаблонСогласованияФД = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Шаблон согласования входящего электронного документа ФД");	
		Если Не ЗначениеЗаполнено(ШаблонСогласованияФД) Тогда		
			ЗаписьЖурналаРегистрации("ЗаписьУстановленныхВиз",УровеньЖурналаРегистрации.Ошибка,,,"Не заполнена настройка: Согласование по почте/Шаблон согласования входящего электронного документа ФД");		
		КонецЕсли;  
		
		ШаблонСогласования = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Шаблон согласования входящего электронного документа");	
		Если Не ЗначениеЗаполнено(ШаблонСогласования) Тогда		
			ЗаписьЖурналаРегистрации("ЗаписьУстановленныхВиз",УровеньЖурналаРегистрации.Ошибка,,,"Не заполнена настройка: Согласование по почте/Шаблон согласования входящего электронного документа");		
		КонецЕсли;
		   
		ШаблонСогласования_ТребуетсяЗаявка1С = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Шаблон согласования входящего электронного документа (Требуется заявка 1С)");	
		Если Не ЗначениеЗаполнено(ШаблонСогласования_ТребуетсяЗаявка1С) Тогда
			ЗаписьЖурналаРегистрации("ЗаписьУстановленныхВиз",УровеньЖурналаРегистрации.Ошибка,,,"Не заполнена настройка: Согласование по почте/Шаблон согласования входящего электронного документа (Требуется заявка 1С)");		
		КонецЕсли;
	
		Для каждого СтрокаТаблицыИзменений Из мТаблицаИзмененийФизЛицЭД Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицыИзменений.ФизическоеЛицоДО) Тогда
				
				Если СтрокаТаблицыИзменений.ДобавленаВручную 
					И ЗначениеЗаполнено(СтрокаТаблицыИзменений.ФизическоеЛицо) 
					И НЕ ЗначениеЗаполнено(СтрокаТаблицыИзменений.Решение) Тогда
					
					Если СтрокаТаблицыИзменений.Виза = ПредопределенноеЗначение("Справочник.бит_Визы.ок_ФД") Тогда
						ШаблонНаОтправку = ШаблонСогласованияФД;
					Иначе
						ШаблонНаОтправку = ШаблонСогласования;
					КонецЕсли;					
					
					СообщениеОбОшибке = "";
			
					Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаТаблицыИзменений.Объект,СтрокаТаблицыИзменений.Виза,,СообщениеОбОшибке,,ШаблонНаОтправку,,СтрокаТаблицыИзменений.ФизическоеЛицо);
					Если НЕ Результат Тогда	
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
						ЗаписьЖурналаРегистрации("ОтправкаПисем",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);		
					КонецЕсли;
				КонецЕсли;
				
				Продолжить;
			КонецЕсли;
						
			Если СтрокаТаблицыИзменений.ФизическоеЛицо <> СтрокаТаблицыИзменений.ФизическоеЛицоДО И НЕ ЗначениеЗаполнено(СтрокаТаблицыИзменений.РешениеДо) Тогда
					
				Если СтрокаТаблицыИзменений.Виза = ПредопределенноеЗначение("Справочник.бит_Визы.ок_ФД") Тогда
					ПолучательОтмены = "";
				Иначе
					ПолучательОтмены = СтрокаТаблицыИзменений.ФизическоеЛицоДО;	
				КонецЕсли;
				
				СообщениеОбОшибке = "";
		
				Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаТаблицыИзменений.Объект,СтрокаТаблицыИзменений.Виза,,СообщениеОбОшибке,,ШаблонСообщенияОтмена,,ПолучательОтмены);
				Если НЕ Результат Тогда	
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
					ЗаписьЖурналаРегистрации("ОтправкаПисем",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
				КонецЕсли;
				
				//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
	//			Если ЗначениеЗаполнено(СтрокаТаблицыИзменений.ФизическоеЛицо) И СтрокаТаблицыИзменений.Виза = ПредопределенноеЗначение("Справочник.бит_Визы.ок_ФД") Тогда
	//				
	//				СообщениеОбОшибке = "";					
	//				Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаТаблицыИзменений.Объект,СтрокаТаблицыИзменений.Виза,,СообщениеОбОшибке,,ШаблонСогласованияФД);
	//
	//				Если НЕ Результат Тогда	
	//					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
	//					ЗаписьЖурналаРегистрации("ОтправкаПисем",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
	//				КонецЕсли;
	//	
	//			КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицыИзменений.ФизическоеЛицо) И НЕ СтрокаТаблицыИзменений.ФизическоеЛицо = Справочники.бит_БК_Инициаторы.СБ_НеЗадан Тогда
					
					СообщениеОбОшибке = "";					
					Если СтрокаТаблицыИзменений.Виза = ПредопределенноеЗначение("Справочник.бит_Визы.ок_ФД") Тогда
						Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаТаблицыИзменений.Объект,СтрокаТаблицыИзменений.Виза,,СообщениеОбОшибке,,ШаблонСогласованияФД);	
					Иначе
						
						Если НЕ ОбъектВизирования.ок_ТребуетсяЗаявка1С Тогда
							ШаблонНаОтправку = ШаблонСогласования;	
						Иначе
							
							СтрокаИнициатора = ОбъектВизирования.Ок_Инициаторы.Найти(СтрокаТаблицыИзменений.ИД, "ИД"); 
							Если ЗначениеЗаполнено(СтрокаИнициатора) 
								И СтрокаИнициатора.ОтветственныйЗаНомерЗаявки Тогда
								ШаблонНаОтправку = ШаблонСогласования_ТребуетсяЗаявка1С;
							Иначе
								ШаблонНаОтправку = ШаблонСогласования;
							КонецЕсли;
																							
						КонецЕсли;		
						
						Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаТаблицыИзменений.Объект,СтрокаТаблицыИзменений.Виза,,СообщениеОбОшибке,,ШаблонНаОтправку,,СтрокаТаблицыИзменений.ФизическоеЛицо);

					КонецЕсли;
					
					Если НЕ Результат Тогда	
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
						ЗаписьЖурналаРегистрации("ОтправкаПисем",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
					КонецЕсли;

				КонецЕсли;	
				//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054) 
																				
			КонецЕсли;
			
		КонецЦикла;
				
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
		//Если ЭтотОбъект.Отбор.Найти("Объект") <> Неопределено Тогда
		//	ОбъектВизирования = ЭтотОбъект.Отбор.Объект.Значение;
		//	Если ЗначениеЗаполнено(ОбъектВизирования) И ТипЗнч(ОбъектВизирования) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий") Тогда
		//		
		//		ТаблицаДляСортировки = ЭтотОбъект.Выгрузить();
		//		ТаблицаДляСортировки.Сортировать("КодСортировки");
		//		ЭтотОбъект.Загрузить(ТаблицаДляСортировки);
		//	
		//		ДокументОбъект = ОбъектВизирования.ПолучитьОбъект();
		//		ВизаИнициатор = ПредопределенноеЗначение("Справочник.бит_Визы.ок_Инициатор");
		//		НомерСтроки = 0;
		//		ЕстьИзмененияВДокументе = Ложь;
		//		Для Каждого СтрокаРегистра Из ЭтотОбъект Цикл
		//			
		//			Если СтрокаРегистра.Виза = ВизаИнициатор Тогда
		//				
		//				Если НомерСтроки > ДокументОбъект.Ок_Инициаторы.Количество()-1 Тогда
		//					ЕстьИзмененияВДокументе = Истина;
		//					НовыйИнициатор = ДокументОбъект.Ок_Инициаторы.Добавить();
		//				    НовыйИнициатор.Инициатор = СтрокаРегистра.ФизическоеЛицо;
		//					НомерСтроки = НомерСтроки + 1;
		//					Продолжить;
		//				КонецЕсли;
		//				
		//				СтрокаИнициатора = ДокументОбъект.Ок_Инициаторы[НомерСтроки];
		//				Если СтрокаИнициатора.Инициатор <> СтрокаРегистра.ФизическоеЛицо Тогда				
		//					ЕстьИзмененияВДокументе = Истина;
		//					СтрокаИнициатора.Инициатор = СтрокаРегистра.ФизическоеЛицо;
		//					
		//					Если ОбъектВизирования.ок_ТребуетсяЗаявка1С И СтрокаИнициатора.ОтветственныйЗаНомерЗаявки Тогда
		//						ШаблонНаОтправку = ШаблонСогласования_ТребуетсяЗаявка1С;
		//					Иначе
		//						ШаблонНаОтправку = ШаблонСогласования;
		//					КонецЕсли;
		//					
		//					СообщениеОбОшибке = "";
		//					Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(ОбъектВизирования,ВизаИнициатор,,СообщениеОбОшибке,,ШаблонНаОтправку,,СтрокаИнициатора.Инициатор);
		//					Если НЕ Результат Тогда	
		//						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		//						ЗаписьЖурналаРегистрации("ОтправкаПисем",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
		//					КонецЕсли;
		//				
		//				КонецЕсли;
		//				
		//				НомерСтроки = НомерСтроки + 1;
		//			КонецЕсли;
		//			
		//		КонецЦикла;
		//		
		//		Если НомерСтроки > 0 Тогда
		//			Пока НомерСтроки <> ДокументОбъект.Ок_Инициаторы.Количество() Цикл
		//				ДокументОбъект.Ок_Инициаторы.Удалить(НомерСтроки);
		//				ЕстьИзмененияВДокументе = Истина;
		//			КонецЦикла;
		//		КонецЕсли;
		//						
		//		Если ЕстьИзмененияВДокументе Тогда
		//			ДокументОбъект.ОбменДанными.Загрузка = Истина;
		//			ДокументОбъект.Записать();
		//		КонецЕсли;
		//		
		//	КонецЕсли;
		//КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054)
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-26 (#3997) 
	//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтотОбъект.Количество()>0 Тогда
		
		ТаблицаЗаписей = ЭтотОбъект.Выгрузить();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТаблицаЗаписей",ТаблицаЗаписей);
		Запрос.Текст = "ВЫБРАТЬ
		               |	ТаблицаЗаписей.Объект КАК Объект,
		               |	ТаблицаЗаписей.Виза КАК Виза,
		               |	ТаблицаЗаписей.ИД КАК ИД,
		               |	ТаблицаЗаписей.Решение КАК Решение,
		               |	ТаблицаЗаписей.Пользователь КАК Пользователь,
		               |	ТаблицаЗаписей.Комментарий КАК Комментарий,
		               |	ТаблицаЗаписей.ДатаКрайняя КАК ДатаКрайняя,
		               |	ТаблицаЗаписей.ДатаУстановки КАК ДатаУстановки
		               |ПОМЕСТИТЬ ТаблицаЗаписей
		               |ИЗ
		               |	&ТаблицаЗаписей КАК ТаблицаЗаписей
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ТаблицаЗаписей.Объект КАК Объект,
		               |	ТаблицаЗаписей.Виза КАК Виза,
		               |	ТаблицаЗаписей.ИД КАК ИД,
		               |	ТаблицаЗаписей.Пользователь КАК Пользователь,
		               |	ТаблицаЗаписей.Комментарий КАК Комментарий,
		               |	ТаблицаЗаписей.ДатаКрайняя КАК ДатаКрайняя,
		               |	ТаблицаЗаписей.ДатаУстановки КАК ДатаУстановки,
		               |	ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) КАК РешениеНачальное,
		               |	ТаблицаЗаписей.Решение КАК РешениеКонечное
		               |ИЗ
		               |	ТаблицаЗаписей КАК ТаблицаЗаписей
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_УстановленныеВизы КАК ТаблицаДо
		               |		ПО ТаблицаЗаписей.Объект = ТаблицаДо.Объект
		               |			И ТаблицаЗаписей.ИД = ТаблицаДо.ИД
		               |			И ТаблицаЗаписей.Виза = ТаблицаДо.Виза
		               |ГДЕ
		               |	(ЕСТЬNULL(ТаблицаДо.Решение, ЗНАЧЕНИЕ(Справочник.бит_ВидыРешенийСогласования.ПустаяСсылка)) <> ТаблицаЗаписей.Решение
		               |			ИЛИ ЕСТЬNULL(ТаблицаДо.Комментарий, """") <> ТаблицаЗаписей.Комментарий)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |УНИЧТОЖИТЬ ТаблицаЗаписей";
					   
		мТаблицаИзменений = Запрос.Выполнить().Выгрузить();	
	
		Для каждого СтрокаТаблицы ИЗ мТаблицаИзменений Цикл

			Если ЗначениеЗаполнено(СтрокаТаблицы.РешениеКонечное)
				И ОпределитьНеобходимостьКомментарияЗадачи(СтрокаТаблицы) Тогда
		
				СтруктураОтбора = Новый Структура;
				СтруктураОтбора.Вставить("ИД", СтрокаТаблицы.ИД);
				СтруктураОтбора.Вставить("Виза", СтрокаТаблицы.Виза);
				СтруктураОтбора.Вставить("Объект", СтрокаТаблицы.Объект);
				
				НайденныеСтроки = ТаблицаЗаписей.НайтиСтроки(СтруктураОтбора);				
				Если НайденныеСтроки.Количество()>0 Тогда
					Индекс = ТаблицаЗаписей.Индекс(НайденныеСтроки[0]);
					ШаблонСообщения = НСтр("ru = 'Для принятия решения ""%1"" необходимо заполнить комментарий или создать задачу по данной визе.'");
					ШаблонСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтрокаТаблицы.РешениеКонечное);
								
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ШаблонСообщения,,"УстановленныеВизы["+Индекс+"].Комментарий",,Отказ);
				КонецЕсли;
				
			КонецЕсли;				
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура сохраняет историю изменения статусов.
// 
// Параметры:
//  Запись  - РегистрСведенийЗапис.бит_СтатусыОбъектов.
// 
Процедура СохранитьИсторию(СтрокаТаблицы)
	
	// Сохраним историю изменения статуса
	МенеджерЗаписи = РегистрыСведений.бит_ИсторияИзмененияВиз.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи,СтрокаТаблицы);
	МенеджерЗаписи.Период  = ?(ЗначениеЗаполнено(СтрокаТаблицы.ДатаУстановки),СтрокаТаблицы.ДатаУстановки,ТекущаяДата());
	Если НЕ ЗначениеЗаполнено(МенеджерЗаписи.Пользователь) Тогда
		МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли; 
	МенеджерЗаписи.Решение = СтрокаТаблицы.РешениеКонечное;
	
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось сохранить историю изменения решений по визе ""%1"". По причине: %2'");
		Кратко 		    = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Подробно 		= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Строка(СтрокаТаблицы.Виза), Кратко);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения); 
		
		ЗаписьЖурналаРегистрации("Визирование", УровеньЖурналаРегистрации.Ошибка,,, Подробно);
	КонецПопытки;
	
КонецПроцедуры // СохранитьИсторию()

// Процедура регистрирует события для последующих оповещений.
// 
// Параметры:
//  Запись            - РегистрСведенийЗапис.бит_СтатусыОбъектов
//  ТаблицаОповещений - ТаблицаЗначений.
// 
Процедура ЗарегистрироватьСобытиеПринятоРешение(Запись,ТаблицаОповещений)
	
	Если НЕ ЗначениеЗаполнено(Запись.Объект) Тогда
		Возврат;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Запись.РешениеКонечное) Тогда
		Возврат;
	КонецЕсли; 
	
	// Обработаем оповещения
	Если НЕ ТаблицаОповещений = Неопределено И НЕ ЭтотОбъект.ДополнительныеСвойства.Свойство("бит_ОтключитьРегистрациюОповещений") Тогда
		
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(Запись.Объект.Метаданные());
		
		Фильтр = Новый Структура;
		Фильтр.Вставить("ВидСобытия", 	 Перечисления.бит_фн_ВидыСобытийОповещений.ПринятоРешение);
		Фильтр.Вставить("ОбъектСистемы", ОбъектСистемы);
		
		ДоступныеОповещения = ТаблицаОповещений.НайтиСтроки(Фильтр);
		
		Для каждого СтрокаОповещения Из ДоступныеОповещения Цикл
			
			ВизаСоответствует = Ложь;
			// Проверим "быстрые" условия
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.Виза) 
			 ИЛИ СтрокаОповещения.Виза = Запись.Виза Тогда
				ВизаСоответствует = Истина;
			КонецЕсли; 
			
			РешениеСоответствует = Ложь;
			// Проверим "быстрые" условия
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.Решение) 
			 ИЛИ СтрокаОповещения.Решение = Запись.РешениеКонечное Тогда
				РешениеСоответствует = Истина;
			КонецЕсли; 
			
			УсловиеВыполнено = РешениеСоответствует И ВизаСоответствует;
			// Если задано пользовательское условие, проверим его.
			Если УсловиеВыполнено И ЗначениеЗаполнено(СтрокаОповещения.ПользовательскоеУсловие) Тогда
				
				КонтекстУсловия = Новый Структура("ТекущийОбъект, НаборВизы");
				КонтекстУсловия.Вставить("ТекущийОбъект",Запись.Объект);
				
				СтруктураОтбор = Новый Структура;
				СтруктураОтбор.Вставить("Объект",Запись.Объект);
				
				НаборВизы = бит_Визирование.ПрочитатьНаборВиз(СтруктураОтбор);
				КонтекстУсловия.Вставить("НаборВизы"    ,НаборВизы);
				
				УсловиеВыполнено = бит_уп_Сервер.ПроверитьПользовательскоеУсловие(
									СтрокаОповещения.ПользовательскоеУсловие,КонтекстУсловия);
			КонецЕсли; 
			
			Если УсловиеВыполнено Тогда
				
				бит_фн_ОповещенияСервер.ЗарегистрироватьСобытиеДляОповещений(Перечисления.бит_фн_ВидыСобытийОповещений.ПринятоРешение,
					СтрокаОповещения.Оповещение, Запись.Объект,,Запись.Виза,,Запись.РешениеКонечное, Запись.Комментарий);
				
			КонецЕсли;  // Событие соответствует отборам
		КонецЦикла; // По массиву оповещений
	КонецЕсли; // Есть оповещения, нужно выполнять регистрацию.
	
КонецПроцедуры // ЗарегистироватьСобытияОповещений()

Процедура ЗарегистрироватьСобытиеДоступныеВизы(ТаблицаОповещений)
	
	Если ЭтотОбъект.Количество() > 0 И ТипЗнч(ТаблицаОповещений) = Тип("ТаблицаЗначений") Тогда
		
		//Запись = ЭтотОбъект[0];
		ОбъектВизирования = Отбор.Объект.Значение;
		ОбъектСистемы 	  = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(ОбъектВизирования.Метаданные());
		ВыполнитьВФоне 	  = Ложь;
		
		// Кеширование результатов выполнения функций.
		ПользовательскиеУсловия = Новый Соответствие(); 
		
		Фильтр = Новый Структура;
		Фильтр.Вставить("ВидСобытия", Перечисления.бит_фн_ВидыСобытийОповещений.ДоступнаВиза);
		Фильтр.Вставить("ОбъектСистемы", ОбъектСистемы);
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-07 (#2939)
		//Имя переменной оставил прежним во избежание многочисленных правок в коде ниже
		//ДостуныеОповещения = ТаблицаОповещений.НайтиСтроки(Фильтр);
		//Индекс 			   = ДостуныеОповещения.ВГраница();	
		ДостуныеОповещения = ТаблицаОповещений.Скопировать(Фильтр);
		ТаблицаВизы = ЭтотОбъект.Выгрузить();
		Индекс = ДостуныеОповещения.Количество() - 1;
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-06 (#2939)
		Пока Индекс >= 0 Цикл
			
			СтрокаОповещения = ДостуныеОповещения[Индекс];
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-06 (#2939)
			Если ТаблицаВизы.Найти(СтрокаОповещения.Виза, "Виза") = Неопределено Тогда 
				ДостуныеОповещения.Удалить(Индекс);
			Иначе
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-06 (#2939)
			УсловиеВыполнено = Истина;
			
			Если ЗначениеЗаполнено(СтрокаОповещения.ПользовательскоеУсловие) Тогда
				
				РезультатИзКеша = ПользовательскиеУсловия.Получить(СтрокаОповещения.ПользовательскоеУсловие);
				Если РезультатИзКеша = Неопределено Тогда
					// Проверка пользовательского условия из оповещения.
					КонтекстУсловия = Новый Структура("ТекущийОбъект, Статус",
											ОбъектВизирования, Справочники.бит_СтатусыОбъектов.ПустаяСсылка());
					
					УсловиеВыполнено = бит_уп_Сервер.ПроверитьПользовательскоеУсловие(СтрокаОповещения.ПользовательскоеУсловие, 
											КонтекстУсловия);
											
					ПользовательскиеУсловия.Вставить(СтрокаОповещения.ПользовательскоеУсловие, УсловиеВыполнено);					
				Иначе	
					УсловиеВыполнено = РезультатИзКеша;
				КонецЕсли; 
				
				Если НЕ УсловиеВыполнено Тогда
					ДостуныеОповещения.Удалить(Индекс);
				КонецЕсли;
			КонецЕсли; 
			
			Если УсловиеВыполнено И СтрокаОповещения.ФоновыйРежим Тогда
				ВыполнитьВФоне = Истина;
			КонецЕсли;
			
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-06 (#2939)
			КонецЕсли;
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-06 (#2939)
			
			Индекс = Индекс - 1;
		КонецЦикла; 

		Если ДостуныеОповещения.Количество() > 0 Тогда
			
			//+СБ Пискунова #2691  15.02.2017 (Некорректно отрабатывал механизм доступности)
			ОтборКоличество = ЭтотОбъект.Отбор.Количество();
			Если ЭтотОбъект.Отбор.Виза.Использование = Истина Тогда
				Возврат;
			КонецЕсли;
			//+СБ Пискунова #2691
			
			// Получим общую таблицу точек алгоритма и виз.
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-06 (#2939)
			//Перенес выше
			//ТаблицаВизы          = ЭтотОбъект.Выгрузить();
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-06 (#2939)
			ТаблицаВизы.Колонки.Добавить("ДоступностьВизы", Новый ОписаниеТипов("Булево"));
			
			ТаблицаВизы.ЗаполнитьЗначения(Истина, "ДоступностьВизы");
			
			Если ВыполнитьВФоне Тогда
				
				МассивПараметров = Новый Массив;
				МассивПараметров.Добавить(ОбъектВизирования);
				МассивПараметров.Добавить(ТаблицаВизы);
				
				// Массив строк табличной части не удается передать в фоновое задание,
				// поэтому моделируем строки таб. части структурами.
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-07 (#2939)
				//// Массив строк табличной части не удается передать в фоновое задание,
				//// поэтому моделируем строки таб. части структурами.
				//МодельМассива = Новый Массив;
				//Для каждого СтрокаОповещение Из ДостуныеОповещения Цикл
				//	МодельСтроки = Новый Структура;
				//	МодельСтроки.Вставить("Виза"         , СтрокаОповещение.Виза);
				//	МодельСтроки.Вставить("ВидСобытия"   , СтрокаОповещение.ВидСобытия);
				//	МодельСтроки.Вставить("Оповещение"   , СтрокаОповещение.Оповещение);
				//	МодельМассива.Добавить(МодельСтроки);
				//КонецЦикла; 
				//
				//МассивПараметров.Добавить(МодельМассива);
				//Заменено на:
				//Передадим адрес временного хранилища таблицы значений
				МассивПараметров.Добавить(ПоместитьВоВременноеХранилище(ДостуныеОповещения));
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-07 (#2939)
		
				ТекФоновоеЗадание = ФоновыеЗадания.Выполнить("бит_фн_ОповещенияСервер.ЗарегистрироватьСобытиеДоступныеВизы"
																,МассивПараметров
																,
																,"Регистрация события ДоступнаВиза");

			Иначе	
				
				бит_фн_ОповещенияСервер.ЗарегистрироватьСобытиеДоступныеВизы(ОбъектВизирования, ТаблицаВизы, ДостуныеОповещения);
				
			КонецЕсли; 
		КонецЕсли; //  МассивОповещений не пустой
	КонецЕсли; // Набор записей не пустой
	
КонецПроцедуры // ОпределитьДоступныеВизы()

Функция ОпределитьНеобходимостьКомментарияЗадачи(СтрокаТаблицы)
	
	Возврат РегистрыСведений.бит_УстановленныеВизы.НуженКомментарий(СтрокаТаблицы);
	
КонецФункции

#КонецОбласти

#КонецЕсли
