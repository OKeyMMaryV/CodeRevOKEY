﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// бит_Финанс изменения кода. Начало.
	бит_Казначейство.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	бит_Казначейство.ПодготовитьФормуНаСервере(ЭтотОбъект);
	// бит_Финанс изменения кода. Конец.

	ЗагрузитьПараметрыВРеквизитыФормы();
	ПоступлениеНаРасчетныйСчетФормы.ПодготовитьФормуНаСервере(ЭтотОбъект);
	ПоступлениеНаРасчетныйСчетФормы.УстановитьПараметрыВыбораСчетовУчетаДенежныхСредств(ЭтотОбъект);
	ПоступлениеНаРасчетныйСчетФормы.УстановитьВидимостьСчетовУчета(ЭтотОбъект);
	ПоступлениеНаРасчетныйСчетФормы.УстановитьУсловноеОформление(ЭтотОбъект);	

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И (Модифицированность ИЛИ ПеренестиВДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		Отказ = НЕ ПроверитьЗаполнение();
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		ИсходящиеПараметры = Новый Структура("СвойстваПлатежа");
		ЗаполнитьЗначенияСвойств(ИсходящиеПараметры,  ЭтотОбъект);
		ИсходящиеПараметры.Вставить("СуммаДокумента", Объект.СуммаДокумента);
		ИсходящиеПараметры.Вставить("СуммаУслуг",     Объект.СуммаУслуг);
		ИсходящиеПараметры.Вставить("Графа5_УСН",     Объект.Графа5_УСН);
		ИсходящиеПараметры.Вставить("АдресХранилищаРасшифровкаПлатежа", АдресХранилищаРасшифровкаПлатежа);
		Модифицированность = Ложь;
		ОповеститьОВыборе(ИсходящиеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ПоступлениеНаРасчетныйСчет.ОбработкаПроверкиЗаполненияРасшифровкаПлатежа(
		Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	// Чтобы дважды не вызывать сервер, сразу поместим во временное хранилище 
	// таблицу РасшифровкаПлатежа.
	Если НЕ Отказ Тогда
		АдресХранилищаРасшифровкаПлатежа = ПоместитьРасшифровкаПлатежаВоВременноеХранилище();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыРасшифровкаПлатежа

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасшифровкаПлатежа

&НаКлиенте
Процедура РасшифровкаПлатежаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПередУдалением(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаПлатеж = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	Если СтрокаПлатеж.ДоговорКонтрагента = СвойстваПлатежа.ДоговорКонтрагента
		И РасшифровкаПлатежа.Индекс(СтрокаПлатеж) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииНаСервере(СтрокаПлатеж.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.СтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСпособПогашенияЗадолженностиПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.СпособПогашенияЗадолженностиПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.СделкаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСуммаПлатежаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаСуммаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаКурсВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаКурсВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСуммаВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаСуммаВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСтавкаНДСПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.СтавкаНДСПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСчетУчетаРасчетовСКонтрагентомПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаСчетУчетаРасчетовСКонтрагентомПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеАвансаПредставлениеПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеАвансаПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеАвансаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеАвансаПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеДоходаПредставлениеПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеДоходаПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеДоходаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеДоходаПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнкассация

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСчетУчетаРасчетовСКонтрагентомПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСчетУчетаРасчетовСКонтрагентомПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт1ПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтПриИзменении(ЭтотОбъект, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт2ПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтПриИзменении(ЭтотОбъект, 2);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт3ПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтПриИзменении(ЭтотОбъект, 3);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСубконтоКт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияСубконтоКтНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияПередУдалением(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		СтрокаПлатеж = Элемент.ТекущиеДанные;
		Если НЕ Копирование Тогда
			ЗаполнитьЗначенияСвойств(СтрокаПлатеж, Объект, "СчетУчетаРасчетовСКонтрагентом");
			
			ЗаполнитьДобавленныеКолонкиТаблиц();
		КонецЕсли;
		
		СтрокаПлатеж.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
	// бит_Финанс изменения кода. Начало.
	Если НоваяСтрока Тогда
		бит_КазначействоКлиентСервер.ЗаполнитьКлючВРасшифровке(СтрокаПлатеж);
	КонецЕсли; 
	// бит_Финанс изменения кода. Конец. 
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияПередНачаломИзменения(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаИнкассацияПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаИнкассацияСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ИнкассацияСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПокупкаВалюты

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыПередУдалением(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыСуммаПлатежаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыСуммаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыСуммаВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПокупкаВалютыСуммаВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыКурсВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПокупкаВалютыКурсВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыКурсВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПокупкаВалютыКурсВзаиморасчетовНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыДоговорКонтрагентаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыДоговорКонтрагентаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыДоговорКонтрагентаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПокупкаВалютыДоговорКонтрагентаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПокупкаВалютыСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПродажаВалюты

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыПередУдалением(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыСуммаВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПродажаВалютыСуммаВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыСуммаПлатежаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыСуммаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыКурсВзаиморасчетовПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПродажаВалютыКурсВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыКурсВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПродажаВалютыКурсВзаиморасчетовНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыДоговорКонтрагентаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыДоговорКонтрагентаОткрытие(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыДоговорКонтрагентаПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПродажаВалютыДоговорКонтрагентаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПродажаВалютыСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлатежныеКарты

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПлатежныеКартыПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыПередУдалением(Элемент, Отказ)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыСуммаПлатежаПриИзменении(Элемент)
	
	СтрокаПлатеж = Элемент.Родитель.ТекущиеДанные;
	РасшифровкаПлатежаПлатежныеКартыСуммаПлатежаПриИзмененииНаСервере(СтрокаПлатеж.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыСуммаУслугПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПлатежныеКартыСуммаУслугПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыДоговорКонтрагентаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПлатежныеКартыДоговорКонтрагентаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаПлатеж = Элемент.Родитель.ТекущиеДанные;
	Если СтрокаПлатеж.ДоговорКонтрагента = СвойстваПлатежа.ДоговорКонтрагента
		И РасшифровкаПлатежа.Индекс(СтрокаПлатеж) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	РасшифровкаПлатежаПлатежныеКартыДоговорКонтрагентаПриИзмененииНаСервере(СтрокаПлатеж.ПолучитьИдентификатор());
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПлатежныеКартыДоговорКонтрагентаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.ПлатежныеКартыСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПлатежныеКартыПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПлатежныеКартыПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыОтражениеДоходаПредставлениеПриИзменении(Элемент)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеДоходаПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПлатежныеКартыОтражениеДоходаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаОтражениеДоходаПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьИСохранить(Команда)
	
	Если Модифицированность Тогда
		ПеренестиВДокумент = Истина;
		Закрыть(КодВозвратаДиалога.OK);
	Иначе
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииНаСервере(ИдСтроки)
	
	СтрокаПлатеж = РасшифровкаПлатежа.НайтиПоИдентификатору(ИдСтроки);
	ПоступлениеНаРасчетныйСчетФормы.ДоговорКонтрагентаПриИзмененииНаСервере(СтрокаПлатеж, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура РасшифровкаПлатежаПлатежныеКартыСуммаПлатежаПриИзмененииНаСервере(ИдСтроки);
	
	СтрокаПлатеж = РасшифровкаПлатежа.НайтиПоИдентификатору(ИдСтроки);
	ПоступлениеНаРасчетныйСчетФормы.ПлатежныеКартыСуммаПлатежаПриИзмененииНаСервере(СтрокаПлатеж, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура РасшифровкаПлатежаПлатежныеКартыДоговорКонтрагентаПриИзмененииНаСервере(ИдСтроки)
	
	СтрокаПлатеж = РасшифровкаПлатежа.НайтиПоИдентификатору(ИдСтроки);
	ПоступлениеНаРасчетныйСчетФормы.ПлатежныеКартыДоговорКонтрагентаПриИзмененииНаСервере(СтрокаПлатеж, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	ПоступлениеНаРасчетныйСчетФормы.ЗаполнитьДобавленныеКолонкиТаблиц(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьРасшифровкаПлатежаВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(РасшифровкаПлатежа.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПОДКЛЮЧАЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


////////////////////////////////////////////////////////////////////////////////
// ЗАВЕРШЕНИЕ НЕМОДАЛЬНЫХ ВЫЗОВОВ

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
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
Процедура РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбораЗавершение(
		ЭтотОбъект, РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПокупкаВалютыКурсВзаиморасчетовНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПокупкаВалютыКурсВзаиморасчетовНачалоВыбораЗавершение(
		ЭтотОбъект, РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПродажаВалютыКурсВзаиморасчетовНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПоступлениеНаРасчетныйСчетФормыКлиент.РасшифровкаПлатежаПродажаВалютыКурсВзаиморасчетовНачалоВыбораЗавершение(
		ЭтотОбъект, РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПараметрыВРеквизитыФормы()
	
	Объект = Новый Структура("Ссылка, Дата, ВидОперации, Организация, СчетОрганизации, ВалютаДокумента, СчетБанк,
		|Контрагент, СчетКонтрагента, ВалютаДокумента, НазначениеПлатежа, КурсНаДатуПриобретенияРеализацииВалюты,
		|СуммаДокумента, СуммаУслуг, БезЗакрывающихДокументов,
		|СчетУчетаРасчетовСКонтрагентом, Графа4_УСН, Графа5_УСН");
	Объект.Вставить("ДополнительныеСвойства", Новый Структура()); // Используется при проверке заполнения.
	ЗаполнитьЗначенияСвойств(Объект,     Параметры.ПараметрыФормы.Шапка);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы.Шапка);
	БезЗакрывающихДокументов = Объект.БезЗакрывающихДокументов;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы,
		"СвойстваПлатежа,
		|ПрименениеУСН, ПрименениеУСНДоходы, ПрименяетсяОсобыйПорядокНалогообложения, ПрименяетсяУСНПатент,
		|ОплатаВВалюте, КурсДокумента, КратностьДокумента");
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыФормы.АдресХранилищаРасшифровкаПлатежа) Тогда
		РасшифровкаПлатежа.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ПараметрыФормы.АдресХранилищаРасшифровкаПлатежа));
	КонецЕсли;
	
	Ссылка = Параметры.Ключ;
	
	Если РасшифровкаПлатежа.Количество() = 0 Тогда
		РасшифровкаПлатежа.Добавить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
