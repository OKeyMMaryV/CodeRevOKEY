﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьВариантыЗаполненияЗначений(Параметры.ВариантыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыЗаполненияЗначений

&НаКлиенте
Процедура ВариантыЗаполненияЗначенийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НЕ НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ВариантыЗаполненияЗначений.ТекущиеДанные;
	ТекущиеДанные.ФормироватьАвтоматически = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыЗаполненияЗначенийЗначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВариантыЗаполненияЗначений.ТекущиеДанные;
	Если ТекущиеДанные.ФормироватьАвтоматически Тогда
		ТекущиеДанные.Представление = ТекущиеДанные.Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыЗаполненияЗначенийПредставлениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВариантыЗаполненияЗначений.ТекущиеДанные;
	Если ПустаяСтрока(ТекущиеДанные.Значение) Тогда
		ТекущиеДанные.Значение = ТекущиеДанные.Представление;
	КонецЕсли;
	
	ТекущиеДанные.ФормироватьАвтоматически = ТекущиеДанные.Значение = ТекущиеДанные.Представление;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	Если ВариантыЗаполненияЗначений.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнен список вариантов заполнения значений дополнительных полей'"),,
			"ВариантыЗаполненияЗначений");
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Ошибки = Неопределено;
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2'");
	МассивСтрок = Новый Массив;
	НомерСтроки = 1;
	Для Каждого СтрокаТаблицы Из ВариантыЗаполненияЗначений Цикл
		
		Если ПустаяСтрока(СтрокаТаблицы.Значение) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"ВариантыЗаполненияЗначений[%1].Значение",
				СтрШаблон(ШаблонСообщения, НСтр("ru = 'Значение'"), НомерСтроки), Неопределено,
				НомерСтроки - 1);
		КонецЕсли;
		
		Если ПустаяСтрока(СтрокаТаблицы.Представление) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"ВариантыЗаполненияЗначений[%1].Представление",
				СтрШаблон(ШаблонСообщения, НСтр("ru = 'Отображать как'"), НомерСтроки), Неопределено,
				НомерСтроки - 1);
		КонецЕсли;
		
		МассивСтрок.Добавить(СтрокаТаблицы.Представление);
		
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
	КонецЕсли;
	
	МассивВариантов = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ВариантыЗаполненияЗначений Цикл
		СтруктураВарианта = Новый Структура("Значение, Представление");
		ЗаполнитьЗначенияСвойств(СтруктураВарианта, СтрокаТаблицы);
		МассивВариантов.Добавить(СтруктураВарианта);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", Новый ФиксированныйМассив(МассивВариантов));
	Результат.Вставить("Представление", СтрСоединить(МассивСтрок, "; "));
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВариантыЗаполненияЗначений(ВариантыЗаполнения);
	
	Если Не ЗначениеЗаполнено(ВариантыЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Вариант Из ВариантыЗаполнения Цикл
		
		НоваяСтрока = ВариантыЗаполненияЗначений.Добавить();
		НоваяСтрока.Значение = Вариант.Значение;
		НоваяСтрока.Представление = Вариант.Представление;
		НоваяСтрока.ФормироватьАвтоматически = НоваяСтрока.Значение = НоваяСтрока.Представление;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти