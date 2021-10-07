﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если ЗначениеЗаполнено(Параметры.НалоговыйПериод)
			И КонецКвартала(Параметры.НалоговыйПериод) <> КонецКвартала(Объект.Дата) Тогда
			Объект.Дата = КонецКвартала(Параметры.НалоговыйПериод);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
		
		ВидОперации = Параметры.ВидОперации;
		
		ПодготовитьФормуНаСервере();
		
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.ЗаписьКУДиР",
		"ФормаДокументаОднострочная",
		СтрШаблон(НСтр("ru = 'Новости: %1'"), ВидОперации),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.ПометкаУдаления
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		
		ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Строки.Количество() = 0 Тогда
		Строка = ТекущийОбъект.Строки.Добавить();
	Иначе
		Строка = ТекущийОбъект.Строки[0];
	КонецЕсли;
	
	СуммаДокумента = ?(ВидОперации = ВидыОпераций.ВозвратПокупателю, -Сумма, Сумма);
	
	Строка.ДатаПервичногоДокумента  = ДатаПервичногоДокумента;
	Строка.НомерПервичногоДокумента = НомерПервичногоДокумента;
	Строка.Графа4                   = СуммаДокумента;
	Строка.Графа5                   = СуммаДокумента;
	Строка.Содержание               = Содержание;
	Строка.ДатаНомер = УчетУСН.РеквизитыПервичногоДокументаДляКУДиР(
		Строка.ДатаПервичногоДокумента,
		Строка.НомерПервичногоДокумента,
		ТекущийОбъект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеЗаписиКУДиР");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Параметры.НалоговыйПериод)
		И (Объект.Дата < НачалоГода(Параметры.НалоговыйПериод)
		Или КонецКвартала(Параметры.НалоговыйПериод) < Объект.Дата) Тогда
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Укажите дату в интервале с %1 по %2'"),
			Формат(НачалоГода(Параметры.НалоговыйПериод), "ДЛФ=D"),
			Формат(КонецКвартала(Параметры.НалоговыйПериод), "ДЛФ=D"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Дата", "Объект", Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();
	
	ВидыОпераций = Документы.ЗаписьКУДиР.ВидыОперацийОднострочнойФормы();
	
	Если Объект.Строки.Количество() <> 0 Тогда
		
		Строка = Объект.Строки[0];
		ДатаПервичногоДокумента  = Строка.ДатаПервичногоДокумента;
		НомерПервичногоДокумента = Строка.НомерПервичногоДокумента;
		
		Если Строка.Графа5 < 0 Тогда
			ВидОперации = ВидыОпераций.ВозвратПокупателю;
			Сумма =-Строка.Графа5;
		Иначе
			ВидОперации = ВидыОпераций.ПолучениеДохода;
			Сумма = Строка.Графа5;
		КонецЕсли;
		
		Содержание = Строка.Содержание;
		
	Иначе
		ДатаПервичногоДокумента = Объект.Дата;
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
	УстановитьТекстПодсказокПоВидуОперации();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ЗначениеЗаполнено(ВидОперации) Тогда
			Заголовок = СтрШаблон(НСтр("ru = '%1 (создание)'"), ВидОперации);
		Иначе
			Заголовок = НСтр("ru = 'Запись книги доходов и расходов (создание)'");
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ВидОперации) Тогда
			Заголовок = СтрШаблон(НСтр("ru = '%1 от %2'"), ВидОперации, Формат(Объект.Дата, "ДЛФ=D"));
		Иначе
			Заголовок = СтрШаблон(НСтр("ru = 'Запись книги доходов и расходов от %1'"), Формат(Объект.Дата, "ДЛФ=D"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПодсказокПоВидуОперации()
	
	Если ВидОперации = ВидыОпераций.ВозвратПокупателю Тогда
		НачалоПодсказки = НСтр("ru = 'Номер и дата платежного поручения, кассового ордера или другого документа, подтверждающего возврат денег покупателю.'");
	Иначе
		НачалоПодсказки = НСтр("ru = 'Номер и дата платежного поручения, кассового ордера или другого документа, подтверждающего получение дохода.'");
	КонецЕсли;
	Элементы.ГруппаНомерДатаПервичногоДокумента.Подсказка = СтрШаблон("%1 %2", НачалоПодсказки, НСтр("ru = 'Используется для заполнения ""Книги учета доходов и расходов"".'"));
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#Область ОбработкаРеквизитовШапки

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти