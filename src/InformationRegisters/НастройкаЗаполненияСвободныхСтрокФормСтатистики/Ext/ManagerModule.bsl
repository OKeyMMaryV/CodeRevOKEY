﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверяет есть ли записи в регистре, по заданному отбору.
// Параметры:
//	Отбор - Структура - Отбор по которому нужно искать записи.
//	 * Организация - СправочникСсылка.Организации - Организация для которой нужно определить наличие настройки.
//	 * ОбъектНаблюдения - СправочникСсылка.ОбъектыСтатистическогоНаблюдения - 
//		Объект наблюдения для которого нужно определить наличие настройки.
// Возвращаемое значение:
//	Булево - истина - записи есть, Ложь - Записей нет.
//
Функция ЕстьЗаписи(Отбор) Экспорт
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	НастройкаЗаполненияСвободныхСтрокФормСтатистики.Организация
	|ИЗ
	|	РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики КАК НастройкаЗаполненияСвободныхСтрокФормСтатистики
	|{ГДЕ
	|	НастройкаЗаполненияСвободныхСтрокФормСтатистики.Организация КАК Организация,
	|	НастройкаЗаполненияСвободныхСтрокФормСтатистики.ОбъектНаблюдения КАК ОбъектНаблюдения,
	|	НастройкаЗаполненияСвободныхСтрокФормСтатистики.ДетализацияОбъектаНаблюдения КАК ДетализацияОбъектаНаблюдения}";
	
	Для Каждого КлючИЗначение Из Отбор Цикл
		ЭлементОтбора = Запрос.Отбор.Добавить(КлючИЗначение.Ключ);
		ЭлементОтбора.Установить(КлючИЗначение.Значение);
	КонецЦикла;
	
	Запрос.Выполнить();
	Возврат Не Запрос.Результат.Пустой();
	
КонецФункции

#КонецЕсли