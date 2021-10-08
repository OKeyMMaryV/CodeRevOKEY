﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Отбор.Организация;
		ЭлементОтбораОрганизация = ОтборыСписковКлиентСервер.ЭлементОтбораСпискаПоИмени(Список, "Организация");
		Если ЭлементОтбораОрганизация <> Неопределено Тогда
			ЭлементОтбораОрганизация.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ПодразделениеОрганизации") Тогда
		ОтборПодразделение = Параметры.Отбор.ПодразделениеОрганизации;
		ЭлементОтбораПодразделение = ОтборыСписковКлиентСервер.ЭлементОтбораСпискаПоИмени(Список, "ПодразделениеОрганизации");
		Если ЭлементОтбораПодразделение <> Неопределено Тогда
			ОтборПодразделение.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
	КонецЕсли;
	
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Начало 2021-04-27 (#ТП_БП11_ФР15)
	ок_МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Конец 2021-04-27 (#ТП_БП11_ФР15)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы <> Неопределено И ТипЗнч(ВладелецФормы.Объект.Ссылка) = Тип("СправочникСсылка.ПодразделенияОрганизаций")
		И НЕ ВладелецФормы.Объект.ОбособленноеПодразделение Тогда
		ТолькоПросмотр = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Лимит остатка кассы устанавливается только для обособленных подразделений'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список,, Параметр);
	КонецЕсли;
	
КонецПроцедуры
