﻿////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияСЯндексКассойСлужебныйКлиент: механизм интеграции с Яндекс.Кассой.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму формирования платежной ссылки основания платежа.
// Перед открытием проверяется наличие подключенной интернет поддержки пользователей.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого будет формироваться ссылка.
//
Процедура ОткрытьФормуПлатежнойСсылки(Знач ОснованиеПлатежа) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьФормуПлатежнойСсылкиПродолжение", ЭтотОбъект, Параметры);
	
	НачатьПроверкуИПодключениеИПП(ОбработкаПродолжения);
	
КонецПроцедуры

// Получает данные для заполнения предопределенного шаблона сообщений.
//
// Параметры:
//   ДанныеЗаполнения - Структура - Структура данных заполнения, обязательно необходимо указать:
//    * ПолноеИмяТипаНазначения - Строка - Полное имя объекта метаданных, на основании которого по данному шаблону будут создаваться сообщения.
//    * ТипШаблона - Строка - тип шаблона должен быть "Письмо".
//    * ФорматПисьма - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем - формат письма, должен быть HTML.
//
Процедура ПолучитьДанныеЗаполненияПредопределенногоШаблона(ДанныеЗаполнения) Экспорт 
	
	ПредопределенныеШаблоныСообщений =  Новый Массив;
	ИнтеграцияСЯндексКассойСлужебныйВызовСервера.ПредопределенныеШаблоныСообщений(ПредопределенныеШаблоныСообщений);
	
	Для Каждого Шаблон Из ПредопределенныеШаблоныСообщений Цикл 
		
		Если ДанныеЗаполнения.ПолноеИмяТипаНазначения = Шаблон.ПолноеИмяТипаНазначения Тогда 
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДанныеЗаполнения, Шаблон, Истина);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// См. ИнтеграцияСЯндексКассой.ПриОпределенииКомандПодключенныхКОбъекту
Процедура Подключаемый_ОткрытьФормуПлатежнойСсылки(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт 
	
	ИнтеграцияСЯндексКассойКлиент.ОткрытьФормуПлатежнойСсылки(ПараметрКоманды);
	
КонецПроцедуры

// Выполнение проверки и подключение к ИПП.
//
// Параметры:
//  ОбработкаЗавершения - ОписаниеОповещения - Процедура, которая будет либо выполнена сразу, если вход в ИПП выполнен,
//                                             либо после вывода пользователю диалога о необходимости подключения к
//                                             ИПП и ввода учетных данных.
//                                             Параметр Результат процедуры-обработчика может принимать значение Ложь,
//                                             если пользователь отказался от подключения к ИПП или отменил ввод
//                                             учетных данных, либо Истина, если вход в ИПП выполнен.
//
Процедура НачатьПроверкуИПодключениеИПП(Знач ОбработкаЗавершения = Неопределено) Экспорт
	
	Если ПроверитьПодключениеИПП() Тогда
		
		Если ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОбработкаЗавершения, Истина);
		КонецЕсли;
		
	Иначе
		
		ПоказатьВопросПодключенияИПП(ОбработкаЗавершения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования. Продолжение ОткрытьФормуПлатежнойСсылки после проверки и подключения ИПП.
Процедура ОткрытьФормуПлатежнойСсылкиПродолжение(Знач ПодключенаИПП, Знач Параметры) Экспорт
	
	Если Не ПодключенаИПП Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ИнтеграцияСЯндексКассой.ОткрытиеФормыПлатежнойСсылки");
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОснованиеПлатежа", Параметры.ОснованиеПлатежа);
	
	ОткрытьФорму("Справочник.НастройкиЯндексКассы.Форма.ФормаПодготовкиПлатежнойСсылки", ПараметрыФормы);
	
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей

Функция ПроверитьПодключениеИПП() 
	
	Возврат ИнтеграцияСЯндексКассойСлужебныйВызовСервера.ДанныеИнтернетПоддержкиУказаны();
	
КонецФункции

Процедура ПоказатьВопросПодключенияИПП(Знач ОбработкаЗавершения = Неопределено) 
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОбработкаЗавершения", ОбработкаЗавершения);
	
	ОбработкаОтвета = Новый ОписаниеОповещения("ПоказатьВопросПодключенияИПП_Завершение", ЭтотОбъект, Параметры);
	
	ТекстВопроса = НСтр("ru='Для использования функций взаимодействия с сервисом Яндекс.Касса,
		|необходимо подключиться к Интернет-поддержке пользователей.
		|Подключиться сейчас?'");
	ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПоказатьВопросПодключенияИПП.
Процедура ПоказатьВопросПодключенияИПП_Завершение(Знач Ответ, Знач Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОбработкаПодключения = Новый ОписаниеОповещения("НачатьПодключениеИПП_Завершение", ЭтотОбъект, Параметры);
		
		НачатьПодключениеИПП(ОбработкаПодключения);
		
	Иначе
		
		Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПодключениеИПП(Знач ОбработкаПодключения = Неопределено)
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОбработкаПодключения, ЭтотОбъект);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры НачатьПодключениеИПП
Процедура НачатьПодключениеИПП_Завершение(Знач ДанныеПодключения, Знач Параметры) Экспорт
	
	Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
		
		Подключено = (ДанныеПодключения <> Неопределено);
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Подключено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти