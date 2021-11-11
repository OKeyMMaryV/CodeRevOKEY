﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяВзноса = Параметры.ИмяВзноса;
	Всего     = Параметры.Всего;
	Уплачено  = Параметры.Уплачено;
	Сумма     = Параметры.Сумма;
	
	Период           = КонецКвартала(Параметры.Период);
	Организация      = Параметры.Организация;
	СтруктураДоходов = Параметры.СтруктураДоходов;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураДоходов);
	ПредельнаяСуммаВзноса = Параметры.ПредельнаяСуммаВзноса;
	
	ТаблицаПлатежей = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыПлатежей);
	Если ТипЗнч(ТаблицаПлатежей) = Тип("ТаблицаЗначений") Тогда
		Платежи.Загрузить(ТаблицаПлатежей);
		Для Каждого Платеж Из Платежи Цикл
			Платеж.ПредставлениеДокумента = ПомощникиПоУплатеНалоговИВзносов.ПредставлениеДокументаОплаты(Платеж, Истина);
		КонецЦикла;
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
	ИспользуетсяИнтеграцияСБанком = ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
	
	Заголовок = Параметры.Заголовок;
	
	Элементы.ЗаголовокКОплате.Заголовок = СтрШаблон(НСтр("ru = 'К оплате за %1 квартал'"), Формат(Период, "ДФ=к"));
	
	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененВидДеятельностиОрганизации" Тогда
		
		Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Организации") И Параметр = Организация Тогда
			ЗаполнитьСтраховыеВзносыНаСервере();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменениеВыписки" 
		ИЛИ ИмяСобытия = "ОбновитьПоказателиРасчетаУСН" И Не ЗначениеЗаполнено(Параметр)
		ИЛИ ИмяСобытия = "ИзменениеЗаписиКУДиР" Тогда
		
		ЗаполнитьСтраховыеВзносыНаСервере();
		
	ИначеЕсли ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" Тогда
		
		Налог = Неопределено;
		
		Если ТипЗнч(Параметр) = Тип("Структура")
			И Параметр.Свойство("Организация") И Параметр.Организация = Организация
			И Параметр.Свойство("Налог", Налог) И ЗначениеЗаполнено(Налог)
			И Параметр.Свойство("Оплачено") И Параметр.Оплачено = Истина
			И ЭтоФиксированныеВзносы(Налог) Тогда
			
			ЗаполнитьСтраховыеВзносыНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаДоходаИПНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("РежимРасшифровки", Истина);
	СтруктураПараметров.Вставить("Организация",      Организация);
	СтруктураПараметров.Вставить("НачалоПериода",    НачалоГода(Период));
	СтруктураПараметров.Вставить("КонецПериода",     КонецКвартала(Период));
	
	ОткрытьФорму("Отчет.КнигаУчетаДоходовИРасходовПредпринимателя.Форма", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаУСННажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация",   Организация);
	СтруктураПараметров.Вставить("НачалоПериода", НачалоГода(Период));
	СтруктураПараметров.Вставить("КонецПериода",  КонецКвартала(Период));
	
	ИмяФормыРасшифровки = ?(ИспользуетсяИнтеграцияСБанком, "РасшифровкаДоходовИнтеграцияСБанком", "РасшифровкаДоходов");
	ПолноеИмяФормыРасшифровки = СтрШаблон("Обработка.ПомощникРасчетаНалогаУСН.Форма.%1", ИмяФормыРасшифровки);
	
	ОткрытьФорму(ПолноеИмяФормыРасшифровки, СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПотенциальноВозможныйДоходНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", Новый Структура("Владелец", Организация));
	СтруктураПараметров.Вставить("Период", Период);
	
	ОткрытьФорму("Справочник.Патенты.ФормаСписка", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВмененныйДоходНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация",   Организация);
	СтруктураПараметров.Вставить("НачалоПериода", НачалоГода(Период));
	СтруктураПараметров.Вставить("КонецПериода",  КонецКвартала(Период));
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВмененныйДоходПоВидамДеятельностиЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ВидыДеятельностиЕНВД.Форма.ВмененныйДоход",
		СтруктураПараметров,
		ЭтотОбъект,
		Истина,
		,
		,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыбореИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОплатуЧерезБанк(Команда)
	
	Перем ВидНалога, БанковскийСчет;
	
	ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть");
	
	Если ИспользуетсяИнтеграцияСБанком Тогда
		БанковскийСчет = ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка");
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.СоздатьОплатуЧерезБанк(
		Организация,
		Период,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидНалога),
		ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела"),
		БанковскийСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОплатуНаличными(Команда)
	
	Перем ВидНалога;
	
	ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть");
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.СоздатьОплатуНаличными(
		Организация,
		Период,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидНалога),
		ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	НачалоПериода = НачалоГода(Период);
	КонецПериода  = КонецГода(Период);
	
	Если УчетнаяПолитика.Существует(Организация, КонецПериода) Тогда
		ПлательщикНДФЛ       = УчетнаяПолитика.ПлательщикНДФЛЗаПериод(Организация, НачалоПериода, КонецПериода);
		ПрименяетсяУСН       = УчетнаяПолитика.ПрименяетсяУСНЗаПериод(Организация, НачалоПериода, КонецПериода);
		ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатентЗаПериод(Организация, НачалоПериода, КонецПериода);
		ПлательщикЕНВД       = УчетнаяПолитика.ПлательщикЕНВДЗаПериод(Организация, НачалоПериода, КонецПериода);
	Иначе
		День = 24 * 60 * 60;
		ПлательщикНДФЛ       = УчетнаяПолитика.ПлательщикНДФЛ(Организация, КонецПериода + День);
		ПрименяетсяУСН       = УчетнаяПолитика.ПрименяетсяУСН(Организация, КонецПериода + День);
		ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, КонецПериода + День);
		ПлательщикЕНВД       = УчетнаяПолитика.ПлательщикЕНВД(Организация, КонецПериода + День);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	// Суммы доходов по видам деятельности
	
	Элементы.Всего.Подсказка = ?(ПредельнаяСуммаВзноса, НСтр("ru = ' (предельная сумма взноса)'"), "");
	Элементы.ДекорацияФормулаРасчета.Видимость = Не ПредельнаяСуммаВзноса;
	
	НесколькоВидовДеятельности =
		(ПлательщикНДФЛ + ПрименяетсяУСН + ПлательщикЕНВД + ПрименяетсяУСНПатент) > 1;
	
	Элементы.СуммаДоходаИП.Видимость = ПлательщикНДФЛ;
	Элементы.СуммаДоходаУСН.Видимость = ПрименяетсяУСН;
	Элементы.ВмененныйДоход.Видимость = ПлательщикЕНВД;
	Элементы.ПотенциальноВозможныйДоход.Видимость = ПрименяетсяУСНПатент;
	
	Элементы.ГруппаСуммаДоходов.Отображение = ?(НесколькоВидовДеятельности,
		ОтображениеОбычнойГруппы.ОбычноеВыделение, ОтображениеОбычнойГруппы.Нет);
	Элементы.ВсегоДоходов.Видимость = НесколькоВидовДеятельности;
	
	// Формула расчета взносов с доходов
	
	ФормулаРасчета = Обработки.РасчетСтраховыхВзносовИП.ФормулаРасчетаВзносовСДоходов(Организация, Период);
	
	ДекорацияПояснениеКФормулеРасчета = ФормулаРасчета.Пояснение;
	ДекорацияФормулаРасчета = ФормулаРасчета.Формула;
	
	Элементы.ФиксированнаяЧастьВзносов.Видимость = ФормулаРасчета.ЕстьФиксированнаяЧастьВзносов;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтраховыеВзносыНаСервере()
	
	// Доходы по видам деятельности
	СтруктураДоходов = УчетСтраховыхВзносовИП.СтруктураДоходовПоВидамДеятельности(
		Организация, НачалоГода(Период), КонецКвартала(Период));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураДоходов);
	
	// Страховые взносы, исчисленные с суммы доходов
	СтраховыеВзносыСДоходовКУплате = УчетСтраховыхВзносовИП.СтраховыеВзносыСДоходовКУплате(
		Организация, Период, СтруктураДоходов, Ложь);
	
	ПредельнаяСуммаВзноса = СтраховыеВзносыСДоходовКУплате.ПредельнаяСуммаВзноса;
	Всего                 = СтраховыеВзносыСДоходовКУплате.СуммаВзносаПФРсДоходовВсего;
	Уплачено              = СтраховыеВзносыСДоходовКУплате.СуммаВзносаПФРсДоходовУплачено;
	Сумма                 = СтраховыеВзносыСДоходовКУплате.СуммаВзносаПФРсДоходов;
	
	ТаблицаПлатежей = СтраховыеВзносыСДоходовКУплате.СтраховыеВзносыУплаченные;
	Если ТаблицаПлатежей <> Неопределено Тогда
		ТаблицаПлатежей.Колонки.ДокументОплаты.Имя = "Ссылка";
		ТаблицаПлатежей.Колонки.НомерДокументаОплаты.Имя = "Номер";
		ТаблицаПлатежей.Колонки.ДатаДокументаОплаты.Имя = "Дата";
		Платежи.Загрузить(ТаблицаПлатежей);
		Для Каждого Платеж Из Платежи Цикл
			Платеж.ПредставлениеДокумента = ПомощникиПоУплатеНалоговИВзносов.ПредставлениеДокументаОплаты(Платеж, Истина);
		КонецЦикла;
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореИЗакрыть()
	
	ЗначениеВыбора = Новый Структура;
	ЗначениеВыбора.Вставить(ИмяВзноса, Сумма);
	ЗначениеВыбора.Вставить("СтруктураДоходов", СтруктураДоходов);
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВмененныйДоходПоВидамДеятельностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьСтраховыеВзносыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеУдаленияПлатежногоДокумента()
	Возврат Новый ОписаниеОповещения("УдалитьДокументУплатыНаКлиентеЗавершение", ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура УдалитьДокументУплатыНаКлиентеЗавершение(ДокументУплатыДляУдаления, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДокументУплатыДляУдаления) Тогда
		УдалитьДокументУплаты(ДокументУплатыДляУдаления);
		Оповестить("УдалитьДокументУплаты", ДокументУплатыДляУдаления);
		Оповестить("ОбновитьПоказателиРасчетаУСН", , ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументУплаты(ДокументУплатыДляУдаления)
	
	ДокументУплатыОбъект = ДокументУплатыДляУдаления.ПолучитьОбъект();
	ДокументУплатыОбъект.УстановитьПометкуУдаления(Истина);
	
	УдалитьДокументУплатыИзТаблицыПлатежей(ДокументУплатыДляУдаления);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументУплатыИзТаблицыПлатежей(ДокументУплатыДляУдаления)
	
	СтрокиПлатежа = Платежи.НайтиСтроки(Новый Структура("Ссылка", ДокументУплатыДляУдаления));
	Для Каждого СтрокаПлатежа Из СтрокиПлатежа Цикл
		Уплачено = Уплачено - СтрокаПлатежа.Сумма;
		Платежи.Удалить(СтрокаПлатежа);
		Сумма = Макс(Всего - Уплачено, 0);
	КонецЦикла;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОповеститьОВыбореИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПлатежОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПлатежныхДокументов = ПомощникиПоУплатеНалоговИВзносовКлиент.ПараметрыОбработкиПлатежныхДокументов(
		Платежи, "Платеж", ОповещениеУдаленияПлатежногоДокумента());
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.ОбработкаНавигационнойСсылкиПлатежногоДокумента(Элемент, НавигационнаяСсылкаФорматированнойСтроки, ПараметрыПлатежныхДокументов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоФиксированныеВзносы(Знач Налог)
	
	Возврат Обработки.РасчетСтраховыхВзносовИП.ЭтоФиксированныеВзносы(Налог);
	
КонецФункции

#КонецОбласти
