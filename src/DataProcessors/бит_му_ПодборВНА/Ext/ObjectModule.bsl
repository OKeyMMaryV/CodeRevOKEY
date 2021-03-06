#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция формирует структуру данных для добавления их в таб.часть документа владельца.
// 
Функция ПолучитьСтруктуруРезультатаВыбора(ДействиеВыбора = "Добавить", ИДСтроки = Неопределено) Экспорт
	
	Если ИДСтроки = Неопределено Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Выполнять", Истина);
		
		РезТаблица = ПереченьОбъектов.Выгрузить(СтруктураОтбора);
		
	Иначе
		
		ТекущаяСтрока = ПереченьОбъектов[ИДСтроки];
		
		РезТаблица = ПереченьОбъектов.Выгрузить();
		РезТаблица.Очистить(); 		
		
		НоваяСтрока = РезТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекущаяСтрока);
		
	КонецЕсли;
	
	СтруктураТаблиц = Новый Структура;
	
	Если ЗначениеЗаполнено(КорСчет) Тогда
		// ОКЕЙ Конаков Ю.М. (СофтЛаб) Начало 2021-10-20 (#4297) 
		Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ок_ПринятиеКУчетуОборудования Тогда 
			
			НомерСубконтоНоменклатура			= 0;
			НомерСубконтоОбъектыСтроительства	= 0;
			
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ВидСубконто", ПланыВидовХарактеристик.бит_ВидыСубконтоДополнительные_2.Номенклатура);
			
			СубконтоНоменклатура = КорСчет.ВидыСубконто.НайтиСтроки(СтруктураПоиска);
			
			Если СубконтоНоменклатура.Количество() > 0 Тогда 
				
				НомерСубконтоНоменклатура = СубконтоНоменклатура[0].НомерСтроки;
				
			КонецЕсли;
			
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ВидСубконто", ПланыВидовХарактеристик.бит_ВидыСубконтоДополнительные_2.Объект);
			
			СубконтоОбъектыСтроительства = КорСчет.ВидыСубконто.НайтиСтроки(СтруктураПоиска);
			
			Если СубконтоОбъектыСтроительства.Количество() > 0 Тогда 
				
				НомерСубконтоОбъектыСтроительства = СубконтоОбъектыСтроительства[0].НомерСтроки;
				
			КонецЕсли;
			
			
			Если Не НомерСубконтоНоменклатура = 0
				И РезТаблица.Колонки.Найти("КорСубконто"+НомерСубконтоНоменклатура) = Неопределено Тогда 
				
				ТипСубконто = КорСчет.ВидыСубконто[НомерСубконтоНоменклатура-1].ВидСубконто.ТипЗначения;
				
				РезТаблица.Колонки.Добавить("КорСубконто"+НомерСубконтоНоменклатура, ТипСубконто);
				
			КонецЕсли;
			
			Если Не НомерСубконтоОбъектыСтроительства = 0
				И РезТаблица.Колонки.Найти("КорСубконто"+НомерСубконтоОбъектыСтроительства) = Неопределено Тогда 
				
				ТипСубконто = КорСчет.ВидыСубконто[НомерСубконтоОбъектыСтроительства-1].ВидСубконто.ТипЗначения;
				
				РезТаблица.Колонки.Добавить("КорСубконто"+НомерСубконтоОбъектыСтроительства, ТипСубконто);
				
			КонецЕсли;
			
			
			Если Не НомерСубконтоНоменклатура = 0 Или Не НомерСубконтоОбъектыСтроительства = 0 Тогда 
				
				Для Каждого Строка Из РезТаблица Цикл
					
					Если Не НомерСубконтоНоменклатура = 0 Тогда 
						
						Строка["КорСубконто"+НомерСубконтоНоменклатура] = Строка.ок_Оборудование;
						
					КонецЕсли;
					
					Если Не НомерСубконтоОбъектыСтроительства = 0 Тогда 
						
						Строка["КорСубконто"+НомерСубконтоОбъектыСтроительства] = Строка.ОбъектСтроительства;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		// ОКЕЙ Конаков Ю.М. (СофтЛаб) Конец 2021-10-20 (#4297) 
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(КорСчет));
		РезТаблица.Колонки.Добавить("КорСчет", Новый ОписаниеТипов(МассивТипов));
		РезТаблица.ЗаполнитьЗначения(КорСчет, "КорСчет")
	КонецЕсли;
	
	
	УпаковатьТаблицу(РезТаблица, СтруктураТаблиц);
	
	РезСтруктура = НовыйРезСтруктура();
	РезСтруктура.Вставить("Действие", ДействиеВыбора);
	РезСтруктура.Вставить("Данные"  , СтруктураТаблиц);
	РезСтруктура.Вставить("Режим"   , Режим);
		
	Возврат РезСтруктура;
	
