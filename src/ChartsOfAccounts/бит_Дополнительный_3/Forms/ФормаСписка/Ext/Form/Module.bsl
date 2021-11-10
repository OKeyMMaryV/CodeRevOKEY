﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.ПланыСчетов.бит_Дополнительный_3;
	
    Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	фИмяПланаСчетов = СтрЗаменить(Список.ОсновнаяТаблица, "ПланСчетов.", "");
	
	// Выведем установленный заголовок.
    бит_НазначениеСинонимовОбъектов.ВывестиЗаголовокФормы(МетаданныеОбъекта
														 , ЭтаФорма
														 , Перечисления.бит_ВидыФормОбъекта.Списка);
														 
КонецПроцедуры // ПриСозданииНаСервере()

 &НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ТекстВопроса = НСтр("ru='Будет выполнено добавление счетов из шаблона. Продолжить?'");	
	
	ОповещениеСозданиеДокументов = Новый ОписаниеОповещения("ВыопросЗаполнениеПоУмолчанию", ЭтотОбъект);
	
    ПоказатьВопрос(ОповещениеСозданиеДокументов, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет);
			
КонецПроцедуры // ЗаполнитьПоУмолчанию()

&НаКлиенте
// Обработка оповещения вопроса пользователю. 
//
// Параметры:
//  Результат - Строка.
//  ДополнительныеПараметры - Структура.
//
Процедура ВыопросЗаполнениеПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если НЕ Ответ = КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
	
	ЗаполнитьПоУмолчаниюСервер();
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПлануСчетов(Команда)
	
	ПараметрыФормы = Новый Структура("ПланСчетовПриемник", фИмяПланаСчетов);
	ОткрытьФорму("Обработка.бит_ЗаполнитьПланСчетовПоПлануСчетов.Форма", ПараметрыФормы, ЭтаФорма);

	Элементы.Список.Обновить();
	
КонецПроцедуры // ЗаполнитьПоПлануСчетов()

#Область бит_ОбработчикиКомандРаботаСExcel

&НаКлиенте
Процедура ЗагрузитьЧерезТабДок(Команда)
    
    ПараметрыФормы = Новый Структура;
    ПараметрыФормы.Вставить("РежимЗагрузки"	, "ПланСчетов");
    ПараметрыФормы.Вставить("ИмяПланаСчетов", "бит_Дополнительный_3");
    
    ОткрытьФорму("Обработка.бит_ЗагрузкаДанныхИзТабличногоДокумента.Форма"
                    , ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
    
КонецПроцедуры // ЗагрузитьЧерезТабДок()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет счета по умолчанию.
// 
&НаСервере
Процедура ЗаполнитьПоУмолчаниюСервер()
	
	бит_БухгалтерияСервер.ЗаполнитьПланСчетовПоУмолчанию(фИмяПланаСчетов);
			
КонецПроцедуры // ЗаполнитьПоУмолчаниюСервер()

#КонецОбласти

