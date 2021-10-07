﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СервисЭлектронныхТрудовыхКнижек.НастроитьПараметрыОтбораСотрудников(ЭтотОбъект);
	
	Список.ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникСотрудники.Ссылка КАК Ссылка,
		|	СправочникСотрудники.ВерсияДанных КАК ВерсияДанных,
		|	СправочникСотрудники.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникСотрудники.Предопределенный КАК Предопределенный,
		|	СправочникСотрудники.Код КАК Код,
		|	СправочникСотрудники.Наименование КАК Наименование,
		|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СправочникСотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	СправочникСотрудники.ТекущийПроцентСевернойНадбавки КАК ТекущийПроцентСевернойНадбавки,
		|	СправочникСотрудники.ВАрхиве КАК ВАрхиве,
		|	СправочникСотрудники.УточнениеНаименования КАК УточнениеНаименования,
		|	СправочникСотрудники.ГоловнойСотрудник КАК ГоловнойСотрудник,
		|	ЕСТЬNULL(ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости, ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ПустаяСсылка)) КАК ВидЗанятости,
		|	ВЫБОР
		|		КОГДА ОсновныеСотрудникиФизическихЛиц.Сотрудник ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ОсновноеРабочееМестоВОрганизации,
		|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ТекущаяОрганизация,
		|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Подразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК ТекущееПодразделение,
		|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ТекущаяДолжность,
		|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриема,
		|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаУвольнения,
		|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущаяТарифнаяСтавка, 0) КАК ТекущаяТарифнаяСтавка,
		|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийСпособРасчетаАванса, ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ПустаяСсылка)) КАК ТекущийСпособРасчетаАванса,
		|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийАванс, 0) КАК ТекущийАванс,
		|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ОформленПоТрудовомуДоговору, ЛОЖЬ) КАК ОформленПоТрудовомуДоговору
		|ИЗ
		|	Справочник.Сотрудники КАК СправочникСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО (ТекущиеКадровыеДанныеСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
		|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
		|		ПО СправочникСотрудники.Ссылка = ОсновныеСотрудникиФизическихЛиц.Сотрудник
		|			И (ОсновныеСотрудникиФизическихЛиц.ДатаНачала В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(Т.ДатаНачала)
		|				ИЗ
		|					РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК Т
		|				ГДЕ
		|					СправочникСотрудники.Ссылка = Т.Сотрудник
		|					И &МаксимальнаяДатаНачалоДня МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
		|		ПО СправочникСотрудники.Ссылка = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
		|			И (КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(Т.ДатаНачала)
		|				ИЗ
		|					РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
		|				ГДЕ
		|					СправочникСотрудники.Ссылка = Т.Сотрудник
		|					И &МаксимальнаяДатаНачалоДня МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
		|		ПО СправочникСотрудники.Ссылка = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
		|			И (ВидыЗанятостиСотрудниковИнтервальный.ДатаНачала В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(Т.ДатаНачала)
		|				ИЗ
		|					РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК Т
		|				ГДЕ
		|					СправочникСотрудники.Ссылка = Т.Сотрудник
		|					И &МаксимальнаяДатаНачалоДня МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущаяТарифнаяСтавкаСотрудников КАК ТекущаяТарифнаяСтавкаСотрудников
		|		ПО (ТекущаяТарифнаяСтавкаСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
		|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)}";
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "МаксимальнаяДатаНачалоДня", НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()), Истина);
	
	// Получение параметров отбора.
	Параметры.Отбор.Свойство("ТекущаяОрганизация", ОтборТекущаяОрганизация);
	Параметры.Отбор.Свойство("ГоловнаяОрганизация", ОтборГоловнаяОрганизация);
	
	Параметры.Отбор.Удалить("ТекущаяОрганизация");
	Параметры.Отбор.Удалить("ГоловнаяОрганизация");
	Параметры.Отбор.Удалить("ТекущееПодразделение");
	
	// Считается, что организация такая же как и головная организация, если организация не задана.
	Если НЕ ЗначениеЗаполнено(ОтборГоловнаяОрганизация) Тогда
		ОтборГоловнаяОрганизация = ОтборТекущаяОрганизация;
	ИначеЕсли НЕ ЗначениеЗаполнено(ОтборТекущаяОрганизация) Тогда
		ОтборТекущаяОрганизация = ОтборГоловнаяОрганизация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборГоловнаяОрганизация) Тогда
		ОтборГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(ОтборГоловнаяОрганизация);
	КонецЕсли;
	
	// Получение значений по умолчанию, если организация не задана.
	Если НЕ ЗначениеЗаполнено(ОтборТекущаяОрганизация) Тогда
		
		ЗаполняемыеЗначения = Новый Структура;
		ЗаполняемыеЗначения.Вставить("Организация", "ОтборТекущаяОрганизация");
		ЗаполняемыеЗначения.Вставить("Подразделение", "ОтборТекущееПодразделение");
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗаполняемыеЗначения);
		
	КонецЕсли;
	
	// Заполнение меню ввода на основании.
	СотрудникиФормы.УстановитьМенюВводаНаОсновании(ЭтаФорма, "ОформитьДокумент");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Установка признаков использования быстрых отборов.
	ОтборТекущаяОрганизацияИспользование = ЗначениеЗаполнено(ОтборТекущаяОрганизация);
	
	// Установка отбора по головной организации.
	Если ЗначениеЗаполнено(ОтборГоловнаяОрганизация) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор,
			"ГоловнаяОрганизация",
			ОтборГоловнаяОрганизация,
			,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	Иначе
		
		// Очистка  связей параметров выбора организации.
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОтборТекущаяОрганизация",
			"СвязиПараметровВыбора",
			Новый ФиксированныйМассив(Новый Массив));
		
	КонецЕсли;
	
	// Перенос отборов из параметров формы в настройки динамического списка.
	ЗарплатаКадрыКлиентСервер.НастроитьОтборыПараметровФормыСписка(Список, Параметры);
	
	ПрименитьОтборНаСервере();
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", , , , "ГоловнаяОрганизация, ТекущаяОрганизация, ТекущееПодразделение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеСотрудники.Количество() > 0 Тогда
		ОповеститьОВыборе(ВыбранныеСотрудники.ВыгрузитьЗначения());
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
	Если ИмяСобытия = "ИзменениеДанныхМестаРаботы" Тогда
		
		Элементы.Список.Обновить();
		
	ИначеЕсли ИмяСобытия = "СозданСотрудник" Тогда
		
		Если Параметры.РежимВыбора И Источник = ЭтаФорма Тогда
			ОповеститьОВыборе(Параметр);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборТекущаяОрганизацияИспользованиеПриИзменении(Элемент)
	
	ПрименитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТекущаяОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОтбораПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТекущееПодразделениеИспользованиеПриИзменении(Элемент)
	
	ПрименитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТекущееПодразделениеПриИзменении(Элемент)
	
	ОтборТекущееПодразделениеИспользование = ЗначениеЗаполнено(ОтборТекущееПодразделение);
	ПрименитьОтбор();

КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыЭлементаСправочникаСотрудники");
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыНовогоЭлементаСправочникаСотрудники");

	Если Элементы.Список.РежимВыбора И ДоступныНепринятые Тогда
		
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		Если ЗначениеЗаполнено(ОтборГоловнаяОрганизация) Тогда
			ПараметрыФормы.Вставить("ГоловнаяОрганизация", ОтборГоловнаяОрганизация);
		КонецЕсли;
		
		Если ОтборТекущаяОрганизацияИспользование И ЗначениеЗаполнено(ОтборТекущаяОрганизация) Тогда
			ПараметрыФормы.Вставить("ТекущаяОрганизация",  ОтборТекущаяОрганизация);
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.Сотрудники.ФормаОбъекта",
			ПараметрыФормы,
			ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Элементы.Список.ТекущаяСтрока, Команда.Имя);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрименитьОтбор()
	
	УстановитьБыстрыйОтборСписка(
		Список,
		ОтборТекущаяОрганизацияИспользование,
		ОтборТекущаяОрганизация,
		ОтборТекущееПодразделениеИспользование,
		ОтборТекущееПодразделение,
		ДоступныНепринятые,
		ПолучитьФункциональнуюОпциюФормы("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая"));	
		
КонецПроцедуры

&НаСервере
Процедура ПрименитьОтборНаСервере()
	
	УстановитьБыстрыйОтборСписка(
		Список,
		ОтборТекущаяОрганизацияИспользование,
		ОтборТекущаяОрганизация,
		ОтборТекущееПодразделениеИспользование,
		ОтборТекущееПодразделение,
		ДоступныНепринятые,
		ПолучитьФункциональнуюОпциюФормы("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая"));	
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьБыстрыйОтборСписка(Список, ИспользованиеОрганизации, Организация, ИспользованиеПодразделения, Подразделение, ДоступныНепринятые, ИспользоватьНесколькоОрганизаций)
	
	Если ДоступныНепринятые Тогда
		ИмяПоляОтбораПоОрганизации = "ГоловнаяОрганизация";
	Иначе
		ИмяПоляОтбораПоОрганизации = "ТекущаяОрганизация";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, ИмяПоляОтбораПоОрганизации);
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, "ТекущееПодразделение");
	
	Если ИспользованиеОрганизации И ИспользоватьНесколькоОрганизаций Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор,
			ИмяПоляОтбораПоОрганизации,
			Организация,
			,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
	КонецЕсли;
	
	Если ИспользованиеПодразделения Тогда
		
		Если ТипЗнч(Подразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВИерархии;
		Иначе
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор,
			"ТекущееПодразделение",
			Подразделение,
			ВидСравненияОтбора,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтбораПоОрганизации()
	
	ОтборТекущаяОрганизацияИспользование = ЗначениеЗаполнено(ОтборТекущаяОрганизация);
	ОтборТекущееПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
	ОтборТекущееПодразделениеИспользование = Ложь;
	ПрименитьОтбор();
	
КонецПроцедуры

#КонецОбласти