КонецФункции // ПолучитьСтруктуруРезультатаВыбора()

// Процедура добавляет быстрые отборы для пользователя.
// 
Процедура ДобавитьПользовательскиеОтборы() Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	СтруктураОтбора.Вставить("Организация"		, Новый Структура("Использование, Значение", Истина, Организация));
	СтруктураОтбора.Вставить("Проведен"			, Новый Структура("Использование, Значение", Истина, Истина));
	СтруктураОтбора.Вставить("МОЛ"				, Новый Структура("Использование, Значение", ЗначениеЗаполнено(МОЛ), МОЛ));
	СтруктураОтбора.Вставить("Местонахождение"	, Новый Структура("Использование, Значение", ЗначениеЗаполнено(Местонахождение), Местонахождение));
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС 
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииОС
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаОС
		//БИТ Тртилек 31012013 для пермещения тоже добавим вид класса
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ПеремещениеОС
		//БИТ Тртилек
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеОС Тогда
		
		СтруктураОтбора.Вставить("ВидКласса", Новый Структура("Использование, Значение", ЗначениеЗаполнено(ВидКласса), ВидКласса));
	КонецЕсли;
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаОС
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаНМА Тогда
		
		СтруктураОтбора.Вставить("МетодНачисленияАмортизации", Новый Структура("Использование, Значение", ЗначениеЗаполнено(МетодНачисленияАмортизации), МетодНачисленияАмортизации));
	КонецЕсли;
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииОС 
		 ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииНМА  Тогда
		
		СтруктураОтбора.Вставить("НачислятьАмортизацию", Новый Структура("Использование, Значение", Истина, Истина));
	КонецЕсли; 
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаОС
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаНМА
		ИЛИ Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеНМА Тогда
		
		СтруктураОтбора.Вставить("МодельУчета", Новый Структура("Использование, Значение", ЗначениеЗаполнено(МодельУчета), МодельУчета));
	КонецЕсли;
	
	// ++ БоровинскаяОА (СофтЛаб) 15.12.18 Начало (#3128)
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеОС Тогда
		СтруктураОтбора.Вставить("ВыбылоПоДокументамБУ", Новый Структура("Использование, Значение", Истина, Истина));
		// ОКЕЙ Конаков Ю.М. (СофтЛаб) Начало 2021-10-20 (#4297) 
		СтруктураОтбора.Вставить("АвтоматическийПараллельныйУчет", Новый Структура("Использование, Значение", Истина, Истина));
		// ОКЕЙ Конаков Ю.М. (СофтЛаб) Начало 2021-10-20 (#4297) 
	КонецЕсли;
	// -- БоровинскаяОА (СофтЛаб) 15.12.18 Конец (#3128)
	
	Отбор = Компоновщик.Настройки.Отбор;
	
	// ОКЕЙ Конаков Ю.М. (СофтЛаб) Начало 2021-10-20 (#4297) 
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ок_ПринятиеКУчетуОборудования Тогда
		
		СтруктураОтбора.Вставить("ПринятоКУчетуМСФО",				Новый Структура("Использование, Значение", Истина, Ложь));
		СтруктураОтбора.Вставить("АвтоматическийПараллельныйУчет",	Новый Структура("Использование, Значение", Истина, Истина));
		
	КонецЕсли;
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ок_МодернизацияОборудования Тогда 
		
		СтруктураОтбора.Вставить("АвтоматическийПараллельныйУчет", Новый Структура("Использование, Значение", Истина, Истина));
		
	КонецЕсли;
	
	Если Режим = Перечисления.бит_му_РежимыПодбораВНА.ПеремещениеОС Тогда 
		
		СтруктураОтбора.Вставить("АвтоматическийПараллельныйУчет", Новый Структура("Использование, Значение", Истина, Истина));
		
	КонецЕсли;
	// ОКЕЙ Конаков Ю.М. (СофтЛаб) Конец 2021-10-20 (#4297) 
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		НастройкаЭлемента = ЭлементОтбора.Значение;
		
		ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Ключ);
		ДоступноеПоле = Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора);
		
		Если НЕ НастройкаЭлемента.Использование
			ИЛИ ДоступноеПоле = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Отбор, ПолеОтбора, НастройкаЭлемента.Значение);
		
	КонецЦикла;
	
КонецПроцедуры // ДобавитьПользовательскиеОтборы()

// Процедура заполняет табличную часть ПереченьОбъектов.
// 
Функция ПолучитьТаблицуОбъектов(АдресСКД) Экспорт

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация"	  , Организация);
	СтруктураПараметров.Вставить("ДатаНачала"	  , ДатаНачала);
	СтруктураПараметров.Вставить("ДатаОкончания"  , ДатаОкончания);
	СтруктураПараметров.Вставить("Режим"		  , Режим);
	СтруктураПараметров.Вставить("ВалютаДокумента", ВалютаДокумента);
	
	ТаблицаОбъектов = Обработки.бит_му_ПодборВНА.ПолучитьПереченьОбъектов(АдресСКД, Компоновщик, СтруктураПараметров);
	
	Возврат ТаблицаОбъектов;
	
КонецФункции // ПолучитьТаблицуОбъектов()

// Функция выполняет подбор ВНА через обработку подбора минуя форму
// 
// Параметры:
//  ПараметрыПодбора - Структура.
//
Функция ВыполнитьПодборДляЗакрытия(ПараметрыПодбора) Экспорт
	
	ПараметрыПодбора.Свойство("Организация"			      , Организация);
	ПараметрыПодбора.Свойство("ДатаНачала"				  , ДатаНачала);
	ПараметрыПодбора.Свойство("ДатаОкончания"			  , ДатаОкончания);
	ПараметрыПодбора.Свойство("Режим"					  , Режим);
	ПараметрыПодбора.Свойство("МОЛ"					      , МОЛ);
	ПараметрыПодбора.Свойство("Местонахождение"		      , Местонахождение);
	ПараметрыПодбора.Свойство("ВидКласса"				  , ВидКласса);
	ПараметрыПодбора.Свойство("МодельУчета"			      , МодельУчета);
	ПараметрыПодбора.Свойство("ВидДвижения"			      , ВидДвижения);
	ПараметрыПодбора.Свойство("МетодНачисленияАмортизации", МетодНачисленияАмортизации);
	ПараметрыПодбора.Свойство("ВалютаДокумента"		      , ВалютаДокумента);
	
	ТекстЗапроса = Обработки.бит_му_ПодборВНА.ПолучитьТекстЗапроса(Режим, ПараметрыПодбора);
	
	АдресСКД = Обработки.бит_му_ПодборВНА.ИнициализироватьСКД(ТекстЗапроса, Новый УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	Компоновщик.Инициализировать(ИсточникНастроек);
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	ДобавитьПользовательскиеОтборы();
	
	// Обновить перечень объектов
	ТаблицаОбъектов = ПолучитьТаблицуОбъектов(АдресСКД);
	
	СтруктураТаблиц = Новый Структура;	
	УпаковатьТаблицу(ТаблицаОбъектов, СтруктураТаблиц);
	
	РезСтруктура = НовыйРезСтруктура();
	РезСтруктура.Вставить("Действие", "Загрузить");
	РезСтруктура.Вставить("Данные"  , СтруктураТаблиц);
	РезСтруктура.Вставить("Режим", Режим);
	
	Возврат РезСтруктура;
	
КонецФункции // ВыполнитьПодборДляЗакрытия()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйРезСтруктура()

	Возврат Новый Структура("Действие, Данные, Режим");

КонецФункции // НовыйРезСтруктура()

// Процедура преобразует реквизит таблицу значений в массив структур.
// 
// Параметры:
//  СтрТаблиц  - Структура.
//  ИмяТаблицы - Строка.
// 
Процедура УпаковатьТаблицу(Таблица, СтрТаблиц)
	
	МассивРеквизитов = Таблица.Колонки;
	ИменаРеквизитов  = Новый Структура;
	Для каждого Реквизит ИЗ МассивРеквизитов Цикл 		
		ИменаРеквизитов.Вставить(Реквизит.Имя, Реквизит.ТипЗначения);		
	КонецЦикла;
	
	СтрТаблиц.Вставить("ПереченьОбъектов"		 , бит_ОбщегоНазначенияКлиентСервер.УпаковатьДанныеФормыКоллекция(Таблица, ИменаРеквизитов));
	СтрТаблиц.Вставить("ПереченьОбъектов_Колонки", ИменаРеквизитов);
	
КонецПроцедуры // УпаковатьТаблицу()

#КонецОбласти

#КонецЕсли