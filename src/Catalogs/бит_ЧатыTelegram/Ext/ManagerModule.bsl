﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Проверка уникальности ИД
//
// Параметры:
//  Чат		 - Справочникссылка.бит_ЧатыTelegram	 - объект записи.
//  ИД		 - Строка	 - идентификатор.
//  Отказ	 - Булево	 - флаг отказа от выполнения операции.
//
Процедура ПроверкаУникальностиИД(Чат, ИД, Отказ) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	бит_ЧатыTelegram.Ссылка
	|ИЗ
	|	Справочник.бит_ЧатыTelegram КАК бит_ЧатыTelegram
	|ГДЕ
	|	бит_ЧатыTelegram.ИД = &ИД
	|	И бит_ЧатыTelegram.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("ИД", ИД);
	Запрос.УстановитьПараметр("Ссылка", Чат);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда 
		ТекстСообщения =  НСтр("ru = 'ID чата с ботом не уникально!'");
		бит_ТелеграмКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
