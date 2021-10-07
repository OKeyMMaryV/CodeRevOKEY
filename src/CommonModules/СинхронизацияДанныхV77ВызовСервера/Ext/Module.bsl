﻿
Функция ПолучитьПараметрСинхронизацииV77(ИмяПараметра) Экспорт
	
	ОбъектПараметров = Справочники.ПараметрыСинхронизацииV77.ОбъектПараметровСинхронизации.ПолучитьОбъект().Ссылка;
	ТекПараметр = ОбъектПараметров[ИмяПараметра];
	
	Возврат ТекПараметр;
	
КонецФункции

Процедура УстановитьПараметрСинхронизацииV77(ИмяПараметра, ЗначениеПараметра) Экспорт
	
	ОбъектПараметров = Справочники.ПараметрыСинхронизацииV77.ОбъектПараметровСинхронизации.ПолучитьОбъект();
	ОбъектПараметров[ИмяПараметра] = ЗначениеПараметра;
	
	Попытка
		ОбъектПараметров.Записать();
	Исключение
		ТекстСообщения = "ru = 'Не удалось записать элемент справочника ""Параметры синхронизации""!'";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

Процедура ОчиститьПараметрыСинхронизацииV77() Экспорт
	
	УстановитьПараметрСинхронизацииV77("ИмяФайлаДанных", "");
	УстановитьПараметрСинхронизацииV77("НомерПоследнейЗагрузки", 0);
	УстановитьПараметрСинхронизацииV77("ОтветственныйПользователь", "");
	
КонецПроцедуры

Функция ПолучитьПредставлениеДокумента77(Объект) Экспорт
	
	Комментарий = Объект.Комментарий;
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ОперацияБух") Тогда
		Комментарий = Объект.Содержание;
	КонецЕсли;
	
	Поз = СтрНайти(Комментарий, "7.7");
	
	Если Поз <> 0 Тогда
		Комментарий = Сред(Комментарий, Поз + 3);
		Комментарий = СокрЛ(Комментарий);
		
		Если Лев(Комментарий, 1) = "#" Тогда
			Комментарий = Сред(Комментарий, 2);
		КонецЕсли;	
	ИначеЕсли Поз = 0 Тогда
		Если Лев(Комментарий, 1) = "#" Тогда
			Комментарий = Сред(Комментарий, 2);
		КонецЕсли;
	КонецЕсли;
	
	Комментарий = СокрЛ(Комментарий);
	КолВхождений = СтрЧислоВхождений(Комментарий, "#");
	
	Если КолВхождений > 0 Тогда
		Поз = СтрНайти(Комментарий, "#");
		Комментарий = Сред(Комментарий, 0, Поз - 2);
	КонецЕсли;
	
	Возврат Комментарий;
	
КонецФункции	

Процедура ДобавитьСтрокуВТаблицуСоответствий(ТаблицаСоответствий, Объект) Экспорт
	
	Комментарий = ПолучитьПредставлениеДокумента77(Объект);
	
	НоваяСтрока            = ТаблицаСоответствий.Добавить();
	НоваяСтрока.Документ77 = Комментарий;
	НоваяСтрока.Объект     = Объект;
	НоваяСтрока.ПредставлениеОбъекта = Строка(Объект);
	
КонецПроцедуры

Функция ВыполнятьСинхронизациюV77() Экспорт	
	Флаг = Ложь;
	
	Если Константы.ВыполнятьСинхронизациюV77.Получить() Тогда
		Флаг = Истина;
	КонецЕсли;
	
	Возврат Флаг;
	
КонецФункции	

Функция ПроверитьПолныеПрава(СтрПользователь) Экспорт	
	
	ТекПользователь = Пользователи.НайтиПоИмени(СтрПользователь);
	
	Если ТекПользователь = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Пользователь %1 отсутствует в информационной базе!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрПользователь);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура УстановитьПараметрыСинхронизации(ИмяФайлаДанных, ИзменитьИнтерфейс=Ложь) Экспорт
	
	ОчиститьПараметрыСинхронизацииV77();
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	УстановитьПараметрСинхронизацииV77("ОтветственныйПользователь", ПользовательИБ);
	
	Если ИзменитьИнтерфейс Тогда
		ОбщегоНазначенияБП.УстановитьРежимКомандногоИнтерфейса("ИнтерфейсВерсии77");
	КонецЕсли;
	
	Константы.ВыполнятьСинхронизациюV77.Установить(Истина);
	УстановитьПараметрСинхронизацииV77("ИмяФайлаДанных", ИмяФайлаДанных);
	УстановитьПараметрСинхронизацииV77("НомерПоследнейЗагрузки", 1);
	
КонецПроцедуры

Процедура ЗаписатьСообщениеВЖР(ТекстСообщения) Экспорт
	
	ИмяСобытия = НСтр("ru = 'Загрузка данных из 1С:Бухгалтерии 7.7'");
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация,,,
	НСтр(ТекстСообщения)
	);
	
КонецПроцедуры
