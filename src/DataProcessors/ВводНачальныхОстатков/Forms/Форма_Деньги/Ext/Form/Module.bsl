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

&НаСервереБезКонтекста
Процедура ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита)
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
	КонецЕсли;
	ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, ?(ИмяРеквизита = "СуммаПроценты", "ВалютнаяСуммаПроценты", "ВалютнаяСумма"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, ИмяРеквизитаВал = "ВалютнаяСумма")
	
	ИмяРасчетногоРеквизита = ИмяРеквизита + "Остаток";
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
		ПараметрыСтроки[ИмяРеквизита] = ПараметрыСтроки[ИмяРасчетногоРеквизита];
	Иначе
		ПараметрыСтроки[ИмяРеквизитаВал] = ПараметрыСтроки[ИмяРасчетногоРеквизита];
		ПараметрыСтроки[ИмяРеквизита] = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
								ПараметрыСтроки[ИмяРасчетногоРеквизита],
								РаботаСКурсамиВалют.ПолучитьКурсВалюты(ПараметрыСтроки.Валюта, ПараметрыСтроки.ДатаВводаОстатков),
								РаботаСКурсамиВалют.ПолучитьКурсВалюты(ПараметрыСтроки.ВалютаРегламентированногоУчета, ПараметрыСтроки.ДатаВводаОстатков));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоляСтрокиТабличнойЧасти(СтрокаТаблицы)
	
	КолонкиТаблицы = СтруктураТаблиц.Получить(0).Значение;
	
	ПараметрыСтроки  = Новый Структура("Организация, ДатаВводаОстатков, ВалютаРегламентированногоУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Объект.ВалютаРегламентированногоУчета);
	
	Для Каждого Колонка ИЗ КолонкиТаблицы Цикл
		ИмяКолонки = Колонка.Значение;
		ПараметрыСтроки.Вставить(ИмяКолонки, СтрокаТаблицы[ИмяКолонки]);
	КонецЦикла;
	
	Возврат ПараметрыСтроки;
	
КонецФункции

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина)
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.Деньги, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.ДенежныеСредства);
		
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "Деньги");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.Деньги, Отбор);
		
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.Деньги);
	
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "БухСправка");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат, Объект.СуществующиеДокументы);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.Деньги, "Деньги", 
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
		Если СтрокаТаблицы.Сумма <> 0
			ИЛИ СтрокаТаблицы.ВалютнаяСумма <> 0 Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанных.Колонки.БанковскийСчет.Имя = "Субконто1";
	
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
		Если Элементы.Деньги.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.Деньги.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		ЗаписатьНаСервере(Истина);
		Если НомерСтроки <> 0 Тогда
			Элементы.Деньги.ТекущаяСтрока = Объект.Деньги[НомерСтроки-1].ПолучитьИдентификатор();
		КонецЕсли;
		Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		
		ЗаполнитьДобавленныеКолонкиТаблиц(ЭтотОбъект);
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
Процедура ДобавитьБанковскийСчет(Команда)
	
	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("Владелец", Объект.Организация);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлемента", ПараметрыФормы,ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДобавлениеБанковскогоСчета(БанковскийСчет)
	
	МассивСтрок = Объект.Деньги.НайтиСтроки(Новый Структура("БанковскийСчет", БанковскийСчет));
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТаблицы = Объект.Деньги.Добавить();
		СтрокаТаблицы.НаименованиеПоказателя = БанковскийСчет;
		СтрокаТаблицы.БанковскийСчет = БанковскийСчет;
		ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
		БанковскийСчетПриИзмененииСервер(ПараметрыСтроки,  "Сумма");
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
		Элементы.Деньги.ТекущаяСтрока = Объект.Деньги[СтрокаТаблицы.НомерСтроки-1].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура БанковскийСчетПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита)
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.БанковскийСчет) Тогда
		ПараметрыСтроки.Валюта = ПараметрыСтроки.БанковскийСчет.ВалютаДенежныхСредств;
	КонецЕсли;
	ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита);
	
	ПараметрыСтроки.СчетВРежимеИнтеграции = ИнтеграцияСБанкамиПовтИсп.ИнтеграцияВключена(ПараметрыСтроки.БанковскийСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньгиСуммаОстатокПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.Деньги.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПересчитатьСуммуСервер(ПараметрыСтроки, "Сумма");
	Если ПараметрыСтроки.Сумма = 0 Тогда
		ПараметрыСтроки.Ссылка = "";
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиТаблиц(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.СчетаВРежимеИнтеграции) Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	Для Каждого СтрокаТаблицыДеньги Из Объект.Деньги Цикл
		СтрокаТаблицыДеньги.СчетВРежимеИнтеграции =
			Форма.СчетаВРежимеИнтеграции.Счета.Найти(СтрокаТаблицыДеньги.БанковскийСчет) <> Неопределено;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Если Не ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеньгиСуммаОстаток");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Деньги.СчетВРежимеИнтеграции", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		Счета = Справочники.НастройкиИнтеграцииСБанками.ВсеБанковскиеСчетаВРежимеИнтеграции();
		Если Счета.Количество() > 0 Тогда
			СчетаВРежимеИнтеграции = Новый Структура("Счета", Счета);
		КонецЕсли;
	КонецЕсли;
	
	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Деньги (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	Заголовок = ТекстЗаголовок;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.Деньги, "Деньги", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.Деньги, "Деньги", 
		Новый Структура("Организация,ДатаВводаОстатков",
					Объект.Организация,Объект.ДатаВводаОстатков),
		Объект.СуществующиеДокументы);
	
	ЗаполнитьДобавленныеКолонкиТаблиц(ЭтотОбъект);
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененБанковскийСчет" Тогда
		Если Параметр.Владелец = Объект.Организация 
			И ЗначениеЗаполнено(Параметр.Ссылка) Тогда
				ОбработатьДобавлениеБанковскогоСчета(Параметр.Ссылка);
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
