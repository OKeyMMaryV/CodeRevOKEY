﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МаршрутыПодписания.Ссылка
	               |ИЗ
	               |	Справочник.МаршрутыПодписания КАК МаршрутыПодписания
	               |ГДЕ
	               |	МаршрутыПодписания.СхемаПодписания = ЗНАЧЕНИЕ(Перечисление.СхемыПодписанияЭД.ПустаяСсылка)
	               |	И МаршрутыПодписания.Предопределенный";
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(
		Параметры.Очередь, "Справочник.МаршрутыПодписания");
		
	Если Выборка.Количество() Тогда
		Пока Выборка.Следующий() Цикл
			СхемаПодписания = ?(Выборка.Ссылка = Справочники.МаршрутыПодписания.ОднойДоступнойПодписью,
				Перечисления.СхемыПодписанияЭД.ОднойДоступнойПодписью, Перечисления.СхемыПодписанияЭД.УказыватьПриСоздании);
				
			ОбъектОбработки = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ОбъектОбработки.СхемаПодписания <> СхемаПодписания Тогда
				ОбъектОбработки.СхемаПодписания = СхемаПодписания;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектОбработки);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе // создаем предопределенные данные, если они отсутствуют по каким-либо причинам, например при использовании РИБ.
		Если ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.МаршрутыПодписания.ОднойДоступнойПодписью") = Неопределено Тогда
			МаршрутОбъект = Справочники.МаршрутыПодписания.СоздатьЭлемент();
			МаршрутОбъект.ИмяПредопределенныхДанных = "ОднойДоступнойПодписью";
			МаршрутОбъект.Наименование = НСтр("ru = 'Одной доступной подписью'");
			МаршрутОбъект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ОднойДоступнойПодписью;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(МаршрутОбъект);
		КонецЕсли;
		
		Если ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.МаршрутыПодписания.УказыватьПриСоздании") = Неопределено Тогда
			МаршрутОбъект = Справочники.МаршрутыПодписания.СоздатьЭлемент();
			МаршрутОбъект.ИмяПредопределенныхДанных = "УказыватьПриСоздании";
			МаршрутОбъект.Наименование = НСтр("ru = 'Указывать при создании документа'");
			МаршрутОбъект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.УказыватьПриСоздании;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(МаршрутОбъект);
		КонецЕсли;
	КонецЕсли;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.МаршрутыПодписания");
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника МаршрутыПодписания.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти = Неопределено) Экспорт
	
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОднойДоступнойПодписью";
	Элемент.Наименование = НСтр("ru = 'Одной доступной подписью'", КодОсновногоЯзыка);
	Элемент.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ОднойДоступнойПодписью;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "УказыватьПриСоздании";
	Элемент.Наименование = НСтр("ru = 'Указывать при создании документа'", КодОсновногоЯзыка);
	Элемент.СхемаПодписания = Перечисления.СхемыПодписанияЭД.УказыватьПриСоздании;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#КонецЕсли