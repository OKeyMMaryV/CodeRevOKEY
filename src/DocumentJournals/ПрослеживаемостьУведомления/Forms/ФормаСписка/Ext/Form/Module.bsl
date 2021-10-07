﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.КонтекстныйВызов Тогда
		
		Элементы.Список.Период.ДатаНачала = Параметры.ДатаБольшеИлиРавно;
		Элементы.Список.Период.ДатаОкончания = Параметры.ДатаМеньшеИлиРавно; 
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
				
		Если Параметры.ОтобратьУведомленияСРНПТ Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "РНПТ", , ВидСравненияКомпоновкиДанных.Заполнено, , Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для каждого ТекущаяСтрока Из Строки Цикл
		
		Данные = ТекущаяСтрока.Значение.Данные;
		
		ПредставлениеТипДокумента = НСтр("ru = 'Уведомление'");
		
		Если Данные.НомерКорректировки > 0 Тогда
			
			ПредставлениеТипДокумента = НСтр("ru = 'Корректировочное уведомление'");
			
			Данные.ПредставлениеНомер = ТекстНомераПреставления(
				НомерНаПечатьИсправленногоУведомления(Данные.ДокументУведомление), Данные.НомерКорректировки);
			
		Иначе
			
			Данные.ПредставлениеНомер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Данные.Номер, Истина, Ложь);
				
		КонецЕсли;
		
		Данные.ПредставлениеДата = Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
		
		Если ТипЗНЧ(Данные.Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
			ПредставлениеТипДокумента = ПредставлениеТипДокумента + НСтр("ru = ' об остатках'");
		Иначе
			ПредставлениеТипДокумента = ПредставлениеТипДокумента + НСтр("ru = ' о ввозе'");
		КонецЕсли;
		
		Данные.ПредставлениеТипДокумента = ПредставлениеТипДокумента;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаСервереБезКонтекста
Функция ТекстНомераПреставления(Номер, НомерКорректировки)
	
	ТекстНомера = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 (корр. %2)'"),
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Ложь), 
		НомерКорректировки);
		
	Возврат ТекстНомера;
	
КонецФункции

&НаСервереБезКонтекста
Функция НомерНаПечатьИсправленногоУведомления(ДокументУведомление)
	
	Возврат ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументУведомление, "Номер"));
	
КонецФункции

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",
		?(ПустаяСтрока(КлючНазначенияИспользования), "Уведомления", КлючНазначенияИспользования));
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
		
		Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
			
			Если НЕ ТекущиеДанные.Проведен Тогда
		
				ВывестиСообщениеОбОшибке(
					НСтр("ru='Документ %Документ% не проведен. Ввод на основании непроведенного документа запрещен!'"),
					ТекущиеДанные.Ссылка);
		
			ИначеЕсли НЕ ЗначениеЗаполнено(ТекущиеДанные.РНПТ) Тогда
		
				ВывестиСообщениеОбОшибке(
					НСтр("ru='В документе %Документ% не указан РНПТ. Ввод на основании документа запрещен!'"),
					ТекущиеДанные.Ссылка);
			
			Иначе
				
				ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДокументаКорректировочная", ПараметрыФормы,,,,);
				
			КонецЕсли;
			
		Иначе
			
			ВывестиСообщениеОбОшибке(
					НСтр("ru='Ввод корректировочного уведомления на основании документа %Документ% запрещен!'"),
					ТекущиеДанные.Ссылка);
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Состояние

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Состояние");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Состояние", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не отправлено'"));
	
КонецПроцедуры

&НаКлиенте
Функция ВывестиСообщениеОбОшибке(ТекстОшибки, ДанныеЗаполнения)

	ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДанныеЗаполнения);
	ПоказатьПредупреждение(,ТекстОшибки);
	
КонецФункции

#КонецОбласти
