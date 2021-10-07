﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполним реквизиты формы из параметров.
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,
		"Грузоотправитель, ГрузоотправительПоУмолчанию,
		|Грузополучатель, ГрузополучательПоУмолчанию, 
		|ПоставщикРезидентТаможенногоСоюза, КодВидаТранспорта");
		
	Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда
		ГрузоотправительОнЖе = 1;
	Иначе
		ГрузоотправительОнЖе = 0;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда
		ГрузополучательОнЖе = 1;
	Иначе
	    ГрузополучательОнЖе = 0;
	КонецЕсли;

	Если ЗначениеЗаполнено(ГрузоотправительПоУмолчанию) Тогда
		ТекстГрузоотправительОнЖе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГрузоотправительПоУмолчанию, "Наименование");
	Иначе
		Если ТипЗнч(ГрузоотправительПоУмолчанию) = Тип("СправочникСсылка.Организации") Тогда
			ТекстГрузоотправительОнЖе = НСтр("ru = 'Организация'");
		Иначе
			ТекстГрузоотправительОнЖе = НСтр("ru = 'Контрагент'");
		КонецЕсли;
	КонецЕсли;
	Элементы.ГрузоотправительОнЖе1.СписокВыбора[0].Представление = ТекстГрузоотправительОнЖе;

	Если ЗначениеЗаполнено(ГрузополучательПоУмолчанию) Тогда
		ТекстГрузополучательОнЖе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГрузополучательПоУмолчанию, "Наименование");
	Иначе
		Если ТипЗнч(ГрузополучательПоУмолчанию) = Тип("СправочникСсылка.Организации") Тогда
			ТекстГрузополучательОнЖе = НСтр("ru = 'Организация'");
		Иначе
			ТекстГрузополучательОнЖе = НСтр("ru = 'Контрагент'");
		КонецЕсли;
	КонецЕсли;
	Элементы.ГрузополучательОнЖе1.СписокВыбора[0].Представление = ТекстГрузополучательОнЖе;

	ЗаполнитьСписокВыбораВидовТранспорта(ЭтаФорма.Элементы.КодВидаТранспорта.СписокВыбора);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
	
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ВопросСохраненияДанныхЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ПеренестиВДокумент Тогда
		СтруктураРезультат = Новый Структура("Грузоотправитель, Грузополучатель");
		 
		Если ГрузоотправительОнЖе = 0 Тогда
			СтруктураРезультат.Вставить("Грузоотправитель", Грузоотправитель);
		КонецЕсли;
		
		Если ГрузополучательОнЖе = 0 Тогда
			СтруктураРезультат.Вставить("Грузополучатель", Грузополучатель);
		КонецЕсли;
		
		СтруктураРезультат.Вставить("КодВидаТранспорта", КодВидаТранспорта);
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГрузоотправительОнЖеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОнЖеПриИзменении(Элемент)

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;

	Элементы.Грузоотправитель.Доступность 	= (Форма.ГрузоотправительОнЖе = 0);
	Элементы.Грузополучатель.Доступность	= (Форма.ГрузополучательОнЖе = 0);
	
	Элементы.ВидТранспорта.Видимость = Форма.ПоставщикРезидентТаможенногоСоюза;
	
	ТекущийКод = Элементы.КодВидаТранспорта.СписокВыбора.НайтиПоЗначению(Форма.КодВидаТранспорта);
	Если ТекущийКод <> Неопределено Тогда 
		Форма.НадписьВидТранспорта = Сред(ТекущийКод.Представление, 5);
	Иначе
		Форма.НадписьВидТранспорта = "";
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)

	Если ГрузоотправительОнЖе = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Грузоотправитель'"));
			Поле = "Грузоотправитель";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЕсли;

	Если ГрузополучательОнЖе = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Грузополучатель'"));
			Поле = "Грузополучатель";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросСохраненияДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаТранспортаПриИзменении(Элемент)
	
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(КодВидаТранспорта);
	Если ТекущийКод <> Неопределено Тогда
		НадписьВидТранспорта = Сред(ТекущийКод.Представление, 5);
	Иначе
		НадписьВидТранспорта = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаТранспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(КодВидаТранспорта);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Элемент.СписокВыбора, Элемент, ТекущийКод);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораВидовТранспорта(СписокВыбора)
	
	Документы.ЗаявлениеОВвозеТоваров.ЗаполнитьСписокВыбораВидовТранспорта(СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйКод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйКод <> Неопределено Тогда
		Модифицированность = Истина;
		КодВидаТранспорта = ВыбранныйКод.Значение;
		НадписьВидТранспорта = Сред(ВыбранныйКод.Представление, 5);
	КонецЕсли;

КонецПроцедуры


