﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ЦиклыОбмена = Неопределено Тогда 
		Отказ = Истина;
	КонецЕсли;
	
	ЦиклыОбмена = Параметры.ЦиклыОбмена;
	
	Если ТипЗнч(ЦиклыОбмена) <> Тип("Массив") ИЛИ ЦиклыОбмена.Количество() = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
	СоответствиеТиповСодержимогоЭлементамФормы = Новый Соответствие;
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетности, Элементы.ФлажокИсходныйДокумент);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетностиПФР, Элементы.ФлажокИсходныйДокумент);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеОбОтправке, Элементы.ФлажокПодтверждениеОтправки);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеПолученияОтчетностиПФР, Элементы.ФлажокИзвещениеОбОтказеПФР);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПротоколВходногоКонтроля, Элементы.ФлажокПротокол);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПротоколПФР, Элементы.ФлажокПротокол);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.Реестр2НДФЛ, Элементы.ФлажокРеестрСведений2НДФЛ);
	
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетностиФСГС, Элементы.ФлажокИсходныйДокумент);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеОператораФСГС, Элементы.ФлажокПодтверждениеОтправки);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОПриемеВОбработкуОтчетаФСГС, Элементы.ФлажокПротокол);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОНесоответствииФорматуОтчетаФСГС, Элементы.ФлажокПротокол);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбУточненииОтчетаФСГС, Элементы.ФлажокПротокол);
	СоответствиеТиповСодержимогоЭлементамФормы.Вставить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбОтказеОтчетаФСГС, Элементы.ФлажокПротокол);
	
	ПечататьДокумент 				= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьДокумент") <> Ложь);
	ПечататьПодтверждениеОтправки 	= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьПодтверждениеОтправки") <> Ложь);
	ПечататьИзвещениеОбОтказеПФР 	= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьИзвещениеОбОтказеПФР") <> Ложь);
	ПечататьПротокол 				= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьПротокол") <> Ложь);
	ПечататьУведомлениеОбУточнении 	= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьУведомлениеОбУточнении") <> Ложь);
	ПечататьПротоколПриема2НДФЛ 	= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьПротоколПриема2НДФЛ") <> Ложь);
	ПечататьРеестрСведений2НДФЛ 	= (ХранилищеОбщихНастроек.Загрузить("НастройкиГрупповойПечатиЦикловОбмена_ПечататьРеестрСведений2НДФЛ") <> Ложь);
	
	ЧислоЦикловОбмена = ЦиклыОбмена.Количество();
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	КОЛИЧЕСТВО(ИСТИНА) КАК ЧислоДокументовТипа,
	                      |	СодержимоеТранспортныхКонтейнеров.Тип
	                      |ИЗ
	                      |	РегистрСведений.СодержимоеТранспортныхКонтейнеров КАК СодержимоеТранспортныхКонтейнеров
	                      |ГДЕ
	                      |	СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение.ЦиклОбмена В(&ЦиклОбмена)
	                      |	И СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение.Тип В(&Тип)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СодержимоеТранспортныхКонтейнеров.Тип");
	ВозможныеТипыСообщений = Новый Массив;
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееОтчетностьПФР);
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПодтверждениеПолученияОтчетностиПФР);
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПротоколПФР);
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееОтчетностьФСГС);
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПодтверждениеДатыОтправкиФСГС);
	ВозможныеТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПротоколВходногоКонтроляОтчетностиФСГС);
	Запрос.УстановитьПараметр("Тип", ВозможныеТипыСообщений);
	Запрос.УстановитьПараметр("ЦиклОбмена", ЦиклыОбмена);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЭУ = СоответствиеТиповСодержимогоЭлементамФормы[Выборка.Тип];
		Если ЭУ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЭУ.Доступность = Истина;
		ЭУ.Заголовок = ЭУ.Заголовок + " (" + Формат(Выборка.ЧислоДокументовТипа, "ЧГ=") + ")";
	КонецЦикла;
	
	Для Каждого Эл Из СоответствиеТиповСодержимогоЭлементамФормы Цикл
		Если НЕ Эл.Значение.Доступность Тогда
			
			ЭтаФорма[Эл.Значение.ПутьКДанным] = Ложь;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновныеДействияФормыОК(Команда)
	
	Результат = СформироватьРезультат();
	ВыбранХотяБыОдинТипДокумента = Ложь;
	Для Каждого Эл из Результат Цикл
		Если Эл.Значение Тогда
			ВыбранХотяБыОдинТипДокумента = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ВыбранХотяБыОдинТипДокумента Тогда
		ПоказатьПредупреждение(, "Выберите виды документов для печати.");
	Иначе
		СохранитьНастройки();
		Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОсновныеДействияФормыОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СформироватьРезультат()
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПечататьДокумент", 				ПечататьДокумент);
	ДополнительныеПараметры.Вставить("ПечататьПодтверждениеОтправки", 	ПечататьПодтверждениеОтправки);
	ДополнительныеПараметры.Вставить("ПечататьИзвещениеОбОтказеПФР", 	ПечататьИзвещениеОбОтказеПФР);
	ДополнительныеПараметры.Вставить("ПечататьПротокол", 				ПечататьПротокол);
	ДополнительныеПараметры.Вставить("ПечататьУведомлениеОбУточнении", 	ПечататьУведомлениеОбУточнении);
	ДополнительныеПараметры.Вставить("ПечататьПротоколПриема2НДФЛ",		ПечататьПротоколПриема2НДФЛ);
	ДополнительныеПараметры.Вставить("ПечататьРеестрСведений2НДФЛ", 	ПечататьРеестрСведений2НДФЛ);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	
	Если Элементы.ФлажокИсходныйДокумент.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьДокумент", 
			, 
			ПечататьДокумент);
			
	КонецЕсли;
	
	Если Элементы.ФлажокПодтверждениеОтправки.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьПодтверждениеОтправки", 
			, 
			ПечататьПодтверждениеОтправки);
			
	КонецЕсли;
	
	Если Элементы.ФлажокИзвещениеОбОтказеПФР.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьИзвещениеОбОтказеПФР", 
			, 
			ПечататьИзвещениеОбОтказеПФР);
			
	КонецЕсли;
	
	Если Элементы.ФлажокПротокол.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьПротокол", 
			, 
			ПечататьПротокол);
			
	КонецЕсли;
	
	Если Элементы.ФлажокУведомлениеОбУточнении.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьУведомлениеОбУточнении", 
			, 
			ПечататьУведомлениеОбУточнении);
			
	КонецЕсли;
	
	Если Элементы.ФлажокПротоколПриема2НДФЛ.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьПротоколПриема2НДФЛ", 
			, 
			ПечататьПротоколПриема2НДФЛ);
			
	КонецЕсли;
	
	Если Элементы.ФлажокРеестрСведений2НДФЛ.Доступность Тогда
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиГрупповойПечатиЦикловОбмена_ПечататьРеестрСведений2НДФЛ", 
			, 
			ПечататьРеестрСведений2НДФЛ);
			
	КонецЕсли;

КонецПроцедуры

#КонецОбласти


