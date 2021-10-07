﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОсновнаяСистемаНалогообложения() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОсновнаяСистемаНалогообложения = Константы.ОсновнаяСистемаНалогообложения.Получить();
	
	Если Не ЗначениеЗаполнено(ОсновнаяСистемаНалогообложения) Тогда
		ОсновнаяСистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
	КонецЕсли;
	
	Возврат ОсновнаяСистемаНалогообложения;
	
КонецФункции

Функция ДатаНачалаПрименения(СистемаНалогообложения, ПрименяетсяУСНПатент = Ложь) Экспорт
	
	Если СистемаНалогообложения = НалогНаПрофессиональныйДоход Тогда
		Возврат НалогНаПрофессиональныйДоходКлиентСервер.ДатаНачалаЭксперимента();
	ИначеЕсли ЭтоПатентнаяСистемаНалогообложения(СистемаНалогообложения, ПрименяетсяУСНПатент) Тогда
		Возврат УчетУСН.ДатаНачалаДействияПатентнойСистемы();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоПатентнаяСистемаНалогообложения(СистемаНалогообложения, ПрименяетсяУСНПатент)
	
	Возврат СистемаНалогообложения = ОсобыйПорядок И ПрименяетсяУСНПатент;
	
КонецФункции

#КонецОбласти

#КонецЕсли