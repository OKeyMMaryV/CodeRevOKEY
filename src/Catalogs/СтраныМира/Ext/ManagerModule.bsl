﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не СтандартнаяОбработка Тогда
		// Обрабатывается в другом месте.
		Возврат;
		
	ИначеЕсли Не Параметры.Свойство("РазрешитьДанныеКлассификатора") Тогда
		// Поведение по умолчанию, подбор только справочника.
		Возврат;
		
	ИначеЕсли Истина <> Параметры.РазрешитьДанныеКлассификатора Тогда
		// Подбор классификатора отключен, поведение по умолчанию.
		Возврат;
	КонецЕсли;
	
	УправлениеКонтактнойИнформациейСлужебный.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет данные страны по справочнику стран или классификатору стран.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеСтраныМира.
//
// Параметры:
//    КодСтраны    - Строка, Число - код страны по классификатору. Если не указано, то поиск по коду не производится.
//    Наименование - Строка        - наименование страны. Если не указано, то поиск по наименованию не производится.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//          * Ссылка             - СправочникаСсылка.СтраныМира - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеСтраныМира(Знач КодСтраны = Неопределено, Знач Наименование = Неопределено) Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеСтраныМира(КодСтраны, Наименование);
КонецФункции

// Определяет данные страны по классификатору стран мира.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду.
//
// Параметры:
//    Код - Строка, Число - код страны по классификатору.
//    ТипКода - Строка - Варианты: КодСтраны (по умолчанию), Альфа2, Альфа3.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеКлассификатораСтранМираПоКоду(Знач Код, ТипКода = "КодСтраны") Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду(Код, ТипКода);
КонецФункции

// Определяет данные страны по классификатору.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоНаименованию.
//
// Параметры:
//    Наименование - Строка - наименование страны.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеКлассификатораСтранМираПоНаименованию(Знач Наименование) Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоНаименованию(Наименование);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника СтраныМира.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника СтраныМира.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Россия";
	Элемент.Код                       = "643";
	Элемент.Наименование              = НСтр("ru = 'РОССИЯ'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.НаименованиеПолное        = НСтр("ru = 'Российская Федерация'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.КодАльфа2                 = "RU";
	Элемент.КодАльфа3                 = "RUS";
	Элемент.УчастникЕАЭС              = Истина;
	Элемент.МеждународноеНаименование = НСтр("ru = 'The Russian Federation'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

// Регистрирует к обработке страны мира.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Если наименования были обновлены, то их следует обновить
	МультиязычностьСервер.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.СтраныМира);
	
	СписокСтран = УправлениеКонтактнойИнформацией.СтраныУчастникиЕАЭС();
	
	НоваяСтрока                    = СписокСтран.Добавить();
	НоваяСтрока.Код                = "203";
	НоваяСтрока.Наименование       = НСтр("ru = 'ЧЕШСКАЯ РЕСПУБЛИКА'");
	НоваяСтрока.КодАльфа2          = "CZ";
	НоваяСтрока.КодАльфа3          = "CZE";
	
	НоваяСтрока                    = СписокСтран.Добавить();
	НоваяСтрока.Код                = "270";
	НоваяСтрока.Наименование       = НСтр("ru = 'ГАМБИЯ'");
	НоваяСтрока.КодАльфа2          = "GM";
	НоваяСтрока.КодАльфа3          = "GMB";
	НоваяСтрока.НаименованиеПолное = НСтр("ru = 'Республика Гамбия'");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	СписокСтран.Код КАК Код,
		|	СписокСтран.Наименование КАК Наименование,
		|	СписокСтран.КодАльфа2 КАК КодАльфа2,
		|	СписокСтран.КодАльфа3 КАК КодАльфа3,
		|	СписокСтран.НаименованиеПолное КАК НаименованиеПолное
		|ПОМЕСТИТЬ СписокСтран
		|ИЗ
		|	&СписокСтран КАК СписокСтран
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтраныМира.Ссылка КАК Ссылка
		|ИЗ
		|	СписокСтран КАК СписокСтран
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
		|		ПО (СтраныМира.Код = СписокСтран.Код)
		|			И (СтраныМира.Наименование = СписокСтран.Наименование)
		|			И (СтраныМира.КодАльфа2 = СписокСтран.КодАльфа2)
		|			И (СтраныМира.КодАльфа3 = СписокСтран.КодАльфа3)
		|			И (СтраныМира.НаименованиеПолное = СписокСтран.НаименованиеПолное)";
	
	Запрос.УстановитьПараметр("СписокСтран", СписокСтран);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	СтраныКОбработке = РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СтраныКОбработке);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	СтранаМираСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.СтраныМира");
	НастройкиОбновления = МультиязычностьСервер.НастройкиОбновлениеПредопределенныхДанных(Метаданные.Справочники.СтраныМира);
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока СтранаМираСсылка.Следующий() Цикл
		Попытка
			
			ДанныеКлассификатора = УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду(СтранаМираСсылка.Ссылка.Код);
			
			Если ДанныеКлассификатора <> Неопределено Тогда
				СтранаМира = СтранаМираСсылка.Ссылка.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(СтранаМира, ДанныеКлассификатора);
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтранаМира);
			КонецЕсли;
			
			// Обновление наименований
			Если НастройкиОбновления.ЛокализуемыеРеквизитыОбъекта.Количество() > 0 Тогда
				МультиязычностьСервер.ОбновитьМультиязычныеСтрокиПредопределенногоЭлемента(СтранаМираСсылка, НастройкиОбновления);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать страну мира, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать страну: %1 по причине: %2'"),
					СтранаМираСсылка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.СтраныМира, СтранаМираСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.СтраныМира");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые страны мира(пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.СтраныМира,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура обновления обработала очередную порцию стран мира: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-25 (#4214)
// Определяет, является ли страна мира государством-членом таможенного союза (ЕАЭС)
// Параметры
// СтранаРегистрацииКонтрагента - СправочникСсылка.СтраныМира - страна мира
//
// Возвращаемое значение:
//  Булево - Истина, если переданная страна является государством-членом таможенного союза (ЕАЭС)
//  Для российских контрагентов возвращается Ложь.
Функция ГосударствоЧленТаможенногоСоюза(СтранаРегистрацииКонтрагента) Экспорт

	Если ЗначениеЗаполнено(СтранаРегистрацииКонтрагента)
		И ТипЗнч(СтранаРегистрацииКонтрагента) = Тип("СправочникСсылка.СтраныМира")
		И СтранаРегистрацииКонтрагента <> Справочники.СтраныМира.Россия Тогда
		
		Возврат УправлениеКонтактнойИнформацией.ЭтоСтранаУчастникЕАЭС(СтранаРегистрацииКонтрагента);
		
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-25 (#4214) 
#КонецЕсли

