﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТелоСообщения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ТелоСообщения").Получить();
	
	Если ТипЗнч(ТелоСообщения) = Тип("Строка") Тогда
		
		ТелоСообщенияПредставление = ТелоСообщения;
		
	Иначе
		
		Попытка
			ТелоСообщенияПредставление = ОбщегоНазначения.ЗначениеВСтрокуXML(ТелоСообщения);
		Исключение
			ТелоСообщенияПредставление = НСтр("ru = 'Тело сообщения не может быть представлено строкой.'");
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
