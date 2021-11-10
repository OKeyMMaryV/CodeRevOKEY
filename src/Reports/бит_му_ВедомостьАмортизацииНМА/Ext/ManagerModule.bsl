﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  СписокПараметровНаФорме - СписокЗначений ИЛИ Неопределено - список параметров на форме.
// 
Процедура ЗаполнитьДополнительныеСписки(СписокПараметровНаФорме) Экспорт
	
	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	СписокПараметровНаФорме.Добавить("СтандартныйПериод", "СтандартныйПериод");
	
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

#КонецОбласти
 
#КонецЕсли
