﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений(фКэшЗначений);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	УстановитьЗаголовокФормыДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	УстановитьЗаголовокФормыДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы

#КонецОбласти

&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)
	
	КэшированныеЗначения = Новый Структура;
	
	// Запишем параметр для формирования заголовка.
	КэшированныеЗначения.Вставить("ПредставлениеОбъекта", Объект.Ссылка.Метаданные().ПредставлениеОбъекта);
	
КонецПроцедуры

// Процедура устнавливает заголовок формы документа.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте 
Процедура УстановитьЗаголовокФормыДокумента()
	
	СтруктураЗаголовка = Новый Структура;
	СтруктураЗаголовка.Вставить("ПредставлениеОбъекта", фКэшЗначений.ПредставлениеОбъекта);
	СтруктураЗаголовка.Вставить("СтрокаВидаОперации"  , "");
	СтруктураЗаголовка.Вставить("ЭтоНовый"			  , Параметры.Ключ.Пустая());
	
	бит_РаботаСДиалогамиКлиент.УстановитьЗаголовокФормыДокумента(ЭтаФорма,СтруктураЗаголовка);
	
КонецПроцедуры // УстановитьЗаголовокФормыДокумента()

#КонецОбласти
