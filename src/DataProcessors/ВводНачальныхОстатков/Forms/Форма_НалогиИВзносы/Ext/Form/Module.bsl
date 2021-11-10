﻿
#Область ПроцедурыИФункцииОбщегоНазначения

#Область ОбщегоНазначения

&НаСервереБезКонтекста
Функция ПеречитатьДатуНачалаУчета(Организация)
	
	Возврат Обработки.ВводНачальныхОстатков.ПеречитатьДатуНачалаУчета(Организация);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере();
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина)
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.НалогиИВзносы, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.РасчетыПоНалогамИСборам);
	
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "НалогиИВзносы");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.НалогиИВзносы, Отбор);
	
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.НалогиИВзносы);
	
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "РасчетыПоНалогамИСборам");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат, Объект.СуществующиеДокументы);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.НалогиИВзносы, "НалогиИВзносы", 
			Новый Структура("Организация,ДатаВводаОстатков",
				Объект.Организация,Объект.ДатаВводаОстатков),
			Объект.СуществующиеДокументы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличнуюЧастьКЗаписи(Таблица);
	
	ТаблицаДанных = Таблица.Выгрузить();
	ТаблицаДанных.Очистить();
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл
		Если СтрокаТаблицы.Задолженность <> 0
			ИЛИ СтрокаТаблицы.Переплата <> 0 Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Задолженность.Имя = "СуммаКт";
	ТаблицаДанных.Колонки.Переплата.Имя     = "Сумма";
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОбработчикиЭлементовШапкиФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Модифицированность Тогда
		НомерСтроки = 0;
		Если Элементы.НалогиИВзносы.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.НалогиИВзносы.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		ЗаписатьНаСервере(Истина);
		Если НомерСтроки <> 0 Тогда
			Элементы.НалогиИВзносы.ТекущаяСтрока = Объект.НалогиИВзносы[НомерСтроки-1].ПолучитьИдентификатор();
		КонецЕсли;
		Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		ЗаписатьНаСервере(Ложь);
		Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура ДобавитьНалог(Команда)
	
	ОткрытьФорму("Справочник.ВидыНалоговИПлатежейВБюджет.Форма.ФормаЭлемента",,ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДобавлениеВидаНалога(ВидНалога)
	
	МассивСтрок = Объект.НалогиИВзносы.НайтиСтроки(Новый Структура("ВидНалога", ВидНалога));
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТаблицы = Объект.НалогиИВзносы.Добавить();
		СтрокаТаблицы.ВидНалога = ВидНалога;
		Элементы.НалогиИВзносы.ТекущаяСтрока = Объект.НалогиИВзносы[СтрокаТаблицы.НомерСтроки-1].ПолучитьИдентификатор();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЗадолженностьИлиПереплата(ИмяРеквизита, ИмяОбнуляемогоРеквизита)
	
	СтрокаТаблицы   = Элементы.НалогиИВзносы.ТекущиеДанные;
	
	СтрокаТаблицы[ИмяОбнуляемогоРеквизита] = 0;
	Если СтрокаТаблицы[ИмяРеквизита] = 0 Тогда
		СтрокаТаблицы.Ссылка = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиИВзносыЗадолженностьПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиПереплата("Задолженность", "Переплата");
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиИВзносыПереплатаПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиПереплата("Переплата", "Задолженность");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Налоги (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	ЭтаФорма.Заголовок = ТекстЗаголовок;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.НалогиИВзносы, "НалогиИВзносы", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.НалогиИВзносы, "НалогиИВзносы", 
		Новый Структура("Организация,ДатаВводаОстатков",
					Объект.Организация,Объект.ДатаВводаОстатков),
		Объект.СуществующиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененВидНалогаИПлатежаВБюджет" Тогда
		Если ЗначениеЗаполнено(Параметр.Ссылка) Тогда
				ОбработатьДобавлениеВидаНалога(Параметр.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененениеДатыВводаОстатков" И Источник = "ВводНачальныхОстатков" И Параметр = Объект.Организация Тогда
		Объект.ДатаВводаОстатков = ПеречитатьДатуНачалаУчета(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПередЗакрытиемЗавершение",
		ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти
