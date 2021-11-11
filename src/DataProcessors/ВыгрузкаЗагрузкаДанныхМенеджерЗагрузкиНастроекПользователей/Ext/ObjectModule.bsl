﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущееИмяХранилищаНастроек;
Перем ТекущееХранилищеНастроек;
Перем ТекущиеОбработчики;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ИмяХранилищаНастроек, Обработчики) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущиеОбработчики = Обработчики;
	
	ТекущееИмяХранилищаНастроек = ИмяХранилищаНастроек;
	ТекущееХранилищеНастроек = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ТекущееИмяХранилищаНастроек);
	
КонецПроцедуры

// Загружает настройки пользователей.
//
// Параметры:
//   СопоставлениеПользователей - Соответствие - коллекция пользователей, настройки которых нужно загрузить. 
//                                     Если не указано, то загружаются все настройки "как есть".
//                                       *Ключ - старое имя пользователя
//                                       *Значение - новое имя пользователя.
Процедура ЗагрузитьДанные(СопоставлениеПользователей = Неопределено) Экспорт
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередЗагрузкойХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек,
		Отказ);
	
	Если Не Отказ Тогда
		
		ЗагрузитьНастройкиВСтандартноеХранилище(СопоставлениеПользователей);
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеЗагрузкиХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьНастройкиВСтандартноеХранилище(СопоставлениеПользователей)
	
	ИмяФайла = ТекущийКонтейнер.ПолучитьФайлИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.UserSettings(), ТекущееИмяХранилищаНастроек);
	Если ИмяФайла = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПотокЧтения = Обработки.ВыгрузкаЗагрузкаДанныхПотокЧтенияДанныхИнформационнойБазы.Создать();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	
	Пока ПотокЧтения.ПрочитатьОбъектДанныхИнформационнойБазы() Цикл
		
		Отказ = Ложь;
		
		ЗаписьНастроек = ПотокЧтения.ТекущийОбъект();
		Артефакты = ПотокЧтения.АртефактыТекущегоОбъекта();
		
		КлючНастроек = ЗаписьНастроек.КлючНастроек;
		КлючОбъекта = ЗаписьНастроек.КлючОбъекта;
		Пользователь = ЗаписьНастроек.Пользователь;
		Представление = ЗаписьНастроек.Представление;
		
		Если СопоставлениеПользователей <> Неопределено Тогда
			Пользователь = СопоставлениеПользователей.Получить(Пользователь);
			Если Не ЗначениеЗаполнено(Пользователь) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗаписьНастроек.СериализацияЧерезХранилищеЗначения Тогда
			Настройки = ЗаписьНастроек.Настройки.Получить();
		Иначе
			Настройки = ЗаписьНастроек.Настройки;
		КонецЕсли;
		
		ТекущиеОбработчики.ПередЗагрузкойНастроек(
			ТекущийКонтейнер,
			ТекущееИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление,
			Артефакты,
			Отказ);
		
		Если Не Отказ Тогда
			
			ОписаниеНастроек = Новый ОписаниеНастроек;
			ОписаниеНастроек.Представление = Представление;
			
			ТекущееХранилищеНастроек.Сохранить(
				КлючОбъекта,
				КлючНастроек,
				Настройки,
				ОписаниеНастроек,
				Пользователь);
			
		КонецЕсли;
		
		ТекущиеОбработчики.ПослеЗагрузкиНастроек(
			ТекущийКонтейнер,
			ТекущееИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление,
			Артефакты);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
