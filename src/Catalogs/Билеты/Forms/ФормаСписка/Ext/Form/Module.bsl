﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОсновнаяОрганизация           = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОтборОрганизация              = ОсновнаяОрганизация;
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	УстановитьВосстановленныеОтборы();
	
	УстановитьУсловноеОформление();
	
	ЗагружаютсяДанныеВнешнихСистем = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагружаютсяДанныеВнешнихСистем();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗагружаютсяДанныеВнешнихСистем Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗагрузитьДанныеВнешнихСистем", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСотрудникИспользованиеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Сотрудник");
КонецПроцедуры

&НаКлиенте
Процедура ОтборСотрудникПриИзменении(Элемент)
	ОтборСотрудникИспользование = ЗначениеЗаполнено(ОтборСотрудник);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Сотрудник");
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Сотрудник");
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Видимость колонки Организация
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизацияИспользование", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Видимость колонки Сотрудник
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Сотрудник");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборСотрудникИспользование", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#Область ОбменДаннымиСВнешнимиСистемами

&НаКлиенте
Процедура Подключаемый_ЗагрузитьДанныеВнешнихСистем()
	
	ОбменДаннымиСВнешнимиСистемамиБПКлиент.НачатьЗагрузку(
		ЭтотОбъект,
		Новый ОписаниеОповещения("ПодключитьСледующуюЗагрузкуДанныхВнешнихСистем", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьСледующуюЗагрузкуДанныхВнешнихСистем(ИнтервалСледующегоЗапуска, ДополнительныеПараметры) Экспорт // обработчик оповещения
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗагрузитьДанныеВнешнихСистем", ИнтервалСледующегоЗапуска, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
