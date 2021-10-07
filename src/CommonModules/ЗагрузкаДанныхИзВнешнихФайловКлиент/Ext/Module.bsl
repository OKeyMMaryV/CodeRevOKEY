﻿
#Область ПрограммныйИнтерфейс

// Открывает диалог выбора файла для загрузки с последующим распознаванием данных файла.
//
// Параметры: 
//   ПараметрыЗагрузки   - Структура           - см. ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных.
//   ОповещениеОЗагрузке - ОписаниеОповещения  - оповещение, которое будет вызвано после загрузки данных.
//
Процедура ВыбратьФайлДляЗагрузки(ИмяОткрываемойФормы, УникальныйИдентификатор) Экспорт
	
	Параметры = Новый Структура("ИмяФормы, УникальныйИдентификатор", ИмяОткрываемойФормы, УникальныйИдентификатор);
	Оповещение = Новый ОписаниеОповещения("ОбработкаВыбораФайла", ЭтотОбъект, Параметры);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Все поддерживаемые форматы файлов(*.xls;*.xlsx;*.ods;*.mxl;*.csv)|*.xls;*.xlsx;*.ods;*.mxl;*.csv'");
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, что для всех колонок табличного документа указан соответствующий реквизит.
//
// Параметры:
//   ТабличныйДокумент - ТабличныйДокумент - проверяемый табличный документ.
//   ИмяРеквизитаФормы - Строка - имя реквизита, к которому будут привязаны выводимые сообщения об ошибках.
//   ОписаниеКолонок - ДанныеФормыКоллекция - таблица значений, содержащая описание загружаемых колонок.
//                                            См. ЗагрузкаДанныхИзВнешнихФайлов.НовыйОписаниеЗагружаемыхКолонок()
//
// Возвращаемое значение:
//   Булево - результат проверки:
//      * Истина - если все колонки сопоставлены с реквизитами и сопоставлены обязательные реквизиты;
//      * Ложь - в противном случае.
//
Функция ЗаполненыВсеЗаголовкиКолонок(ТабличныйДокумент, ИмяРеквизитаФормы, Знач ОписаниеКолонок) Экспорт
	
	Если ТипЗнч(ОписаниеКолонок) <> Тип("ДанныеФормыКоллекция") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбязательныеКолонки = ОбязательныеКолонки(ОписаниеКолонок);
	
	ЕстьНезаполненныйЗаголовок = Ложь;
	ШиринаТаблицы = ТабличныйДокумент.ШиринаТаблицы;
	ТекстНезаполненныйЗаголовок = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстЗаголовкаНесопоставленнойКолонки();
	
	Для НомерКолонки = 1 по ШиринаТаблицы Цикл
		
		Ячейка = ТабличныйДокумент.Область("R1C" + НомерКолонки);
		
		Если Ячейка.Текст = ТекстНезаполненныйЗаголовок Тогда
			ЕстьНезаполненныйЗаголовок = Истина;
			Продолжить;
		КонецЕсли;
		
		ОбязательнаяКолонка = ОбязательныеКолонки.Найти(Ячейка.ПараметрРасшифровки);
		Если ОбязательнаяКолонка <> Неопределено Тогда
			ОбязательныеКолонки.Удалить(ОбязательнаяКолонка);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьНезаполненныйЗаголовок Тогда
		ТекстСообщения = НСтр("ru = 'Укажите названия реквизитов в заголовках колонок. Если колонку не требуется загружать, удалите ее.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , ИмяРеквизитаФормы);
	КонецЕсли;
	
	Для Каждого ОбязательнаяКолонка Из ОбязательныеКолонки Цикл
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не указана колонка %1.'"), ОбязательнаяКолонка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяРеквизитаФормы);
	КонецЦикла;
	
	ЕстьОшибки = ЕстьНезаполненныйЗаголовок Или ОбязательныеКолонки.Количество() > 0;
	
	Возврат Не ЕстьОшибки;
	
КонецФункции

Функция ОбязательныеКолонки(ОписаниеКолонок)
	
	ОбязательныеКолонки = Новый Массив;
	
	Для Каждого Колонка Из ОписаниеКолонок Цикл
	
		Если Колонка.ОбязательнаДляЗаполнения Тогда
			ОбязательныеКолонки.Добавить(Колонка.Идентификатор);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ОбязательныеКолонки;
	
КонецФункции

Процедура ОбработкаВыбораФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(Результат.Имя);
	Если Не ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.РасширениеФайлаПоддерживается(РасширениеФайла) Тогда
		ТекстСообщения = НСтр("ru = 'Загрузка возможна только из файлов с расширениями xls, xlsx, mxl, csv, ods.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресФайла", Результат.Хранение);
	ПараметрыФормы.Вставить("РасширениеФайла", РасширениеФайла);
	
	ОткрытьФорму(ДополнительныеПараметры.ИмяФормы, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
