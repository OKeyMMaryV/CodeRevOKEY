﻿&НаКлиенте
Перем УстановкаОсновногоКонтактногоЛицаВыполнена;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Отбор.Свойство("ОбъектВладелец") 
		И ЗначениеЗаполнено(Параметры.Отбор.ОбъектВладелец) 
		И ТипЗнч(Параметры.Отбор.ОбъектВладелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		ОсновноеКонтактноеЛицо = Параметры.Отбор.ОбъектВладелец.ОсновноеКонтактноеЛицо;
		Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицо", ОсновноеКонтактноеЛицо);
		Элементы.ВидКонтактногоЛица.Видимость = Ложь;
	Иначе
		Элементы.ФормаИспользоватьОсновным.Видимость = Ложь;
		Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицо", Неопределено);
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.КонтактныеЛица);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ДоступноИспользоватьОсновным = ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УстановкаОсновногоКонтактногоЛицаВыполнена" Тогда
		УстановкаОсновногоКонтактногоЛицаВыполнена = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеФормойКлиент();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.Ссылка = ОсновноеКонтактноеЛицо Тогда
		ОсновноеКонтактноеЛицо = ПредопределенноеЗначение("Справочник.КонтактныеЛица.ПустаяСсылка");
	Иначе
		ОсновноеКонтактноеЛицо = Элементы.Список.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицо", ОсновноеКонтактноеЛицо);
	
	УстановкаОсновногоКонтактногоЛицаВыполнена = Ложь;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Контрагент", Элементы.Список.ТекущиеДанные.ОбъектВладелец);
	СтруктураПараметров.Вставить("ОсновноеКонтактноеЛицо", ОсновноеКонтактноеЛицо);
	
	Оповестить("УстановкаОсновногоКонтактногоЛица", СтруктураПараметров);
	
	// Если форма владельца закрыта, то запишем основное контактеное лицо самостоятельно.
	Если НЕ УстановкаОсновногоКонтактногоЛицаВыполнена Тогда
		ЗаписатьОсновноеКонтактноеЛицо(СтруктураПараметров);
	КонецЕсли;
	
	УправлениеФормойКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписатьОсновноеКонтактноеЛицо(СтруктураПараметров)
	
	Контрагент = СтруктураПараметров.Контрагент;
	КонтрагентОбъект = Контрагент.ПолучитьОбъект();
	
	УстановитьОсновноеКонтактноеЛицо = Истина;
	
	Попытка
		КонтрагентОбъект.Заблокировать();
	Исключение
		// в случае блокировки - не выполнять изменение объекта
		УстановитьОсновноеКонтактноеЛицо = Ложь;
		// записать предупреждение в журнал регистрации
		ШаблонСообщения = НСтр("ru = 'Не удалось заблокировать справочник ""Контрагенты""
                                |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Изменение контактных лиц контрагента'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Справочники.Контрагенты, 
			Контрагент, 
			ТекстСообщения);
	КонецПопытки;
	
	Если УстановитьОсновноеКонтактноеЛицо Тогда
		КонтрагентОбъект.ОсновноеКонтактноеЛицо = СтруктураПараметров.ОсновноеКонтактноеЛицо;
		КонтрагентОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормойКлиент()
	
	Если ОсновноеКонтактноеЛицо = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДоступноИспользоватьОсновным И НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Элементы.ФормаИспользоватьОсновным.Пометка	=
			Элементы.Список.ТекущиеДанные.Ссылка	= ОсновноеКонтактноеЛицо;
	КонецЕсли;
	
	Если ДоступноИспользоватьОсновным Тогда
		Элементы.ФормаИспользоватьОсновным.Доступность	= НЕ Элементы.Список.ТекущиеДанные = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

