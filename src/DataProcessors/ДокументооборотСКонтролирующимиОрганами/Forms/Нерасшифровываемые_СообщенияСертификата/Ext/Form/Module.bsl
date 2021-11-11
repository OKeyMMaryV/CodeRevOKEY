﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ИспользоватьСертификат.Видимость =	Не Параметры.СкрытьПереключатель;
	ИспользоватьСертификат = Не Параметры.Игнорировать;
	
	СертификатОрганизация =  Параметры.Свойства.ПодробноеОписание;
	СертификатОтпечаток = Параметры.Свойства.ОтпечатокСтрокой;
	СертификатСерийныйНомер = Параметры.Свойства.СерийныйНомерСтрокой;
	
	Если ЗначениеЗаполнено(Параметры.Свойства.ОтпечатокСтрокой) Тогда 
		Элементы.СертификатОтпечаток.Видимость = Истина;
	Иначе 
		Элементы.СертификатОтпечаток.Видимость = Ложь;
		
		Если ЗначениеЗаполнено(Параметры.Свойства.СерийныйНомерСтрокой) Тогда 
			Элементы.СертификатСерийныйНомер.Видимость = Истина;
		Иначе 
			Элементы.СертификатСерийныйНомер.Видимость = Ложь;
		КонецЕсли;
	
	КонецЕсли;
	
	ОбновитьНадписиБлокировки(Параметры.Свойства);
			
	Если Параметры.Свойства.Текущий Тогда 
		Элементы.ГруппаТумблер.Доступность = Ложь;		
		Элементы.ИспользоватьСертификат.Подсказка = "настройка не разрешена для действующего сертификата 1С-Отчетности";
	КонецЕсли;
			
	Для Каждого ВхЗапись Из Параметры.Записи Цикл 
		ЗаписьСообщение = Сообщения.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьСообщение, ВхЗапись);
		ЗаписьСообщение.Расшифровка = ДобавитьМесяц(ТекущаяДатаСеанса(), -1);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИспользоватьСертификатСтр = Строка(ИспользоватьСертификат);
	ПрименитьОформлениеТумблера()
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭтаФорма.ВладелецФормы.ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСертификатПриИзменении(Элемент)
	
	ИспользоватьСертификатСтр = НЕ Булево(ИспользоватьСертификатСтр); // Отменим переключение
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеДиалогаСообщенийСертификата", ЭтотОбъект, Неопределено);
	ЭтотОбъект.ВладелецФормы.ПереключениеРасшифровкиПоСертификату(ОповещениеОЗакрытии, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СообщенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Поле.Имя = "СообщенияОписание" Тогда 
		Если ЗначениеЗаполнено(Сообщения[ВыбраннаяСтрока].ТранспортноеСообщение) Тогда 
			ПоказатьЗначение(, Сообщения[ВыбраннаяСтрока].ТранспортноеСообщение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрименитьОформлениеТумблера()
	
	Если ИспользоватьСертификат Тогда 		
		Элементы.ФлагВнимание.Видимость = Ложь;
		Элементы.НадписьВнимание.Видимость = Ложь;
	Иначе 
		Элементы.ФлагВнимание.Видимость = Истина;
		Элементы.НадписьВнимание.Видимость = Истина;		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПримечаниеБлокировки) Тогда 
		Элементы.ПримечаниеБлокировки.Видимость = Не ИспользоватьСертификат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписиБлокировки(Свойства)
	Элементы.ПримечаниеБлокировки.Видимость = Ложь;
	Если ЗначениеЗаполнено(Свойства.ДатаБлокировки) Тогда 
		Элементы.НадписьВнимание.Заголовок = СтрШаблон("не используется с %1 по инициативе пользователя ""%2""",
			Свойства.ДатаБлокировки,
			Свойства.ИнициаторБлокировки
		);
		Если ЗначениеЗаполнено(Свойства.ПричинаБлокировки) Тогда 
			ПримечаниеБлокировки = Свойства.ПричинаБлокировки;
			Элементы.ПримечаниеБлокировки.Видимость = Истина;
		Иначе
			ПримечаниеБлокировки = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеДиалогаСообщенийСертификата(Результат, ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			ОбновитьНадписиБлокировки(Результат.ОбновленныеСвойства);
			Результат = Результат.Результат;
		КонецЕсли;
		ИспользоватьСертификат = Не Результат;
		ИспользоватьСертификатСтр = Строка(ИспользоватьСертификат);
		ПрименитьОформлениеТумблера()
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
