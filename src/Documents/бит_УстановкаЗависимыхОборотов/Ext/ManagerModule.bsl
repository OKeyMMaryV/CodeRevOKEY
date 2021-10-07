﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверитьтЗацикливаниеТаблицы(Реквизиты, Заголовок, Отказ)  Экспорт
	
	// Проверка на зацикливание.
	ЗаголовокСообщения = Заголовок + ": Обнаружено зацикливание по статьям :";
	Результат          = ЗапросЗависисмыеОбороты(Реквизиты.ДатаНачала, Реквизиты.Сценарий, Реквизиты.Ссылка);
	Выборка            = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru = '%1 - %2'"); 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
								Выборка.СтатьяОборотов, Выборка.СтатьяОборотов_Зависимые);
		
		бит_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, ЗаголовокСообщения, СтатусСообщения.Важное);
		ЗаголовокСообщения = "";
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросЗависисмыеОбороты(ДатаЗаполнения, Сценарий, Ссылка)  
	
	ИзмеренияБюджетирования = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("все","имя");
	
	// Получаем имена справочников в зависимости от текущего решения.
	ИмяСправочникаСценарии = бит_ОбщегоНазначения.ПолучитьИмяСправочникаСценарииБюджетирования();
	ИмяСправочникаЦФО 	   = бит_ОбщегоНазначения.ПолучитьИмяСправочникаЦФО();
	ИмяСправочникаПроекты  = бит_ОбщегоНазначения.ПолучитьИмяСправочникаПроекты();
	
	ТекстПоля    = "";
	ТекстУсловия = "";
	ТекстСоединения = "";
	
	ПустоеЗначение = Неопределено;
	
	СтруктураПустых = Новый Структура;
	СтруктураПустых.Вставить("Сценарий"		 	   , "ЗНАЧЕНИЕ(Справочник." + ИмяСправочникаСценарии + ".ПустаяСсылка)");	
	СтруктураПустых.Вставить("ЦФО"			 	   , "ЗНАЧЕНИЕ(Справочник." + ИмяСправочникаЦФО + ".ПустаяСсылка)");
	СтруктураПустых.Вставить("Проект"		 	   , "ЗНАЧЕНИЕ(Справочник." + ИмяСправочникаПроекты + ".ПустаяСсылка)");
	СтруктураПустых.Вставить("СтатьяОборотов"	   , "ЗНАЧЕНИЕ(Справочник.бит_СтатьиОборотов.ПустаяСсылка)");
	СтруктураПустых.Вставить("Контрагент"	 	   , "ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)");
	СтруктураПустых.Вставить("ДоговорКонтрагента"  , "ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)");
	СтруктураПустых.Вставить("НоменклатурнаяГруппа", "ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ПустаяСсылка)");
	СтруктураПустых.Вставить("БанковскийСчет"	   , "ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка)");
	
	Для каждого ТекИзмерение Из Метаданные.РегистрыНакопления.бит_ОборотыПоБюджетам.Измерения Цикл		
		
		ИмяИзмерения = ТекИзмерение.Имя;
		Если ИмяИзмерения = "Валюта" Тогда
			Продолжить;		
		КонецЕсли;
		
		// Поля запроса.
		ТекстПоля = ТекстПоля + Символы.ПС + "	Таблица." + ИмяИзмерения + ",";
		Если ИмяИзмерения <> "Сценарий" Тогда
			ТекстПоля = ТекстПоля + Символы.ПС + "	Таблица." + ИмяИзмерения + "_Зависимый,";
		КонецЕсли;
				
		// Ограничения.
		Если ИмяИзмерения = "СтатьяОборотов" Тогда
			ТекстСоединения = ТекстСоединения + Символы.ПС + 
							"
							|	И Основные.СтатьяОборотов = Зависимые.СтатьяОборотов_Зависимый
							|	И Основные.СтатьяОборотов_Зависимый = Зависимые.СтатьяОборотов";
							
		ИначеЕсли ИмяИзмерения <> "Сценарий" Тогда
			ТекстСоединения = ТекстСоединения + Символы.ПС + "И	Основные." + ИмяИзмерения + " = " + "Зависимые." + ИмяИзмерения + "_Зависимый";
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	// Установка параметров запроса.			             	
	Запрос.УстановитьПараметр("ПустаяДата"    , Дата('00010101'));
	Запрос.УстановитьПараметр("ДатаЗаполнения", ДатаЗаполнения);
	Запрос.УстановитьПараметр("Сценарий"      , Сценарий);
	Запрос.УстановитьПараметр("Ссылка"        , Ссылка);
	
	Запрос.УстановитьПараметр("Сценарий", 			  Справочники[ИмяСправочникаСценарии].ПустаяСсылка());
	Запрос.УстановитьПараметр("ЦФО", 	  			  Справочники[ИмяСправочникаЦФО].ПустаяСсылка());
	Запрос.УстановитьПараметр("Проект",   			  Справочники[ИмяСправочникаПроекты].ПустаяСсылка());
	Запрос.УстановитьПараметр("СтатьяОборотов", 	  Справочники.бит_СтатьиОборотов.ПустаяСсылка());
	Запрос.УстановитьПараметр("Контрагент", 		  Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДоговорКонтрагента",   Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа", Справочники.НоменклатурныеГруппы.ПустаяСсылка());
	Запрос.УстановитьПараметр("БанковскийСчет",  	  Справочники.БанковскиеСчета.ПустаяСсылка());
	
	Для каждого КлючИЗначение Из ИзмеренияБюджетирования Цикл
	
		ИмяИзмерения = КлючИЗначение.Ключ;
		Если ИмяИзмерения = "Сценарий" Тогда		
			Продолжить;		
		КонецЕсли; 
		
	КонецЦикла; 

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Ссылка,
	|	Таблица.ЦФО,
	|	Таблица.СтатьяОборотов,
	|	Таблица.Проект,
	|	Таблица.Контрагент,
	|	Таблица.ДоговорКонтрагента,
	|	Таблица.НоменклатурнаяГруппа,
	|	Таблица.БанковскийСчет,
	|	Таблица.Аналитика_1,
	|	Таблица.Аналитика_2,
	|	Таблица.Аналитика_3,
	|	Таблица.Аналитика_4,
	|	Таблица.Аналитика_5,
	|	Таблица.Аналитика_6,
	|	Таблица.Аналитика_7,
	|	Таблица.ЦФО_Зависимый,
	|	Таблица.СтатьяОборотов_Зависимый,
	|	Таблица.Контрагент_Зависимый,
	|	Таблица.ДоговорКонтрагента_Зависимый,
	|	Таблица.Проект_Зависимый,
	|	Таблица.НоменклатурнаяГруппа_Зависимый,
	|	Таблица.БанковскийСчет_Зависимый,
	|	Таблица.Аналитика_1_Зависимый,
	|	Таблица.Аналитика_2_Зависимый,
	|	Таблица.Аналитика_3_Зависимый,
	|	Таблица.Аналитика_4_Зависимый,
	|	Таблица.Аналитика_5_Зависимый,
	|	Таблица.Аналитика_6_Зависимый,
	|	Таблица.Аналитика_7_Зависимый,
	|	Таблица.ПрофильРаспределения,
	|	Таблица.КоэффициентКоличество,
	|	Таблица.КоэффициентСумма,
	|	Таблица.РеквизитКоличество,
	|	Таблица.РеквизитСумма,
	|	Таблица.ФункцияКоличество,
	|	Таблица.ФункцияСумма,
	|	Таблица.Ссылка.ДатаОкончания,
	|	Таблица.Ссылка.Сценарий
	|ПОМЕСТИТЬ ВТ_Документ
	|ИЗ
	|	Документ.бит_УстановкаЗависимыхОборотов.ЗависимыеОбороты КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Документ.ЦФО,
	|	ВТ_Документ.СтатьяОборотов,
	|	ВТ_Документ.Проект,
	|	ВТ_Документ.Контрагент,
	|	ВТ_Документ.ДоговорКонтрагента,
	|	ВТ_Документ.НоменклатурнаяГруппа,
	|	ВТ_Документ.БанковскийСчет,
	|	ВТ_Документ.Аналитика_1,
	|	ВТ_Документ.Аналитика_2,
	|	ВТ_Документ.Аналитика_3,
	|	ВТ_Документ.Аналитика_4,
	|	ВТ_Документ.Аналитика_5,
	|	ВТ_Документ.Аналитика_6,
	|	ВТ_Документ.Аналитика_7,
	|	ВТ_Документ.Сценарий
	|ПОМЕСТИТЬ ВТ_УсловиеОтбора
	|ИЗ
	|	ВТ_Документ КАК ВТ_Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_Документ.ЦФО_Зависимый,
	|	ВТ_Документ.СтатьяОборотов_Зависимый,
	|	ВТ_Документ.Проект_Зависимый,
	|	ВТ_Документ.Контрагент_Зависимый,
	|	ВТ_Документ.ДоговорКонтрагента_Зависимый,
	|	ВТ_Документ.НоменклатурнаяГруппа_Зависимый,
	|	ВТ_Документ.БанковскийСчет_Зависимый,
	|	ВТ_Документ.Аналитика_1_Зависимый,
	|	ВТ_Документ.Аналитика_2_Зависимый,
	|	ВТ_Документ.Аналитика_3_Зависимый,
	|	ВТ_Документ.Аналитика_4_Зависимый,
	|	ВТ_Документ.Аналитика_5_Зависимый,
	|	ВТ_Документ.Аналитика_6_Зависимый,
	|	ВТ_Документ.Аналитика_7_Зависимый,
	|	ВТ_Документ.Сценарий
	|ИЗ
	|	ВТ_Документ КАК ВТ_Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ЦФО,
	|	&СтатьяОборотов,
	|	&Проект,
	|	&Контрагент,
	|	&ДоговорКонтрагента,
	|	&НоменклатурнаяГруппа,
	|	&БанковскийСчет,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	Сценарий
	|ИЗ
	|	ВТ_Документ КАК ВТ_Документ";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|" + ТекстПоля + "
	|	Таблица.ПрофильРаспределения,
	|	Таблица.КоэффициентКоличество,
	|	Таблица.КоэффициентСумма,
	|	Таблица.РеквизитКоличество,
	|	Таблица.РеквизитСумма,
	|   Таблица.ФункцияКоличество,
	|   Таблица.ФункцияСумма,
	|   Таблица.Регистратор,
	|   Таблица.НомерСтроки,
	|	Таблица.ДатаОкончания	
	|ПОМЕСТИТЬ ВТ_Таблица
	|ИЗ
	|	РегистрСведений.бит_ЗависимыеОбороты.СрезПоследних(
	|			&ДатаЗаполнения,
	|			(	
	|	ЦФО,
	|	СтатьяОборотов,
	|	Проект,
	|	Контрагент,
	|	ДоговорКонтрагента,
	|	НоменклатурнаяГруппа,
	|	БанковскийСчет,
	|	Аналитика_1,
	|	Аналитика_2,
	|	Аналитика_3,
	|	Аналитика_4,
	|	Аналитика_5,
	|	Аналитика_6,
	|	Аналитика_7,
	|	Сценарий) В 
	|	(ВЫБРАТЬ
	|		т.ЦФО,
	|		т.СтатьяОборотов,
	|		т.Проект,
	|		т.Контрагент,
	|		т.ДоговорКонтрагента,
	|		т.НоменклатурнаяГруппа,
	|		т.БанковскийСчет,
	|		т.Аналитика_1,
	|		т.Аналитика_2,
	|		т.Аналитика_3,
	|		т.Аналитика_4,
	|		т.Аналитика_5,
	|		т.Аналитика_6,
	|		т.Аналитика_7,
	|		т.Сценарий 
	|	ИЗ ВТ_УсловиеОтбора КАК Т)
	|			) КАК Таблица
	|ГДЕ
	|	(Таблица.КоэффициентКоличество <> 0
	|			ИЛИ Таблица.ФункцияКоличество <> ЗНАЧЕНИЕ(Справочник.бит_ПользовательскиеФункции.ПустаяСсылка)
	|			ИЛИ Таблица.КоэффициентСумма <> 0
	|			ИЛИ Таблица.ФункцияСумма <> ЗНАЧЕНИЕ(Справочник.бит_ПользовательскиеФункции.ПустаяСсылка))
	|	И (Таблица.РеквизитКоличество <> ЗНАЧЕНИЕ(Перечисление.бит_РеквизитыДляРасчетаЗависимостей.ПустаяСсылка)
	|			ИЛИ Таблица.РеквизитСумма <> ЗНАЧЕНИЕ(Перечисление.бит_РеквизитыДляРасчетаЗависимостей.ПустаяСсылка))
	|	И (КонецПериода(Таблица.ДатаОкончания,День) >= &ДатаЗаполнения
	|					ИЛИ Таблица.ДатаОкончания = &ПустаяДата)";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТ_Таблица.Сценарий,
	|	ВТ_Таблица.ЦФО,
	|	ВТ_Таблица.ЦФО_Зависимый,
	|	ВТ_Таблица.СтатьяОборотов,
	|	ВТ_Таблица.СтатьяОборотов_Зависимый,
	|	ВТ_Таблица.Контрагент,
	|	ВТ_Таблица.Контрагент_Зависимый,
	|	ВТ_Таблица.ДоговорКонтрагента,
	|	ВТ_Таблица.ДоговорКонтрагента_Зависимый,
	|	ВТ_Таблица.Проект,
	|	ВТ_Таблица.Проект_Зависимый,
	|	ВТ_Таблица.НоменклатурнаяГруппа,
	|	ВТ_Таблица.НоменклатурнаяГруппа_Зависимый,
	|	ВТ_Таблица.БанковскийСчет,
	|	ВТ_Таблица.БанковскийСчет_Зависимый,
	|	ВТ_Таблица.Аналитика_1,
	|	ВТ_Таблица.Аналитика_1_Зависимый,
	|	ВТ_Таблица.Аналитика_2,
	|	ВТ_Таблица.Аналитика_2_Зависимый,
	|	ВТ_Таблица.Аналитика_3,
	|	ВТ_Таблица.Аналитика_3_Зависимый,
	|	ВТ_Таблица.Аналитика_4,
	|	ВТ_Таблица.Аналитика_4_Зависимый,
	|	ВТ_Таблица.Аналитика_5,
	|	ВТ_Таблица.Аналитика_5_Зависимый,
	|	ВТ_Таблица.Аналитика_6,
	|	ВТ_Таблица.Аналитика_6_Зависимый,
	|	ВТ_Таблица.Аналитика_7,
	|	ВТ_Таблица.Аналитика_7_Зависимый,
	|	ВТ_Таблица.ПрофильРаспределения,
	|	ВТ_Таблица.КоэффициентКоличество,
	|	ВТ_Таблица.КоэффициентСумма,
	|	ВТ_Таблица.РеквизитКоличество,
	|	ВТ_Таблица.РеквизитСумма,
	|	ВТ_Таблица.ФункцияКоличество,
	|	ВТ_Таблица.ФункцияСумма,
	|	ВТ_Таблица.Регистратор,
	|	ВТ_Таблица.ДатаОкончания
	|ПОМЕСТИТЬ ВТ_Объединение
	|ИЗ
	|	ВТ_Таблица КАК ВТ_Таблица
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ВТ_Документ.Сценарий,
	|	ВТ_Документ.ЦФО,
	|	ВТ_Документ.ЦФО_Зависимый,
	|	ВТ_Документ.СтатьяОборотов,
	|	ВТ_Документ.СтатьяОборотов_Зависимый,
	|	ВТ_Документ.Контрагент,
	|	ВТ_Документ.Контрагент_Зависимый,
	|	ВТ_Документ.ДоговорКонтрагента,
	|	ВТ_Документ.ДоговорКонтрагента_Зависимый,
	|	ВТ_Документ.Проект,
	|	ВТ_Документ.Проект_Зависимый,
	|	ВТ_Документ.НоменклатурнаяГруппа,
	|	ВТ_Документ.НоменклатурнаяГруппа_Зависимый,
	|	ВТ_Документ.БанковскийСчет,
	|	ВТ_Документ.БанковскийСчет_Зависимый,
	|	ВТ_Документ.Аналитика_1,
	|	ВТ_Документ.Аналитика_1_Зависимый,
	|	ВТ_Документ.Аналитика_2,
	|	ВТ_Документ.Аналитика_2_Зависимый,
	|	ВТ_Документ.Аналитика_3,
	|	ВТ_Документ.Аналитика_3_Зависимый,
	|	ВТ_Документ.Аналитика_4,
	|	ВТ_Документ.Аналитика_4_Зависимый,
	|	ВТ_Документ.Аналитика_5,
	|	ВТ_Документ.Аналитика_5_Зависимый,
	|	ВТ_Документ.Аналитика_6,
	|	ВТ_Документ.Аналитика_6_Зависимый,
	|	ВТ_Документ.Аналитика_7,
	|	ВТ_Документ.Аналитика_7_Зависимый,
	|	ВТ_Документ.ПрофильРаспределения,
	|	ВТ_Документ.КоэффициентКоличество,
	|	ВТ_Документ.КоэффициентСумма,
	|	ВТ_Документ.РеквизитКоличество,
	|	ВТ_Документ.РеквизитСумма,
	|	ВТ_Документ.ФункцияКоличество,
	|	ВТ_Документ.ФункцияСумма,
	|	ВТ_Документ.Ссылка,
	|	ВТ_Документ.ДатаОкончания
	|ИЗ
	|	ВТ_Документ КАК ВТ_Документ";
	Запрос.Выполнить();	
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.СтатьяОборотов КАК СтатьяОборотов, Зависимые.СтатьяОборотов КАК СтатьяОборотов_Зависимые
	|ИЗ
	|	ВТ_Объединение КАК Основные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Объединение КАК Зависимые
	|		ПО Основные.Сценарий = Зависимые.Сценарий"
	+  ТекстСоединения + 
	"
	|ГДЕ
	|	НЕ Зависимые.Сценарий ЕСТЬ NULL";
		
	Результат = Запрос.Выполнить();

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
